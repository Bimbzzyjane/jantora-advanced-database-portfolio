# Portfolio 1 — Database Design and Modelling

**Course:** MIT 8103 Advanced Database Systems  
**Case study:** Jantora Superstores (simulated organisation)  
**Marks:** 7

## Overview

Jantora Superstores is a fictional Nigerian supermarket that operates a physical store and an online shopping platform. The scenario begins in Lagos and considers later expansion to multiple branches. This portfolio documents the design of a PostgreSQL database for customers, products, categories, branches, inventory, orders, order items, payments, and deliveries.

## Portfolio 1 deliverables

| Requirement | File | Description |
|---|---|---|
| Case study description | [01_case_study.md](01_case_study.md) | Business background, users, stored data, operations and expansion |
| ER diagram | [02_er_diagram.md](02_er_diagram.md), [er-diagram.mmd](er-diagram.mmd) | Nine entities and their relationships; editable Mermaid source |
| Relational schema | [03_relational_schema.md](03_relational_schema.md) | Formal relational notation and data dictionary |
| Keys and constraints | [04_keys_and_constraints.md](04_keys_and_constraints.md) | Primary/foreign keys and integrity rules |
| Normalisation | [05_normalisation.md](05_normalisation.md) | 1NF, 2NF and 3NF explained with Jantora examples |
| PostgreSQL implementation | [01_schema.sql](01_schema.sql) | Table definitions, keys, constraints and defaults |
| Sample data | [02_seed.sql](02_seed.sql) | Fictional data for development and demonstration |
| Practical evidence | [evidence/](evidence/) | Screenshots and short observations after verification |

## Design summary

- The schema contains nine related tables.
- Registered customers are required for online orders; walk-in purchases may have no customer record.
- `inventory` stores quantities separately for each `(branch_id, product_id)`.
- `order_items` records products purchased, quantities, and prices at the time of sale.
- The simplified model supports a maximum of one payment record and one delivery record per order.
- Delivery tracking is status-based; GPS tracking and delivery history are outside the current scope.

## How to reproduce the database

1. Create an empty PostgreSQL database named `jantora_db`.
2. Connect pgAdmin's Query Tool to `jantora_db`.
3. Run `01_schema.sql` once to create the nine tables.
4. Run `02_seed.sql` once to insert fictional sample data.
5. Inspect the tables and constraints in pgAdmin and save genuine evidence in `evidence/`.

## Evidence and verification

See [evidence/README.md](evidence/README.md) for the recommended screenshots and observation notes.


