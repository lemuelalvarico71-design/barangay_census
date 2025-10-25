import 'package:barangay_census_app/core/dashboard_handler_page.dart';
import 'package:flutter/material.dart';
import 'pages/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Barangay Census Analytics',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/login', // Start with login page
      routes: {
        '/login': (context) => const LoginPage(),
        '/dashboard': (context) => const DashboardHandlerPage(),
      },
    );
  }
}
