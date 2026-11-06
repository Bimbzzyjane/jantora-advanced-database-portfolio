# Jantora Superstores: Advanced Database Systems Portfolio

**Course:** MIT 8103 — Advanced Database Systems

**Selected organisation:** Jantora Superstores, Lagos, Nigeria (fictional case study)

**GitHub repository:** [Bimbzzyjane/jantora-advanced-database-portfolio](https://github.com/Bimbzzyjane/jantora-advanced-database-portfolio)

## Case study and purpose

Jantora Superstores is a fictional Nigerian retailer selling groceries and household goods through physical stores and a proposed online shopping service. I used this organisation across all five activities to connect database concepts to everyday problems: recording purchases, keeping branch stock accurate, tracking payments and organising product information. PostgreSQL and pgAdmin were used for the relational work, while MongoDB Atlas was used for a separate product-catalogue demonstration. The work focuses on databases; a shopping application was outside its scope.

## The five portfolio activities

**1. Database design and modelling.** The relational database contains nine tables: customers, categories, products, branches, inventory, orders, order items, payments and deliveries. The ER diagram explains their relationships, and the normalisation discussion covers 1NF, 2NF and 3NF. Separating orders from order items allows one purchase to contain several products without repeating customer and branch details. Inventory is recorded by branch and product, since the same item can have different stock levels at different locations. Online orders require a registered customer, while walk-in purchases can be anonymous. Primary keys, foreign keys, unique constraints and checks protect the records, including preventing negative quantities. The design allows only one payment and one delivery record per order; split payments and multiple shipments would require further work.

**2. Query processing and optimisation.** Five SQL queries retrieve order details, paid revenue by branch, products priced above average, branch stock and calculated order totals. In the recorded results, Ikeja had three paid orders worth NGN 54,100, and Rice 5kg was the only product priced above the catalogue average. I also examined the inventory query using `EXPLAIN (ANALYZE, BUFFERS)`, which exposes the operations PostgreSQL uses to produce results [1]. A separate 100,000-row synthetic benchmark compared the same customer lookup before and after indexing. Execution time fell from 4.713 ms to 0.099 ms in the selected runs, and the plan changed from a sequential scan to a bitmap heap scan supported by a bitmap index scan. These measurements illustrate the benefit for that lookup; they do not establish an average or production-wide improvement.

**3. Transactions and concurrency.** This activity used an inventory record starting at 30 units. The documented COMMIT experiment reduced it to 29, while ROLLBACK discarded a temporary deduction and returned it to 30. Two-session tests compared READ COMMITTED and REPEATABLE READ: the reported second read saw another session's committed value of 31 under READ COMMITTED, but retained the earlier value of 30 under REPEATABLE READ. This follows PostgreSQL's documented snapshot behaviour [2]. A competing update produced lock-timeout error `55P03` while the first session held the row lock. The documented retry succeeded after release, and final verification showed 30 units. Screenshots capture selected outputs rather than the full session sequence. The revised COMMIT/ROLLBACK script was reviewed statically after these experiments and has not been rerun.

**4. NoSQL and advanced data models.** The MongoDB collection `jantora_nosql.products` contains four illustrative products: Rice, Cooking Oil, Laundry Detergent and Electric Kettle. Nested attributes hold details such as weight or warranty, while an embedded array records sample branch stock. This structure accommodates different product specifications. Filters demonstrated category, price, nested-field and array searches. The kettle warranty was updated from 12 to 18 months, and a temporary document was inserted and deleted. The final collection view shows the four original products; restoration of the warranty to 12 months is recorded in the portfolio account but is not visible in that final image. Atlas document-management guidance supports these operations [3]. This catalogue is separate from PostgreSQL and is not synchronised with its inventory.

**5. Distributed and cloud databases.** The Atlas deployment evidence shows a Free cluster on AWS in Cape Town (`af-south-1`), with one primary and two secondary replica-set members. The collection was accessible, and monitoring displayed operation counts for the members. MongoDB documents replication as a way to maintain redundant copies and support availability [4]. For Jantora, this raises practical questions about how current catalogue reads must be and how reliably stock and payment writes must be acknowledged. Read/write concerns and future sharding were discussed, but consistency timing, forced failover and sharding were not tested. Backups were inactive in the captured overview. The deployment demonstrates cloud hosting and replica-set topology, with further work needed before production use.

## Supporting evidence and repository access

The repository contains scripts, detailed explanations and screenshots for all five activities. The links below provide the supporting evidence for each activity.

| Activity | Screenshots and supporting evidence |
|---|---|
| 1 — Design | [ER diagram, nine tables and constraints](https://github.com/Bimbzzyjane/jantora-advanced-database-portfolio/tree/main/portfolio-1-database-design/evidence) |
| 2 — Queries | [Query outputs and before/after index plans](https://github.com/Bimbzzyjane/jantora-advanced-database-portfolio/tree/main/portfolio-2-query-optimisation/evidence) |
| 3 — Transactions | [Rollback, isolation results and lock timeout](https://github.com/Bimbzzyjane/jantora-advanced-database-portfolio/tree/main/portfolio-3-transactions-concurrency/evidence) |
| 4 — NoSQL | [Document structure, filters, update and deletion](https://github.com/Bimbzzyjane/jantora-advanced-database-portfolio/tree/main/portfolio-4-nosql/evidence) |
| 5 — Cloud | [Deployment, replica-set members, access and monitoring](https://github.com/Bimbzzyjane/jantora-advanced-database-portfolio/tree/main/portfolio-5-distributed-cloud/evidence) |

The GitHub repository was accessible without authentication when checked on **5 November 2026**. Screenshots record the experiments at capture time, rather than the current state of a live database.

## Individual reflection

Using one organisation throughout helped me connect design decisions with their consequences. Recording stock by branch and product made the inventory queries meaningful. Keeping the price charged in each order item also explained why an old purchase should retain its value when the catalogue price changes.

The performance comparison taught me to look beyond a faster execution time. The scan method, dataset size and choice of recorded run affect what I can reasonably conclude. The transaction activity brought out another issue: a non-negative stock constraint alone cannot coordinate simultaneous purchases. Transaction boundaries and locking also matter.

Comparing PostgreSQL with MongoDB helped me see why different parts of a retail system may suit different models. Flexible product descriptions fit documents well, while orders and payments benefit from clear relationships and constraints. If I extended this work, I would prioritise a complete order-and-stock transaction, repeated benchmark trials and fuller two-session evidence. I would also address backups before treating the cloud deployment as ready for business use.

## References and AI-use declaration

1. PostgreSQL Global Development Group. *Using EXPLAIN*, PostgreSQL 18 documentation. [Official documentation](https://www.postgresql.org/docs/18/using-explain.html).
2. PostgreSQL Global Development Group. *Transaction Isolation*, PostgreSQL 18 documentation. [Official documentation](https://www.postgresql.org/docs/18/transaction-iso.html).
3. MongoDB. *Create, View, Update, and Delete Documents*. [Atlas documentation](https://www.mongodb.com/docs/atlas/atlas-ui/documents/).
4. MongoDB. *Replication and Replica Set Fundamentals*. [MongoDB documentation](https://www.mongodb.com/docs/manual/replication/).

References accessed 5 November 2026. Additional technical sources are retained in the individual portfolio documents.

**AI-use declaration:** OpenAI Codex assisted with drafting and editing this summary and checking its descriptions against the existing portfolio documentation. The results reported here come from the repository's recorded experiments and supplied screenshots; the AI did not rerun the databases or generate new experimental evidence for this report.
