-- WorkItem 3

SELECT product_id, product_name, price
FROM Product
WHERE product_name IN ('Emma Dress', 'Otto Trousers');


-- MEANINGFUL TRANSACTION
-- Apply two related product price updates as one unit of work.

BEGIN;

UPDATE Product
SET price = 1550.00
WHERE product_name = 'Emma Dress';

UPDATE Product
SET price = 1299.00
WHERE product_name = 'Otto Trousers';

-- Check the prices before committing.
SELECT product_name, price
FROM Product
WHERE product_name IN ('Emma Dress', 'Otto Trousers');

COMMIT;
