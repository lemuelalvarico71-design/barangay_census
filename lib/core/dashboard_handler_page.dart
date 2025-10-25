import 'package:barangay_census_app/pages/census_data_page.dart';
import 'package:barangay_census_app/pages/dashboard_page.dart';
import 'package:barangay_census_app/pages/household_page.dart';
import 'package:barangay_census_app/pages/population_page.dart';
import 'package:barangay_census_app/pages/reports_page.dart';
import 'package:barangay_census_app/pages/user_page.dart';
import 'package:flutter/material.dart';

class DashboardHandlerPage extends StatefulWidget {
  const DashboardHandlerPage({super.key});

  @override
  State<DashboardHandlerPage> createState() => _DashboardHandlerPageState();
}

class _DashboardHandlerPageState extends State<DashboardHandlerPage> {
  int selectedIndex = 0;

  List pages = [
    DashboardPage(),
    PopulationPage(),
    HouseholdPage(),
    UserPage(),
    ReportsPage(),
    CensusDataPage(),
  ];

  void onItemTapped(int index) {
    setState(() => selectedIndex = index);
  }

  Widget _buildNavItem(
    BuildContext context,
    IconData icon,
    String title,
    int index,
  ) {
    bool isSelected = selectedIndex == index;

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
      selectedTileColor: Colors.blue[800],
      onTap: () => onItemTapped(index),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Container(
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
                _buildNavItem(context, Icons.dashboard, 'Dashboard', 0),
                _buildNavItem(context, Icons.people, 'Population', 1),
                _buildNavItem(context, Icons.home, 'Households', 2),
                _buildNavItem(context, Icons.group, 'User Management', 3),
                _buildNavItem(context, Icons.bar_chart, 'Reports', 4),
                _buildNavItem(context, Icons.data_usage, 'Census Data', 5),
                const Spacer(),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.white70),
                  title: const Text(
                    'Logout',
                    style: TextStyle(color: Colors.white70),
                  ),
                  onTap:
                      () => Navigator.pushReplacementNamed(context, '/login'),
                ),
              ],
            ),
          ),
          Expanded(child: pages[selectedIndex]),
        ],
      ),
    );
  }
}
