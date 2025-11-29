import 'dart:convert';
import 'package:barangay_census_app/services/auth_service.dart';
import 'package:flutter/material.dart';
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

  Future<int> insertHousehold(Household household) async {
  final conn = await _connection;

  // Convert family members (with base64 images)
  final familyMembersJson = household.familyMembers.map((member) {
    return {
      'name': member.name,
      'age': member.age,
      'gender': member.gender,
      'relationship': member.relationship,
      'philsys_image': member.philsysImage != null
          ? base64Encode(member.philsysImage!)
          : null,
      'education_status': member.educationStatus,
      'year_level': member.yearLevel,
      'course': member.course,
      'employment_status': member.employmentStatus,
    };
  }).toList();

  // Convert economic data
  final economicDataJson = household.economicData.map((e) => {
        'member_name': e.memberName,
        'occupation': e.occupation,
        'monthly_income': e.monthlyIncome,
        'employer': e.employer,
      }).toList();

  // Convert head photo to base64
  final String? headPhotoBase64 = household.headPhoto != null
      ? base64Encode(household.headPhoto!)
      : null;

final result = await conn.query(
      '''
      INSERT INTO households (
        household_number, head_of_household, head_photo,
        contact_number, street, barangay, city, province,
        family_members, economic_data, census_year
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
      ''',
      [
        household.householdNumber,
        household.headOfHousehold,
        headPhotoBase64,
        household.contactNumber,
        household.street,
        household.barangay,
        household.city,
        household.province,
        jsonEncode(familyMembersJson),
        jsonEncode(economicDataJson),
        household.censusYear,
      ],
    );

  final householdId = result.insertId!;

  // Log activity
  final currentUser = AuthService.getCurrentUser();
  await logActivity(
    action: 'Add Household',
    fullname: currentUser?['fullname'] ?? 'Unknown',
    role: currentUser?['role'] ?? 'Unknown',
    userId: currentUser?['id'],
    description: 'Added household: ${household.householdNumber}',
  );

  return householdId;
}

Future<void> updateHousehold(Household household) async {
  final conn = await _connection;

  final familyMembersJson = household.familyMembers.map((m) => {
    'name': m.name,
    'age': m.age,
    'gender': m.gender,
    'relationship': m.relationship,
    'philsys_image': m.philsysImage != null ? base64Encode(m.philsysImage!) : null,
    'education_status': m.educationStatus,
    'year_level': m.yearLevel,
    'course': m.course,
    'employment_status': m.employmentStatus,
  }).toList();

  final economicDataJson = household.economicData.map((e) => {
    'member_name': e.memberName,
    'occupation': e.occupation,
    'monthly_income': e.monthlyIncome,
    'employer': e.employer,
  }).toList();

  final headPhotoBase64 = household.headPhoto != null ? base64Encode(household.headPhoto!) : null;

  await conn.query('''
    UPDATE households SET
      household_number = ?, head_of_household = ?, head_photo = ?,
      contact_number = ?, street = ?, barangay = ?, city = ?, province = ?,
      family_members = ?, economic_data = ?, census_year = ?
    WHERE id = ?
  ''', [
    household.householdNumber,
    household.headOfHousehold,
    headPhotoBase64,
    household.contactNumber,
    household.street,
    household.barangay,
    household.city,
    household.province,
    jsonEncode(familyMembersJson),
    jsonEncode(economicDataJson),
    household.censusYear,
    household.id,
  ]);
}

  // ────── GET ALL HOUSEHOLDS ──────
  Future<List<Household>> getAllHouseholds() async {
    final conn = await _connection;
    final results = await conn.query(
      'SELECT * FROM households ORDER BY created_at DESC',
    );

    return results.map((row) {
      final f = row.fields;
      final familyMembers = _parseFamilyMembers(f['family_members']);
      // Calculate totalMembers from familyMembers array length
      final totalMembers = familyMembers.length;

      return Household(
        id: f['id'] as int?,
        householdNumber: f['household_number'] as String,
        headOfHousehold: f['head_of_household'] as String,
        totalMembers: totalMembers, // Calculated from familyMembers
        contactNumber: f['contact_number'] as String?,
        street: f['street'] as String?,
        barangay: f['barangay'] as String?,
        city: f['city'] as String?,
        censusYear: (f['census_year'] as int?) ?? DateTime.now().year,
        province: f['province'] as String?,
        familyMembers: familyMembers,
        economicData: _parseEconomicData(f['economic_data']),
      );
    }).toList();
  }

  // ────── DELETE HOUSEHOLD BY ID ──────
  Future<void> deleteHousehold(int id) async {
    final conn = await _connection;
    final result = await conn.query('DELETE FROM households WHERE id = ?', [
      id,
    ]);

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
      return list
          .cast<Map<String, dynamic>>()
          .map(FamilyMember.fromMap)
          .toList();
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
      return list
          .cast<Map<String, dynamic>>()
          .map(EconomicEntry.fromMap)
          .toList();
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
    final results = await conn.query(
      'SELECT id, fullname, email, username, role FROM users ORDER BY created_at DESC',
    );
    return results.map((row) => row.fields).toList();
  }

  Future<void> deleteUser(int id) async {
    final conn = await _connection;
    await conn.query('DELETE FROM users WHERE id = ?', [id]);
  }

  // Add this method to DatabaseService
  Future<void> logActivity({
    required String action,
    required String fullname,
    required String role,
    int? userId,
    String? description,
    String? ipAddress,
  }) async {
    try {
      final conn = await _connection;
      await conn.query(
        '''
      INSERT INTO activity_logs 
      (user_id, fullname, role, action, description, ip_address, created_at)
      VALUES (?, ?, ?, ?, ?, ?, NOW())
      ''',
        [userId, fullname, role, action, description ?? '', ipAddress],
      );
    } catch (e) {
      debugPrint('Failed to log activity: $e');
    }
  }
}
