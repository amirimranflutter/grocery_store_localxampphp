# Grocery Store Database Structure

## Overview
This is a comprehensive relational database for a grocery store management system with 14 interconnected tables.

## Database Schema

### Core Tables

#### 1. **categories**
- Primary Key: `cat_id`
- Stores product categories
- Fields: cat_name, cat_description, cat_image, is_active
- **Relationships**: One-to-Many with products

#### 2. **suppliers**
- Primary Key: `supplier_id`
- Stores supplier information
- Fields: supplier_name, contact_person, phone, email, address, city, country
- **Relationships**: One-to-Many with products

#### 3. **products**
- Primary Key: `p_id`
- Central table for all products
- Fields: p_name, p_description, price, cost_price, stock, barcode, sku, unit, weight
- **Foreign Keys**: 
  - `cat_id` → categories(cat_id)
  - `supplier_id` → suppliers(supplier_id)
- **Relationships**: 
  - Many-to-One with categories
  - Many-to-One with suppliers
  - One-to-Many with order_items, cart_items, reviews, promotion_products

### People Tables

#### 4. **customers**
- Primary Key: `customer_id`
- Stores customer information
- Fields: customer_name, email, phone, address, city, postal_code, loyalty_points, total_purchases
- **Relationships**: 
  - One-to-Many with orders
  - One-to-Many with cart
  - One-to-Many with reviews

#### 5. **employees**
- Primary Key: `emp_id`
- Stores employee information
- Fields: emp_name, emp_role, emp_phone, emp_email, emp_salary, hire_date
- **Relationships**: 
  - One-to-Many with orders (as cashier)
  - One-to-Many with inventory_transactions

### Transaction Tables

#### 6. **orders**
- Primary Key: `order_id`
- Main order/sales table
- Fields: total_amount, discount_amount, tax_amount, final_amount, payment_method, order_status
- **Foreign Keys**:
  - `customer_id` → customers(customer_id)
  - `emp_id` → employees(emp_id)
- **Relationships**:
  - Many-to-One with customers
  - Many-to-One with employees
  - One-to-Many with order_items
  - One-to-Many with payment_transactions

#### 7. **order_items**
- Primary Key: `order_item_id`
- Junction table linking orders and products
- Fields: quantity, unit_price, subtotal, discount
- **Foreign Keys**:
  - `order_id` → orders(order_id) [CASCADE DELETE]
  - `p_id` → products(p_id) [RESTRICT DELETE]
- **Relationships**:
  - Many-to-One with orders
  - Many-to-One with products

#### 8. **payment_transactions**
- Primary Key: `payment_id`
- Tracks payment details for orders
- Fields: payment_method, amount, payment_status, transaction_reference
- **Foreign Keys**:
  - `order_id` → orders(order_id) [CASCADE DELETE]
- **Relationships**:
  - Many-to-One with orders

### Cart Tables

#### 9. **cart**
- Primary Key: `cart_id`
- Shopping cart for each customer
- **Foreign Keys**:
  - `customer_id` → customers(customer_id) [CASCADE DELETE]
- **Relationships**:
  - Many-to-One with customers
  - One-to-Many with cart_items

#### 10. **cart_items**
- Primary Key: `cart_item_id`
- Junction table for cart and products
- Fields: quantity
- **Foreign Keys**:
  - `cart_id` → cart(cart_id) [CASCADE DELETE]
  - `p_id` → products(p_id) [CASCADE DELETE]
- **Relationships**:
  - Many-to-One with cart
  - Many-to-One with products

### Additional Feature Tables

#### 11. **inventory_transactions**
- Primary Key: `transaction_id`
- Tracks all inventory movements
- Fields: transaction_type (purchase/sale/adjustment/return), quantity, previous_stock, new_stock
- **Foreign Keys**:
  - `p_id` → products(p_id) [CASCADE DELETE]
  - `emp_id` → employees(emp_id)
- **Relationships**:
  - Many-to-One with products
  - Many-to-One with employees

#### 12. **promotions**
- Primary Key: `promotion_id`
- Stores promotional campaigns
- Fields: promotion_name, description, discount_type, discount_value, start_date, end_date
- **Relationships**:
  - One-to-Many with promotion_products

#### 13. **promotion_products**
- Primary Key: `promotion_product_id`
- Junction table linking promotions and products
- **Foreign Keys**:
  - `promotion_id` → promotions(promotion_id) [CASCADE DELETE]
  - `p_id` → products(p_id) [CASCADE DELETE]
- **Relationships**:
  - Many-to-One with promotions
  - Many-to-One with products

#### 14. **reviews**
- Primary Key: `review_id`
- Customer product reviews
- Fields: rating (1-5), review_text
- **Foreign Keys**:
  - `p_id` → products(p_id) [CASCADE DELETE]
  - `customer_id` → customers(customer_id) [CASCADE DELETE]
- **Relationships**:
  - Many-to-One with products
  - Many-to-One with customers

## Key Relationships Summary

### Products (Central Hub)
- Products → Categories (Many-to-One)
- Products → Suppliers (Many-to-One)
- Products ← Order Items (One-to-Many)
- Products ← Cart Items (One-to-Many)
- Products ← Reviews (One-to-Many)
- Products ← Promotion Products (One-to-Many)
- Products ← Inventory Transactions (One-to-Many)

### Customers
- Customers → Orders (One-to-Many)
- Customers → Cart (One-to-Many)
- Customers → Reviews (One-to-Many)

### Orders (Transaction Flow)
- Orders → Customers (Many-to-One)
- Orders → Employees (Many-to-One)
- Orders → Order Items (One-to-Many)
- Orders → Payment Transactions (One-to-Many)

### Cart (Shopping Flow)
- Cart → Customers (Many-to-One)
- Cart → Cart Items (One-to-Many)
- Cart Items → Products (Many-to-One)

## API Endpoints Created

### Products
- GET `/products/get_products.php` - List all products with category and supplier info
- POST `/products/add_product.php` - Add new product
- PUT `/products/update_product.php` - Update product
- DELETE `/products/delete_product.php` - Delete product
- GET `/products/get_categories.php` - List categories

### Customers
- GET `/customers/get_customers.php` - List customers with order stats
- POST `/customers/add_customer.php` - Add new customer

### Cart
- GET `/cart/get_cart.php?customer_id=X` - Get customer's cart with items
- POST `/cart/add_to_cart.php` - Add product to cart
- DELETE `/cart/remove_from_cart.php` - Remove item from cart

### Orders
- GET `/orders/get_orders.php` - List orders with customer and cashier info
- GET `/orders/get_order_details.php?order_id=X` - Get full order details with items
- POST `/orders/create_order.php` - Create new order

### Staff
- GET `/staff/get_employee.php` - List employees
- POST `/staff/add_employee.php` - Add employee
- DELETE `/staff/delete_employee.php` - Delete employee

### Suppliers
- GET `/suppliers/get_suppliers.php` - List suppliers with product count

### Promotions
- GET `/promotions/get_promotions.php` - List promotions with products

### Reports
- GET `/reports/inventory_report.php` - Inventory analysis and low stock alerts
- GET `/reports/sales_summary.php` - Sales analytics with date range

## Setup Instructions

1. **Run the enhanced setup script**:
   ```
   http://localhost/grocery_api/setup_database_enhanced.php
   ```

2. **This will create**:
   - Database: `grocerystore`
   - 14 tables with proper relationships
   - Sample data for testing

3. **View in phpMyAdmin Designer**:
   - Open phpMyAdmin
   - Select `grocerystore` database
   - Click "Designer" tab
   - You'll see all tables with relationship lines showing foreign keys

## Sample Data Included

- 8 Categories
- 4 Suppliers
- 10 Products
- 4 Employees
- 5 Customers
- 5 Orders with 13 order items
- 3 Carts with 6 cart items
- 2 Promotions with 4 promotion products
- 4 Product reviews
- 5 Payment transactions

## Database Features

1. **Referential Integrity**: All foreign keys properly defined
2. **Cascade Deletes**: Where appropriate (cart items, order items)
3. **Restrict Deletes**: Prevents deleting products with order history
4. **Timestamps**: Created_at and updated_at on most tables
5. **Soft Deletes**: is_active flags for logical deletion
6. **Data Validation**: CHECK constraints on ratings
7. **Unique Constraints**: Email, barcode, SKU fields
8. **Indexes**: Primary and foreign keys automatically indexed

## phpMyAdmin Designer View

When you open the Designer in phpMyAdmin, you'll see:

- **Central Hub**: Products table in the middle
- **Left Side**: Categories and Suppliers feeding into Products
- **Right Side**: Orders, Cart, and Reviews branching from Products
- **Bottom**: Customers connecting to Orders, Cart, and Reviews
- **Top**: Employees connecting to Orders and Inventory
- **Corners**: Promotions and Payment Transactions

All relationship lines will be visible showing the complex interconnected structure!
