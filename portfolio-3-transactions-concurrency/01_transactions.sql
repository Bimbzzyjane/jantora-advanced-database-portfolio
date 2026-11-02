-- JANTORA | Portfolio 3 | 01_transactions.sql

-- SECTION A: BASELINE. Record inventory_id and original quantity; screenshot optional.
SELECT inventory_id, branch_id, product_id, quantity
FROM inventory 
WHERE quantity >= 2 
ORDER BY inventory_id LIMIT 1;


-- SECTION B: COMMIT. Run this block together; screenshot the output.
BEGIN;

UPDATE inventory 
SET quantity = quantity - 1
WHERE inventory_id = (SELECT MIN(inventory_id) 
FROM inventory WHERE quantity >= 2);

SELECT inventory_id, quantity FROM inventory
WHERE inventory_id = (SELECT MIN(inventory_id) 
FROM inventory WHERE quantity >= 1);

COMMIT;


-- SECTION C: VERIFY COMMIT. Capture screenshot 01-commit.png.
SELECT inventory_id, branch_id, product_id, quantity
FROM inventory 
WHERE inventory_id = (SELECT MIN(inventory_id) 
FROM inventory WHERE quantity >= 1);

--SECTION D: RESTORE COMMITTED CHANGE (a new, committed transaction).

BEGIN;

UPDATE inventory 
SET quantity = quantity + 1 WHERE inventory_id = 1;

COMMIT;

SELECT inventory_id, quantity 
FROM inventory WHERE inventory_id = 1;

-- SECTION E: ROLLBACK PART 1. Before rollback. Screenshot 02-before-rollback.png.
BEGIN;

UPDATE inventory 
SET quantity = quantity - 1 
WHERE inventory_id = 1 AND quantity >= 1;

SELECT inventory_id, quantity 
FROM inventory 
WHERE inventory_id = 1;

-- SECTION F: ROLLBACK PART 2. SAME session, after Section E. Screenshot 03-after-rollback.png.

ROLLBACK;

SELECT inventory_id, quantity 
FROM inventory 
WHERE inventory_id = 1;

-- SECTION G: FINAL VERIFICATION. Screenshot 04-final-verification.png; original quantity should be restored.
SELECT inventory_id, quantity 
FROM inventory 
WHERE inventory_id = 1;

-- The blocks requiring your chosen ID are commented intentionally.
-- Uncomment only the relevant block after replacing its ID, then run it separately.
