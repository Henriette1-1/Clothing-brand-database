-- WorkItem3

-- Run as a database administrator or suitably privileged user

CREATE ROLE clothing_reader
WITH LOGIN PASSWORD 'Password';

-- Replacing clothing_brand with the actual database name.
GRANT CONNECT ON DATABASE clothing_brand
TO clothing_reader;

GRANT USAGE ON SCHEMA public
TO clothing_reader;

GRANT SELECT ON TABLE public.Category, public.Product
TO clothing_reader;

-- This should succeed
SELECT * FROM public.Product;

-- This should fail because UPDATE permission was not granted
UPDATE public.Product
SET price = 10
WHERE product_id = 1;
