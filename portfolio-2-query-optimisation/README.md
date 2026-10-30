# Portfolio 2 — Query Processing and Optimisation

## Aim

This portfolio demonstrates how SQL can answer business questions for Jantora Superstores and how PostgreSQL processes and optimises queries. It includes five business queries, an execution-plan analysis of the real inventory tables, and an indexing experiment using a separate simulated order-search workload.

## Folder contents

| File or folder | Purpose |
|---|---|
| `01_queries.sql` | Five business queries covering joins, aggregation and a subquery |
| `02_execution_plans.sql` | `EXPLAIN (ANALYZE, BUFFERS)` for the inventory query (Q4) |
| `03_index_optimisation.sql` | Sections A–E for the 100,000-record benchmark and before/after index tests |
| `performance_analysis.md` | Observed results, execution-plan interpretation, timings |
| `evidence/` | Screenshots from pgAdmin and an evidence guide |

## Part 1 — Business queries

Ran each statement in `01_queries.sql` separately against `jantora_db` in pgAdmin.

| Query | Business question | SQL techniques |
|---|---|---|
| Q1 — Order details | Which customers placed orders, at which branches, and with what payment status? | `JOIN`, `LEFT JOIN`, `COALESCE` |
| Q2 — Paid revenue by branch | How many paid orders and how much paid revenue does each branch have? | `LEFT JOIN`, `COUNT`, `SUM`, `GROUP BY` |
| Q3 — Above-average prices | Which products cost more than the average product price? | Subquery, `AVG`, `WHERE` |
| Q4 — Inventory by branch | What stock quantity is recorded for each product at each branch? | Multiple `JOIN` operations |
| Q5 — Calculated order totals | What is each order's total based on its line items? | `JOIN`, `SUM`, `GROUP BY` |

All five queries were successfully executed. 

## Part 2 — Execution plan

`02_execution_plans.sql` examines **Q4 only**. It uses `EXPLAIN (ANALYZE, BUFFERS)` to show how PostgreSQL accesses the `inventory`, `branches` and `products` tables.

In the captured run, the plan showed sequential scans, hash joins, quicksort, eight output rows, **0.639 ms planning time** and **0.315 ms execution time**. See `performance_analysis.md` for interpretation.

## Part 3 — Index optimisation

`03_index_optimisation.sql` is divided into sections. **Run one section at a time, in order:**

1. **A — Setup:** Create a separate table, `portfolio2_benchmark_orders`, and insert 100,000 synthetic order-like records.
2. **B — Before:** Run the customer-number lookup with `EXPLAIN (ANALYZE, BUFFERS)` and save its plan.
3. **C — Index:** Create `idx_p2_benchmark_customer_number` on `customer_number`, then update statistics.
4. **D — Verify:** Check the index definition in `pg_indexes` (optional screenshot).
5. **E — After:** Repeat the same lookup and save the new plan.

**Why use a separate benchmark table?** Jantora's existing business tables contain too few rows to make a performance comparison especially informative. The synthetic table models a larger order-search workload relevant to a growing supermarket. **It is not Jantora's actual `orders` table**, and no production-performance claim is made.

### Recorded comparison

| Measurement | Before index | After index (repeated run) |
|---|---:|---:|
| Planning time | 0.119 ms | 0.144 ms |
| Execution time | 4.713 ms | 0.099 ms |
| Planning + execution | 4.832 ms | 0.243 ms |

The selected execution-time reduction was **97.90%**. An earlier after-index run measured **4.321 ms planning** and **0.201 ms execution**, demonstrating timing variability. The full discussion is in `performance_analysis.md`.

## Evidence and reproducibility

See [`evidence/README.md`](evidence/README.md) for the screenshot checklist. 
