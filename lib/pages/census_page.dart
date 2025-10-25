import 'package:flutter/material.dart';
import '../widgets/app_sidebar.dart';

class CensusPage extends StatefulWidget {
  const CensusPage({super.key});

  @override
  State<CensusPage> createState() => _CensusPageState();
}

class _CensusPageState extends State<CensusPage> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;
  final List<Map<String, String>> _censusData = [
    {'barangay': 'Barangay Rizal', 'population': '2000', 'households': '400', 'lastUpdated': '10/22/2025 02:31 PM PST'},
  ];
  String _barangay = '';
  String _population = '';
  String _households = '';

  void _continue() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _currentStep = 1;
      });
    }
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _censusData.add({
          'barangay': _barangay,
          'population': _population,
          'households': _households,
          'lastUpdated': '10/22/2025 02:31 PM PST',
        });
        _currentStep = 0; // Back to view
        _barangay = '';
        _population = '';
        _households = '';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Census data added!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return 
          Expanded(
            child: Padding(
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildStepCard('View Data', 'Step 1', 'View existing census data', _currentStep == 0),
                        _buildStepCard('Add Data', 'Step 2', 'Add new census entry', _currentStep == 1),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (_currentStep == 0)
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: DataTable(
                            headingRowColor: MaterialStateProperty.all(Colors.blue[100]),
                            columns: const [
                              DataColumn(label: Text('Barangay', style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(label: Text('Population', style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(label: Text('Households', style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(label: Text('Last Updated', style: TextStyle(fontWeight: FontWeight.bold))),
                            ],
                            rows: _censusData.map((data) => DataRow(
                              cells: [
                                DataCell(Text(data['barangay']!)),
                                DataCell(Text(data['population']!)),
                                DataCell(Text(data['households']!)),
                                DataCell(Text(data['lastUpdated']!)),
                              ],
                            )).toList(),
                          ),
                        ),
                      ),
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
                                TextFormField(
                                  decoration: const InputDecoration(labelText: 'Barangay *'),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter barangay name';
                                    }
                                    return null;
                                  },
                                  onChanged: (value) => _barangay = value,
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  decoration: const InputDecoration(labelText: 'Population *'),
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter population';
                                    }
                                    if (int.tryParse(value) == null) {
                                      return 'Please enter a valid number';
                                    }
                                    return null;
                                  },
                                  onChanged: (value) => _population = value,
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  decoration: const InputDecoration(labelText: 'Households *'),
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter households';
                                    }
                                    if (int.tryParse(value) == null) {
                                      return 'Please enter a valid number';
                                    }
                                    return null;
                                  },
                                  onChanged: (value) => _households = value,
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: _save,
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                                  child: const Text('Save'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (_currentStep == 0)
                          ElevatedButton(
                            onPressed: _continue,
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                            child: const Text('Add New Data'),
                          ),
                        if (_currentStep == 1)
                          ElevatedButton(
                            onPressed: _save,
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                            child: const Text('Save and Return'),
                          ),
                      ],
                    ),
                    const Text(
                      'Last Updated: 10/22/2025 02:31 PM PST',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
           
      ),
    );
  }

  Widget _buildStepCard(String title, String step, String description, bool isCurrent) {
    return Expanded(
      child: Card(
        color: isCurrent ? Colors.blue[100] : Colors.grey[200],
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.data_usage, color: Colors.blue),
              const SizedBox(height: 8),
              Text(title),
              Text(description, style: const TextStyle(color: Colors.grey)),
              Text(step, style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}