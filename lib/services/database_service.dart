
import 'dart:convert';
import 'package:mysql1/mysql1.dart';
import '../config/db_config.dart';
import '../models/household.dart';

class DatabaseService {
  DatabaseService._();
  static final DatabaseService instance = DatabaseService._();

  MySqlConnection? _conn;

  Future<MySqlConnection> get _connection async {
    _conn ??= await MySqlConnection.connect(DatabaseConfig.settings);
    return _conn!;
  }

  Future<void> close() async {
    await _conn?.close();
    _conn = null;
  }

  /// Insert household into single table with JSON columns
  Future<int> insertHousehold(Household household) async {
    final conn = await _connection;

    final result = await conn.query(
      '''
      INSERT INTO households 
        (household_number, head_of_household, total_members, contact_number,
         street, barangay, city, province, zip_code, gps_verified,
         family_members, economic_data)
      VALUES (?,?,?,?,?,?,?,?,?,?,?,?)
      ''',
      [
        household.householdNumber,
        household.headOfHousehold,
        household.totalMembers,
        household.contactNumber,
        household.street,
        household.barangay,
        household.city,
        household.province,
        household.zipCode,
        household.gpsVerified ? 1 : 0,
        jsonEncode(household.familyMembers.map((m) => m.toJson()).toList()),
        jsonEncode(household.economicData.map((e) => e.toJson()).toList()),
      ],
    );

    return result.insertId!;
  }

  /// Optional: Load household from DB (for future edit)
  Future<Household?> getHousehold(int id) async {
    final conn = await _connection;
    final results = await conn.query(
        'SELECT * FROM households WHERE id = ?', [id]);

    if (results.isEmpty) return null;

    final row = results.first.fields;

    return Household(
      householdNumber: row['household_number'],
      headOfHousehold: row['head_of_household'],
      totalMembers: row['total_members'],
      contactNumber: row['contact_number'],
      street: row['street'],
      barangay: row['barangay'],
      city: row['city'],
      province: row['province'],
      zipCode: row['zip_code'],
      gpsVerified: row['gps_verified'] == 1,
      familyMembers: _parseJsonList(row['family_members'], (m) => FamilyMember.fromMap(m)),
      economicData: _parseJsonList(row['economic_data'], (m) => EconomicEntry.fromMap(m)),
    );
  }

  List<T> _parseJsonList<T extends Object?>(
  dynamic json,
  T Function(Map<String, dynamic>) fromMap,
) {
  if (json == null) return <T>[];
  final List<dynamic> list = jsonDecode(json) as List<dynamic>;
  return list
      .cast<Map<String, dynamic>>()
      .map(fromMap)
      .toList();
}
}