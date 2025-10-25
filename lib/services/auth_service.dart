import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import '../config/db_config.dart';

class AuthService {
  // Return the user record (Map) instead of just true/false
  static Future<Map<String, dynamic>?> login(
    String username,
    String password,
  ) async {
    try {
      final conn = await MySqlConnection.connect(DatabaseConfig.settings);

      var results = await conn.query(
        'SELECT * FROM users WHERE (username = ? OR email = ?) AND password = ? LIMIT 1',
        [username, username, password],
      );

      await conn.close();

      if (results.isNotEmpty) {
        var row = results.first;
        return {
          'id': row['id'],
          'fullname': row['fullname'],
          'email': row['email'],
          'role': row['role'],
        };
      }
      return null;
    } catch (e) {
      debugPrint('MySQL error: $e');
      return null;
    }
  }
}
