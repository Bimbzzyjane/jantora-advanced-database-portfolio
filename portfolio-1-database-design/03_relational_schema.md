# 3. Relational Schema – Jantora Superstores

## 3.1 Introduction

The relational schema describes how the data for Jantora Superstores is organised into related tables. The database uses nine tables to manage products, customers, branches, stock, orders, payments and deliveries. The schema below reflects the tables created in PostgreSQL using `01_schema.sql`.

In the notation below, **PK** means primary key and **FK** means foreign key.

## 3.2 Relational schema notation

1. **CATEGORIES**(`category_id` PK, `category_name`)
2. **BRANCHES**(`branch_id` PK, `branch_name`, `state`, `address`)
3. **CUSTOMERS**(`customer_id` PK, `full_name`, `email`, `phone`, `address`)
4. **PRODUCTS**(`product_id` PK, `category_id` FK → CATEGORIES.category_id, `product_name`, `price`)
5. **INVENTORY**(`inventory_id` PK, `branch_id` FK → BRANCHES.branch_id, `product_id` FK → PRODUCTS.product_id, `quantity`)
6. **ORDERS**(`order_id` PK, `customer_id` FK → CUSTOMERS.customer_id, `branch_id` FK → BRANCHES.branch_id, `order_type`, `order_status`, `ordered_at`)
7. **ORDER_ITEMS**(`order_item_id` PK, `order_id` FK → ORDERS.order_id, `product_id` FK → PRODUCTS.product_id, `quantity`, `unit_price`)
8. **PAYMENTS**(`payment_id` PK, `order_id` FK → ORDERS.order_id, `amount`, `payment_method`, `payment_status`, `paid_at`)
9. **DELIVERIES**(`delivery_id` PK, `order_id` FK → ORDERS.order_id, `delivery_address`, `delivery_status`, `dispatched_at`, `delivered_at`)

**Note:** `ORDERS.customer_id` is nullable because customers can make purchases in the physical store without registering. A check constraint requires a customer ID for online orders.

## 3.3 Data dictionary

The tables below list the actual PostgreSQL data types. `PK` and `FK` identify keys; other rules are explained in `04_keys_and_constraints.md`.

### CATEGORIES

| Attribute | Data type | Key |
|---|---|---|
| category_id | INTEGER (identity) | PK |
| category_name | VARCHAR(100) | — |

### BRANCHES

| Attribute | Data type | Key |
|---|---|---|
| branch_id | INTEGER (identity) | PK |
| branch_name | VARCHAR(120) | — |
| state | VARCHAR(80) | — |
| address | TEXT | — |

### CUSTOMERS

| Attribute | Data type | Key |
|---|---|---|
| customer_id | INTEGER (identity) | PK |
| full_name | VARCHAR(150) | — |
| email | VARCHAR(255) | — |
| phone | VARCHAR(30) | — |
| address | TEXT | — |

### PRODUCTS

| Attribute | Data type | Key |
|---|---|---|
| product_id | INTEGER (identity) | PK |
| category_id | INTEGER | FK → CATEGORIES |
| product_name | VARCHAR(150) | — |
| price | NUMERIC(12,2) | — |

### INVENTORY

| Attribute | Data type | Key |
|---|---|---|
| inventory_id | INTEGER (identity) | PK |
| branch_id | INTEGER | FK → BRANCHES |
| product_id | INTEGER | FK → PRODUCTS |
| quantity | INTEGER | — |

### ORDERS

| Attribute | Data type | Key |
|---|---|---|
| order_id | INTEGER (identity) | PK |
| customer_id | INTEGER (nullable) | FK → CUSTOMERS |
| branch_id | INTEGER | FK → BRANCHES |
| order_type | VARCHAR(12) | — |
| order_status | VARCHAR(20) | — |
| ordered_at | TIMESTAMPTZ | — |

### ORDER_ITEMS

| Attribute | Data type | Key |
|---|---|---|
| order_item_id | INTEGER (identity) | PK |
| order_id | INTEGER | FK → ORDERS |
| product_id | INTEGER | FK → PRODUCTS |
| quantity | INTEGER | — |
| unit_price | NUMERIC(12,2) | — |

### PAYMENTS

| Attribute | Data type | Key |
|---|---|---|
| payment_id | INTEGER (identity) | PK |
| order_id | INTEGER | FK → ORDERS |
| amount | NUMERIC(12,2) | — |
| payment_method | VARCHAR(20) | — |
| payment_status | VARCHAR(20) | — |
| paid_at | TIMESTAMPTZ | — |

### DELIVERIES

| Attribute | Data type | Key |
|---|---|---|
| delivery_id | INTEGER (identity) | PK |
| order_id | INTEGER | FK → ORDERS |
| delivery_address | TEXT | — |
| delivery_status | VARCHAR(20) | — |
| dispatched_at | TIMESTAMPTZ | — |
| delivered_at | TIMESTAMPTZ | — |

## 3.4 Explanation of the design

The `products` table stores each product once, while `inventory` records how much of that product is available at each branch. This makes it possible to track stock separately as Jantora opens more branches. `orders` records a purchase and its fulfilment branch, and `order_items` stores the products and quantities in that purchase. The `unit_price` in `order_items` records the price charged when the order was placed, even if the current product price later changes.

`payments` and `deliveries` are linked to `orders` using the order ID. The current design allows at most one payment record and one delivery record per order. A delivery record is not required for every order because customers can shop in-store.

This relational schema provides the structure needed for the next portfolio activities. The full SQL implementation is in `01_schema.sql`, and the separate keys and constraints document will explain the integrity rules in more detail.
