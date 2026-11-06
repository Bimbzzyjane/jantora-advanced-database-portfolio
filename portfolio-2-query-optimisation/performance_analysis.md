# Query Results and Performance Analysis


## 1. Business queries and observations

The screenshots show the five business queries in `01_queries.sql` executed in pgAdmin. The captured dataset contains five orders, consistent with Portfolio 1's basic seed followed by `03_additional_seed.sql`.

| Query | SQL technique | Purpose | Observation visible in the supplied screenshot |
|---|---|---|---|
| Q1 — Order details | `JOIN`, `LEFT JOIN`, `COALESCE` | Show orders alongside customer, branch and payment details | Five orders are shown: Ada, a **Walk-in customer**, Tunde, Janet and Joshua. Tunde and Joshua have pending payments. |
| Q2 — Paid revenue by branch | `LEFT JOIN`, `COUNT`, `SUM`, `GROUP BY` | Calculate the number of paid orders and total paid revenue per branch | Ikeja has three paid orders totalling **NGN 54,100**; Ibadan and Lekki each have zero paid orders and zero paid revenue. |
| Q3 — Above-average product prices | Scalar subquery, `AVG`, `WHERE` | Identify products priced above the average product price | **Rice 5kg**, priced at **NGN 12,500**, is the only product returned. |
| Q4 — Stock by branch | Multi-table `JOIN` | Display inventory quantities by branch and product | Eight recorded branch/product inventory rows are shown; the execution plan also reports eight output rows. |
| Q5 — Calculated order totals | `JOIN`, `SUM`, `GROUP BY` | Calculate order values from the quantity and unit price of each order item | Totals for order IDs 1–5 are **NGN 27,200; 1,900; 12,500; 25,000; 2,850**, respectively. |

Q2 measures payments marked `PAID`, without an order-status exclusion; Q4 lists recorded inventory combinations; Q5 includes orders with line items. These query scopes should be considered when interpreting the results.

## 2. Execution plan: inventory query

The inventory query (Q4) in `02_execution_plans.sql` uses `EXPLAIN (ANALYZE, BUFFERS)` to examine how PostgreSQL retrieves and combines the records.

| Measurement | Observed result |
|---|---|
| Tables involved | `inventory`, `branches`, `products` |
| Table access | Sequential scans |
| Join operations | Hash joins |
| Sorting | Quicksort |
| Rows in final result | 8 |
| Sort memory | 25 kB |
| Planning time | 0.639 ms |
| Execution time | 0.315 ms |

**Interpretation:** PostgreSQL read the small tables using sequential scans, combined related rows using hash joins and sorted the output by branch and product name. The execution completed in 0.315 ms in the recorded run. A sequential scan is not necessarily inefficient: when tables are small, scanning them may be cheaper than using an index. This execution plan describes **one query (Q4)**, not all five business queries.

## 3. Index optimisation experiment

### 3.1 Test design

The script `03_index_optimisation.sql` creates a separate table named `portfolio2_benchmark_orders` containing **100,000 synthetic order-like records**. This table models a larger customer-order search workload that Jantora Superstores might experience as its business grows. It is **not** the existing Jantora `orders` table, and it does not establish production performance.

The same query was measured before and after indexing:

```sql
SELECT benchmark_id, customer_number, ordered_at, order_amount
FROM portfolio2_benchmark_orders
WHERE customer_number = 42;
```

After recording the baseline, the below index was created:

```sql
CREATE INDEX idx_p2_benchmark_customer_number
ON portfolio2_benchmark_orders (customer_number);
```

The SQL query and filter condition were unchanged for the before-and-after comparison.

### 3.2 Recorded results

| Measurement | Before index | After index (repeated run) |
|---|---:|---:|
| Scan method | Sequential Scan | Bitmap Heap Scan with a child Bitmap Index Scan |
| Planning time | 0.119 ms | 0.144 ms |
| Execution time | 4.713 ms | 0.099 ms |
| Planning + execution | 4.832 ms | 0.243 ms |

The earlier after-index run was reported as **4.321 ms to plan** and **0.201 ms to execute**. These original measurements are retained, but no screenshot or execution log for that run is supplied. The repeated run's **0.144 ms planning** and **0.099 ms execution**, and the baseline planning and execution times, are visible in `08-after-index.png` and `07-before-index.png`, respectively.

The planning-plus-execution totals are calculated from the captured timings. The selected execution-time reduction is:

\[
\frac{4.713 - 0.099}{4.713} \times 100 = 97.90\%.
\]

The query therefore executed approximately **47.61 times faster** in the selected before-and-after comparison. When planning and execution time are added, the recorded total decreased from **4.832 ms** to **0.243 ms**, a reduction of approximately **94.97%**. These percentages describe the measured runs, not a guaranteed speedup for every query.

### 3.3 Interpretation

The baseline screenshot shows a **Sequential Scan**, five matches and 99,995 rows removed by the filter. After indexing, a **Bitmap Index Scan** on `idx_p2_benchmark_customer_number` identifies matching heap locations, and its parent **Bitmap Heap Scan** retrieves the five rows. Shared-buffer hits decreased from **736 to 7**. Both captured runs show buffer hits; this is not evidence of reduced physical disk reads.

The reported earlier after-index run had a higher planning time than the captured repeated run. Its cause cannot be established from the supplied evidence. The comparison uses one baseline and a selected repeated indexed run, without a balanced series of trials; it does not establish an average speedup or isolate caching and system-load effects.

## 4. Practical evidence

The following screenshots are present in the repository.

| Evidence file | What it demonstrates |
|---|---|
| `evidence/01-order-details.png` | Q1 output showing customer, branch and payment details |
| `evidence/02-revenue-by-branch.png` | Q2 paid revenue grouped by branch |
| `evidence/03-above-average-products.png` | Q3 result identifying Rice 5kg |
| `evidence/04-stock-by-branch.png` | Q4 stock by product and branch |
| `evidence/05-order-totals.png` | Q5 calculated order totals |
| `evidence/06-inventory-execution-plan.png` | Inventory query plan, including scan and join operations |
| `evidence/07-before-index.png` | Benchmark plan and timing before indexing |
| `evidence/08-after-index.png` | Repeated benchmark plan and timing after indexing |

## Source attribution

The measurements and results above come from the repository's scripts and screenshots. PostgreSQL's [Using EXPLAIN](https://www.postgresql.org/docs/18/using-explain.html) explains sequential scans, bitmap index scans and bitmap heap scans.
