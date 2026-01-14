import 'package:flutter/material.dart';
import '../core/appColors.dart';
import 'package:grocerystore_local/geroceryStore/screens/sales/sale_summary.dart';
import 'package:grocerystore_local/geroceryStore/screens/staff/staff_management.dart';
import 'package:grocerystore_local/geroceryStore/screens/inventory/inventory.dart';
import 'checkout_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() =>
      _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const DashboardHome(),
    const InventoryScreen(),
    const StaffManagementScreen(),
    const SalesSummaryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1024;
    final isDesktop = screenWidth >= 1024;

    // Enhanced responsive AppBar title size - bigger on desktop
    final appBarTitleSize = isMobile ? 16.0 : (isTablet ? 18.0 : 24.0);

    // Enhanced responsive icon sizes - much bigger on desktop
    final appBarIconSize = isMobile ? 22.0 : (isTablet ? 24.0 : 32.0);
    final avatarRadius = isMobile ? 16.0 : (isTablet ? 18.0 : 24.0);
    final avatarIconSize = isMobile ? 18.0 : (isTablet ? 20.0 : 28.0);

    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        title: Text(
          'Grocery Pro Manager',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: appBarTitleSize,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none_rounded, size: appBarIconSize),
            onPressed: () {},
          ),
          Padding(
            padding: EdgeInsets.only(
              right: isMobile ? 12.0 : (isTablet ? 16.0 : 20.0),
              left: isMobile ? 6.0 : (isTablet ? 8.0 : 12.0),
            ),
            child: CircleAvatar(
              radius: avatarRadius,
              backgroundColor: AppColors.primary,
              child: Icon(
                Icons.person,
                size: avatarIconSize,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      drawer: _buildEnhancedDrawer(context, isMobile, isTablet, isDesktop),
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: _buildEnhancedBottomNav(
        isMobile,
        isTablet,
        isDesktop,
      ),
      floatingActionButton: _buildEnhancedFAB(isMobile, isTablet, isDesktop),
    );
  }

  Widget _buildEnhancedDrawer(
      BuildContext context,
      bool isMobile,
      bool isTablet,
      bool isDesktop,
      ) {
    // Enhanced sizes for desktop
    final headerTitleSize = isMobile ? 18.0 : (isTablet ? 20.0 : 26.0);
    final headerSubtitleSize = isMobile ? 12.0 : (isTablet ? 13.0 : 16.0);
    final drawerIconSize = isMobile
        ? 24.0
        : (isTablet ? 26.0 : 36.0); // Much bigger on desktop
    final drawerTextSize = isMobile ? 14.0 : (isTablet ? 15.0 : 18.0);
    final avatarRadius = isMobile ? 30.0 : (isTablet ? 35.0 : 50.0);
    final avatarIconSize = isMobile ? 35.0 : (isTablet ? 40.0 : 55.0);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: AppColors.primary),
            accountName: Text(
              "Amir Admin",
              style: TextStyle(
                fontSize: headerTitleSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            accountEmail: Text(
              "admin@grocerystore.com",
              style: TextStyle(fontSize: headerSubtitleSize),
            ),
            currentAccountPicture: CircleAvatar(
              radius: avatarRadius,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.person,
                color: AppColors.primary,
                size: avatarIconSize,
              ),
            ),
          ),
          // Enhanced ListTiles with bigger icons and text on desktop
          ListTile(
            leading: Icon(Icons.settings, size: drawerIconSize),
            title: Text(
              "Settings",
              style: TextStyle(
                fontSize: drawerTextSize,
                fontWeight: isDesktop ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 24.0 : 16.0,
              vertical: isDesktop ? 8.0 : 0.0,
            ),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(
              Icons.logout,
              color: Colors.red,
              size: drawerIconSize,
            ),
            title: Text(
              "Logout",
              style: TextStyle(
                color: Colors.red,
                fontSize: drawerTextSize,
                fontWeight: isDesktop ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 24.0 : 16.0,
              vertical: isDesktop ? 8.0 : 0.0,
            ),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedBottomNav(bool isMobile, bool isTablet, bool isDesktop) {
    // Enhanced sizes - much bigger icons and labels on desktop
    final iconSize = isMobile ? 24.0 : (isTablet ? 26.0 : 36.0);
    final labelSize = isMobile ? 12.0 : (isTablet ? 13.0 : 16.0);

    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (index) => setState(() => _selectedIndex = index),
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: Colors.grey,
      iconSize: iconSize,
      selectedLabelStyle: TextStyle(
        fontSize: labelSize,
        fontWeight: isDesktop ? FontWeight.bold : FontWeight.w600,
      ),
      unselectedLabelStyle: TextStyle(
        fontSize: labelSize,
        fontWeight: isDesktop ? FontWeight.w500 : FontWeight.normal,
      ),
      // Enhanced padding for desktop
      elevation: isDesktop ? 8.0 : 4.0,
      items: [
        BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.only(bottom: isDesktop ? 4.0 : 0.0),
            child: const Icon(Icons.grid_view_rounded),
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.only(bottom: isDesktop ? 4.0 : 0.0),
            child: const Icon(Icons.inventory_2_outlined),
          ),
          label: 'Stock',
        ),
        BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.only(bottom: isDesktop ? 4.0 : 0.0),
            child: const Icon(Icons.people_alt_outlined),
          ),
          label: 'Staff',
        ),
        BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.only(bottom: isDesktop ? 4.0 : 0.0),
            child: const Icon(Icons.bar_chart_outlined),
          ),
          label: 'Reports',
        ),
      ],
    );
  }

  Widget _buildEnhancedFAB(bool isMobile, bool isTablet, bool isDesktop) {
    // Enhanced FAB size - much bigger on desktop
    final fabSize = isMobile ? 56.0 : (isTablet ? 60.0 : 72.0);
    final fabIconSize = isMobile ? 24.0 : (isTablet ? 26.0 : 32.0);

    return SizedBox(
      width: fabSize,
      height: fabSize,
      child: FloatingActionButton(
        backgroundColor: AppColors.primary,
        elevation: isDesktop ? 8.0 : 6.0,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CheckoutScreen()),
        ),
        child: Icon(
          Icons.add_shopping_cart,
          color: Colors.white,
          size: fabIconSize,
        ),
      ),
    );
  }
}

class DashboardHome extends StatelessWidget {
  const DashboardHome({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1024;
    final isDesktop = screenWidth >= 1024;

    // Enhanced responsive padding - more spacious on desktop
    final pagePadding = isMobile ? 16.0 : (isTablet ? 24.0 : 40.0);

    // Enhanced responsive text sizes - bigger on desktop
    final welcomeTextSize = isMobile ? 22.0 : (isTablet ? 26.0 : 36.0);
    final subtitleTextSize = isMobile ? 14.0 : (isTablet ? 15.0 : 18.0);
    final sectionTitleSize = isMobile ? 18.0 : (isTablet ? 20.0 : 28.0);

    // Enhanced responsive spacing
    final headerSpacing = isMobile ? 25.0 : (isTablet ? 30.0 : 45.0);
    final sectionSpacing = isMobile ? 15.0 : (isTablet ? 18.0 : 25.0);

    // Enhanced responsive grid
    final gridColumns = isMobile ? 2 : (isTablet ? 3 : 4);
    final gridSpacing = isMobile ? 12.0 : (isTablet ? 16.0 : 24.0);
    final childAspectRatio = isMobile ? 1.5 : (isTablet ? 1.6 : 1.8);

    return SingleChildScrollView(
      padding: EdgeInsets.all(pagePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome Back, Amir 👋',
            style: TextStyle(
              fontSize: welcomeTextSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Your store is performing well today.',
            style: TextStyle(color: Colors.grey, fontSize: subtitleTextSize),
          ),
          SizedBox(height: headerSpacing),

          // Enhanced Stats Grid
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: gridColumns,
            childAspectRatio: childAspectRatio,
            crossAxisSpacing: gridSpacing,
            mainAxisSpacing: gridSpacing,
            children: [
              _buildEnhancedStatCard(
                context,
                "Sales",
                "\$4,250",
                Icons.trending_up,
                Colors.green,
              ),
              _buildEnhancedStatCard(
                context,
                "Orders",
                "128",
                Icons.shopping_bag,
                Colors.blue,
              ),
              _buildEnhancedStatCard(
                context,
                "Low Stock",
                "5 Items",
                Icons.warning,
                Colors.red,
              ),
              _buildEnhancedStatCard(
                context,
                "Staff",
                "8/10",
                Icons.badge,
                Colors.orange,
              ),
            ],
          ),

          SizedBox(height: headerSpacing),
          Text(
            "Quick Actions",
            style: TextStyle(
              fontSize: sectionTitleSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: sectionSpacing),

          _buildEnhancedActionTile(
            context,
            "Start New Sale",
            Icons.point_of_sale,
            Colors.blue,
            const CheckoutScreen(),
          ),
          _buildEnhancedActionTile(
            context,
            "Manage Inventory",
            Icons.inventory,
            Colors.purple,
            const InventoryScreen(),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedStatCard(
      BuildContext context,
      String label,
      String value,
      IconData icon,
      Color color,
      ) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1024;
    final isDesktop = screenWidth >= 1024;

    // Enhanced sizes for stat card - much bigger icons on desktop
    final cardPadding = isMobile ? 12.0 : (isTablet ? 14.0 : 20.0);
    final iconSize = isMobile
        ? 22.0
        : (isTablet ? 30.0 : 40.0); // Much bigger on desktop
    final valueSize = isMobile ? 20.0 : (isTablet ? 22.0 : 28.0);
    final labelSize = isMobile ? 14.0 : (isTablet ? 15.0 : 16.0);
    final verticalSpacing = isMobile ? 8.0 : (isTablet ? 10.0 : 16.0);
    final borderRadius = isMobile ? 12.0 : (isTablet ? 14.0 : 18.0);

    return Container(
      padding: EdgeInsets.all(cardPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDesktop ? 0.08 : 0.05),
            blurRadius: isDesktop ? 8 : 5,
            offset: Offset(0, isDesktop ? 3 : 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: iconSize),
          SizedBox(height: verticalSpacing),
          Text(
            value,
            style: TextStyle(fontSize: valueSize, fontWeight: FontWeight.bold),
          ),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey,
              fontSize: labelSize,
              fontWeight: isDesktop ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedActionTile(
      BuildContext context,
      String title,
      IconData icon,
      Color color,
      Widget screen,
      ) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1024;
    final isDesktop = screenWidth >= 1024;

    // Enhanced sizes for action tile - bigger icons on desktop
    final cardMargin = isMobile ? 10.0 : (isTablet ? 12.0 : 16.0);
    final borderRadius = isMobile ? 10.0 : (isTablet ? 12.0 : 16.0);
    final avatarRadius = isMobile ? 20.0 : (isTablet ? 22.0 : 28.0);
    final avatarIconSize = isMobile ? 20.0 : (isTablet ? 22.0 : 28.0);
    final titleSize = isMobile ? 14.0 : (isTablet ? 15.0 : 18.0);
    final trailingIconSize = isMobile ? 20.0 : (isTablet ? 22.0 : 28.0);
    final tilePadding = isMobile ? 12.0 : (isTablet ? 14.0 : 20.0);

    return Card(
      margin: EdgeInsets.only(bottom: cardMargin),
      elevation: isDesktop ? 4.0 : 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(
          horizontal: tilePadding,
          vertical: isMobile ? 4.0 : (isTablet ? 8.0 : 12.0),
        ),
        leading: CircleAvatar(
          radius: avatarRadius,
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color, size: avatarIconSize),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: isDesktop ? FontWeight.w600 : FontWeight.w500,
            fontSize: titleSize,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          size: trailingIconSize,
          color: isDesktop ? Colors.grey[600] : Colors.grey,
        ),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        ),
      ),
    );
  }
}
