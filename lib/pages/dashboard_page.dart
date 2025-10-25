import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  final String fullname;
  const DashboardPage({super.key, required this.fullname});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Welcome, $fullname!',
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
    );
  }
}
