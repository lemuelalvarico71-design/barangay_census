import 'package:flutter/material.dart';
import '../widgets/app_sidebar.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;
  final List<Map<String, String>> _reports = [
    {
      'type': 'Population Report',
      'barangay': 'Barangay Rizal',
      'date': '10/22/2025 02:31 PM PST',
      'status': 'Completed'
    },
  ];
  String _reportType = '';
  String _barangay = '';

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
        _reports.add({
          'type': _reportType,
          'barangay': _barangay,
          'date': '10/22/2025 02:31 PM PST',
          'status': 'Generated'
        });
        _currentStep = 0; // Back to view
        _reportType = '';
        _barangay = '';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Report generated!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Reports Management',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildStepCard('View Reports', 'Step 1', 'View existing reports', _currentStep == 0),
                        _buildStepCard('Generate Report', 'Step 2', 'Generate new report', _currentStep == 1),
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
                              DataColumn(label: Text('Report Type', style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(label: Text('Barangay', style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(label: Text('Date Generated', style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
                            ],
                            rows: _reports.map((report) => DataRow(
                              cells: [
                                DataCell(Text(report['type']!)),
                                DataCell(Text(report['barangay']!)),
                                DataCell(Text(report['date']!)),
                                DataCell(Text(report['status']!)),
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
                                  decoration: const InputDecoration(labelText: 'Report Type *'),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter report type';
                                    }
                                    return null;
                                  },
                                  onChanged: (value) => _reportType = value,
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  decoration: const InputDecoration(labelText: 'Barangay *'),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter barangay';
                                    }
                                    return null;
                                  },
                                  onChanged: (value) => _barangay = value,
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: _save,
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                                  child: const Text('Generate Report'),
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
                            child: const Text('Generate New Report'),
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
              Icon(Icons.bar_chart, color: Colors.blue),
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