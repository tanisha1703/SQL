-- CREATING DATA SET

-- CREATE SALES TABLE
CREATE TABLE sales (
  "customer_id" VARCHAR(1),
  "order_date" DATE,
  "product_id" INTEGER
);

-- INSERT VALUES IN SALES TABLE
INSERT INTO sales
  ("customer_id", "order_date", "product_id")
VALUES
  ('A', '2021-01-01', '1'),
  ('A', '2021-01-01', '2'),
  ('A', '2021-01-07', '2'),
  ('A', '2021-01-10', '3'),
  ('A', '2021-01-11', '3'),
  ('A', '2021-01-11', '3'),
  ('B', '2021-01-01', '2'),
  ('B', '2021-01-02', '2'),
  ('B', '2021-01-04', '1'),
  ('B', '2021-01-11', '1'),
  ('B', '2021-01-16', '3'),
  ('B', '2021-02-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-07', '3');
  
-- CREATE MENU TABLE
CREATE TABLE menu (
  "product_id" INTEGER,
  "product_name" VARCHAR(5),
  "price" INTEGER
);

-- INSERT VALUES IN MENU TABLE
INSERT INTO menu
  ("product_id", "product_name", "price")
VALUES
  ('1', 'sushi', '10'),
  ('2', 'curry', '15'),
  ('3', 'ramen', '12');
  
-- CREATE MEMBER TABLE
CREATE TABLE members (
  "customer_id" VARCHAR(1),
  "join_date" DATE
);

-- INSERT VALUES IN MEMBER TABLE
INSERT INTO members
  ("customer_id", "join_date")
VALUES
  ('A', '2021-01-07'),
  ('B', '2021-01-09');
  
  
--1 Total amount spend by each customer
SELECT s.customer_id, SUM(m.price) AS total_amount
FROM sales AS s
JOIN menu AS m
ON s.product_id=m.product_id
GROUP BY s.customer_id
ORDER BY s.customer_id;


--2 How many days has each customer visited the restaurant?
SELECT customer_id, COUNT(DISTINCT(order_date)) AS time_visited
FROM sales
GROUP BY customer_id
ORDER BY customer_id;


--3. What was the first item from the menu purchased by each customer?
With first_item AS
(
SELECT S.customer_id, 
       M.product_name, 
	     S.order_date,
	     DENSE_RANK() OVER (PARTITION BY S.customer_id ORDER BY S.order_date) AS ranking
FROM Menu AS m
JOIN Sales AS s
ON m.product_id = s.product_id
)
SELECT DISTINCT customer_id, product_name, order_date
FROM first_item
WHERE ranking = 1;


--4. What is the most purchased item on the menu and how many times was it purchased by all customers?
SELECT m.product_name, COUNT(s.product_id) AS time_purchased
FROM sales AS s
JOIN menu AS m
ON s.product_id=m.product_id
GROUP BY m.product_name
ORDER BY COUNT(s.product_id) DESC
LIMIT 1;


--5. Which item was the most popular for each customer?
with CTE AS
(
SELECT S.customer_id,
		M.product_name,
		COUNT(S.product_id) AS purchased_time,
		DENSE_RANK() OVER (PARTITION BY S.customer_id ORDER BY COUNT(S.product_id) DESC) AS ranking
FROM menu AS m
JOIN sales AS S
ON m.product_id = s.product_id
Group by S.customer_id, M.product_name
)
SELECT customer_id, product_name, purchased_time
FROM CTE
WHERE ranking =1;


--6. Which item was purchased first by the customer after they became a member?
With first_item AS
(
SELECT S.customer_id, 
       M.product_name, 
	     S.order_date,
	     DENSE_RANK() OVER (PARTITION BY S.Customer_id ORDER BY S.order_date) AS order_rank
FROM Menu AS m
JOIN Sales AS s
ON m.product_id = s.product_id
JOIN members AS n
ON s.customer_id = n.customer_id
WHERE s.order_date >= n.join_date
)
SELECT customer_id, product_name, order_date
FROM first_item
WHERE order_rank = 1;


--7. Which item was purchased just before the customer became a member?
With first_purchased AS
(
SELECT S.customer_id, 
       M.product_name, 
	     S.order_date,
	     DENSE_RANK() OVER (PARTITION BY S.Customer_id ORDER BY S.order_date) AS ranking
FROM Menu AS m
JOIN Sales AS s
ON m.product_id = s.product_id
JOIN members AS n
ON s.customer_id = n.customer_id
WHERE s.order_date < n.join_date
)
SELECT customer_id, product_name, order_date
FROM first_purchased
WHERE ranking = 1;


--8. What is the total items and amount spent for each member before they became a member?
SELECT s.customer_id, COUNT(s.product_id) AS total_items, SUM(m.price) AS total_sales
FROM menu AS m
JOIN sales AS s
ON s.product_id = m.product_id
JOIN members AS n
ON s.customer_id = n.customer_id
WHERE s.order_date < n.join_date
GROUP BY s.customer_id
ORDER BY s.customer_id;
select * from menu

-- 9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
SELECT s.customer_id,
SUM
(
CASE WHEN m.product_id = 1 THEN m.price * 20
	ELSE m.price * 10 END
) AS total_points
FROM sales AS s
JOIN menu AS m
ON s.product_id = m.product_id
GROUP BY s.customer_id
ORDER BY s.customer_id;

