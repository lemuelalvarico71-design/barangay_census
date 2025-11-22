// services/db_helper.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import '../config/db_config.dart';

class DBHelper {
  DBHelper._();
  static final DBHelper _instance = DBHelper._();
  static DBHelper get instance => _instance;

  MySqlConnection? _connection;

  Future<MySqlConnection> get connection async {
    if (_connection == null || await _isClosed()) {
      _connection = await MySqlConnection.connect(DatabaseConfig.settings);
    }
    return _connection!;
  }

  Future<bool> _isClosed() async {
    try {
      await _connection?.query('SELECT 1');
      return false;
    } catch (_) {
      return true;
    }
  }

  Future<Results> query(String sql, [List<Object?> parameters = const []]) async {
    final conn = await connection;
    try {
      return await conn.query(sql, parameters);
    } catch (e) {
      debugPrint('Query Error: $e');
      rethrow;
    }
  }

  Future<Results> execute(String sql, [List<Object?> parameters = const []]) async {
    final conn = await connection;
    try {
      return await conn.query(sql, parameters);
    } catch (e) {
      debugPrint('Execute Error: $e');
      rethrow;
    }
  }

  Future<void> close() async {
    await _connection?.close();
    _connection = null;
    debugPrint('Database connection closed.');
  }

  Future<void> testConnection() async {
    try {
      final conn = await connection;
      final result = await conn.query('SELECT NOW() as server_time, VERSION() as version');
      final row = result.first;
      debugPrint('Connected! Server time: ${row[0]}, MySQL Version: ${row[1]}');
    } catch (e) {
      debugPrint('Connection failed: $e');
    }
  }

  // ==============================================
  // NEW: Get ALL households with full data
  // ==============================================
  Future<List<Map<String, dynamic>>> queryAllHouseholds({int? censusYear}) async {
    try {
      final String sql = '''
        SELECT 
          id,
          household_number,
          head_of_household,
          total_members,
          contact_number,
          street,
          barangay,
          city,
          province,
          zip_code,
          family_members,
          economic_data,
          created_at,
          updated_at,
          census_year
        FROM households
        WHERE census_year = ? OR ? IS NULL
        ORDER BY id ASC
      ''';

      final Results results = await query(sql, [censusYear ?? DateTime.now().year, censusYear]);

      List<Map<String, dynamic>> households = [];

      for (var row in results) {
        final Map<String, dynamic> map = {
          'id': row[0],
          'household_number': row[1]?.toString() ?? '',
          'head_of_household': row[2]?.toString() ?? '',
          'total_members': row[3] is int ? row[3] : int.tryParse(row[3].toString()) ?? 0,
          'contact_number': row[4]?.toString(),
          'street': row[5]?.toString().trim().isNotEmpty == true ? row[5].toString().trim() : 'Unknown Purok',
          'barangay': row[6]?.toString(),
          'city': row[7]?.toString(),
          'province': row[8]?.toString(),
          'zip_code': row[9]?.toString(),
          'family_members': row[10]?.toString(),        // JSON string
          'economic_data': row[11]?.toString(),
          'created_at': row[12],
          'updated_at': row[13],
          'census_year': row[14],
        };

        // Safely parse family_members JSON
        final String? jsonStr = map['family_members'] as String?;
        if (jsonStr != null && jsonStr.isNotEmpty && jsonStr != 'null') {
          try {
            map['parsed_family_members'] = jsonDecode(jsonStr);
          } catch (e) {
            debugPrint('JSON parse error for household ${map['id']}: $e');
            map['parsed_family_members'] = [];
          }
        } else {
          map['parsed_family_members'] = [];
        }

        households.add(map);
      }

      debugPrint('Loaded ${households.length} households from database.');
      return households;
    } catch (e) {
      debugPrint('Error in queryAllHouseholds(): $e');
      rethrow;
    }
  }

  // Optional: Future enhancement — filter by purok
  Future<List<Map<String, dynamic>>> queryHouseholdsByPurok(String purok) async {
    return await queryAllHouseholds(censusYear: DateTime.now().year)
        .then((list) => list.where((h) => h['street'] == purok).toList());
  }
}