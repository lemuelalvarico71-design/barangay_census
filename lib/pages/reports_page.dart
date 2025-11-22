import 'package:flutter/material.dart';

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
              
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Reports Management',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                    
                        if (_currentStep == 1)
                          ElevatedButton(
                            onPressed: _save,
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                            child: const Text('Save and Return'),
                          ),
                      ],
                    ),
                   
                  ],
                ),
              
           
    );
  }

  
}