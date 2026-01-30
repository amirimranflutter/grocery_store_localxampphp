# 🚀 Quick Reference Card

## 📋 Setup Commands (Run in Order)

```
1. http://localhost/grocery_api/setup_database_enhanced.php
2. http://localhost/grocery_api/test_enhanced_db.php
3. http://localhost/phpmyadmin → grocerystore → Designer
```

## 📊 Database Stats

- **14 Tables**
- **20+ Relationships**
- **50+ Sample Records**
- **15+ API Endpoints**

## 🗂️ Table Quick List

```
Core:        categories, suppliers, products
People:      customers, employees
Orders:      orders, order_items, payment_transactions
Cart:        cart, cart_items
Features:    inventory_transactions, promotions, 
             promotion_products, reviews
```

## 🔗 Key Relationships

```
products → 7 tables (Central Hub!)
customers → orders, cart, reviews
orders → order_items, payment_transactions
cart → cart_items
```

## 📡 Essential API Endpoints

```
Products:    /products/get_products.php
Customers:   /customers/get_customers.php
Cart:        /cart/get_cart.php?customer_id=1
Orders:      /orders/get_orders.php
Reports:     /reports/sales_summary.php
Inventory:   /reports/inventory_report.php
```

## 💡 Demo Queries

### Show All Relationships
```sql
SELECT TABLE_NAME, COLUMN_NAME, REFERENCED_TABLE_NAME
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'grocerystore'
AND REFERENCED_TABLE_NAME IS NOT NULL;
```

### Complex Join (7 tables)
```sql
SELECT o.order_id, c.customer_name, e.emp_name, 
       p.p_name, cat.cat_name, s.supplier_name, oi.quantity
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN employees e ON o.emp_id = e.emp_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.p_id = p.p_id
JOIN categories cat ON p.cat_id = cat.cat_id
JOIN suppliers s ON p.supplier_id = s.supplier_id
LIMIT 5;
```

### Sales Analytics
```sql
SELECT c.cat_name, COUNT(*) as sales, SUM(oi.subtotal) as revenue
FROM order_items oi
JOIN products p ON oi.p_id = p.p_id
JOIN categories c ON p.cat_id = c.cat_id
GROUP BY c.cat_id
ORDER BY revenue DESC;
```

## 🎯 Presentation Checklist

- [ ] Run setup script
- [ ] Verify in test script
- [ ] Open phpMyAdmin Designer
- [ ] Arrange tables nicely
- [ ] Test 2-3 API endpoints
- [ ] Run complex query
- [ ] Show relationship count
- [ ] Highlight key features

## 🎨 Designer Layout Suggestion

```
Top:      [promotions] [suppliers]
Middle:   [categories] → [products]
Bottom:   [customers] → [orders] → [payments]
Left:     [cart] → [cart_items]
Right:    [order_items] [reviews]
```

## 📈 Key Talking Points

1. **14 interconnected tables** - Complex structure
2. **Products as hub** - Connects to 7 tables
3. **Full customer journey** - Browse → Cart → Order → Review
4. **Business intelligence** - Sales, inventory, customer analytics
5. **Data integrity** - Foreign keys, cascades, constraints
6. **Real-world ready** - Mirrors actual retail systems

## 🔥 Impressive Features

- ✅ Junction tables for many-to-many
- ✅ Cascade deletes for cleanup
- ✅ Soft deletes with is_active
- ✅ Audit trails with timestamps
- ✅ Complex queries (7+ table joins)
- ✅ Business rules (stock levels, ratings)
- ✅ Performance indexes
- ✅ RESTful API endpoints

## 📞 Quick Troubleshooting

**Tables not showing?**
→ Run setup_database_enhanced.php again

**No relationships in Designer?**
→ Check Foreign Keys are enabled in phpMyAdmin

**API not working?**
→ Check XAMPP Apache and MySQL are running

**Empty results?**
→ Sample data included, check test_enhanced_db.php

## 🎊 Success Indicators

✅ Designer shows all 14 tables
✅ Relationship lines visible
✅ API endpoints return JSON
✅ Complex queries work
✅ Sample data present

---

**Print this for quick reference during presentation!**
