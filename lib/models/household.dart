import 'dart:convert';
import 'dart:typed_data';
import 'package:mysql1/mysql1.dart';

class Household {
  final int? id;
  final String householdNumber;
  final String headOfHousehold;
  final int totalMembers;
  final String? contactNumber;

  final String? street;
  final String? barangay;
  final String? city;
  final String? province;
  final int censusYear;

  final List<FamilyMember> familyMembers;
  final List<EconomicEntry> economicData;

  final Uint8List? headPhoto;

  Household({
    this.id,
    required this.householdNumber,
    required this.headOfHousehold,
    required this.totalMembers,
    this.contactNumber,
    this.street,
    this.barangay,
    this.city,
    this.province,
    required this.censusYear,
    List<FamilyMember>? familyMembers,
    List<EconomicEntry>? economicData,
    this.headPhoto,
  })  : familyMembers = familyMembers ?? <FamilyMember>[],
        economicData = economicData ?? <EconomicEntry>[];

  // ────── BLOB → String (for JSON) ──────
  static String _blobToString(dynamic value) {
    if (value == null) return '';
    if (value is String) return value;
    if (value is Blob) return String.fromCharCodes(value.toBytes());
    return value.toString();
  }

  // ────── Parse JSON list from BLOB/String ──────
  static List<T> _parseJsonList<T>(
    dynamic json,
    T Function(Map<String, dynamic>) fromMap,
  ) {
    if (json == null) return <T>[];
    final String jsonStr = _blobToString(json);
    if (jsonStr.isEmpty) return <T>[];
    try {
      final List<dynamic> list = jsonDecode(jsonStr);
      return list.cast<Map<String, dynamic>>().map(fromMap).toList();
    } catch (e) {
      return <T>[];
    }
  }

  // ────── Create from DB row ──────
  factory Household.fromMap(Map<String, dynamic> map) {
    Uint8List? headPhotoBytes;
    final photo = map['head_photo'];
    if (photo != null && photo is String && photo.isNotEmpty) {
      try {
        headPhotoBytes = base64Decode(photo);
      } catch (e) {
        headPhotoBytes = null;
      }
    }
    return Household(
      householdNumber: map['household_number'] as String,
      headOfHousehold: map['head_of_household'] as String,
      totalMembers: map['total_members'] as int,
      contactNumber: map['contact_number'] as String?,
      street: map['street'] as String?,
      barangay: map['barangay'] as String?,
      city: map['city'] as String?,
      province: map['province'] as String?,
      censusYear: (map['census_year'] as int?) ?? DateTime.now().year,
      familyMembers: _parseJsonList(map['family_members'], FamilyMember.fromMap),
      economicData: _parseJsonList(map['economic_data'], EconomicEntry.fromMap),
      headPhoto: headPhotoBytes,
    );
  }

  Map<String, dynamic> toJson() => {
        'household_number': householdNumber,
        'head_of_household': headOfHousehold,
        'total_members': totalMembers,
        'contact_number': contactNumber,
        'street': street,
        'barangay': barangay,
        'city': city,
        'province': province,
        'family_members': familyMembers.map((m) => m.toJson()).toList(),
        'economic_data': economicData.map((e) => e.toJson()).toList(),
      };
}

// models/household.dart → Add to FamilyMember class
class FamilyMember {
  final String name;
  final int age;
  final String gender;
  final String relationship;
  final Uint8List? philsysImage;

  // ────── NEW: Educational Status ──────
  final String? educationStatus;     // e.g., "Undergraduate", "Graduate", "High School", etc.
  final String? yearLevel;          // only if Undergraduate
  final String? course;             // only if Undergraduate
  final String? employmentStatus;   // only if Graduate: "Employed" or "Unemployed"

  FamilyMember({
    required this.name,
    required this.age,
    required this.gender,
    required this.relationship,
    this.philsysImage,
    this.educationStatus,
    this.yearLevel,
    this.course,
    this.employmentStatus,
  });

  factory FamilyMember.fromMap(Map<String, dynamic> map) {
    Uint8List? image;
    final img = map['philsys_image'];
    if (img is String && img.isNotEmpty) {
      try { image = base64Decode(img); } catch (e) { image = null; }
    }
    return FamilyMember(
      name: map['name'] as String,
      age: map['age'] as int,
      gender: map['gender'] as String,
      relationship: map['relationship'] as String,
      philsysImage: image,
      educationStatus: map['education_status'] as String?,
      yearLevel: map['year_level'] as String?,
      course: map['course'] as String?,
      employmentStatus: map['employment_status'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'age': age,
    'gender': gender,
    'relationship': relationship,
    'philsys_image': philsysImage != null ? base64Encode(philsysImage!) : null,
    'education_status': educationStatus,
    'year_level': yearLevel,
    'course': course,
    'employment_status': employmentStatus,
  };
}

class EconomicEntry {
  final String memberName;
  final String occupation;
  final double monthlyIncome;
  final String employer;

  EconomicEntry({
    required this.memberName,
    required this.occupation,
    required this.monthlyIncome,
    required this.employer,
  });

  factory EconomicEntry.fromMap(Map<String, dynamic> map) => EconomicEntry(
        memberName: map['member_name'] as String,
        occupation: map['occupation'] as String,
        monthlyIncome: (map['monthly_income'] as num).toDouble(),
        employer: map['employer'] as String,
      );

  Map<String, dynamic> toJson() => {
        'member_name': memberName,
        'occupation': occupation,
        'monthly_income': monthlyIncome,
        'employer': employer,
      };
}