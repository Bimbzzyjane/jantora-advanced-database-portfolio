-- JANTORA | Portfolio 3 | 03_concurrency_test.sql
-- All updates are rolled back; the original quantity is preserved.

-- SETUP (either session): choose a row with stock and record its quantity.
SELECT inventory_id, branch_id, product_id, quantity
FROM inventory 
WHERE quantity > 0 
ORDER BY inventory_id LIMIT 1;

-- A1 (Session A): acquire a row lock and LEAVE the transaction open.
BEGIN;
UPDATE inventory 
SET quantity = quantity - 1
WHERE inventory_id = 1 AND quantity > 0;

SELECT inventory_id, quantity 
FROM inventory WHERE inventory_id = 1;

-- B1 (Session B): attempt to change the SAME row while A1 is open.
-- Expect SQLSTATE 55P03 (lock_not_available) after 3 seconds. screenshot 07-concurrency-lock.png.
BEGIN;

SET LOCAL lock_timeout = '3s';

UPDATE inventory 
SET quantity = quantity - 1
WHERE inventory_id = 1 AND quantity > 0;

-- B2 (Session B): after expected timeout, clear aborted transaction.
ROLLBACK;

-- A2 (Session A): release lock, undo change, confirm original quantity.
ROLLBACK;
SELECT inventory_id, quantity 
FROM inventory WHERE inventory_id = 1;

-- B3 (Session B): retry succeeds after lock released, then undo it.
-- screenshot 08-concurrency-result.png and 09-concurrency-final-verification.png.

BEGIN;

SET LOCAL lock_timeout = '3s';

UPDATE inventory 
SET quantity = quantity - 1
WHERE inventory_id = 1 AND quantity > 0;

SELECT inventory_id, quantity 
FROM inventory WHERE inventory_id = 1;

ROLLBACK;

SELECT inventory_id, quantity 
FROM inventory WHERE inventory_id = 1;

