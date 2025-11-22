// services/auth_service.dart
import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import '../config/db_config.dart';
import '../services/database_service.dart';
import '../services/current_user.dart'; // ADD THIS

class AuthService {
  static Future<Map<String, dynamic>?> login(String username, String password) async {
    try {
      final conn = await MySqlConnection.connect(DatabaseConfig.settings);

      var results = await conn.query(
        'SELECT * FROM users WHERE (username = ? OR email = ?) LIMIT 1',
        [username, username],
      );

      await conn.close();

      if (results.isNotEmpty) {
        final row = results.first;
        
          final userData = {
            'id': row['id'],
            'fullname': row['fullname'],
            'email': row['email'],
            'username': row['username'],
            'role': row['role'],
          };

          // SET CURRENT USER
          CurrentUser().setUser(userData);

          // LOG ACTIVITY
          await DatabaseService.instance.logActivity(
            action: 'Login',
            fullname: row['fullname'],
            role: row['role'],
            userId: row['id'],
            description: 'User logged in successfully',
          );

          return userData;
        }
      
      return null;
    } catch (e) {
      debugPrint('Login error: $e');
      return null;
    }
  }

  static Future<bool> register({
    required String fullname,
    required String email,
    required String username,
    required String password,
    required String role,
  }) async {
    try {
      final conn = await MySqlConnection.connect(DatabaseConfig.settings);

      final check = await conn.query(
        'SELECT id FROM users WHERE username = ? OR email = ? LIMIT 1',
        [username, email],
      );

      if (check.isNotEmpty) {
        await conn.close();
        return false;
      }

      

      final result = await conn.query(
        '''
        INSERT INTO users (fullname, email, username, password, role, created_at)
        VALUES (?, ?, ?, ?, ?, NOW())
        ''',
        [fullname, email, username, password, role],
      );

      final newUserId = result.insertId!;

      // LOG REGISTER
      await DatabaseService.instance.logActivity(
        action: 'Register',
        fullname: fullname,
        role: role,
        userId: newUserId,
        description: 'New account created as $role',
      );

      await conn.close();
      return true;
    } catch (e) {
      debugPrint('Register error: $e');
      return false;
    }
  }

  // ADD THIS: Get current user (for other pages)
  static Map<String, dynamic>? getCurrentUser() {
    return CurrentUser().user;
  }

  // Optional: Logout
  static void logout() {
    final user = CurrentUser().user;
    if (user != null) {
      DatabaseService.instance.logActivity(
        action: 'Logout',
        fullname: user['fullname'],
        role: user['role'],
        userId: user['id'],
        description: 'User logged out',
      );
    }
    CurrentUser().clear();
  }
}