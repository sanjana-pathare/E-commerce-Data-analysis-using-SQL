CREATE DATABASE e_commerce;

SELECT *FROM users;
SELECT *FROM orders;
SELECT *FROM product;
SELECT *FROM reviews;
SELECT *FROM order_items;
SELECT *FROM events;

#Q1. total number of users 
SELECT COUNT(*) AS total_users FROM users;

#Q2.Count users by gender 
SELECT gender ,COUNT(*) FROM users GROUP BY gender;

#Q3.Total number of products
SELECT COUNT(*) AS total_products FROM product;

#Q4. Average product price 
SELECT AVG(price) AS avg_product_price FROM product;

#Q5. Number of orders
SELECT COUNT(*) AS total_orders FROM orders;

#Q6.Total revenue (only completed orders) 
SELECT SUM(total_amount)AS revenue FROM orders WHERE order_status="completed";

#Q7.Count orders by status
SELECT order_status, COUNT(*) FROM orders GROUP BY order_status;

#Q8. Top 5 expensive products
SELECT product_name ,price FROM product ORDER BY price DESC LIMIT 5;

#Q9.Total quantity sold 
SELECT SUM(quantity) AS total_sold_quantity FROM order_items;

#Q10. Average rating of products 
SELECT AVG(rating) FROM product;

#Q11. Users from a specific city 
SELECT * FROM users WHERE city="Lake Larry";

#Q12.Orders placed after 2023 
SELECT * FROM orders WHERE order_date > "2023-01-01";

#Q13. Distinct product categories 
SELECT category ,COUNT(*) FROM product GROUP BY category ORDER BY COUNT(category) DESC ; #by count

SELECT DISTINCT category FROM product; # by type

#Q14. Count reviews 
SELECT COUNT(*) FROM reviews;

#Q15. Count events by type 
SELECT event_type ,COUNT(*) FROM events GROUP BY event_type;

#Q16. Get all orders with user names
SELECT o.order_id, u.name 
FROM orders o
JOIN users u
ON o.user_id = u.user_id;

#17. Orders with product names 
SELECT oi.order_id ,p.product_name
FROM order_items oi
JOIN product p
ON p.product_id = oi.product_id;

#Q18. Total spending per user 
SELECT u.name,SUM(o.total_amount)
AS total_spent
FROM users u
JOIN orders o
ON u.user_id = o.user_id
GROUP BY u.name;

#Q19.Number of orders per user 
SELECT u.name ,COUNT(o.order_id) AS order_count_per_user
FROM users u
LEFT JOIN orders o
ON u.user_id = o.user_id
GROUP BY u.name ;

#Q20. Most purchased products 
SELECT p.product_name , SUM(oi.quantity) AS total_qty
FROM product p 
JOIN order_items oi
ON p.product_id = oi.product_id
GROUP BY p.product_name
ORDER BY total_qty DESC;

#Q21.Revenue by category
SELECT p.category , SUM(oi.item_price) AS revenue
FROM product p
JOIN order_items oi
ON p.product_id = oi.product_id
GROUP BY p.category
ORDER BY  revenue DESC;

#Q22.Users who placed orders 
SELECT DISTINCT u.name 
FROM users u
JOIN orders o
ON u.user_id = o.user_id;

#Q23. Products never ordered 
SELECT p.product_name
FROM product p
LEFT JOIN order_items oi
ON p.product_id = oi.product_id
WHERE oi.product_id IS NULL; 

#Q24.Orders with multiple items 
SELECT order_id ,COUNT(*) AS items
FROM order_items
GROUP by order_id
HAVING COUNT(*) > 1;

#Q25. Users and their review count
SELECT u.name , COUNT(r.review_id) AS review_count
FROM users u 
LEFT JOIN reviews r 
ON u.user_id = r.user_id
GROUP BY u.name;

#Q26.Average rating per product 
SELECT p.product_name ,AVG(p.rating) 
AS avg_product_rating 
FROM product p 
JOIN reviews r 
ON p.product_id = r.product_id
GROUP BY p.product_name;

#27.Orders with total quantity 
 SELECT o.order_id , SUM(oi.quantity) 
 AS total_qty
 FROM orders o
 JOIN order_items oi
 ON o.order_id = oi.order_id
 GROUP BY o.order_id;
 
 #Q28. Users who never ordered 
 SELECT u.name 
 FROM users u
 LEFT JOIN orders o
 ON u.user_id = o.user_id
 WHERE o.order_id IS NULL;
 
 #Q29.Top cities by number of users 
 SELECT city , COUNT(*)
 AS top_cities
 FROM users
 GROUP BY  city
 ORDER BY top_cities DESC;

#Q30. Most active users (based on events) 
SELECT user_id , COUNT(*) AS active_users
FROM events 
GROUP BY user_id
ORDER BY active_users DESC;

#Q31.Users who spent more than average 	
SELECT name
FROM users
WHERE user_id IN (
    SELECT user_id
    FROM orders
    GROUP BY user_id
    HAVING SUM(total_amount) > (
        SELECT AVG(user_total)
        FROM (
            SELECT SUM(total_amount) AS user_total
            FROM orders
            GROUP BY user_id)t));
            
#Q32. Products priced above average 
SELECT product_name, price 
FROM product
WHERE price >(
SELECT AVG(price)FROM product ORDER BY price DESC);

#Q33. Users with at least one completed order
SELECT  name FROM  users WHERE user_id IN ( SELECT user_id FROM orders WHERE order_status = "completed");

#Q34. Most expensive product 
SELECT product_name, price FROM product WHERE price =(SELECT MAX(price) FROM product);

#Q35. Orders with highest total 
SELECT * FROM orders WHERE total_amount =(SELECT MAX(total_amount) FROM orders);

#Q36. Products with highest rating 
SELECT * FROM product WHERE rating =(SELECT MAX(rating) FROM product);

#Q37. Users who reviewed products
SELECT DISTINCT name ,user_id FROM users WHERE user_id IN( SELECT user_id FROM reviews); 

#Q38. Products not reviewed 
SELECT product_name FROM product WHERE product_id NOT IN (SELECT product_id FROM reviews);

#Q39. Users with more than 2 orders 
SELECT name FROM users WHERE user_id IN(SELECT user_id FROM orders GROUP BY user_id HAVING COUNT(*) > 2 );

#Q40.Orders above average value 
SELECT * FROM orders WHERE total_amount >(SELECT AVG(total_amount) FROM orders);

#Q41.Rank products by price 
SELECT product_name , price,
RANK() OVER( ORDER BY price DESC) AS product_rank
FROM product ;

#Q42. Row number for users by signup date 
SELECT name ,signup_date , 
ROW_NUMBER() OVER( ORDER BY signup_date)
AS  row_num  
FROM users;

#Q43.Dense rank of users by spending 
SELECT user_id , SUM(total_amount) AS total_spent, 
DENSE_RANK() OVER(ORDER BY SUM(total_amount) DESC )AS rank 
FROM orders
GROUP BY user_id;

#Q44.Running total of revenue 
SELECT order_id , order_date ,
SUM(total_amount) OVER(ORDER BY order_date) 
AS running_total
FROM orders;

#Q45. Previous order value (LAG) 
SELECT order_id ,total_amount , 
LAG(total_amount) OVER(ORDER BY order_date) 
AS prv_order_value
FROM orders;

#Q46. Next order value (LEAD)
SELECT order_id , total_amount ,
LEAD(total_amount) OVER(ORDER BY order_date) 
AS next_order_value
FROM orders;

#Q47.Partition users by city 
SELECT name , city ,
COUNT(*) OVER(PARTITION BY city ) AS city_count FROM users;

#Q48. Top product per category 
SELECT product_name , category, price , RANK() OVER(PARTITION BY category ORDER BY price DESC) AS top_products FROM product;

#Q49.Running total per user 
SELECT user_id ,order_date, total_amount, SUM(total_amount) OVER(PARTITION BY user_id ORDER BY order_date)AS running_total FROM orders;

#Q50. First order per user 
SELECT *
FROM (
    SELECT *,
    ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY order_date) AS rn
    FROM orders
) t
WHERE rn = 1;

