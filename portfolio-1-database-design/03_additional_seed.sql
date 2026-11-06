-- JANTORA | Portfolio 1 | Additional fictional sample data.
-- Run this entire script once after 01_schema.sql and 02_seed.sql in jantora_db.

BEGIN;

DO $additional_seed$
DECLARE
    v_ikeja_branch_id public.branches.branch_id%TYPE;
    v_lekki_branch_id public.branches.branch_id%TYPE;
    v_janet_product_id public.products.product_id%TYPE;
    v_joshua_product_id public.products.product_id%TYPE;
    v_janet_price public.products.price%TYPE;
    v_joshua_price public.products.price%TYPE;
    v_janet_customer_id public.customers.customer_id%TYPE;
    v_joshua_customer_id public.customers.customer_id%TYPE;
    v_janet_order_id public.orders.order_id%TYPE;
    v_joshua_order_id public.orders.order_id%TYPE;
BEGIN
    -- Required lookups must each return a row; missing data abort the script.
    SELECT branch_id INTO STRICT v_ikeja_branch_id
    FROM public.branches
    WHERE branch_name = 'Jantora Ikeja';

    SELECT branch_id INTO STRICT v_lekki_branch_id
    FROM public.branches
    WHERE branch_name = 'Jantora Lekki';

    SELECT product_id, price INTO STRICT v_janet_product_id, v_janet_price
    FROM public.products
    ORDER BY product_id
    LIMIT 1;

    SELECT product_id, price INTO STRICT v_joshua_product_id, v_joshua_price
    FROM public.products
    ORDER BY product_id DESC
    LIMIT 1;

    -- STEP 1: Preserve the two original customers; capture generated IDs.
    INSERT INTO public.customers (full_name, email, phone, address)
    VALUES ('Janet Okedoyin', 'janet.okedoyin@example.com',
            '08000000001', 'Surulere, Lagos')
    RETURNING customer_id INTO v_janet_customer_id;

    INSERT INTO public.customers (full_name, email, phone, address)
    VALUES ('Joshua Adedeji', 'joshua.adedeji@example.com',
            '08000000002', 'Yaba, Lagos')
    RETURNING customer_id INTO v_joshua_customer_id;

    -- STEPS 2-3: Capture these specific new orders, without assumed IDs.
    INSERT INTO public.orders (customer_id, branch_id, order_type, order_status)
    VALUES (v_janet_customer_id, v_ikeja_branch_id, 'ONLINE', 'COMPLETED')
    RETURNING order_id INTO v_janet_order_id;

    INSERT INTO public.orders (customer_id, branch_id, order_type, order_status)
    VALUES (v_joshua_customer_id, v_lekki_branch_id, 'ONLINE', 'PROCESSING')
    RETURNING order_id INTO v_joshua_order_id;

    -- STEP 4: Add the original quantities to only the captured new orders.
    INSERT INTO public.order_items (order_id, product_id, quantity, unit_price)
    VALUES (v_janet_order_id, v_janet_product_id, 2, v_janet_price),
           (v_joshua_order_id, v_joshua_product_id, 3, v_joshua_price);

    -- STEPS 5-6: Derive payments from only those new orders' line items.
    INSERT INTO public.payments
        (order_id, amount, payment_method, payment_status, paid_at)
    SELECT v_janet_order_id, SUM(quantity * unit_price),
           'CARD', 'PAID', CURRENT_TIMESTAMP
    FROM public.order_items
    WHERE order_id = v_janet_order_id;

    INSERT INTO public.payments
        (order_id, amount, payment_method, payment_status)
    SELECT v_joshua_order_id, SUM(quantity * unit_price), 'TRANSFER', 'PENDING'
    FROM public.order_items
    WHERE order_id = v_joshua_order_id;
END;
$additional_seed$ LANGUAGE plpgsql;

COMMIT;
