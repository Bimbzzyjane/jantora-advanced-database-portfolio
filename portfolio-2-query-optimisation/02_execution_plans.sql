-- Portfolio 2 / Step 2: Investigate how PostgreSQL executes a business query.
-- Connect to jantora_db in pgAdmin.
-- Run this after 01_queries.sql. EXPLAIN ANALYZE executes the SELECT.
-- Save the real plan; do not assume the planner will choose a particular scan.

-- Plan for Q4: stock quantities by branch and product.
EXPLAIN (ANALYZE, BUFFERS)
SELECT b.branch_name, pr.product_name, i.quantity
FROM inventory AS i
JOIN branches AS b ON b.branch_id = i.branch_id
JOIN products AS pr ON pr.product_id = i.product_id
ORDER BY b.branch_name, pr.product_name;

-- Notes: record the scan and join types, Planning Time and Execution Time
-- in performance_analysis.md. The small seed dataset may favour scans.
