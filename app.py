from flask import Flask, render_template, request, redirect, url_for, session, jsonify
import mysql.connector
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from io import BytesIO
import base64

app = Flask(__name__)
app.secret_key = '444030'  # Replace with your generated key

def get_db_connection():
    return mysql.connector.connect(
        host='localhost',
        user='root',
        password='password',
        database='shop_db'
    )

@app.route('/')
def home():
    return render_template('login.html')

@app.route('/login', methods=['POST'])
def login():
    username = request.form['username']
    password = request.form['password']
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute('SELECT * FROM users WHERE email = %s AND password = SHA2(%s, 256)', (username, password))
    user = cursor.fetchone()
    conn.close()

    if user:
        session['user_id'] = user['id']
        if user['role'] == 'Admin':
            return redirect(url_for('admin_dashboard'))
        else:
            return redirect(url_for('customer_dashboard'))
    else:
        return redirect(url_for('home'))

@app.route('/signup', methods=['GET', 'POST'])
def signup():
    if request.method == 'POST':
        username = request.form['username']
        email = request.form['email']
        password = request.form['password']

        conn = get_db_connection()
        cursor = conn.cursor()

       
        try:
            cursor.execute('INSERT INTO users (username, email, password,role) VALUES (%s, %s, SHA2(%s, 256),"Customer")', (username, email, password))
            conn.commit()
            return redirect(url_for('home'))  
        except mysql.connector.Error as err:
            print(f"Error: {err}")
            conn.rollback()
        finally:
            conn.close()
    
    return render_template('signup.html')

@app.route('/admin_dashboard')
def admin_dashboard():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    # Total Sales per Product
    query = """
    SELECT p.product_name, SUM(s.quantity * s.price) AS total_sales
    FROM sales s
    JOIN product p ON s.product_id = p.product_id
    GROUP BY p.product_name
    """
    df = pd.read_sql(query, con=conn)
    plt.figure(figsize=(10, 6))
    sns.barplot(x='product_name', y='total_sales', data=df)
    plt.title('Total Sales per Product')
    img = BytesIO()
    plt.savefig(img, format='png')
    img.seek(0)
    total_sales_img = base64.b64encode(img.getvalue()).decode('utf-8')
    plt.close()

    # Top 5 Customers by Spending
    query = """
    SELECT c.username, SUM(s.quantity * s.price) AS total_spent
    FROM sales s
    JOIN customer c ON s.customer_id = c.customer_id
    GROUP BY c.username
    ORDER BY total_spent DESC
    LIMIT 5
    """
    df_top_customers = pd.read_sql(query, con=conn)

    # Monthly Sales Summary
    query = """
    SELECT DATE_FORMAT(order_date, '%Y-%m') AS month, SUM(quantity * price) AS total_sales
    FROM sales
    WHERE YEAR(order_date) = YEAR(CURDATE())
    GROUP BY month
    """
    df_monthly_sales = pd.read_sql(query, con=conn)
    plt.figure(figsize=(10, 6))
    sns.lineplot(x='month', y='total_sales', data=df_monthly_sales)
    plt.title('Monthly Sales Summary')
    img2 = BytesIO()
    plt.savefig(img2, format='png')
    img2.seek(0)
    monthly_sales_img = base64.b64encode(img2.getvalue()).decode('utf-8')
    plt.close()

    conn.close()
    return render_template('admin_dashboard.html', top_customers=df_top_customers.to_dict(orient='records'),
                          total_sales_img=total_sales_img, monthly_sales_img=monthly_sales_img)

@app.route('/customer_dashboard', methods=['GET', 'POST'])
def customer_dashboard():
    if request.method == 'POST':
        cart_items = request.form.getlist('cart_items[]')
        customer_id = session.get('user_id')

        conn = get_db_connection()
        cursor = conn.cursor()

        total_amount = 0
        for item in cart_items:
            product_id = item['product_id']
            quantity = int(item['quantity'])
            price = float(item['price'])
            cursor.execute('UPDATE product SET stock_quantity = stock_quantity - %s WHERE product_id = %s', (quantity, product_id))
            cursor.execute('INSERT INTO sales (order_date, product_id, quantity, price, customer_id) VALUES (CURDATE(), %s, %s, %s, %s)', (product_id, quantity, price, customer_id))
            total_amount += quantity * price

        cursor.execute('INSERT INTO transaction (transaction_date, amount, customer_id) VALUES (CURDATE(), %s, %s)', (total_amount, customer_id))

        conn.commit()
        conn.close()

        return jsonify({'success': True})

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute('SELECT * FROM product')
    products = cursor.fetchall()
    conn.close()
    return render_template('customer_dashboard.html', products=products)


@app.route('/logout')
def logout():
    session.pop('user_id', None)
    return redirect(url_for('home'))

if __name__ == '__main__':
    app.run(debug=True)
