# Portfolio 3 — Screenshot evidence

The nine actual pgAdmin screenshots captured during the exercises are in this folder, with these exact filenames:

1. `01-commit.png` — committed stock quantity 29.
2. `02-before-rollback.png` — uncommitted stock quantity 29.
3. `03-after-rollback.png` — stock restored to 30.
4. `04-final-verification.png` — final quantity 30.
5. `05-read-committed.png` — Session A sees 31 after Session B commits.
6. `06-repeatable-read.png` — Session A still sees 30 within its snapshot.
7. `07-concurrency-lock.png` — SQLSTATE 55P03 timeout.
8. `08-concurrency-result.png` — successful retry after lock release.
9. `09-concurrency-final-verification.png` — final quantity 30.
