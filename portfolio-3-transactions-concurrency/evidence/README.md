# Portfolio 3 — Screenshot evidence

The nine actual pgAdmin screenshots captured during the exercises are in this folder, with these exact filenames:

1. `01-commit.png` — verification SELECT returning 29 after the reported COMMIT; the COMMIT itself is not visible.
2. `02-before-rollback.png` — uncommitted stock quantity 29.
3. `03-after-rollback.png` — stock restored to 30.
4. `04-final-verification.png` — final quantity 30.
5. `05-read-committed.png` — SELECT returning 31, reported as Session A's read after Session B commits.
6. `06-repeatable-read.png` — SELECT returning 30, reported as Session A's repeatable-read snapshot.
7. `07-concurrency-lock.png` — SQLSTATE 55P03 timeout.
8. `08-concurrency-result.png` — UPDATE and SELECT returning 29, reported as the retry after lock release.
9. `09-concurrency-final-verification.png` — final quantity 30.
