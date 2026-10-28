-- Run after schema and seed. Save output screenshots for your portfolio.
SELECT 'categories' AS table_name, COUNT(*) AS rows FROM categories
UNION ALL SELECT 'branches', COUNT(*) FROM branches
UNION ALL SELECT 'customers', COUNT(*) FROM customers
UNION ALL SELECT 'products', COUNT(*) FROM products
UNION ALL SELECT 'inventory', COUNT(*) FROM inventory
UNION ALL SELECT 'orders', COUNT(*) FROM orders
UNION ALL SELECT 'order_items', COUNT(*) FROM order_items
UNION ALL SELECT 'payments', COUNT(*) FROM payments
UNION ALL SELECT 'deliveries', COUNT(*) FROM deliveries;

-- Customer orders and their totals (including anonymous in-store sales).
SELECT o.order_id, o.order_type, COALESCE(c.full_name,'Walk-in customer') AS customer,
       b.branch_name, SUM(oi.quantity * oi.unit_price) AS order_total
FROM orders o
LEFT JOIN customers c ON c.customer_id = o.customer_id
JOIN branches b ON b.branch_id = o.branch_id
JOIN order_items oi ON oi.order_id = o.order_id
GROUP BY o.order_id, o.order_type, c.full_name, b.branch_name
ORDER BY o.order_id;

-- Stock per branch.
SELECT b.branch_name, p.product_name, i.quantity
FROM inventory i JOIN branches b ON b.branch_id=i.branch_id
JOIN products p ON p.product_id=i.product_id
ORDER BY b.branch_name, p.product_name;

-- Delivery tracking.
SELECT d.delivery_id, d.order_id, d.delivery_status, d.delivery_address
FROM deliveries d ORDER BY d.delivery_id;

-- Constraint test: should reject an ONLINE order without a customer.
-- Run separately if you want to capture the error; do not insert it into real data:
-- INSERT INTO orders (customer_id, branch_id, order_type) VALUES (NULL, 1, 'ONLINE');
