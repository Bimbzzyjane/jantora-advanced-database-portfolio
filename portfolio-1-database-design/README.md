# Portfolio 1 — Database Design and Modelling

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
| Basic sample data | [02_seed.sql](02_seed.sql) | Three initial orders and associated fictional records |
| Additional sample data | [03_additional_seed.sql](03_additional_seed.sql) | Janet and Joshua, their orders, line items and payments; produces the five-order dataset shown in Portfolio 2 |
| Practical evidence | [evidence/](evidence/) | Supplied screenshots of tables, the ERD and inventory constraints |

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
5. Run `03_additional_seed.sql` once to reproduce the five-order dataset shown in Portfolio 2.

The basic seed alone creates three orders. The revised additional seed runs inside an explicit transaction and captures the inserted customer and order IDs with RETURNING. Its line items and payments reference only those new orders; a failure prevents partial row inserts from being committed. It remains a run-once script after the schema and basic seed, using the public schema and identity sequences advanced by the basic seed. The two sample customer emails must not already exist; a repeat run fails rather than reusing records. It preserves the original lowest/highest-product-ID selection and catalogue prices, so changed product data can affect the selected products and amounts. Run the whole script with no open transaction or concurrent sample-data edits; after an error, ROLLBACK before retrying. Identity sequences may retain gaps after failure. The nine-table count describes the business schema; Portfolio 2 adds a separate benchmark table.

## Evidence and verification

See [evidence/README.md](evidence/README.md) for the supplied screenshots and their scope. The constraints image shows the inventory table's listed constraints; it does not document constraint tests for all nine tables.
