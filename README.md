# Jantora Superstores — Advanced Database Systems Portfolio

**Course:** MIT 8103 — Advanced Database Systems

**Assessment:** Individual practical database portfolio

## About the project

This project applies advanced database concepts to Jantora Superstores, a fictional retailer based in Lagos, Nigeria. The business sells groceries and household goods through physical stores and an online shopping store, with sample branches in Ikeja, Lekki and Ibadan.

I chose a supermarket because its everyday activities bring together products, customers, stock, orders and payments. As more branches open, the business needs organised records to show what was purchased, where stock is held and which orders have been paid for. Using one case study helped me connect database design, useful business queries, reliable stock updates and cloud database concepts across five portfolios.

The repository contains database scripts, explanations, diagrams and screenshots. The practical work was carried out through database tools; a shopping website or application is outside the scope of this project.

## Technologies used

| Technology | How I used it |
|---|---|
| **PostgreSQL** | Stored retail records in related tables and demonstrated SQL queries, indexing and transactions. The pgAdmin screenshots show a server labelled PostgreSQL 18. |
| **pgAdmin** | Ran SQL and inspected PostgreSQL tables, query results and execution plans—the steps the database uses to answer a query. |
| **MongoDB** | Modelled a separate catalogue using documents that can hold different product specifications. |
| **MongoDB Atlas** | Hosted the MongoDB catalogue in the cloud and provided deployment and monitoring views. The captured Free deployment uses MongoDB `8.0.36` on AWS Cape Town (`af-south-1`). |
| **mongosh and Mermaid** | Provided alternative MongoDB shell scripts and the editable source for the database relationship diagram, respectively. |

## What I accomplished

Each portfolio folder contains its implementation files, detailed guide and an `evidence/` folder with screenshots.

| Portfolio | Work completed | Guide | Evidence |
|---|---|---|---|
| **1 — Database design and modelling** | Designed nine related tables, created an entity relationship diagram, explained normalisation to reduce repeated data, and implemented keys, validation rules and sample records. | [Portfolio 1](portfolio-1-database-design/README.md) | [Screenshots](portfolio-1-database-design/evidence/) |
| **2 — Query processing and optimisation** | Executed five business queries, examined the inventory query's execution plan and compared a customer lookup before and after adding an index. | [Portfolio 2](portfolio-2-query-optimisation/README.md) | [Screenshots](portfolio-2-query-optimisation/evidence/) |
| **3 — Transactions and concurrency** | Tested saving changes with COMMIT, cancelling changes with ROLLBACK, visibility of updates between two sessions and locking when both sessions update the same stock record. | [Portfolio 3](portfolio-3-transactions-concurrency/README.md) | [Screenshots](portfolio-3-transactions-concurrency/evidence/) |
| **4 — NoSQL and advanced data models** | Created four MongoDB product documents with nested specifications and sample branch stock, then demonstrated searches, an update and temporary-record deletion. | [Portfolio 4](portfolio-4-nosql/README.md) | [Screenshots](portfolio-4-nosql/evidence/) |
| **5 — Distributed and cloud databases** | Inspected the Atlas deployment, primary and secondary members, collection access and monitoring. Discussed consistency and future scaling options. | [Portfolio 5](portfolio-5-distributed-cloud/README.md) | [Screenshots](portfolio-5-distributed-cloud/evidence/) |

The PostgreSQL model covers customers, categories, products, branches, inventory, orders, order items, payments and deliveries. It supports registered online customers and anonymous walk-in purchases. Stock is recorded separately for each product at each branch, and order items retain the price charged at purchase time.

See the [relationship diagram and explanation](portfolio-1-database-design/02_er_diagram.md) or its [editable Mermaid source](portfolio-1-database-design/er-diagram.mmd).

## Key results

- **Business queries:** The five-order dataset showed three paid orders totalling **NGN 54,100** for Ikeja. Other queries retrieved order details, products priced above average, branch stock and calculated order totals.
- **Query performance:** On a separate table of **100,000 synthetic records**, the selected customer-lookup runs took **4.713 ms before indexing** and **0.099 ms after indexing**. An index helps the database locate matching records without scanning the whole table. The [performance analysis](portfolio-2-query-optimisation/performance_analysis.md) explains the plans and measurement limits.
- **Transactions:** A committed deduction changed stock from **30 to 29 units**. After restoring the starting quantity, a separate temporary deduction was rolled back, leaving **30 units**. A competing update also produced a lock timeout, and the documented retry succeeded after the lock was released.
- **Product catalogue:** MongoDB held Rice, Cooking Oil, Laundry Detergent and Electric Kettle documents. The screenshots show the kettle warranty changed from **12 to 18 months** and confirm deletion of the temporary test product.
- **Cloud deployment:** Atlas showed **one primary and two secondary members**, successful access to the four products and operation-count charts. These members form a replica set, which maintains copies of the database.

## Finding and running the scripts

To recreate the PostgreSQL setup, create an empty database named `jantora_db`, connect to it in pgAdmin and run these files once, in order:

1. [`01_schema.sql`](portfolio-1-database-design/01_schema.sql) — creates the nine tables.
2. [`02_seed.sql`](portfolio-1-database-design/02_seed.sql) — inserts the initial sample data, including three orders.
3. [`03_additional_seed.sql`](portfolio-1-database-design/03_additional_seed.sql) — is intended to add Janet and Joshua and their orders, bringing the total to five. Its revised version has not been execution-tested.

Read the [Portfolio 1 execution conditions](portfolio-1-database-design/README.md#how-to-reproduce-the-database) first. The additional seed requires the original sample data and unused sample customer emails; it is not intended for repeated execution against the same populated database.

For the remaining exercises:

- **Queries and indexing:** Use Portfolio 2's [business queries](portfolio-2-query-optimisation/01_queries.sql), [inventory execution plan](portfolio-2-query-optimisation/02_execution_plans.sql) and [indexing benchmark](portfolio-2-query-optimisation/03_index_optimisation.sql). Run the benchmark sections in order; repeating its setup deletes and recreates only the synthetic benchmark table.
- **Transactions:** Follow the [Portfolio 3 guide](portfolio-3-transactions-concurrency/README.md) section by section. Check the required starting stock and use two distinct connections for isolation and locking tests.
- **MongoDB:** Follow the [Portfolio 4 guide](portfolio-4-nosql/README.md). Use either the [JSON sample data](portfolio-4-nosql/01_insert_documents.json) in Atlas Data Explorer or the [alternative mongosh insertion script](portfolio-4-nosql/01_create_and_insert.js). The [query](portfolio-4-nosql/02_queries.js) and [update/delete](portfolio-4-nosql/03_update_and_delete.js) files explain both routes. Atlas's Filter box accepts search conditions; full JavaScript commands run in mongosh. Check existing product IDs and starting values before repeating changes.
- **Cloud inspection:** Follow [Portfolio 5](portfolio-5-distributed-cloud/README.md), which uses the same Atlas deployment as Portfolio 4.

## Final report

The [final report](Final-documentation/Okedoyin_Janet_301931096.md) contains the portfolio summary, individual reflection, evidence links, references and AI-use declaration. Technical sources also appear in the individual portfolio documents.
