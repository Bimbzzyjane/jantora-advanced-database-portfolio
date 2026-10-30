-- Portfolio 2 / Step 3: Compare a query BEFORE and AFTER indexing.
-- Connect to jantora_db in pgAdmin. Run ONE section at a time (highlight it).
-- This uses a SEPARATE synthetic table; it does not modify the nine Jantora tables.

-- SECTION A: SET UP THE BENCHMARK DATA (run once).
-- CAUTION: Re-running this section deletes and recreates the synthetic table.
DROP TABLE IF EXISTS portfolio2_benchmark_orders;
CREATE TABLE portfolio2_benchmark_orders (
    benchmark_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    customer_number INTEGER NOT NULL,
    ordered_at TIMESTAMPTZ NOT NULL,
    order_amount NUMERIC(12,2) NOT NULL
);
INSERT INTO portfolio2_benchmark_orders (customer_number, ordered_at, order_amount)
SELECT (g % 20000) + 1,
       TIMESTAMPTZ '2026-01-01 00:00:00+00' + g * INTERVAL '1 minute',
       ((g % 50000) + 100)::NUMERIC / 100
FROM generate_series(1, 100000) AS g;
ANALYZE portfolio2_benchmark_orders;

-- SECTION B: BEFORE INDEX (run separately and save the actual execution plan).
EXPLAIN (ANALYZE, BUFFERS)
SELECT benchmark_id, customer_number, ordered_at, order_amount
FROM portfolio2_benchmark_orders
WHERE customer_number = 42;

-- SECTION C: CREATE INDEX (only after recording Section B's plan).
CREATE INDEX idx_p2_benchmark_customer_number
ON portfolio2_benchmark_orders (customer_number);
ANALYZE portfolio2_benchmark_orders;

-- SECTION D: VERIFY INDEX (save result if useful).
SELECT indexname, indexdef
FROM pg_indexes
WHERE schemaname = 'public'
  AND tablename = 'portfolio2_benchmark_orders'
ORDER BY indexname;

-- SECTION E: AFTER INDEX (run separately and save the actual execution plan).
EXPLAIN (ANALYZE, BUFFERS)
SELECT benchmark_id, customer_number, ordered_at, order_amount
FROM portfolio2_benchmark_orders
WHERE customer_number = 42;
