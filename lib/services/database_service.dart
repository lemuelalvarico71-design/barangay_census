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
    INSERT INTO households (
      household_number, head_of_household, total_members, contact_number,
      street, barangay, city, province, zip_code, gps_verified,
      census_year
    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
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
      household.censusYear, 
    ],
  );

  final householdId = result.insertId!;

  // Insert family members
  for (final member in household.familyMembers) {
    await conn.query(
      '''
      INSERT INTO family_members (
        household_id, name, age, gender, relationship, philsys_image,
        education_status, year_level, course, employment_status
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
      ''',
      [
        householdId,
        member.name,
        member.age,
        member.gender,
        member.relationship,
        member.philsysImage,
        member.educationStatus,
        member.yearLevel,
        member.course,
        member.employmentStatus,
      ],
    );
  }

  // Insert economic data
  for (final eco in household.economicData) {
    await conn.query(
      '''
      INSERT INTO economic_data (
        household_id, member_name, occupation, monthly_income, employer
      ) VALUES (?, ?, ?, ?, ?)
      ''',
      [
        householdId,
        eco.memberName,
        eco.occupation,
        eco.monthlyIncome,
        eco.employer,
      ],
    );
  }

  return householdId;
}

  // ────── GET ALL HOUSEHOLDS ──────
  Future<List<Household>> getAllHouseholds() async {
    final conn = await _connection;
    final results = await conn.query('SELECT * FROM households ORDER BY created_at DESC');

    return results.map((row) {
      final f = row.fields;
      return Household(
        id: f['id'] as int?, // ← Make sure your model supports `id`
        householdNumber: f['household_number'] as String,
        headOfHousehold: f['head_of_household'] as String,
        totalMembers: f['total_members'] as int,
        contactNumber: f['contact_number'] as String?,
        street: f['street'] as String?,
        barangay: f['barangay'] as String?,
        city: f['city'] as String?,
       censusYear: (f['census_year'] as int?) ?? DateTime.now().year,
        province: f['province'] as String?,
        zipCode: f['zip_code'] as String?,
        gpsVerified: (f['gps_verified'] as int?) == 1,
        familyMembers: _parseFamilyMembers(f['family_members']),
        economicData: _parseEconomicData(f['economic_data']),
      );
    }).toList();
  }

  // ────── DELETE HOUSEHOLD BY ID ──────
  Future<void> deleteHousehold(int id) async {
    final conn = await _connection;
    final result = await conn.query(
      'DELETE FROM households WHERE id = ?',
      [id],
    );

    if (result.affectedRows == 0) {
      throw Exception('Household with id $id not found');
    }
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

  // ────── USER MANAGEMENT ──────
Future<int> insertUser({
  required String fullname,
  required String email,
  required String username,
  required String password,
  required String role,
}) async {
  final conn = await _connection;
  final result = await conn.query(
    '''
    INSERT INTO users (fullname, email, username, password, role)
    VALUES (?, ?, ?, ?, ?)
    ''',
    [fullname, email, username, password, role],
  );
  return result.insertId!;
}

Future<List<Map<String, dynamic>>> getAllUsers() async {
  final conn = await _connection;
  final results = await conn.query('SELECT id, fullname, email, username, role FROM users ORDER BY created_at DESC');
  return results.map((row) => row.fields).toList();
}

Future<void> deleteUser(int id) async {
  final conn = await _connection;
  await conn.query('DELETE FROM users WHERE id = ?', [id]);
}
}