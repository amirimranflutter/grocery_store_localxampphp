# 🛒 Grocery Store Management System

A complete, production-ready grocery store management system with Flutter frontend, PHP backend, and MySQL database featuring 14 interconnected tables.

## 🌟 Highlights

- **14 Database Tables** with 20+ relationships
- **7-Table JOIN** queries for complete transaction views
- **Beautiful Flutter UI** with 6 main features
- **15+ RESTful APIs** for complete CRUD operations
- **Real-time Analytics** with business intelligence
- **Production-Ready** code and architecture

## 🚀 Quick Start

```bash
# 1. Start XAMPP (Apache + MySQL)
# 2. Setup database
http://localhost/grocery_api/setup_database_enhanced.php

# 3. Configure app IP in lib/geroceryStore/core/appConstant.dart
# 4. Run Flutter app
flutter pub get
flutter run
```

**See [QUICK_START.md](QUICK_START.md) for detailed 5-minute setup**

## 📊 Project Structure

```
grocery-store/
├── lib/                          # Flutter app
│   └── geroceryStore/
│       ├── core/                 # App configuration
│       ├── model/                # Data models (8 classes)
│       ├── services/             # API services (7 services)
│       ├── screens/              # UI screens (10+ screens)
│       └── widgets/              # Reusable widgets
├── xampp/htdocs/grocery_api/     # PHP Backend
│   ├── config/                   # Database connection
│   ├── products/                 # Product APIs
│   ├── customers/                # Customer APIs
│   ├── cart/                     # Cart APIs
│   ├── orders/                   # Order APIs
│   ├── staff/                    # Staff APIs
│   ├── suppliers/                # Supplier APIs
│   ├── promotions/               # Promotion APIs
│   └── reports/                  # Analytics APIs
└── docs/                         # Documentation
```

## 🗂️ Database Schema

### 14 Tables:
- **Core**: categories, suppliers, products
- **People**: customers, employees
- **Transactions**: orders, order_items, payment_transactions
- **Cart**: cart, cart_items
- **Features**: inventory_transactions, promotions, promotion_products, reviews

### Key Relationships:
- Products → 7 tables (central hub)
- Orders → 4 tables (complete transaction)
- Customers → 3 tables (CRM)

**See [DATABASE_STRUCTURE.md](xampp/htdocs/grocery_api/DATABASE_STRUCTURE.md) for complete schema**

## 📱 App Features

### 1. Dashboard
Navigation hub with 6 quick actions

### 2. Inventory Management
- Product list with categories and suppliers
- Stock tracking
- Add/Edit/Delete products
- **3-table JOIN**

### 3. Customer Management
- Customer profiles with loyalty points
- Lifetime value calculation
- Order history
- **2-table JOIN + aggregation**

### 4. Orders
- Order list with status tracking
- Customer and cashier information
- Detailed order view
- **7-table JOIN in details!**

### 5. Analytics Dashboard
- Sales summary (orders, revenue, avg)
- Top selling products
- Sales by category
- Inventory statistics
- Low stock alerts
- **5-table JOIN + aggregations**

### 6. Staff Management
- Employee list
- Role and salary management
- Performance tracking

## 🔗 API Endpoints

### Products
- `GET /products/get_products.php` - List all products
- `POST /products/add_product.php` - Add product
- `PUT /products/update_product.php` - Update product
- `DELETE /products/delete_product.php` - Delete product

### Customers
- `GET /customers/get_customers.php` - List customers
- `POST /customers/add_customer.php` - Add customer

### Orders
- `GET /orders/get_orders.php` - List orders
- `GET /orders/get_order_details.php?order_id=X` - Order details

### Reports
- `GET /reports/inventory_report.php` - Inventory analysis
- `GET /reports/sales_summary.php` - Sales analytics

**See [API Documentation](xampp/htdocs/grocery_api/README.md) for all endpoints**

## 🎯 Technical Stack

### Frontend
- **Flutter** - Cross-platform UI framework
- **Dart** - Programming language
- **HTTP** - API communication
- **Material Design** - UI components

### Backend
- **PHP** - Server-side scripting
- **MySQL** - Relational database
- **RESTful API** - Architecture pattern
- **JSON** - Data format

### Database
- **14 Tables** - Normalized design
- **20+ Relationships** - Foreign keys
- **Complex Queries** - JOINs, aggregations
- **Indexes** - Performance optimization

## 📚 Documentation

### Setup & Configuration
- [QUICK_START.md](QUICK_START.md) - 5-minute setup
- [FINAL_SETUP_CHECKLIST.md](FINAL_SETUP_CHECKLIST.md) - Complete checklist

### Presentation Guides
- [UI_PRESENTATION_GUIDE.md](UI_PRESENTATION_GUIDE.md) - App demo guide
- [PRESENTATION_STEPS.md](PRESENTATION_STEPS.md) - Database demo
- [QUICK_REFERENCE.md](xampp/htdocs/grocery_api/QUICK_REFERENCE.md) - Quick ref

### Technical Documentation
- [DATABASE_STRUCTURE.md](xampp/htdocs/grocery_api/DATABASE_STRUCTURE.md) - Schema docs
- [DATABASE_DIAGRAM.txt](xampp/htdocs/grocery_api/DATABASE_DIAGRAM.txt) - Visual diagram
- [COMPLETE_PROJECT_SUMMARY.md](COMPLETE_PROJECT_SUMMARY.md) - Full overview

## 🎨 Screenshots

### Dashboard
![Dashboard](screenshots/dashboard.png)

### Order Details (7-Table JOIN)
![Order Details](screenshots/order-details.png)

### Analytics
![Analytics](screenshots/analytics.png)

### phpMyAdmin Designer
![Database](screenshots/database-designer.png)

## 🔥 Key Features

### Database Design
✅ Proper normalization (3NF)
✅ 20+ foreign key relationships
✅ Junction tables for many-to-many
✅ Referential integrity
✅ Performance indexes

### Business Logic
✅ Loyalty points system
✅ Lifetime value calculation
✅ Low stock alerts
✅ Inventory tracking
✅ Sales analytics

### User Experience
✅ Beautiful, modern UI
✅ Real-time data updates
✅ Color-coded status
✅ Intuitive navigation
✅ Responsive design

## 🎯 Use Cases

- **Retail Operations**: Inventory, POS, orders
- **Customer Relations**: Loyalty, profiles, history
- **Business Intelligence**: Sales analytics, reports
- **Supply Chain**: Suppliers, stock, reordering
- **Staff Management**: Employees, roles, performance

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.9.2+)
- XAMPP (Apache + MySQL)
- Dart (included with Flutter)
- PHP (included with XAMPP)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd grocery-store
   ```

2. **Setup database**
   - Start XAMPP
   - Open: `http://localhost/grocery_api/setup_database_enhanced.php`

3. **Configure app**
   - Edit: `lib/geroceryStore/core/appConstant.dart`
   - Update IP address

4. **Run app**
   ```bash
   flutter pub get
   flutter run
   ```

### Verification

Test database:
```
http://localhost/grocery_api/test_enhanced_db.php
```

Test API:
```
http://localhost/grocery_api/products/get_products.php
```

## 📊 Project Statistics

- **Lines of Code**: 5000+
- **Dart Files**: 20+
- **PHP Files**: 25+
- **Database Tables**: 14
- **API Endpoints**: 15+
- **Model Classes**: 8
- **Service Classes**: 7
- **UI Screens**: 10+

## 🎓 Learning Outcomes

This project demonstrates:
- Database design and normalization
- Complex SQL queries (JOINs, aggregations)
- RESTful API development
- Flutter mobile development
- Full-stack integration
- Business logic implementation
- Professional documentation

## 🤝 Contributing

This is a demonstration project for educational purposes.

## 📝 License

This project is for educational and demonstration purposes.

## 👨‍💻 Author

Built with ❤️ for presentation excellence

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- PHP community for backend support
- MySQL for reliable database
- Material Design for beautiful UI

## 📞 Support

For issues or questions:
- Check documentation in `/docs`
- Review setup guides
- Test API endpoints
- Verify database setup

## 🎉 Status

✅ **Production Ready**
- All features implemented
- Complete documentation
- Tested and working
- Ready to present

---

**Built to demonstrate enterprise-level full-stack development skills**

*For quick setup, see [QUICK_START.md](QUICK_START.md)*
*For presentation, see [UI_PRESENTATION_GUIDE.md](UI_PRESENTATION_GUIDE.md)*
