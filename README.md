# Task-for-SQL-Python
 ![image](https://github.com/user-attachments/assets/26cd6486-4618-48a1-a255-dca5bdd1ba82)
 ## Username : admin@example.com
 ## password : admin123

  ## Admin Dashboard
 ![image](https://github.com/user-attachments/assets/0b60f6d4-99eb-4e5f-8b12-ac38f86e46bb)
 ![image](https://github.com/user-attachments/assets/3dfce008-5451-4a30-a911-99a4718d81cf)
 ![image](https://github.com/user-attachments/assets/3a4c8658-edf9-4e8b-ac5e-e49bb12c6026)

 ## Customer Panel [ Dummy ]
 email : eva.adams@example.com
 password : password5

 ![image](https://github.com/user-attachments/assets/1bbcf652-98f3-47c4-8c92-d25ecf53ab17)
 ![image](https://github.com/user-attachments/assets/dd6507fe-9743-48b6-87f4-434c70d6abf3)


 SQL :
  Total Sales per Product
    
    SELECT p.product_name, SUM(s.quantity * s.price) AS total_sales
    FROM sales s
    JOIN product p ON s.product_id = p.product_id
    GROUP BY p.product_name

  Top 5 Customer Spending

   SELECT c.username, SUM(s.quantity * s.price) AS total_spent
    FROM sales s
    JOIN customer c ON s.customer_id = c.customer_id
    GROUP BY c.username
    ORDER BY total_spent DESC
    LIMIT 5

   Monthly sales Summary

   SELECT DATE_FORMAT(order_date, '%Y-%m') AS month, SUM(quantity * price) AS total_sales
    FROM sales
    WHERE YEAR(order_date) = YEAR(CURDATE())
    GROUP BY month





 


