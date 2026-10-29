-- WorkItem3

-- STEP 1: Run before creating the index.
EXPLAIN ANALYZE
SELECT order_id, order_date
FROM CustomerOrder
WHERE customer_id = 1
ORDER BY order_date DESC;

-- STEP 2: Create the index.
CREATE INDEX idx_customerorder_customer_date
ON CustomerOrder (customer_id, order_date);

-- STEP 3: Run the same query after creating the index.
EXPLAIN ANALYZE
SELECT order_id, order_date
FROM CustomerOrder
WHERE customer_id = 1
ORDER BY order_date DESC;
