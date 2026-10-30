# Portfolio 2 — Query Results and Performance Analysis

**Case study:** Jantora Superstores  
**Database:** PostgreSQL (`jantora_db`)  
**Focus:** SQL query processing, execution plans and index optimisation

## 1. Business queries and observations

I executed the five business queries in `01_queries.sql` using pgAdmin. The queries retrieve information relevant to Jantora Superstores' sales, customers and inventory.

| Query | SQL technique | Purpose | Observation from my pgAdmin session |
|---|---|---|---|
| Q1 — Order details | `JOIN`, `LEFT JOIN`, `COALESCE` | Show orders alongside customer, branch and payment details | The initial result showed three orders, including an in-store purchase displayed as **Walk-in customer** and an online order with a pending payment. |
| Q2 — Paid revenue by branch | `LEFT JOIN`, `COUNT`, `SUM`, `GROUP BY` | Calculate the number of paid orders and total paid revenue per branch | The query executed successfully. Exact revenue figures should be read from the saved result screenshot; they have not been recorded in this report. |
| Q3 — Above-average product prices | Scalar subquery, `AVG`, `WHERE` | Identify products priced above the average product price | **Rice** was the only product returned in the dataset tested. |
| Q4 — Stock by branch | Multi-table `JOIN` | Display inventory quantities by branch and product | The query executed successfully; the related execution plan reported **eight output rows**. |
| Q5 — Calculated order totals | `JOIN`, `SUM`, `GROUP BY` | Calculate order values from the quantity and unit price of each order item | The query executed successfully. |

These queries demonstrate how a relational database can answer practical business questions. The results depend on the records present when each query is run; additional sample customers and orders may change later outputs.

## 2. Execution plan: inventory query

I used `EXPLAIN (ANALYZE, BUFFERS)` with the inventory query (Q4) in `02_execution_plans.sql` to examine how PostgreSQL retrieved and combined the records.

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

I used `03_index_optimisation.sql` to create a separate table named `portfolio2_benchmark_orders` containing **100,000 synthetic order-like records**. This table models a larger customer-order search workload that Jantora Superstores might experience as its business grows. It is **not** the existing Jantora `orders` table, and it does not establish production performance.

The same query was measured before and after indexing:

```sql
SELECT benchmark_id, customer_number, ordered_at, order_amount
FROM portfolio2_benchmark_orders
WHERE customer_number = 42;
```

After recording the baseline, the script created this index:

```sql
CREATE INDEX idx_p2_benchmark_customer_number
ON portfolio2_benchmark_orders (customer_number);
```

The SQL query and filter condition were unchanged for the before-and-after comparison.

### 3.2 Recorded results

| Measurement | Before index | After index (repeated run) |
|---|---:|---:|
| Scan method | Sequential Scan (verify against saved baseline screenshot) | Index Scan |
| Planning time | 0.119 ms | 0.144 ms |
| Execution time | 4.713 ms | 0.099 ms |
| Planning + execution | 4.832 ms | 0.243 ms |

The **first** after-index run took **4.321 ms to plan** and **0.201 ms to execute**. A repeated run took **0.144 ms to plan** and **0.099 ms to execute**. I have reported both observations because performance measurements can vary between runs.

The selected execution-time reduction is:

\[
\frac{4.713 - 0.099}{4.713} \times 100 = 97.90\%.
\]

The query therefore executed approximately **47.61 times faster** in the selected before-and-after comparison. When planning and execution time are added, the recorded total decreased from **4.832 ms** to **0.243 ms**, a reduction of approximately **94.97%**. These percentages describe the measured runs, not a guaranteed speedup for every query.

### 3.3 Interpretation

Before the index was created, PostgreSQL had to inspect the table to find rows matching `customer_number = 42`. After indexing, the execution plan showed an **Index Scan**, indicating that PostgreSQL used the new index to locate matching records more directly. This explains why execution was substantially faster in the recorded comparison.

The initial after-index run had an unusually high planning time compared with the repeated run. One measurement is not enough to determine its cause. Caching, system activity and other measurement conditions can affect timings; it would be inappropriate to attribute the difference solely to the index.

## 4. Practical evidence

The following screenshots were captured or requested during the pgAdmin exercise.

| Evidence file | What it demonstrates |
|---|---|
| `evidence/01-order-details.png` | Q1 output showing customer, branch and payment details |
| `evidence/02-revenue-by-branch.png` | Q2 paid revenue grouped by branch |
| `evidence/03-above-average-products.png` | Q3 result identifying Rice |
| `evidence/04-stock-by-branch.png` | Q4 stock by product and branch |
| `evidence/05-order-totals.png` | Q5 calculated order totals |
| `evidence/06-inventory-execution-plan.png` | Inventory query plan, including scan and join operations |
| `evidence/07-before-index.png` | Benchmark plan and timing before indexing |
| `evidence/08-after-index.png` | Repeated benchmark plan and timing after indexing |

