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

  Future<Results> query(
    String sql, [
    List<Object?> parameters = const [],
  ]) async {
    final conn = await connection;
    try {
      return await conn.query(sql, parameters);
    } catch (e) {
      debugPrint('Query Error: $e');
      rethrow;
    }
  }

  Future<Results> execute(
    String sql, [
    List<Object?> parameters = const [],
  ]) async {
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
      final result = await conn.query(
        'SELECT NOW() as server_time, VERSION() as version',
      );
      final row = result.first;
      debugPrint('Connected! Server time: ${row[0]}, MySQL Version: ${row[1]}');
    } catch (e) {
      debugPrint('Connection failed: $e');
    }
  }

  // ==============================================
  // NEW: Get ALL households with full data
  // ==============================================
  Future<List<Map<String, dynamic>>> queryAllHouseholds({
    int? censusYear,
  }) async {
    try {
      final String sql = '''
        SELECT 
          id,
          household_number,
          head_of_household,
          contact_number,
          street,
          barangay,
          city,
          province,
          family_members,
          economic_data,
          created_at,
          updated_at,
          census_year
        FROM households
        WHERE census_year = ? OR ? IS NULL
        ORDER BY id ASC
      ''';

      final Results results = await query(sql, [
        censusYear ?? DateTime.now().year,
        censusYear,
      ]);

      List<Map<String, dynamic>> households = [];

      for (var row in results) {
        // Safely parse family_members JSON to calculate total_members
        final String? jsonStr = row[8]?.toString();
        List<dynamic> parsedFamilyMembers = [];
        if (jsonStr != null && jsonStr.isNotEmpty && jsonStr != 'null') {
          try {
            parsedFamilyMembers = jsonDecode(jsonStr);
          } catch (e) {
            debugPrint('JSON parse error for household ${row[0]}: $e');
          }
        }

        final Map<String, dynamic> map = {
          'id': row[0],
          'household_number': row[1]?.toString() ?? '',
          'head_of_household': row[2]?.toString() ?? '',
          'total_members':
              parsedFamilyMembers.length, // Calculated from family_members
          'contact_number': row[3]?.toString(),
          'street':
              row[4]?.toString().trim().isNotEmpty == true
                  ? row[4].toString().trim()
                  : 'Unknown Purok',
          'barangay': row[5]?.toString(),
          'city': row[6]?.toString(),
          'province': row[7]?.toString(),
          'family_members': jsonStr, // JSON string
          'economic_data': row[9]?.toString(),
          'created_at': row[10],
          'updated_at': row[11],
          'census_year': row[12],
          'parsed_family_members': parsedFamilyMembers,
        };

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
  Future<List<Map<String, dynamic>>> queryHouseholdsByPurok(
    String purok,
  ) async {
    return await queryAllHouseholds(
      censusYear: DateTime.now().year,
    ).then((list) => list.where((h) => h['street'] == purok).toList());
  }
}
