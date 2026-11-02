# Portfolio 3 — Transactions and Concurrency

**Case study:** Jantora Superstores  
**Database:** PostgreSQL (`jantora_db`)  
**Requirement:** Transaction examples showing COMMIT, ROLLBACK, isolation, a concurrency issue/control mechanism, and screenshot/output evidence.

## Objective

Demonstrate how PostgreSQL handles reliable inventory updates and simultaneous access to the same stock record. All experiments use Jantora's existing `inventory` table; no extra demonstration tables were created. The tested record was `inventory_id = 1` (`branch_id = 1`, `product_id = 1`), initially holding **30 units**.

## Files and execution

- `01_transactions.sql` — COMMIT, ROLLBACK and inventory restoration.
- `02_isolation_levels.sql` — READ COMMITTED and REPEATABLE READ, using two pgAdmin sessions.
- `03_concurrency_test.sql` — row-level locking, a lock timeout, retry and rollback, using two sessions.
- `evidence/` — nine screenshots of the executed SQL and pgAdmin output.

Open `jantora_db` in pgAdmin Query Tool. Execute **only one labelled section at a time**, in the order specified by each script. For the isolation and concurrency tests, use two distinct database connections (Session A and Session B). The scripts use `inventory_id = 1` based on this run; check the row and its current stock before repeating the tests. Avoid running stock updates or restoration steps more than once.

## 1. COMMIT and ROLLBACK

### COMMIT

A transaction deducted one unit from the inventory row and committed the update. A subsequent query confirmed that the quantity had changed from **30 to 29**. Because COMMIT made the change permanent, a **separate committed transaction** restored the stock from **29 to 30** before the next experiment.

![COMMIT result: 29 units](evidence/01-commit.png)

### ROLLBACK

A new transaction temporarily deducted one unit, changing the quantity from **30 to 29**. Before committing, `ROLLBACK` discarded that update; the subsequent query showed **30** again. Final verification confirmed the original quantity remained intact.

![Temporary change before ROLLBACK: 29 units](evidence/02-before-rollback.png)

![Quantity after ROLLBACK: 30 units](evidence/03-after-rollback.png)

![Final verification: 30 units](evidence/04-final-verification.png)

## 2. Transaction isolation

Two separate pgAdmin Query Tool sessions were used. Session A started a transaction and read the stock quantity, while Session B committed an update from **30 to 31**.

| Observation | READ COMMITTED | REPEATABLE READ |
|---|---:|---:|
| Session A's first read | 30 | 30 |
| Session B's committed update | 31 | 31 |
| Session A's next read, before its COMMIT | **31** | **30** |
| Session A's read after COMMIT | — | **31** |
| Quantity after the test's reset | 30 | 30 |

Under **READ COMMITTED**, Session A's new SELECT saw the change already committed by Session B. Under **REPEATABLE READ**, Session A continued to see its earlier snapshot (30) until its transaction ended. After COMMIT, a new SELECT saw 31. Each test's committed increment was reversed by a separate update to restore the original 30 units.

![READ COMMITTED: Session A sees 31](evidence/05-read-committed.png)

![REPEATABLE READ: Session A still sees 30](evidence/06-repeatable-read.png)

## 3. Concurrency control: row-level locking

Two sessions attempted to deduct stock from `inventory_id = 1` at the same time. Session A updated the quantity from **30 to 29** inside an open transaction, holding a row-level lock. Session B attempted to update the same row with `lock_timeout = '3s'` and received the expected **SQLSTATE 55P03** (`lock_not_available`), showing that the conflicting update could not proceed while Session A held the lock.

Session B rolled back its failed transaction. Session A then rolled back its uncommitted deduction, releasing the lock and restoring 30 units. Session B retried the update successfully (temporarily seeing **29**) and rolled it back. The final verification returned **30 units**.

![Session B lock timeout: SQLSTATE 55P03](evidence/07-concurrency-lock.png)

![Session B successful retry after lock release](evidence/08-concurrency-result.png)

![Final inventory verification: 30 units](evidence/09-concurrency-final-verification.png)

## Findings and ACID properties

- **Atomicity:** ROLLBACK undid the uncommitted stock deduction as a single transaction.
- **Consistency:** The original inventory quantity was restored after all controlled tests; the schema's inventory constraints also help prevent invalid stock values.
- **Isolation:** READ COMMITTED and REPEATABLE READ produced different, expected visibility of another session's committed update.
- **Durability:** The committed stock deduction remained visible in a subsequent query until a separate restoration transaction changed it.
- **Concurrency control:** A row-level lock prevented a second session from modifying the same stock record concurrently; the lock timeout made the waiting behavior observable, and the retry succeeded after release.

These are observations from a controlled test of one inventory record, not a production workload benchmark. The screenshots provide the corresponding execution evidence.
