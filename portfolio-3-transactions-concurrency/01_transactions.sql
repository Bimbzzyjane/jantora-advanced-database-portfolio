-- JANTORA | Portfolio 3 | 01_transactions.sql

-- SECTION A: Verify exactly one row: ID 1, branch 1, product 1, 30.

SELECT inventory_id, branch_id, product_id, quantity
FROM public.inventory
WHERE inventory_id = 1;

-- SECTION B: COMMIT. Run from BEGIN through COMMIT together: 30 -> 29.
BEGIN;

DO $commit_deduction$
BEGIN
    UPDATE public.inventory
    SET quantity = quantity - 1
    WHERE inventory_id = 1 AND branch_id = 1 AND product_id = 1
      AND quantity = 30;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'COMMIT deduction requires inventory 1, branch 1, product 1 at 30 units';
    END IF;
END;
$commit_deduction$ LANGUAGE plpgsql;

SELECT inventory_id, quantity
FROM public.inventory
WHERE inventory_id = 1 AND branch_id = 1 AND product_id = 1;

COMMIT;

-- SECTION C: VERIFY COMMIT. Same target should show 29 after Section B.
-- Evidence reference: 01-commit.png.
SELECT inventory_id, branch_id, product_id, quantity
FROM public.inventory
WHERE inventory_id = 1 AND branch_id = 1 AND product_id = 1;

-- SECTION D: RESTORE. Run the whole section once: a new commit, 29 -> 30.
-- Run only after Section B committed and Section C verified that deduction.
BEGIN;

DO $restore_committed_change$
BEGIN
    UPDATE public.inventory
    SET quantity = quantity + 1
    WHERE inventory_id = 1 AND branch_id = 1 AND product_id = 1
      AND quantity = 29;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Restoration requires inventory 1, branch 1, product 1 at 29 units';
    END IF;
END;
$restore_committed_change$ LANGUAGE plpgsql;

COMMIT;

SELECT inventory_id, quantity
FROM public.inventory
WHERE inventory_id = 1 AND branch_id = 1 AND product_id = 1;

-- SECTION E: ROLLBACK PART 1. Run this whole section and leave it open: 30 -> 29.
-- Evidence reference: 02-before-rollback.png.
BEGIN;

DO $temporary_deduction$
BEGIN
    UPDATE public.inventory
    SET quantity = quantity - 1
    WHERE inventory_id = 1 AND branch_id = 1 AND product_id = 1
      AND quantity = 30;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Temporary deduction requires inventory 1, branch 1, product 1 at 30 units';
    END IF;
END;
$temporary_deduction$ LANGUAGE plpgsql;

SELECT inventory_id, quantity
FROM public.inventory
WHERE inventory_id = 1 AND branch_id = 1 AND product_id = 1;

-- SECTION F: ROLLBACK PART 2. Same connection, immediately after Section E.
-- ROLLBACK discards the temporary deduction: 29 -> 30.
-- Evidence reference: 03-after-rollback.png.
ROLLBACK;

SELECT inventory_id, quantity
FROM public.inventory
WHERE inventory_id = 1 AND branch_id = 1 AND product_id = 1;

-- SECTION G: FINAL VERIFICATION. Same target should show the original 30.
-- Evidence reference: 04-final-verification.png.
SELECT inventory_id, quantity
FROM public.inventory
WHERE inventory_id = 1 AND branch_id = 1 AND product_id = 1;
