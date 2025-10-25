import 'package:flutter/material.dart';

class AppSidebar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const AppSidebar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  Widget _buildNavItem(
    BuildContext context,
    IconData icon,
    String title,
    int index,
  ) {
    bool isSelected = selectedIndex == index;

    return Container(
      decoration: BoxDecoration(
        border:
            isSelected
                ? Border(left: BorderSide(color: Colors.yellow[400]!, width: 4))
                : null,
        color:
            isSelected
                ? Colors.blue.withValues(alpha: 0.2)
                : Colors.transparent,
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? Colors.white : Colors.white70,
          size: 20,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            color: isSelected ? Colors.white : Colors.white70,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        selected: isSelected,
        onTap: () => onItemTapped(index),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      color: Color(0xFF031273),
      child: Column(
        children: [
          SizedBox(height: 20),
          Image.asset('assets/images/logo.png', height: 80, width: 80),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Brgy. Rizal Census Management',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            height: 1,
            decoration: BoxDecoration(color: Colors.blueGrey),
          ),
          _buildNavItem(context, Icons.dashboard, 'Dashboard', 0),
          _buildNavItem(context, Icons.people, 'Population', 1),
          _buildNavItem(context, Icons.home, 'Households', 2),
          _buildNavItem(context, Icons.group, 'User Management', 3),
          _buildNavItem(context, Icons.bar_chart, 'Reports', 4),
          _buildNavItem(context, Icons.data_usage, 'Census Data', 5),
          const Spacer(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.white70, size: 20),
            title: const Text(
              'Logout',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            onTap: () => Navigator.pushReplacementNamed(context, '/login'),
          ),
        ],
      ),
    );
  }
}
