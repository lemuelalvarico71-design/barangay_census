import 'package:barangay_census_app/models/household.dart';
import 'package:barangay_census_app/services/database_service.dart';
import 'package:flutter/material.dart';

class PopulationPage extends StatefulWidget {
  const PopulationPage({super.key});

  @override
  State<PopulationPage> createState() => _PopulationPageState();
}

class _PopulationPageState extends State<PopulationPage> {
  List<Household> _households = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
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

  // ────── Delete Household ──────
  Future<void> _deleteHousehold(int id, int index) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Household?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await DatabaseService.instance.deleteHousehold(id);
      setState(() {
        _households.removeAt(index);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Household deleted'), backgroundColor: Colors.green),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Delete failed: $e'), backgroundColor: Colors.red),
      );
    }
  }

  // ────── Stats ──────
  int get totalPopulation => _households.fold(0, (sum, h) => sum + h.familyMembers.length);
  int get totalHouseholds => _households.length;
  double get avgFamilySize => totalHouseholds > 0 ? totalPopulation / totalHouseholds : 0;
  double get totalIncome => _households.fold(0.0, (sum, h) => sum + h.economicData.fold(0.0, (s, e) => s + e.monthlyIncome));

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
          const SizedBox(height: 24),
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
        Expanded(child: _statCard('Avg Family', avgFamilySize.toStringAsFixed(1), Icons.family_restroom)),
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
            const Text('Household Entries', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _households.isEmpty
                ? const Center(child: Text('No data available', style: TextStyle(color: Colors.grey)))
                : LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(minWidth: constraints.maxWidth),
                          child: DataTable(
                            headingRowHeight: 48,
                            dataRowHeight: 60,
                            columnSpacing: 16,
                            columns: const [
                              DataColumn(label: Text('HH #', style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(label: Text('Head', style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(label: Text('Members', style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(label: Text('Barangay', style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(label: Text('Income', style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(label: Text('Action')), // New column
                            ],
                            rows: _households.asMap().entries.map((entry) {
                              final index = entry.key;
                              final h = entry.value;
                              final totalIncome = h.economicData.fold(0.0, (s, e) => s + e.monthlyIncome);

                              return DataRow(cells: [
                                DataCell(Text(h.householdNumber, style: const TextStyle(fontWeight: FontWeight.w500))),
                                DataCell(Text(h.headOfHousehold, overflow: TextOverflow.ellipsis)),
                                DataCell(Text(h.totalMembers.toString(), textAlign: TextAlign.center)),
                                DataCell(Text(h.barangay ?? '-', overflow: TextOverflow.ellipsis)),
                                DataCell(Text('₱${totalIncome.toStringAsFixed(0)}', style: const TextStyle(color: Colors.green))),
                                DataCell(
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    tooltip: 'Delete Household',
                                    onPressed: () => _deleteHousehold(h.id!, index),
                                  ),
                                ),
                              ]);
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

  Widget _buildLastSync() {
    return Text(
      'Last synced: ${DateTime.now().toString().substring(0, 19)}',
      style: const TextStyle(fontSize: 14, color: Colors.grey),
    );
  }
}