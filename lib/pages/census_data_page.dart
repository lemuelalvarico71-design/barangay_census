import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/db_helper.dart'; 

class CensusDataPage extends StatefulWidget {
  const CensusDataPage({super.key});
  @override
  State<CensusDataPage> createState() => _CensusDataPageState();
}

class _CensusDataPageState extends State<CensusDataPage> {
final DBHelper _dbHelper = DBHelper.instance;

  int totalHouseholds = 0;
  int totalPopulation = 0;
  double avgHouseholdSize = 0.0;

  // Purok breakdown
  final Map<String, int> purokHouseholds = {};
  final Map<String, int> purokPopulation = {};

  // Demographics from family_members JSON
  int maleCount = 0, femaleCount = 0, otherCount = 0;
  final Map<String, int> ageGroups = {
    '0–17 (Minors)': 0,
    '18–35 (Youth)': 0,
    '36–59 (Adults)': 0,
    '60+ (Seniors)': 0,
  };

  final Map<String, int> educationLevels = {
    'No Formal Education': 0,
    'Elementary': 0,
    'High School': 0,
    'Vocational/Technical': 0,
    'College Undergraduate': 0,
    'College Graduate': 0,
    'Post-Graduate': 0,
  };

  final Map<String, int> civilStatusMap = {
    'Single': 0,
    'Married': 0,
    'Live-in': 0,
    'Widowed': 0,
    'Separated': 0,
  };

  bool isLoading = true;
  String lastUpdated = '';

  @override
  void initState() {
    super.initState();
    _loadRealCensusData();
  }

  Future<void> _loadRealCensusData() async {
    setState(() => isLoading = true);

    try {
      final List<Map<String, dynamic>> households = await _dbHelper.queryAllHouseholds();

      totalHouseholds = households.length;
      totalPopulation = 0;
      maleCount = femaleCount = otherCount = 0;
      purokHouseholds.clear();
      purokPopulation.clear();
      ageGroups.updateAll((k, v) => 0);
      educationLevels.updateAll((k, v) => 0);
      civilStatusMap.updateAll((k, v) => 0);

      for (var hh in households) {
        final int membersCount = hh['total_members'] as int? ?? 0;
        totalPopulation += membersCount;

        // Use street as Purok identifier (you can adjust logic)
        final String? street = hh['street']?.toString().trim();
        final String purokKey = street?.isNotEmpty == true ? street! : 'Unknown Purok';
        purokHouseholds.update(purokKey, (v) => v + 1, ifAbsent: () => 1);
        purokPopulation.update(purokKey, (v) => v + membersCount, ifAbsent: () => membersCount);

        // Parse family_members JSON
        final String? jsonStr = hh['family_members'] as String?;
        if (jsonStr != null && jsonStr.isNotEmpty && jsonStr != 'null') {
          try {
            final List<dynamic> members = jsonDecode(jsonStr);
            for (var member in members) {
              final String gender = (member['gender'] ?? 'Other').toString();
              final int age = int.tryParse(member['age']?.toString() ?? '0') ?? 0;

              // Gender count
              if (gender == 'Male') maleCount++;
              else if (gender == 'Female') femaleCount++;
              else otherCount++;

              // Age group
              if (age <= 17) ageGroups['0–17 (Minors)'] = ageGroups['0–17 (Minors)']! + 1;
              else if (age <= 35) ageGroups['18–35 (Youth)'] = ageGroups['18–35 (Youth)']! + 1;
              else if (age <= 59) ageGroups['36–59 (Adults)'] = ageGroups['36–59 (Adults)']! + 1;
              else if (age >= 60) ageGroups['60+ (Seniors)'] = ageGroups['60+ (Seniors)']! + 1;

              // Education (you can extend this field later)
              final String? edu = member['education_status']?.toString();
              if (edu != null && educationLevels.containsKey(edu)) {
                educationLevels[edu] = educationLevels[edu]! + 1;
              }

              // Civil status (add field later if needed)
              // For now, we'll leave it zero or map from relationship
            }
          } catch (e) {
            debugPrint("JSON parse error: $e");
          }
        }
      }

      avgHouseholdSize = totalHouseholds > 0 ? totalPopulation / totalHouseholds : 0;
      lastUpdated = DateFormat('MMM dd, yyyy • hh:mm a').format(DateTime.now());
    } catch (e) {
      debugPrint("Error loading census data: $e");
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadRealCensusData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    
  const Text('Barangay Cenus Dashboard', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
                    // Key Metrics
                    Row(
                      children: [
                        _metricCard('Households', totalHouseholds.toString(), Icons.home, Colors.blue),
                        SizedBox(width: 10,), 
                        _metricCard('Population', totalPopulation.toString(), Icons.people, Colors.green),
                            SizedBox(width: 10,), 
                        _metricCard('Puroks', purokHouseholds.length.toString(), Icons.map, Colors.orange),
                            SizedBox(width: 10,), 
                        _metricCard('Seniors', ageGroups['60+ (Seniors)'].toString(), Icons.elderly, Colors.purple),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Purok Breakdown
                    _sectionTitle('Population per Purok (via Street)'),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: purokHouseholds.entries.map((e) {
                            final pop = purokPopulation[e.key]!;
                            return _purokRow(e.key, e.value, pop);
                          }).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Gender
                    _sectionTitle('Population by Gender'),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _genderBar('Male', maleCount, Colors.blue),
                           
                            _genderBar('Female', femaleCount, Colors.pink),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Age Groups
                    _sectionTitle('Age Group Distribution'),
                    _progressCard(ageGroups, totalPopulation),
                    const SizedBox(height: 24),

                    // Education (will grow as you add field)
                    _sectionTitle('Highest Educational Attainment'),
                    _progressCard(educationLevels, totalPopulation, colorMap: {
                      'College Graduate': Colors.green[700]!,
                      'Post-Graduate': Colors.teal,
                      'College Undergraduate': Colors.blue,
                    }),
                    const SizedBox(height: 32),

                    
                  ],
                ),
              ),
            ),
    );
  }

  // Reusable Widgets
  Widget _metricCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: SizedBox(
        width: 170,
        child: Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Icon(icon, size: 36, color: color),
                const SizedBox(height: 8),
                Text(value, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                Text(label, textAlign: TextAlign.center, style: TextStyle(color: Colors.grey[700], fontSize: 12)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _purokRow(String purok, int hh, int pop) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(flex: 4, child: Text(purok, style: const TextStyle(fontWeight: FontWeight.w600))),
          Expanded(child: Text('$hh HH', textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold))),
          Expanded(child: Text('$pop', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green[700]))),
        ],
      ),
    );
  }

  Widget _genderBar(String label, int count, Color color) {
    return Column(
      children: [
        Text('$count', style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Container(width: 90, height: 100, color: color.withOpacity(0.2)),
        Text(label, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }

  Widget _progressCard(Map<String, int> data, int total, {Map<String, Color>? colorMap}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: data.entries.map((e) {
            final percent = total > 0 ? (e.value / total * 100).toStringAsFixed(1) : '0';
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  SizedBox(width: 190, child: Text(e.key)),
                  const SizedBox(width: 12),
                  Expanded(child: LinearProgressIndicator(value: e.value / total, color: colorMap?[e.key] ?? Colors.blue)),
                  const SizedBox(width: 12),
                  SizedBox(width: 70, child: Text('$percent% (${e.value})', textAlign: TextAlign.right, style: const TextStyle(fontWeight: FontWeight.w500))),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Text(title, style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold)),
    );
  }
}