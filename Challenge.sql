USE sakila


-- Create a view 

DROP VIEW IF EXISTS rental_summary;
CREATE VIEW rental_summary AS
SELECT
c.customer_id,
CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
c.email,
COUNT(r.rental_id) AS rental_count
FROM customer AS c
JOIN rental  AS r ON c.customer_id = r.customer_id
GROUP BY
c.customer_id,
c.first_name,
c.last_name,
c.email;


-- Create a Temporary Table

DROP TEMPORARY TABLE IF EXISTS payment_summary;
CREATE TEMPORARY TABLE payment_summary AS
SELECT
v.customer_id,
v.customer_name,
v.email,
SUM(p.amount) AS total_paid
FROM rental_summary AS v
JOIN payment AS p ON v.customer_id = p.customer_id
GROUP BY
v.customer_id,
v.customer_name,
v.email;


-- Build a CTE and generate the final report

WITH customer_cte AS (
SELECT
v.customer_name,
v.email,
v.rental_count,
t.total_paid
FROM rental_summary AS v
JOIN payment_summary AS t
ON v.customer_id = t.customer_id
)
SELECT
customer_name,
email,
rental_count,
total_paid,
ROUND(total_paid / rental_count, 2) AS average_payment_per_rental
FROM customer_cte
ORDER BY total_paid DESC;


