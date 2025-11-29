import 'package:barangay_census_app/models/household.dart';
import 'package:barangay_census_app/pages/household_edit_page.dart';
import 'package:barangay_census_app/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PopulationPage extends StatefulWidget {
  const PopulationPage({super.key});

  @override
  State<PopulationPage> createState() => _PopulationPageState();
}

class _PopulationPageState extends State<PopulationPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  List<Household> _households = [];
  bool _isLoading = true;
  String? _error;

  final int currentYear = DateTime.now().year;

  // CORRECT: Head of Household is ALWAYS counted + all family members
  int get totalPopulation {
    int total = 0;
    for (var h in _households) {
      int membersCount = h.familyMembers.length;

      // If head is NOT in the familyMembers list → add +1
      bool headIsInList = h.familyMembers.any((member) =>
          member.name.trim().toLowerCase() == h.headOfHousehold.trim().toLowerCase());

      total += membersCount + (headIsInList ? 0 : 1);
    }
    return total;
  }

  int get totalHouseholds => _households.length;

  double get avgFamilySize =>
      totalHouseholds > 0 ? totalPopulation / totalHouseholds : 0.0;

  double get totalIncome => _households.fold(
        0.0,
        (sum, h) => sum + h.economicData.fold(0.0, (acc, e) => acc + (e.monthlyIncome ?? 0.0)),
      );

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic);
    _loadData();
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final data = await DatabaseService.instance.getAllHouseholds();
      setState(() {
        _households = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Population Census'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) return const Center(child: CircularProgressIndicator());
    if (_error != null) return _buildError();
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSummaryCards(),
          const SizedBox(height: 12),
          _buildDataTable(),
          const SizedBox(height: 24),
          _buildLastSync(),
        ],
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, color: Colors.red, size: 64),
          const SizedBox(height: 16),
          Text('Error: $_error', textAlign: TextAlign.center),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: _loadData, child: const Text('Retry')),
        ],
      ),
    );
  }

  Widget _buildSummaryCards() {
    return Row(
      children: [
        Expanded(child: _statCard('Total Population', totalPopulation.toString(), Icons.people)),
        const SizedBox(width: 12),
        Expanded(child: _statCard('Households', totalHouseholds.toString(), Icons.home)),
        const SizedBox(width: 12),
       
        Expanded(child: _statCard('Total Income', '₱${totalIncome.toStringAsFixed(0)}', Icons.attach_money)),
      ],
    );
  }

  Widget _statCard(String label, String value, IconData icon) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 32, color: Colors.blue),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildDataTable() {
  return Card(
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Household Entries',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _households.isEmpty
              ? const Center(
                  child: Text(
                    'No data available',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minWidth: constraints.maxWidth),
                        child: DataTable(
                          headingRowHeight: 56,
                          dataRowHeight: 68,
                          columnSpacing: 16,
                          columns: const [
                            DataColumn(label: Text('HH #', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Head', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Members', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Purok', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Barangay', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Income', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Action', style: TextStyle(fontWeight: FontWeight.bold))), // NEW
                          ],
                          rows: _households.asMap().entries.map((entry) {
                            final index = entry.key;
                            final h = entry.value;
                            final totalIncome = h.economicData.fold(0.0, (s, e) => s + e.monthlyIncome);

                            return DataRow(
                              cells: [
                                DataCell(Text(h.householdNumber, style: const TextStyle(fontWeight: FontWeight.w600))),
                                DataCell(
                                  SizedBox(
                                    width: 120,
                                    child: Text(
                                      h.headOfHousehold,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Center(
                                    child: Text(
                                      h.totalMembers.toString(),
                                      style: const TextStyle(fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                DataCell(Text(h.street ?? '-', overflow: TextOverflow.ellipsis)),
                                DataCell(Text(h.barangay ?? '-', overflow: TextOverflow.ellipsis)),
                                DataCell(
                                  Text(
                                    '₱${totalIncome.toStringAsFixed(0)}',
                                    style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w600),
                                  ),
                                ),
                                DataCell(
                                  Row(
                                    
                                    children: [
                                      // VIEW BUTTON
                                      Tooltip(
                                        message: 'View Details',
                                        child: IconButton(
                                          icon: const Icon(Icons.visibility, color: Colors.blue, size: 20,),
                                          onPressed: () => _viewHousehold(h),
                                        ),
                                      ),
                                      const SizedBox(width: 3),
                                      // EDIT BUTTON
                                      Tooltip(
                                        message: 'Edit Household',
                                        child: IconButton(
                                          icon: const Icon(Icons.edit, color: Colors.orange, size: 20,),
                                          onPressed: () => _editHousehold(h),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    );
                  },
                ),
        ],
      ),
    ),
  );
}

void _viewHousehold(Household household) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.home, color: Colors.purple),
          const SizedBox(width: 8),
          Text('Household #${household.householdNumber}'),
        ],
      ),
      content: SizedBox(
        width: 600,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (household.headPhoto != null) ...[
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.memory(
                      household.headPhoto!,
                      height: 180,
                      width: 180,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              _infoRow('Head of Household', household.headOfHousehold),
              _infoRow('Total Members', household.totalMembers.toString()),
              _infoRow('Contact', household.contactNumber ?? 'N/A'),
              _infoRow('Street/Purok', household.street ?? 'N/A'),
              _infoRow('Barangay', household.barangay ?? 'N/A'),
              _infoRow('City/Municipality', household.city ?? 'N/A'),
              _infoRow('Province', household.province ?? 'N/A'),
              _infoRow('Census Year', household.censusYear.toString()),
              const Divider(height: 32),
              const Text('Family Members', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ...household.familyMembers.map((m) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text('• ${m.name} (${m.age}yo, ${m.gender}, ${m.relationship})'),
                  )),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
      ],
    ),
  );
}

void _editHousehold(Household household) {
  // Navigate to Edit Page (create this later)
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => HouseholdEditPage(household: household),
    ),
  );
}

Widget _infoRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 140,
          child: Text(
            '$label:',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        Expanded(child: Text(value)),
      ],
    ),
  );
}



  Widget _buildLastSync() {
    return Text(
      'Last synced: ${DateTime.now().toString().substring(0, 19)}',
      style: const TextStyle(fontSize: 14, color: Colors.grey),
    );
  }
}