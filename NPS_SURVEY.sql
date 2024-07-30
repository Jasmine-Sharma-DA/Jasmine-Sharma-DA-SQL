CREATE DATABASE nps_survey;
USE nps_survey;
CREATE TABLE orders (
                  order_id INT PRIMARY KEY, 
                  customer_id INT NOT NULL, 
                  delivery_date DATE
				   );
CREATE TABLE customers (
                  customer_id INT PRIMARY KEY, 
                  customer_name VARCHAR(50), 
                  country VARCHAR(50)
				   );
CREATE TABLE nps (
				  order_id INT PRIMARY KEY, 
                  nps_sent_date DATE NOT NULL,
                  nps_responses_date DATE, 
                  score TINYINT);
CREATE TABLE contacts (
				  contact_id INT PRIMARY KEY, 
                  contact_date DATE NOT NULL,
                  order_id INT NOT NULL, 
                  channel VARCHAR(50));  
SELECT COUNT(nps_responses_date)/COUNT(nps_sent_date)*100 AS nps_response_rate
FROM nps;

WITH order_country AS (SELECT o.order_id, o.customer_id, c.country
FROM orders AS o 
RIGHT JOIN customers AS c
ON o.customer_id=c.customer_id)

SELECT  country, COUNT(order_id) AS total_orders
FROM order_country
GROUP BY country;

WITH promoters AS(
SELECT COUNT(score) AS promoters_count
FROM nps
WHERE score >= 9),

detractors AS(
SELECT COUNT(score) AS detractors_count
FROM nps
WHERE score BETWEEN 0 AND 6),

total_responses AS(
SELECT COUNT(score) AS total_count
FROM nps
)

SELECT 
(promoters.promoters_count - detractors.detractors_count)/total_responses.total_count*100 AS nps
FROM 
promoters,detractors,total_responses;


