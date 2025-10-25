import 'package:barangay_census_app/pages/census_data_page.dart';
import 'package:barangay_census_app/pages/dashboard_page.dart';
import 'package:barangay_census_app/pages/household_page.dart';
import 'package:barangay_census_app/pages/population_page.dart';
import 'package:barangay_census_app/pages/reports_page.dart';
import 'package:barangay_census_app/pages/user_page.dart';
import 'package:flutter/material.dart';
import '../widgets/app_sidebar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  final List<Widget> pages = [
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          AppSidebar(selectedIndex: selectedIndex, onItemTapped: onItemTapped),
          Expanded(child: pages[selectedIndex]),
        ],
      ),
    );
  }
}
