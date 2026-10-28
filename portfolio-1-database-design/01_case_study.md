# 1. Chosen Case Study: Jantora Superstores

## 1.1 Background of the Organisation

Jantora Superstores is a fictional retail business based in Lagos State, Nigeria. The supermarket sells groceries, beverages, household items, personal care products and other everyday essentials. It operates both a physical store and an online shopping platform, allowing customers to purchase products in-store or place orders online.

As the business grows, Jantora Superstores plans to open more branches within Lagos State and later expand to other parts of Nigeria. Managing products, sales, customer orders and stock across these locations will require an organised advanced database system. The proposed database will support the supermarket's daily activities and provide a foundation for managing operations as the business expands.

## 1.2 Users of the Database

Different groups of people will use the system for different purposes:

- **Customers:** Registered online customers can browse products, place orders, review their orders and check delivery status. Walk-in customers can buy items at the physical store without registering.
- **Sales staff:** Record purchases made at the physical store.
- **Inventory staff:** Monitor stock quantities and update product availability for each branch.
- **Store managers:** Review sales, orders and stock information for their branches.
- **Delivery staff:** Update the progress of deliveries, including when orders are dispatched and delivered.
- **System administrators:** Manage access to the system and maintain the database.

These users would normally interact with the database through an application. For this portfolio, the database operations are demonstrated directly in PostgreSQL.

## 1.3 Major Data to Be Stored

The database stores information about customers, product categories, products, branches, inventory, orders, order items, payments and deliveries. Customer records contain contact details, while product records contain product names, prices and categories. Branch and inventory records show where products are stocked and the quantity available at each location.

Orders and order items record purchases and the products included in them. Payment records contain the amount, method and payment status. Delivery records store the delivery address, status and relevant dates. The database uses nine related tables to organise this information.

## 1.4 Key Database Operations

The database is designed to support the following activities:

1. Register customers for online shopping and maintain customer information.
2. Add products, organise them into categories and update their prices.
3. Record sales made online and in physical stores.
4. Record the products and quantities included in each order.
5. Track stock quantities separately for each supermarket branch.
6. Record payment details and payment status.
7. Track deliveries using statuses such as pending, processing, out for delivery and delivered.
8. Retrieve sales, order and inventory information for management purposes.

Online orders must be linked to a registered customer, while in-store purchases can be recorded without customer registration. Each order is assigned to a branch, and inventory is managed by branch and product. These decisions help the database support both physical and online retail operations.

## 1.5 Future Expansion

The initial case study focuses on a manageable relational database. As Jantora Superstores grows into multiple branches and states, the business may face higher transaction volumes and greater demands for availability and reliable access to information. Later portfolio activities will explore query optimisation, transactions, NoSQL modelling and cloud or distributed database concepts using this same business scenario.

The organisation and sample records are fictional and are used for academic demonstration.
