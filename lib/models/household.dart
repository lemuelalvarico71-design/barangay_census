// models/household.dart
class Household {
  final String householdNumber;
  final String headOfHousehold;
  final int totalMembers;
  final String? contactNumber;

  final String? street;
  final String? barangay;
  final String? city;
  final String? province;
  final String? zipCode;
  final bool gpsVerified;

  final List<FamilyMember> familyMembers;
  final List<EconomicEntry> economicData;

  Household({
    required this.householdNumber,
    required this.headOfHousehold,
    required this.totalMembers,
    this.contactNumber,
    this.street,
    this.barangay,
    this.city,
    this.province,
    this.zipCode,
    required this.gpsVerified,
    List<FamilyMember>? familyMembers,
    List<EconomicEntry>? economicData,
  })  : familyMembers = familyMembers ?? [],
        economicData = economicData ?? [];

  /// Helper to create from DB row
  factory Household.fromMap(Map<String, dynamic> map) => Household(
        householdNumber: map['household_number'] as String,
        headOfHousehold: map['head_of_household'] as String,
        totalMembers: map['total_members'] as int,
        contactNumber: map['contact_number'] as String?,
        street: map['street'] as String?,
        barangay: map['barangay'] as String?,
        city: map['city'] as String?,
        province: map['province'] as String?,
        zipCode: map['zip_code'] as String?,
        gpsVerified: (map['gps_verified'] as int) == 1,
      );

      Map<String, dynamic> toJson() => {
  'household_number': householdNumber,
  'head_of_household': headOfHousehold,
  'total_members': totalMembers,
  'contact_number': contactNumber,
  'street': street,
  'barangay': barangay,
  'city': city,
  'province': province,
  'zip_code': zipCode,
  'gps_verified': gpsVerified,
  'family_members': familyMembers.map((m) => m.toJson()).toList(),
  'economic_data': economicData.map((e) => e.toJson()).toList(),
};
}

class FamilyMember {
  final String name;
  final int age;
  final String gender;
  final String relationship;

  FamilyMember({
    required this.name,
    required this.age,
    required this.gender,
    required this.relationship,
  });

  factory FamilyMember.fromMap(Map<String, dynamic> map) => FamilyMember(
        name: map['name'] as String,
        age: map['age'] as int,
        gender: map['gender'] as String,
        relationship: map['relationship'] as String,
      );

      Map<String, dynamic> toJson() => {
  'name': name,
  'age': age,
  'gender': gender,
  'relationship': relationship,
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

