import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import '../config/db_config.dart';

class DBHelper {
  static Future<MySqlConnection> connect() async {
    final conn = await MySqlConnection.connect(DatabaseConfig.settings);
    return conn;
  }

  static Future<void> testQuery() async {
    final conn = await connect();

    var results = await conn.query('SELECT * FROM users');
    for (var row in results) {
      debugPrint('User: ${row[1]}'); //todo
    }

    await conn.close();
  }
}
