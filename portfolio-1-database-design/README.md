# Portfolio 1 — Database Design and Modelling (7 marks)

## Organisation and business process
Jantora Superstores is a simulated Nigerian retail business operating a physical supermarket and an online shopping channel. It begins with one Lagos store, then expands to additional branches. The relational database holds customer, product, order, payment, inventory, and delivery records.

**Users:** registered online customers; cashiers; inventory staff; branch managers; delivery staff; system administrators. These users ordinarily interact through an application; this portfolio demonstrates the underlying SQL directly.

**Key operations:** register customers; list products; manage stock by branch; record in-store and online orders; record payments; update delivery statuses; report on branch sales and inventory.

## Design decisions
- Online orders must reference a customer; walk-in purchases may have `customer_id = NULL`. A `CHECK` constraint enforces this.
- An order is fulfilled by one branch in this simplified model. Cross-branch split fulfillment is out of scope.
- Product stock is stored in `inventory`, one row per `(branch_id, product_id)`, not in `products`.
- `order_items.unit_price` preserves the price at purchase time, even if `products.price` later changes.
- Each order has zero or one payment record and zero or one delivery record in this simplified model. Multiple payment attempts, refunds, delivery status histories, and partial shipments are not modelled.
- Delivery status is a manually updated value, not GPS tracking.
- The database supports multiple branches from the start, even though the scenario begins with one branch.

## Entities and relationships
1. `categories` (1) → (many) `products`
2. `branches` (1) → (many) `inventory`; `products` (1) → (many) `inventory`
3. `customers` (1) → (many) `orders` (nullable for in-store sales)
4. `branches` (1) → (many) `orders`
5. `orders` (1) → (many) `order_items`; `products` (1) → (many) `order_items`
6. `orders` (1) → (zero/one) `payments` and `deliveries`

The diagram is in [`er-diagram.mmd`](er-diagram.mmd). The actual relational schema, keys and constraints are in [`01_schema.sql`](01_schema.sql).

## Normalisation (up to 3NF)
**1NF:** Each field holds one value, and order products are represented by separate rows in `order_items` rather than a comma-separated list.

**2NF:** Every non-key attribute depends on the whole key. In `inventory`, the pair `(branch_id, product_id)` uniquely identifies the stock quantity; `branch_name` and `product_name` are not repeated there. `order_items` uses a surrogate primary key, while its product and order references identify the purchased item.

**3NF:** Non-key attributes depend on keys, not on other non-key attributes. Product category names are held in `categories`, branch addresses in `branches`, and customer contact details in `customers` instead of being copied into every order. `order_items.unit_price` is intentionally stored as a historical transaction fact, not as a copy of the current product price.

## Validation checklist
- [ ] Run schema in PostgreSQL without errors.
- [ ] Run seed script and inspect inserted records.
- [ ] Run validation queries and capture output.
- [ ] Verify invalid online orders without a customer are rejected.
- [ ] Export or screenshot the ER diagram.
- [ ] Write a short note describing what you observed when testing.

## Evidence to capture
Screenshots of created tables, ER diagram, sample query results, and constraint error from an intentional invalid insert (test inside a transaction and roll it back). Do not present untested code as successful execution.
