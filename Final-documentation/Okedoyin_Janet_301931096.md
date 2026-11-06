# Jantora Superstores: Advanced Database Systems Portfolio

**Course:** MIT 8103 — Advanced Database Systems

**Name:** Janet Okedoyin       **Student ID:** 301931096

**Selected organisation:** Jantora Superstores, Lagos, Nigeria

**GitHub repository:** [Bimbzzyjane/jantora-advanced-database-portfolio](https://github.com/Bimbzzyjane/jantora-advanced-database-portfolio)

## Selected organisation and scope

For this assessment, I used Jantora Superstores, a fictional Nigerian retailer selling groceries and household products through physical stores and an online shopping channel. The business operates across multiple branches, with plans to expand beyond Lagos. I chose a supermarket because its daily operations involve several related activities, including managing products, monitoring branch inventory, recording customer purchases, processing payments and tracking deliveries. These activities provided a practical setting for understanding how databases support business operations. The project comprises five portfolios covering relational database design, query optimisation, transaction management, NoSQL databases and cloud database systems. I used PostgreSQL and pgAdmin for the relational database exercises and MongoDB Atlas for document modelling and cloud deployment. Both databases contain fictional sample data and operate independently.

## Summary of the Five Portfolios

**Portfolio 1. Database design and modelling.** I designed a relational database containing nine tables: categories, branches, customers, products, inventory, orders, order_items, payments and deliveries. I created an Entity Relationship Diagram (ERD) to illustrate how these tables connect and applied First, Second and Third Normal Forms (1NF–3NF) to reduce unnecessary data duplication. Primary keys, foreign keys and constraints were used to maintain relationships and prevent invalid data. The design supports registered online customers, walk-in purchases without customer registration, and stock quantities recorded separately for each branch. This helped me understand how a database structure can represent everyday supermarket operations while maintaining data consistency.

**Portfolio 2. Query processing and optimisation.** I developed five SQL queries to retrieve information useful for supermarket management, including customer orders, paid revenue by branch, products priced above average, available inventory and order totals. I used `EXPLAIN (ANALYZE, BUFFERS)` to examine how PostgreSQL processes a query [1]. Because the original business dataset was small, I created a separate benchmark table containing 100,000 synthetic records to investigate the effect of indexing. In the selected test runs, execution time decreased from 4.713 ms to 0.099 ms after creating an index. The execution plan changed from a sequential scan to a bitmap-based index access plan. This exercise demonstrated how indexing can improve specific queries, while also showing why performance results should be interpreted in relation to the dataset and workload.

**Portfolio 3. Transactions and concurrency.** I performed practical experiments to understand how PostgreSQL manages database changes and simultaneous access. Using an inventory record containing 30 units, I demonstrated how COMMIT permanently saved a deduction to 29 units. After restoring the original quantity, I used ROLLBACK to cancel another deduction, returning the stock to 30. I also used two pgAdmin sessions to investigate transaction isolation. Under READ COMMITTED, a subsequent query could see another transaction's committed change, whereas REPEATABLE READ maintained the earlier transaction snapshot [2]. The concurrency experiment demonstrated row-level locking when two sessions attempted conflicting updates. A lock timeout occurred while one session held the lock, and a later attempt succeeded after the lock was released. These exercises helped me understand how transactions and isolation levels protect data during simultaneous operations.

**Portfolio 4. NoSQL and advanced data models.** I created a MongoDB collection named jantora_nosql.products containing four sample products: Rice, Cooking Oil, Laundry Detergent and Electric Kettle. Unlike the relational tables, MongoDB documents allowed products to have different attributes. For example, rice could include weight information, while an electric kettle could include power and warranty details. I practised inserting documents, filtering products by category, price and nested attributes, and querying stock information stored in embedded arrays. I also performed update and delete operations using MongoDB Atlas [3]. This portfolio demonstrated how a document database can accommodate product information with varying structures.

**Portfolio 5. Distributed and cloud databases.** I used MongoDB Atlas to explore cloud database deployment and replication. The database was hosted on an Atlas Free cluster in the AWS Cape Town region (af-south-1). The deployment displayed three replica-set members: one primary and two secondaries. I accessed the product collection, examined the cluster configuration and reviewed available monitoring information. I also studied replication, read and write concerns, and sharding as concepts relevant to distributed databases [4]. Although I observed the replica-set configuration, I did not perform a failover or sharding experiment. This distinction helped me understand the difference between observing a system's configuration and testing its behaviour under failure.

## Results and supporting evidence

Each portfolio includes practical scripts, explanations and screenshots showing selected stages and results of the exercises.

| Activity | Screenshots and supporting evidence |
|---|---|
| 1 — Database Design | [Tables, ER diagram and constraints](https://github.com/Bimbzzyjane/jantora-advanced-database-portfolio/tree/main/portfolio-1-database-design/evidence) |
| 2 — Query Optimisation | [Query results, execution plans and before/after index plans](https://github.com/Bimbzzyjane/jantora-advanced-database-portfolio/tree/main/portfolio-2-query-optimisation/evidence) |
| 3 — Transactions | [Commit, Rollback, isolation and locking](https://github.com/Bimbzzyjane/jantora-advanced-database-portfolio/tree/main/portfolio-3-transactions-concurrency/evidence) |
| 4 — NoSQL | [Document structure, filters, update and deletion](https://github.com/Bimbzzyjane/jantora-advanced-database-portfolio/tree/main/portfolio-4-nosql/evidence) |
| 5 — Cloud Databases | [Deployment, replica-set members, access and monitoring](https://github.com/Bimbzzyjane/jantora-advanced-database-portfolio/tree/main/portfolio-5-distributed-cloud/evidence) |


## Individual reflection

Working on the five portfolios using one organisation helped me understand how different database concepts connect to real business activities. The database design exercise showed me that organising data properly is important for preventing duplication and maintaining accurate records. For example, recording inventory by branch makes it possible to track the same product across different locations, while separating orders from order items allows multiple products to belong to one purchase.

The query optimisation exercise taught me that obtaining the correct result is not the only consideration when writing SQL. I also need to understand how PostgreSQL retrieves the data and how indexes can affect performance.

The transaction and concurrency exercises were particularly useful because they showed how database operations behave when multiple users access or update the same records. Observing COMMIT, ROLLBACK and locking made these concepts easier to understand than studying them only in theory.

Working with MongoDB also helped me appreciate the differences between relational and document databases. I learned that the choice of database structure depends on the type of information being managed and the needs of the application.

If I were to extend this project, I would focus on integrating order creation, payment processing and inventory deductions into a complete transaction. I would also conduct repeated performance tests and explore backup and recovery procedures for cloud databases. Overall, the project improved my understanding of database design, querying, data consistency and the practical considerations involved in managing business information.

## References and AI-use declaration

1. PostgreSQL Global Development Group. *Using EXPLAIN*, PostgreSQL 18 documentation. [Official documentation](https://www.postgresql.org/docs/18/using-explain.html).
2. PostgreSQL Global Development Group. *Transaction Isolation*, PostgreSQL 18 documentation. [Official documentation](https://www.postgresql.org/docs/18/transaction-iso.html).
3. MongoDB. *Create, View, Update, and Delete Documents*. [Atlas documentation](https://www.mongodb.com/docs/atlas/atlas-ui/documents/).
4. MongoDB. *Replication and Replica Set Fundamentals*. [MongoDB documentation](https://www.mongodb.com/docs/manual/replication/).


**AI-use declaration:** I used OpenAI ChatGPT to assist with planning, understanding database concepts, drafting and explaining SQL and MongoDB examples, troubleshooting, interpreting results and preparing documentation. I also used Codex in VS Code to review the repository and improve documentation and selected SQL scripts.
I performed the original practical exercises in pgAdmin and MongoDB Atlas, reviewed the outputs and captured supporting screenshots. I remain responsible for understanding, verifying and accurately presenting the work submitted.
