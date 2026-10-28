# Task 5: Database Normalisation

## 5.1 Introduction

Normalisation is the process of organising relational tables to reduce unnecessary duplication and avoid problems when inserting, updating, or deleting records. For Jantora Superstores, I separated customers, products, branches, orders, and other information into related tables instead of keeping everything in one large sales table. Below, I explain the design using the first three normal forms (1NF, 2NF, and 3NF).

## 5.2 Why normalisation is needed

Imagine storing every sale in a single table containing the customer name and email, branch address, product name, category name, quantity, and payment details. A customer placing several orders would have their information repeated many times. If their email changed, we might need to edit several rows. Similarly, changing a branch address in one row but not another would leave conflicting information. Splitting the data into related tables reduces these risks.

## 5.3 First Normal Form (1NF)

A table satisfies 1NF when its columns contain single values rather than lists or repeating groups, and its rows can be uniquely identified. In our design, an order does not have columns such as `product_1`, `product_2`, and `product_3`. Instead, each product purchased appears as a separate row in `order_items`, with its own `order_item_id`, `order_id`, `product_id`, quantity, and unit price. All nine tables have primary keys, and their columns store individual values of the intended type.

**Example:** An order containing rice and milk is represented by one record in `orders` and two records in `order_items`, rather than a comma-separated product list.

## 5.4 Second Normal Form (2NF)

A table is in 2NF when it is already in 1NF and every non-prime attribute depends on the whole of every candidate key, not only part of a composite candidate key.

Our tables use single-column primary keys, but that alone is not enough to establish 2NF: we also need to consider composite candidate keys created by unique constraints. In `inventory`, the pair (`branch_id`, `product_id`) uniquely identifies a stock record, and `quantity` depends on both values together. A product may have different stock quantities at different branches. We therefore do not put `quantity` in `products` or store one overall stock quantity for all branches.

Likewise, in `order_items`, the pair (`order_id`, `product_id`) uniquely identifies an order line. The ordered `quantity` and recorded `unit_price` relate to that specific product in that specific order. The product's current catalogue price is stored separately in `products`; the order-line price preserves the price charged at the time of sale.

## 5.5 Third Normal Form (3NF)

A table is in 3NF when it is in 2NF and its non-key information does not depend transitively on a key through another non-key attribute (more formally, for each non-trivial functional dependency, the determinant is a superkey or the dependent attribute is prime).

In Jantora, the product's category name is stored in `categories`, not repeated in every row of `products`. The `products` table keeps `category_id` as a foreign key. Similarly, branch names and addresses are kept in `branches` rather than copied into `inventory` and `orders`. Customer details are kept in `customers`, while `orders` stores a customer reference when applicable. This reduces duplication and makes updates easier.

The separation of `orders` and `order_items` also avoids repeating order-level details for every product in an order. `payments` and `deliveries` hold details of those activities rather than adding many unrelated fields to `orders`.

## 5.6 Summary of the implemented tables

| Table | Main reason for its separation |
|---|---|
| `categories` | Stores category names once. |
| `products` | Stores product details and links each product to a category. |
| `branches` | Stores each branch's location details once. |
| `inventory` | Stores stock per product per branch. |
| `customers` | Stores customer information separately from orders. |
| `orders` | Stores information about each purchase. |
| `order_items` | Stores the individual products and quantities in each purchase. |
| `payments` | Stores payment details associated with an order. |
| `deliveries` | Stores delivery details for orders requiring delivery. |

## 5.7 Design choices and limitations

Normalisation does not mean that two similar-looking values must never appear in different tables. For example, `products.price` is the current catalogue price, while `order_items.unit_price` is the historical price charged for that order. They serve different purposes, so keeping both is intentional. We can calculate an order total from `order_items.quantity * order_items.unit_price` rather than storing a second total in `orders`.

The design is suitable for the current assessment scenario, although a real growing retailer might need extra tables for addresses, payment attempts, delivery-status history, and more complex stock movements. Those would be extensions rather than requirements for the present nine-table design.

## 5.8 Conclusion

The Jantora Superstores schema is designed to satisfy 1NF, 2NF, and 3NF under the business rules described above. Separating related data helps reduce duplication, supports consistent updates, and allows the same database to handle online purchases, in-store sales, and inventory at multiple branches. This normalised structure provides a foundation for the SQL, transaction, NoSQL, and cloud database activities in the remaining portfolios.

**Source:** Jantora Superstores `portfolio-1-database-design/01_schema.sql` (implemented PostgreSQL schema).
