-- Fictional sample records; run after 01_schema.sql.
BEGIN;
INSERT INTO categories (category_id, category_name) VALUES
 (1,'Groceries'),(2,'Beverages'),(3,'Household'),(4,'Personal Care');
INSERT INTO branches (branch_id, branch_name, state, address) VALUES
 (1,'Jantora Ikeja','Lagos','Ikeja, Lagos'),
 (2,'Jantora Lekki','Lagos','Lekki, Lagos'),
 (3,'Jantora Ibadan','Oyo','Ibadan, Oyo');
-- Branches 2 and 3 represent the later expansion scenario.
INSERT INTO customers (customer_id, full_name, email, phone, address) VALUES
 (1,'Ada Okafor','ada.okafor@example.com','08000000001','Yaba, Lagos'),
 (2,'Tunde Bello','tunde.bello@example.com','08000000002','Ikeja, Lagos');
INSERT INTO products (product_id, category_id, product_name, price) VALUES
 (1,1,'Rice 5kg',12500.00),(2,2,'Orange Juice 1L',2200.00),
 (3,3,'Dishwashing Liquid 500ml',1800.00),(4,4,'Bath Soap',950.00);
INSERT INTO inventory (inventory_id, branch_id, product_id, quantity) VALUES
 (1,1,1,30),(2,1,2,45),(3,1,3,20),(4,1,4,60),
 (5,2,1,18),(6,2,2,25),(7,3,1,22),(8,3,4,35);
INSERT INTO orders (order_id, customer_id, branch_id, order_type, order_status) VALUES
 (1,1,1,'ONLINE','PROCESSING'),(2,NULL,1,'IN_STORE','COMPLETED'),
 (3,2,2,'ONLINE','PLACED');
INSERT INTO order_items (order_item_id, order_id, product_id, quantity, unit_price) VALUES
 (1,1,1,2,12500.00),(2,1,2,1,2200.00),
 (3,2,4,2,950.00),(4,3,1,1,12500.00);
INSERT INTO payments (payment_id, order_id, amount, payment_method, payment_status, paid_at) VALUES
 (1,1,27200.00,'TRANSFER','PAID',CURRENT_TIMESTAMP),
 (2,2,1900.00,'CASH','PAID',CURRENT_TIMESTAMP),
 (3,3,12500.00,'CARD','PENDING',NULL);
INSERT INTO deliveries (delivery_id, order_id, delivery_address, delivery_status) VALUES
 (1,1,'Yaba, Lagos','PROCESSING'),(2,3,'Ikeja, Lagos','PENDING');
-- Explicit IDs require identity sequences to be advanced for future inserts.
SELECT setval(pg_get_serial_sequence('categories','category_id'),(SELECT MAX(category_id) FROM categories));
SELECT setval(pg_get_serial_sequence('branches','branch_id'),(SELECT MAX(branch_id) FROM branches));
SELECT setval(pg_get_serial_sequence('customers','customer_id'),(SELECT MAX(customer_id) FROM customers));
SELECT setval(pg_get_serial_sequence('products','product_id'),(SELECT MAX(product_id) FROM products));
SELECT setval(pg_get_serial_sequence('inventory','inventory_id'),(SELECT MAX(inventory_id) FROM inventory));
SELECT setval(pg_get_serial_sequence('orders','order_id'),(SELECT MAX(order_id) FROM orders));
SELECT setval(pg_get_serial_sequence('order_items','order_item_id'),(SELECT MAX(order_item_id) FROM order_items));
SELECT setval(pg_get_serial_sequence('payments','payment_id'),(SELECT MAX(payment_id) FROM payments));
SELECT setval(pg_get_serial_sequence('deliveries','delivery_id'),(SELECT MAX(delivery_id) FROM deliveries));
COMMIT;
