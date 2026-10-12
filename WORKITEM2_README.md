-- USING ORIGINAL CB-DATABASE SAMPLE DATA FROM WORK ITEM 1 AS STARTING POINT

-- ============================================
-- UPDATE SAMPLE DATA
-- ============================================

-- 1. Add additional category for trousers
INSERT INTO Category (category_name)
VALUES
    ('Trousers');

-- 2. Add new product in category 'Trousers'
INSERT INTO Product (product_name, price, category_id)
VALUES
    (
        'Otto Trousers',
        1359.00,
        (SELECT category_id
         FROM Category
         WHERE category_name = 'Trousers')
    );
    
-- 3. Updated dress price for 'Emma Dress'
UPDATE Product
	SET price = 1500.00
	WHERE product_name = 'Emma Dress';

-- 4. Deleting an order item for customer order
DELETE FROM OrderItem
WHERE Order_id = 1 AND product_id = 1;

-- 5. Adding a different item for customer order where order number is 1
INSERT INTO OrderItem (order_id, product_id, quantity)
VALUES
    (
    	1,
        (SELECT product_id
         FROM Product
         WHERE product_name = 'Otto Trousers'),
        1
    );

-- ============================================
-- QUERYING SAMPLE DATA
-- ============================================

-- 1. Selecting from order items table and ordering by order_id
SELECT * FROM OrderItem
ORDER BY order_id;

-- 2. Selecting full customer information and items ordered, ordering by order_date
SELECT
	C.customer_id,
	C.first_name,
	C.last_name,
	C.email,
	O.order_id,
	O.order_date,
	I.product_id,
	P.product_name
FROM customer AS C
JOIN CustomerOrder AS O ON C.customer_id = O.customer_id
JOIN OrderItem AS I ON O.order_id = I.order_id
JOIN Product AS P ON I.product_id = P.product_id
ORDER BY customer_id, order_id;

-- 3. Selecting full customer information with left joins to show all customers regardless of whether they have ordered an item
SELECT
	C.customer_id,
	C.first_name,
	C.last_name,
	C.email,
	O.order_id,
	O.order_date,
	I.product_id,
	P.product_name
FROM customer C
LEFT JOIN CustomerOrder O ON C.customer_id = O.customer_id
LEFT JOIN OrderItem I ON O.order_id = I.order_id
LEFT JOIN Product P ON I.product_id = P.product_id
ORDER BY customer_id, order_id;

-- 4. Calculating sales revenue for each category
SELECT
	C.category_name,
	SUM(P.price * OI.quantity) AS total_revenue
FROM Category C
JOIN Product P ON C.category_id = P.category_id
JOIN OrderItem OI ON P.product_id = OI.product_id
GROUP BY C.category_id, C.category_name
ORDER BY total_revenue DESC;

-- 5. Restricting sales revenue analysis to categories with revenue greater than or equal to 1,500
SELECT
	C.category_name,
	SUM(P.price * OI.quantity) AS total_revenue
FROM Category C
JOIN Product P ON C.category_id = P.category_id
JOIN OrderItem OI ON P.product_id = OI.product_id
GROUP BY C.category_id, C.category_name
HAVING SUM(P.price * OI.quantity) >= 1500
ORDER BY total_revenue DESC;

-- 6. Subquery to find items that appear in customer orders and rank by best selling items
SELECT 
	P.product_id,
	P.product_name,
	SUM(OI.quantity) AS number_sold
FROM product P
JOIN OrderItem OI ON P.product_id = OI.product_id
WHERE P.product_id IN
	(
	SELECT product_id
	FROM OrderItem
	)
GROUP BY P.product_id
ORDER BY number_sold DESC, P.product_id;

-- 7. Query to find latest order date and order id from any given customer, showing customers with no orders as well
SELECT
	C.customer_id,
	C.first_name,
	C.last_name,
	MAX(order_date) AS latest_order_date,
	MAX(order_id) AS latest_order_id
FROM customer C
LEFT JOIN CustomerOrder CO ON C.customer_id = CO.Customer_id
GROUP BY C.customer_id
ORDER BY C.customer_id;

-- 8. Query for average value of orders for customer '1'
SELECT 
	AVG(order_total) AS average_order_value
	FROM 
	(
		SELECT 
			CO.order_id,
			SUM(P.price * OI.quantity) AS order_total
		FROM CustomerOrder CO
		JOIN OrderItem OI ON CO.order_id = OI.order_id
		JOIN Product P ON OI.product_id = P.product_id
		WHERE CO.customer_id = 1
		GROUP BY CO.order_id
	);

-- 9. Query for average value of orders for each customer
SELECT 
	C.customer_id,
	C.first_name,
	C.last_name,
	AVG(order_total) AS average_order_value
FROM Customer C
JOIN (
		SELECT 
			CO.order_id,
			CO.customer_id,
			SUM(P.price * OI.quantity) AS order_total
		FROM CustomerOrder CO
		JOIN OrderItem OI ON CO.order_id = OI.order_id
		JOIN Product P ON OI.product_id = P.product_id
		GROUP BY CO.order_id, CO.customer_id
	) AS order_values ON c.customer_id = order_values.customer_id 
GROUP BY C.customer_id, C.first_name, C.last_name
ORDER BY average_order_value DESC;
