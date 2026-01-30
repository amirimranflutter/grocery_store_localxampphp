# 🛒 Enhanced Grocery Store API

A comprehensive grocery store management system with a complex relational database structure featuring 14 interconnected tables.

## 🚀 Quick Start

### 1. Setup Database
```
http://localhost/grocery_api/setup_database_enhanced.php
```

### 2. Test Database
```
http://localhost/grocery_api/test_enhanced_db.php
```

### 3. View in phpMyAdmin Designer
1. Open phpMyAdmin (http://localhost/phpmyadmin)
2. Select `grocerystore` database
3. Click **"Designer"** tab
4. See the beautiful relationship diagram!

## 📊 Database Structure (14 Tables)

### 🏪 Core Business Tables
```
categories (8 records)
    ↓
products (10 records) ← suppliers (4 records)
    ↓
    ├→ order_items
    ├→ cart_items
    ├→ promotion_products
    ├→ reviews
    └→ inventory_transactions
```

### 👥 People Tables
```
customers (5 records)
    ├→ orders
    ├→ cart
    └→ reviews

employees (4 records)
    ├→ orders (as cashier)
    └→ inventory_transactions
```

### 💰 Transaction Tables
```
orders (5 records)
    ├→ order_items (13 records)
    └→ payment_transactions (5 records)
```

### 🛍️ Shopping Cart
```
cart (3 records)
    └→ cart_items (6 records)
```

### 🎁 Marketing Tables
```
promotions (2 records)
    └→ promotion_products (4 records)
```

## 🔗 Key Relationships

### Products (Central Hub) 🌟
- **Products** connects to 7 other tables!
- Links: Categories, Suppliers, Orders, Cart, Reviews, Promotions, Inventory

### Complete Relationship Map
```
                    promotions
                        ↓
    suppliers → products ← categories
                   ↓
        ┌──────────┼──────────┐
        ↓          ↓          ↓
    reviews   order_items  cart_items
                   ↓          ↓
    customers → orders      cart
        ↓          ↓
    reviews   payment_transactions
    
    employees → orders
    employees → inventory_transactions
```

## 📡 API Endpoints

### Products
- `GET /products/get_products.php` - All products with joins
- `POST /products/add_product.php` - Add product
- `PUT /products/update_product.php` - Update product
- `DELETE /products/delete_product.php` - Delete product
- `GET /products/get_categories.php` - All categories

### Customers
- `GET /customers/get_customers.php` - Customers with stats
- `POST /customers/add_customer.php` - Add customer

### Cart Management
- `GET /cart/get_cart.php?customer_id=1` - Get cart
- `POST /cart/add_to_cart.php` - Add to cart
- `DELETE /cart/remove_from_cart.php` - Remove from cart

### Orders
- `GET /orders/get_orders.php` - All orders
- `GET /orders/get_order_details.php?order_id=1` - Order details
- `POST /orders/create_order.php` - Create order

### Staff
- `GET /staff/get_employee.php` - All employees
- `POST /staff/add_employee.php` - Add employee
- `DELETE /staff/delete_employee.php` - Delete employee

### Suppliers
- `GET /suppliers/get_suppliers.php` - All suppliers

### Promotions
- `GET /promotions/get_promotions.php` - All promotions
- `GET /promotions/get_promotions.php?active_only=true` - Active only

### Reports & Analytics
- `GET /reports/inventory_report.php` - Inventory analysis
- `GET /reports/sales_summary.php` - Sales analytics
- `GET /reports/sales_summary.php?start_date=2026-01-01&end_date=2026-01-31`

## 🎯 Complex Query Examples

### Example 1: Customer Order History
```sql
SELECT 
    c.customer_name,
    o.order_id,
    o.order_date,
    o.final_amount,
    e.emp_name as cashier,
    COUNT(oi.order_item_id) as total_items
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN employees e ON o.emp_id = e.emp_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.order_id;
```

### Example 2: Product Performance
```sql
SELECT 
    p.p_name,
    c.cat_name,
    s.supplier_name,
    p.stock,
    COUNT(oi.order_item_id) as times_sold,
    SUM(oi.quantity) as total_quantity_sold,
    SUM(oi.subtotal) as total_revenue
FROM products p
LEFT JOIN categories c ON p.cat_id = c.cat_id
LEFT JOIN suppliers s ON p.supplier_id = s.supplier_id
LEFT JOIN order_items oi ON p.p_id = oi.p_id
GROUP BY p.p_id;
```

### Example 3: Customer Cart with Product Details
```sql
SELECT 
    c.customer_name,
    p.p_name,
    p.price,
    ci.quantity,
    (p.price * ci.quantity) as subtotal,
    cat.cat_name,
    s.supplier_name
FROM customers c
JOIN cart ct ON c.customer_id = ct.customer_id
JOIN cart_items ci ON ct.cart_id = ci.cart_id
JOIN products p ON ci.p_id = p.p_id
LEFT JOIN categories cat ON p.cat_id = cat.cat_id
LEFT JOIN suppliers s ON p.supplier_id = s.supplier_id;
```

## 🎨 phpMyAdmin Designer Tips

### To Create Beautiful Diagram:
1. Open Designer tab
2. Click "Import/Export" → "Import from file" (if needed)
3. Drag tables to organize them
4. Relationship lines appear automatically
5. Use "Create relation" to add more if needed

### Suggested Layout:
```
Top Row:     [promotions] [suppliers]
Middle Row:  [categories] → [products] ← [inventory_transactions]
Bottom Row:  [customers] → [orders] → [payment_transactions]
Left Side:   [cart] → [cart_items]
Right Side:  [order_items] [reviews]
```

## 📈 Sample Data Summary

| Table | Records | Purpose |
|-------|---------|---------|
| categories | 8 | Product categories |
| suppliers | 4 | Product suppliers |
| products | 10 | Store inventory |
| employees | 4 | Staff members |
| customers | 5 | Registered customers |
| orders | 5 | Completed orders |
| order_items | 13 | Order line items |
| cart | 3 | Active shopping carts |
| cart_items | 6 | Items in carts |
| promotions | 2 | Active promotions |
| promotion_products | 4 | Products on promotion |
| reviews | 4 | Customer reviews |
| payment_transactions | 5 | Payment records |
| inventory_transactions | 0 | Stock movements |

## 🔐 Database Features

✅ **Foreign Keys** - All relationships properly defined  
✅ **Cascade Deletes** - Automatic cleanup of related records  
✅ **Restrict Deletes** - Prevents data loss on critical tables  
✅ **Timestamps** - Auto-tracking of created/updated times  
✅ **Soft Deletes** - is_active flags for logical deletion  
✅ **Unique Constraints** - Email, barcode, SKU validation  
✅ **Check Constraints** - Rating validation (1-5)  
✅ **Indexes** - Optimized query performance  

## 🎓 Learning Points

This database demonstrates:
- **One-to-Many** relationships (customer → orders)
- **Many-to-One** relationships (products → category)
- **Many-to-Many** relationships (promotions ↔ products via junction table)
- **Self-referencing** queries (inventory transactions)
- **Complex joins** (5+ table joins)
- **Aggregate functions** (COUNT, SUM, AVG)
- **Subqueries** and **GROUP BY**
- **Transaction management**

## 🛠️ Next Steps

1. ✅ Run setup script
2. ✅ Test all endpoints
3. ✅ View in phpMyAdmin Designer
4. 📱 Integrate with Flutter app
5. 📊 Create dashboard with reports
6. 🔒 Add authentication
7. 📧 Add email notifications
8. 📱 Add mobile payment integration

## 📞 Support

For issues or questions:
- Check `DATABASE_STRUCTURE.md` for detailed schema
- Run `test_enhanced_db.php` to verify setup
- Check phpMyAdmin for relationship visualization

---

**Made with ❤️ for presentation-ready database design!**
