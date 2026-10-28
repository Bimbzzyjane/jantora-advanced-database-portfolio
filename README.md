# Jantora Superstores — Advanced Database Systems Portfolio

**Course:** MIT 8103 Advanced Database Systems | **Assessment:** Individual practical portfolio (40 marks)

## Case study
Jantora Superstores is a **fictional** supermarket in Lagos, Nigeria, operating a physical store and an e-commerce platform from the start. Customers register before ordering online; walk-in purchases may be anonymous. Jantora later expands to branches in Lagos and other states. Its database supports product catalogues, branch-level inventory, purchases, payments, and delivery status tracking.

## Portfolio roadmap
1. **Database design and modelling:** ER diagram, relational schema, constraints, and normalisation.
2. **Query processing and optimisation:** queries, `EXPLAIN (ANALYZE, BUFFERS)`, indexes, performance evidence.
3. **Transactions and concurrency:** COMMIT, ROLLBACK, isolation, stock contention.
4. **NoSQL:** document model for flexible product attributes.
5. **Distributed/cloud:** evaluate cloud deployment, replication, consistency and branch availability.

## Run Portfolio 1
Requires PostgreSQL 14+ and `psql` (or run each script using pgAdmin Query Tool).

1. Create an empty database named `jantora_db` using pgAdmin or `createdb jantora_db`.
2. Run `portfolio-1-database-design/01_schema.sql` against `jantora_db`.
3. Run `portfolio-1-database-design/02_seed.sql`.
4. Run `portfolio-1-database-design/03_validation.sql` and inspect the results.
5. Open `portfolio-1-database-design/er-diagram.mmd` in a Mermaid renderer to view the ERD.

Example with psql:
```bash
psql -d jantora_db -f portfolio-1-database-design/01_schema.sql
psql -d jantora_db -f portfolio-1-database-design/02_seed.sql
psql -d jantora_db -f portfolio-1-database-design/03_validation.sql
```

> Run scripts in order, once, on an empty database. The seed data is fictional. Save your own screenshots of the results in the relevant portfolio folder. Do not commit passwords or `.env` files.

## Current status
- Portfolio 1: initial design and runnable scripts prepared; local PostgreSQL execution and screenshots **pending**.
- Portfolios 2–5: planned, not yet implemented or tested.
- Final report: outline prepared; individual reflection and AI-use declaration to be completed truthfully after practical work.

## Submission
The lecturer clarified that the GitHub repository should be **public** (the original PDF says private). Submit the 2–3 page summary and accessible repository URL on the LMS. The lecturer requires progressive GitHub activity and an AI-use declaration where applicable.
