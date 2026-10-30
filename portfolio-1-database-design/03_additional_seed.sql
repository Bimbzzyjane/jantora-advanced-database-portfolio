-- STEP 1: Add two new registered customers
INSERT INTO customers (full_name, email, phone, address)
VALUES
    ('Janet Okedoyin', 'janet.okedoyin@example.com',
     '08000000001', 'Surulere, Lagos'),
    ('Joshua Adedeji', 'joshua.adedeji@example.com',
     '08000000002', 'Yaba, Lagos');


-- STEP 2: Create an online order for Janet
INSERT INTO orders (
    customer_id,
    branch_id,
    order_type,
    order_status
)
VALUES (
    (SELECT customer_id FROM customers
     WHERE email = 'janet.okedoyin@example.com'),
    (SELECT branch_id FROM branches
     WHERE branch_name = 'Jantora Ikeja'),
    'ONLINE',
    'COMPLETED'
);


-- STEP 3: Create an online order for Joshua
INSERT INTO orders (
    customer_id,
    branch_id,
    order_type,
    order_status
)
VALUES (
    (SELECT customer_id FROM customers
     WHERE email = 'joshua.adedeji@example.com'),
    (SELECT branch_id FROM branches
     WHERE branch_name = 'Jantora Lekki'),
    'ONLINE',
    'PROCESSING'
);


-- STEP 4: Add one existing product to each new order
-- Product is selected from the existing products table.

INSERT INTO order_items (
    order_id,
    product_id,
    quantity,
    unit_price
)
SELECT
    o.order_id,
    p.product_id,
    2,
    p.price
FROM orders AS o
JOIN customers AS c
    ON c.customer_id = o.customer_id
CROSS JOIN LATERAL (
    SELECT product_id, price
    FROM products
    ORDER BY product_id
    LIMIT 1
) AS p
WHERE c.email = 'janet.okedoyin@example.com';


INSERT INTO order_items (
    order_id,
    product_id,
    quantity,
    unit_price
)
SELECT
    o.order_id,
    p.product_id,
    3,
    p.price
FROM orders AS o
JOIN customers AS c
    ON c.customer_id = o.customer_id
CROSS JOIN LATERAL (
    SELECT product_id, price
    FROM products
    ORDER BY product_id DESC
    LIMIT 1
) AS p
WHERE c.email = 'joshua.adedeji@example.com';


-- STEP 5: Record payment for Janet (successful)
INSERT INTO payments (
    order_id,
    amount,
    payment_method,
    payment_status,
    paid_at
)
SELECT
    o.order_id,
    SUM(oi.quantity * oi.unit_price),
    'CARD',
    'PAID',
    CURRENT_TIMESTAMP
FROM orders AS o
JOIN customers AS c
    ON c.customer_id = o.customer_id
JOIN order_items AS oi
    ON oi.order_id = o.order_id
WHERE c.email = 'janet.okedoyin@example.com'
GROUP BY o.order_id;


-- STEP 6: Record payment for Joshua (pending)
INSERT INTO payments (
    order_id,
    amount,
    payment_method,
    payment_status
)
SELECT
    o.order_id,
    SUM(oi.quantity * oi.unit_price),
    'TRANSFER',
    'PENDING'
FROM orders AS o
JOIN customers AS c
    ON c.customer_id = o.customer_id
JOIN order_items AS oi
    ON oi.order_id = o.order_id
WHERE c.email = 'joshua.adedeji@example.com'
GROUP BY o.order_id;
