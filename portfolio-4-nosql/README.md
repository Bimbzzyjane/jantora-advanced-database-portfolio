# Portfolio 4 — NoSQL and Advanced Data Models

**Case study:** Jantora Superstores, a fictional supermarket business with physical stores and e-commerce operations in Lagos, Nigeria.  
**Technology:** MongoDB Atlas (document-oriented NoSQL)  
**Database:** `jantora_nosql` · **Collection:** `products`

## Objective

Demonstrate a NoSQL document model using the same Jantora case study as Portfolios 1–3, with implementation evidence and an explanation of suitability. This is a separate product-catalogue demonstration; the existing PostgreSQL `jantora_db` is not modified or replaced.

## Document model and rationale

Each `products` document has a `product_id`, name, category, price, currency, nested `attributes` object, and embedded `stock_by_branch` array. Foodstuffs can have weight or volume while appliances have power and warranty fields. Flexible, category-specific product attributes are a strong fit for a document database.

The model embeds sample branch stock to demonstrate nested arrays, **not** to establish MongoDB as Jantora's authoritative inventory system. In a production deployment, frequently changing or transaction-critical stock, orders, and payments require careful consistency design and may remain in PostgreSQL. This portfolio uses illustrative/sample data, not verified copies of the PostgreSQL product records.

## Files

- `01_insert_documents.json` — four sample product documents to insert using **Atlas Data Explorer**.
- `01_create_and_insert.js` — reproducible **mongosh alternative** (upserts by `product_id`; does not erase existing data).
- `02_queries.js` — four equivalent queries for mongosh.
- `03_update_and_delete.js` — sectioned update, restoration, temporary insert and delete for mongosh.
- `evidence/` — actual Atlas screenshots (captured separately; copy into this folder).

**Important:** Atlas Data Explorer's **Filter** field takes a filter document such as `{ "category": "Foodstuff" }`, **not** complete commands such as `db.products.find(...)`. The `.js` scripts are for **mongosh**, not the Atlas Filter field. Do not paste your Atlas credentials or connection string into GitHub.

## Atlas execution and screenshot sequence

1. **Database structure — `01-database-collection.png`.** In Atlas Data Explorer, confirm the `jantora_nosql` database and `products` collection. Screenshot the collection list.
2. **Insert — `02-insert-documents.png`.** Use Add Data → Insert Document → JSON mode, and paste the contents of `01_insert_documents.json`. Insert **once**. Open one document and expand `attributes` and `stock_by_branch` to demonstrate nesting. Save a separate expanded Rice view as `02a-document-structure.png`. If the four records are already present, do not insert them again; just verify and capture. Expected sample `product_id` values are 1–4.
3. **Filter Q1 — `03-foodstuff-query.png`.** Atlas Documents → Filter: `{ "category": "Foodstuff" }` → Find. Expected sample products: Rice, Cooking Oil.
4. **Filter Q2 — `04-price-query.png`.** Filter: `{ "price": { "$gt": 15000 } }`. Expected: Rice, Electric Kettle.
5. **Filter Q3 — `05-nested-attribute-query.png`.** Filter: `{ "attributes.weight": { "$exists": true } }`. Expected: Rice, Laundry Detergent.
6. **Filter Q4 — `06-array-query.png`.** Filter: `{ "stock_by_branch": { "$elemMatch": { "branch": "Ikeja", "quantity": { "$lt": 10 } } } }`. Expected: Electric Kettle.
7. **Update — `07-update-result.png`.** Filter `{ "product_id": 4 }`, open Electric Kettle, use the **pencil/edit** control in **List view**, change `attributes.warranty_months` from 12 to 18, click Update, and capture the changed value. Then edit it back to 12 and verify restoration. Optionally capture `08-update-restored.png`, but not required.
8. **Temporary insert — `08-temporary-document.png`.** Insert this ONE test document using Atlas Add Data → Insert Document → JSON mode: `{ "product_id": 9001, "product_name": "Temporary Test Product", "category": "Demonstration", "price": 1000, "currency": "NGN", "attributes": { "purpose": "delete-test" }, "stock_by_branch": [] }`. Filter `{ "product_id": 9001 }` to show it exists. Screenshot.
9. **Delete — `09-delete-verification.png`.** Filter `{ "product_id": 9001 }`, delete **only that temporary document** using the trash icon and confirm. Run the same filter again; expected result: no documents. Screenshot the filtered empty results.
10. **Final verification — `10-final-collection.png`.** Filter `{}` to see the original four sample products; verify Electric Kettle warranty is back to 12 and temporary ID 9001 is absent. Capture evidence if useful.

**Safety:** Never delete the whole collection or database. Use explicit `product_id` filters for modification and deletion. The expected results above were checked against the actual Atlas observations reported during this portfolio exercise.

## Observed results in MongoDB Atlas

The following results were reported after executing the tests in Atlas Data Explorer. Screenshot references point to files captured during the practical work; add your actual image files under `evidence/` before committing.

| Experiment | Observed result | Screenshot |
|---|---|---|
| Database and collection | `jantora_nosql.products` created and visible | `01-database-collection.png` |
| Document insertion | Four sample products: Rice, Cooking Oil, Laundry Detergent, Electric Kettle | `02-insert-documents.png` |
| Nested document structure | Rice showed its `attributes` object and `stock_by_branch` array | `02a-document-structure.png` |
| Q1: `category = Foodstuff` | Rice and Cooking Oil | `03-foodstuff-query.png` |
| Q2: price greater than NGN 15,000 | Rice and Electric Kettle | `04-price-query.png` |
| Q3: weight attribute exists | Rice and Laundry Detergent | `05-nested-attribute-query.png` |
| Q4: Ikeja stock less than 10 | Electric Kettle (Ikeja: 8; Lekki: 5) | `06-array-query.png` |
| Update product | Electric Kettle warranty changed from 12 to 18 months, then restored to 12 | `07-update-result.png` |
| Insert temporary test record | Product ID 9001 added for deletion testing | `08-temporary-document.png` |
| Delete temporary record | Product ID 9001 deleted; subsequent filter returned no document | `09-delete-verification.png` |
| Final verification | Four original products remained; kettle warranty 12 months; temporary product absent | `10-final-collection.png` |

The sample product data are deliberately illustrative and are not synchronised with the relational PostgreSQL database.

## Suitability and trade-offs

**Why a document model works:** Product attributes differ by category; a document can include nested product specifications and branch availability with fewer joins for a catalogue view. Product documents can evolve as Jantora introduces new categories.

**Trade-offs:** Duplicated branch information can become stale; embedding frequently changing stock in product documents complicates coordination across systems. MongoDB still supports indexes, schema validation, and transactions where needed, but flexible structure alone does not guarantee consistency. PostgreSQL's relational constraints remain useful for critical order and payment workflows.

**Alternatives considered:** Key-value databases are useful for shopping-cart/session lookup but less expressive for multi-attribute catalogue filtering. Wide-column databases can suit large-scale partitioned writes; graph databases suit relationship-heavy recommendations. We chose the document model because the assessment demonstration focuses on flexible product attributes and nested branch stock.

## Screenshot evidence

These image links display after you copy your actual Atlas screenshots into the `evidence/` folder with the matching filenames.

**Atlas database and products collection**

![Atlas database and products collection](evidence/01-database-collection.png)

**Four Jantora product documents**

![Four Jantora product documents](evidence/02-insert-documents.png)

**Rice nested document structure**

![Rice nested document structure](evidence/02a-document-structure.png)

**Foodstuff category filter**

![Foodstuff category filter](evidence/03-foodstuff-query.png)

**Price comparison filter**

![Price comparison filter](evidence/04-price-query.png)

**Nested weight attribute filter**

![Nested weight attribute filter](evidence/05-nested-attribute-query.png)

**Embedded array stock filter**

![Embedded array stock filter](evidence/06-array-query.png)

**Kettle warranty updated**

![Kettle warranty updated](evidence/07-update-result.png)

**Temporary test product**

![Temporary test product](evidence/08-temporary-document.png)

**Temporary product deleted**

![Temporary product deleted](evidence/09-delete-verification.png)

**Final four product documents**

![Final four product documents](evidence/10-final-collection.png)

Reflection and AI-use disclosure are reserved for the final course report.

## References

- [MongoDB Atlas: Create, view, update and delete documents](https://www.mongodb.com/docs/atlas/atlas-ui/documents/)
- [MongoDB Atlas: Query documents in Data Explorer](https://www.mongodb.com/docs/atlas/atlas-ui/query/filter/)
- [MongoDB Shell](https://www.mongodb.com/docs/mongodb-shell/)
