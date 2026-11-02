-- JANTORA | Portfolio 3 | 02_isolation_levels.sql
-- TWO distinct pgAdmin Query Tool connections to jantora_db: Session A and Session B.

-- SETUP (either session, before tests)
SELECT inventory_id, branch_id, product_id, quantity
FROM inventory 
ORDER BY inventory_id LIMIT 1;

-- TEST 1: READ COMMITTED
-- A1 (Session A): first read of Q.
BEGIN ISOLATION LEVEL READ COMMITTED;
SELECT quantity 
FROM inventory 
WHERE inventory_id = 1;

-- B1 (Session B): committed update to Q+1.
BEGIN;

UPDATE inventory 
SET quantity = quantity + 1 WHERE inventory_id = 1;

COMMIT;

SELECT quantity 
FROM inventory WHERE inventory_id = 1;

-- A2 (Session A): new statement sees Q+1. Screenshot 05-read-committed.png.
SELECT quantity 
FROM inventory
WHERE inventory_id = 1;

COMMIT;

-- RESET 1 (either session, AFTER A2): restore Q before next test.
UPDATE inventory 
SET quantity = quantity - 1 WHERE inventory_id = 1;
SELECT quantity 
FROM inventory 
WHERE inventory_id = 1;

-- TEST 2: REPEATABLE READ
-- A3 (Session A): SELECT establishes snapshot at Q.
BEGIN ISOLATION LEVEL REPEATABLE READ;
SELECT quantity 
FROM inventory 
WHERE inventory_id = 1;

-- B2 (Session B): commit a change to Q+1.
BEGIN;
UPDATE inventory 
SET quantity = quantity + 1 
WHERE inventory_id = 1;

COMMIT;

SELECT quantity 
FROM inventory 
WHERE inventory_id = 1;

-- A4 (Session A): still sees Q; after COMMIT a new SELECT sees Q+1. Screenshot: 06-repeatable-read.png
SELECT quantity 
FROM inventory 
WHERE inventory_id = 1;

COMMIT;

SELECT quantity 
FROM inventory 
WHERE inventory_id = 1;

-- RESET 2 (either session, AFTER A4): restore original Q.
UPDATE inventory 
SET quantity = quantity - 1 WHERE inventory_id = 1;

SELECT quantity 
FROM inventory WHERE inventory_id = 1;