-- Portfolio 2: Jantora Superstores business queries.
-- Run in pgAdmin Query Tool connected to jantora_db.
-- These queries only read data; capture the Data Output for each.

-- Q1: Order details (joins): customer, branch, and payment status.
SELECT o.order_id, o.order_type, o.order_status,
       COALESCE(c.full_name, 'Walk-in customer') AS customer,
       b.branch_name, p.payment_status
FROM orders AS o
JOIN branches AS b ON b.branch_id = o.branch_id
LEFT JOIN customers AS c ON c.customer_id = o.customer_id
LEFT JOIN payments AS p ON p.order_id = o.order_id
ORDER BY o.order_id;

-- Q2: Revenue by branch for successfully paid orders (joins + aggregation).
SELECT b.branch_name, COUNT(p.payment_id) AS paid_orders,
       COALESCE(SUM(p.amount), 0) AS total_revenue
FROM branches AS b
LEFT JOIN orders AS o ON o.branch_id = b.branch_id
LEFT JOIN payments AS p ON p.order_id = o.order_id AND p.payment_status = 'PAID'
GROUP BY b.branch_id, b.branch_name
ORDER BY total_revenue DESC, b.branch_name;

-- Q3: Products priced above the average product price (subquery).
SELECT product_id, product_name, price
FROM products
WHERE price > (SELECT AVG(price) FROM products)
ORDER BY price DESC;

-- Q4: Current stock by product and branch (joins).
SELECT b.branch_name, pr.product_name, i.quantity
FROM inventory AS i
JOIN branches AS b ON b.branch_id = i.branch_id
JOIN products AS pr ON pr.product_id = i.product_id
ORDER BY b.branch_name, pr.product_name;

-- Q5: Order totals derived from line items (aggregation).
SELECT o.order_id, o.order_type,
       SUM(oi.quantity * oi.unit_price) AS calculated_order_total
FROM orders AS o
JOIN order_items AS oi ON oi.order_id = o.order_id
GROUP BY o.order_id, o.order_type
ORDER BY o.order_id;
