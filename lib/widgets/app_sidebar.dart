import 'package:flutter/material.dart';

class AppSidebar extends StatefulWidget {
  const AppSidebar({super.key});

  @override
  State<AppSidebar> createState() => _AppSidebarState();
}

class _AppSidebarState extends State<AppSidebar> {
  String _selectedItem = 'Dashboard'; // Default selected item

  void _selectItem(String title) {
    setState(() {
      _selectedItem = title;
    });
    if (title == 'Dashboard') {
      Navigator.pushReplacementNamed(context, '/dashboard');
    } else if (title == 'Population') {
      Navigator.pushReplacementNamed(context, '/population');
    } else if (title == 'Households') {
      Navigator.pushReplacementNamed(context, '/household');
    } else if (title == 'User Management') {
      Navigator.pushReplacementNamed(context, '/user_management');
    } else if (title == 'Reports') {
      Navigator.pushReplacementNamed(context, '/reports');
    } else if (title == 'Census Data') {
      Navigator.pushReplacementNamed(context, '/census_data');
    } else if (title == 'Logout') {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  Widget _buildNavItem(BuildContext context, IconData icon, String title, bool isSelected) {
    return ListTile(
      leading: Icon(icon, color: isSelected ? Colors.white : Colors.white70),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.white70,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      onTap: () => _selectItem(title),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      color: Colors.blue[700],
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Barangay Census\nAnalytics',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const Divider(color: Colors.white54),
          _buildNavItem(context, Icons.dashboard, 'Dashboard', _selectedItem == 'Dashboard'),
          _buildNavItem(context, Icons.people, 'Population', _selectedItem == 'Population'),
          _buildNavItem(context, Icons.home, 'Households', _selectedItem == 'Households'),
          _buildNavItem(context, Icons.group, 'User Management', _selectedItem == 'User Management'),
          _buildNavItem(context, Icons.bar_chart, 'Reports', _selectedItem == 'Reports'),
          _buildNavItem(context, Icons.data_usage, 'Census Data', _selectedItem == 'Census Data'),
          const Spacer(),
          _buildNavItem(context, Icons.logout, 'Logout', _selectedItem == 'Logout'),
        ],
      ),
    );
  }
}