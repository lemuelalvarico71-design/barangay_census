import 'package:flutter/material.dart';

class CensusDataPage extends StatefulWidget {
  const CensusDataPage({super.key});

  @override
  State<CensusDataPage> createState() => _CensusDataPageState();
}

class _CensusDataPageState extends State<CensusDataPage> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;

  final List<Map<String, String>> _censusData = [
    {
      'purok': '1',
      'population': '0',
      'households': '0',
      'lastUpdated': ''
    },
  ];

  String _purok = '';
  String _population = '';
  String _households = '';
  int? _editIndex; // track if editing existing entry

  // Go to Add Page
  void _continue() {
    setState(() {
      _editIndex = null;
      _purok = '';
      _population = '';
      _households = '';
      _currentStep = 1;
    });
  }

  // Cancel form
  void _cancel() {
    setState(() {
      _editIndex = null;
      _purok = '';
      _population = '';
      _households = '';
      _currentStep = 0;
    });
  }

  // Save new or edited data
  void _save() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        if (_editIndex == null) {
          // Add new entry
          _censusData.add({
            'purok': _purok,
            'population': _population,
            'households': _households,
            'lastUpdated': DateTime.now().toString().substring(0, 19),
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('✅ New census data added!')),
          );
        } else {
          // Update existing entry
          _censusData[_editIndex!] = {
            'purok': _purok,
            'population': _population,
            'households': _households,
            'lastUpdated': DateTime.now().toString().substring(0, 19),
          };
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('✏️ Census data updated!')),
          );
        }

        _cancel(); // Return to main view after saving
      });
    }
  }

  // Delete entry
  void _delete(int index) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content:
            Text('Are you sure you want to delete ${_censusData[index]['purok']}?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() => _censusData.removeAt(index));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('🗑️ Entry deleted successfully!')),
      );
    }
  }

  // Edit entry
  void _edit(int index) {
    setState(() {
      _editIndex = index;
      _purok = _censusData[index]['purok']!;
      _population = _censusData[index]['population']!;
      _households = _censusData[index]['households']!;
      _currentStep = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Census Data Management',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Step indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStepCard('View Data', 'Step 1', 'View existing census data', _currentStep == 0),
                _buildStepCard('Add/Edit Data', 'Step 2', 'Add or edit census entry', _currentStep == 1),
              ],
            ),
            const SizedBox(height: 16),

            // Step 1 - View all data
            if (_currentStep == 0)
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: DataTable(
                    headingRowColor: MaterialStateProperty.all(Colors.blue[100]),
                    columns: const [
                      DataColumn(label: Text('Purok', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Population', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Households', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Last Updated', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold))),
                    ],
                    rows: _censusData.asMap().entries.map((entry) {
                      final index = entry.key;
                      final data = entry.value;
                      return DataRow(
                        cells: [
                          DataCell(Text(data['purok']!)),
                          DataCell(Text(data['population']!)),
                          DataCell(Text(data['households']!)),
                          DataCell(Text(data['lastUpdated']!)),
                          DataCell(Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.orange),
                                tooltip: 'Edit entry',
                                onPressed: () => _edit(index),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                tooltip: 'Delete entry',
                                onPressed: () => _delete(index),
                              ),
                            ],
                          )),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),

            // Step 2 - Add/Edit form
            if (_currentStep == 1)
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _editIndex == null
                              ? 'Add New Census Entry'
                              : 'Edit Census Entry',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),

                        // Purok
                        TextFormField(
                          initialValue: _purok,
                          decoration: const InputDecoration(labelText: 'Purok *'),
                          validator: (value) =>
                              value == null || value.isEmpty ? 'Please enter Purok name' : null,
                          onChanged: (value) => _purok = value,
                        ),
                        const SizedBox(height: 16),

                        // Population
                        TextFormField(
                          initialValue: _population,
                          decoration: const InputDecoration(labelText: 'Population *'),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) return 'Please enter population';
                            if (int.tryParse(value) == null) return 'Enter a valid number';
                            return null;
                          },
                          onChanged: (value) => _population = value,
                        ),
                        const SizedBox(height: 16),

                        // Households
                        TextFormField(
                          initialValue: _households,
                          decoration: const InputDecoration(labelText: 'Households *'),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) return 'Please enter households';
                            if (int.tryParse(value) == null) return 'Enter a valid number';
                            return null;
                          },
                          onChanged: (value) => _households = value,
                        ),

                        const SizedBox(height: 24),

                        // Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            OutlinedButton(
                              onPressed: _cancel,
                              style: OutlinedButton.styleFrom(foregroundColor: Colors.grey[700]),
                              child: const Text('Cancel'),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: _save,
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                              child: Text(_editIndex == null ? 'Save' : 'Update'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 16),

            // Add button at bottom (only in View mode)
            if (_currentStep == 0)
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                  onPressed: _continue,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  icon: const Icon(Icons.add),
                  label: const Text('Add New Data'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepCard(String title, String step, String desc, bool isCurrent) {
    return Expanded(
      child: Card(
        color: isCurrent ? Colors.blue[100] : Colors.grey[200],
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.data_usage, color: isCurrent ? Colors.blue : Colors.grey),
              const SizedBox(height: 6),
              Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: isCurrent ? Colors.black : Colors.grey[700])),
              Text(desc, style: const TextStyle(color: Colors.grey)),
              Text(step, style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}
