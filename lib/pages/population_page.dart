import 'package:barangay_census_app/models/household.dart';
import 'package:barangay_census_app/pages/household_edit_page.dart';
import 'package:barangay_census_app/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum PopulationViewState {
  list,
  edit,
}


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
  List<Household> _filteredHouseholds = [];
  bool _isLoading = true;
  String? _error;

  // Search controller
  final TextEditingController _searchController = TextEditingController();  

  PopulationViewState _viewState = PopulationViewState.list;
  Household? _selectedHousehold;

void _returnToList() {
  setState(() {
    _viewState = PopulationViewState.list;
    _selectedHousehold = null;
  });

  // Refresh data after editing
  _loadData();
}


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
// Listen to search input
    _searchController.addListener(_filterHouseholds);
    
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _filterHouseholds() {
    final query = _searchController.text.trim().toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredHouseholds = _households;
      } else {
        _filteredHouseholds = _households.where((h) {
          return h.householdNumber.toLowerCase().contains(query) ||
              h.headOfHousehold.toLowerCase().contains(query) ||
              (h.street?.toLowerCase().contains(query) ?? false) ||
              (h.barangay?.toLowerCase().contains(query) ?? false);
        }).toList();
      }
    });
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final data = await DatabaseService.instance.getAllHouseholds();
      setState(() {
        _households = data;
        _filteredHouseholds = data; // Initialize filtered list
        _isLoading = false;
      });
      // Re-apply current search if any
      _filterHouseholds();
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
      body: _viewState == PopulationViewState.list
    ? _buildBody()
    : HouseholdEditPage(
        household: _selectedHousehold!,
        onBack: _returnToList,
      ),

    );
  }

Widget _buildBody() {
    if (_isLoading) return const Center(child: CircularProgressIndicator());
    if (_error != null) return _buildError();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSummaryCards(),
          const SizedBox(height: 12),

          // SEARCH BAR
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search by HH#, Head, Purok, or Barangay...',
                  prefixIcon: const Icon(Icons.search, color: Colors.blue),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            // _filterHouseholds will be called automatically via listener
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onChanged: (value) => _filterHouseholds(), // Extra safety
              ),
            ),
          ),
          const SizedBox(height: 16),

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
    final displayList = _filteredHouseholds; // Use filtered list

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Household Entries',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${displayList.length} of ${_households.length} households',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
            const SizedBox(height: 12),

            displayList.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        children: [
                          Icon(
                            _searchController.text.isEmpty ? Icons.inbox : Icons.search_off,
                            size: 64,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _searchController.text.isEmpty
                                ? 'No data available'
                                : 'No households found matching "${_searchController.text}"',
                            style: const TextStyle(color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
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
                              DataColumn(label: Text('Action', style: TextStyle(fontWeight: FontWeight.bold))),
                            ],
                            rows: displayList.asMap().entries.map((entry) {
                              final h = entry.value;
                              final totalIncome = h.economicData.fold(0.0, (s, e) => s + (e.monthlyIncome ?? 0.0));

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
                                        Tooltip(
                                          message: 'View Details',
                                          child: IconButton(
                                            icon: const Icon(Icons.visibility, color: Colors.blue, size: 20),
                                            onPressed: () => _viewHousehold(h),
                                          ),
                                        ),
                                        const SizedBox(width: 3),
                                        Tooltip(
                                          message: 'Edit Household',
                                          child: IconButton(
                                            icon: const Icon(Icons.edit, color: Colors.orange, size: 20),
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
    barrierDismissible: true,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          const Icon(Icons.home_work, color: Colors.purple),
          const SizedBox(width: 12),
          Text(
            'Household #${household.householdNumber}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
      content: SizedBox(
        width: 700,
        height: 680,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // HEAD PHOTO - BIG & CENTERED
              if (household.headPhoto != null) ...[
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.purple.shade100, width: 4),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Image.memory(
                        household.headPhoto!,
                        height: 200,
                        width: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Center(
                  child: Text(
                    'Head of Household',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.purple),
                  ),
                ),
                const SizedBox(height: 20),
              ] else ...[
                Center(
                  child: Container(
                    height: 180,
                    width: 180,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.person_off, size: 80, color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 12),
                const Center(child: Text('No Photo Available', style: TextStyle(color: Colors.grey))),
                const SizedBox(height: 20),
              ],

              // BASIC INFO
              _infoRow('Head of Household', household.headOfHousehold,),
              _infoRow('Total Members', '${household.totalMembers}',),
              _infoRow('Contact Number', household.contactNumber ?? 'N/A',),
              _infoRow(
  'Address',
  [
    household.street,
    household.barangay,
    household.city,
    household.province,
  ]
      .where((s) => s != null && s!.isNotEmpty)   
      .join(', ')                                
      .isEmpty                                           
          ? 'N/A'
          : [
              household.street,
              household.barangay,
              household.city,
              household.province,
            ].where((s) => s != null && s!.isNotEmpty).join(', '),
),
              _infoRow('Census Year', household.censusYear.toString(),),

              const Divider(height: 32),

              // FAMILY MEMBERS
              const Text(
                'Family Members',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepPurple),
              ),
              const SizedBox(height: 12),

              if (household.familyMembers.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('No family members recorded.', style: TextStyle(color: Colors.grey)),
                )
              else
                ...household.familyMembers.map((member) => Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                if (member.philsysImage != null) ...[
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.memory(
                                      member.philsysImage!,
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                ] else
                                  Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(Icons.admin_panel_settings_sharp, color: Colors.grey, size: 40),
                                  ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        member.name,
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                      ),
                                      Text('${member.age} years old • ${member.gender}'),
                                      Text('Relationship: ${member.relationship}'),
                                      if (member.educationStatus != null)
                                        Text('Education: ${member.educationStatus}${member.educationStatus == 'Undergraduate' ? ' (${member.yearLevel} - ${member.course})' : ''}'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            if (member.philsysImage != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  'PhilSys ID Uploaded',
                                  style: TextStyle(color: Colors.green[700], fontSize: 12, fontWeight: FontWeight.w600),
                                ),
                              ),
                          ],
                        ),
                      ),
                    )),
            ],
          ),
        ),
      ),
      actions: [
        TextButton.icon(
          icon: const Icon(Icons.close),
          label: const Text('Close'),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    ),
  );
}

void _editHousehold(Household household) {
  setState(() {
    _selectedHousehold = household;
    _viewState = PopulationViewState.edit;
  });
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