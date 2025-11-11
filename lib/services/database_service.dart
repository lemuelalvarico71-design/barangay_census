// database_service.dart
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

  /// Insert household — NO philsys_image column
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
        // REMOVED: philsys_image
      ],
    );

    return result.insertId!;
  }

  // ────── GET ALL HOUSEHOLDS ──────
  Future<List<Household>> getAllHouseholds() async {
    final conn = await _connection;
    final results = await conn.query('SELECT * FROM households ORDER BY created_at DESC');

    return results.map((row) {
      final f = row.fields;
      return Household(
        householdNumber: f['household_number'] as String,
        headOfHousehold: f['head_of_household'] as String,
        totalMembers: f['total_members'] as int,
        contactNumber: f['contact_number'] as String?,
        street: f['street'] as String?,
        barangay: f['barangay'] as String?,
        city: f['city'] as String?,
        province: f['province'] as String?,
        zipCode: f['zip_code'] as String?,
        gpsVerified: (f['gps_verified'] as int?) == 1,
        familyMembers: _parseFamilyMembers(f['family_members']),
        economicData: _parseEconomicData(f['economic_data']),
      );
    }).toList();
  }

  // ────── Helper: BLOB → String ──────
  String _blobToString(dynamic value) {
    if (value == null) return '';
    if (value is String) return value;
    if (value is Blob) return String.fromCharCodes(value.toBytes());
    return value.toString();
  }

  // ────── Parse Family Members (with Base64 image) ──────
  List<FamilyMember> _parseFamilyMembers(dynamic json) {
    if (json == null) return <FamilyMember>[];
    final String jsonStr = _blobToString(json);
    if (jsonStr.isEmpty) return <FamilyMember>[];
    try {
      final List<dynamic> list = jsonDecode(jsonStr);
      return list.cast<Map<String, dynamic>>().map(FamilyMember.fromMap).toList();
    } catch (e) {
      return <FamilyMember>[];
    }
  }

  List<EconomicEntry> _parseEconomicData(dynamic json) {
    if (json == null) return <EconomicEntry>[];
    final String jsonStr = _blobToString(json);
    if (jsonStr.isEmpty) return <EconomicEntry>[];
    try {
      final List<dynamic> list = jsonDecode(jsonStr);
      return list.cast<Map<String, dynamic>>().map(EconomicEntry.fromMap).toList();
    } catch (e) {
      return <EconomicEntry>[];
    }
  }
}