import 'package:flutter/material.dart';

class PopulationPage extends StatefulWidget {
  const PopulationPage({super.key});

  @override
  State<PopulationPage> createState() => _PopulationPageState();
}

class _PopulationPageState extends State<PopulationPage> {
  final _formKey = GlobalKey<FormState>();
  String _barangay = 'Barangay Rizal';
  int _population = 2000;
  double _growthRate = 2.5;

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Population data updated!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return 
           Scaffold(
             body: Padding(
                padding: const EdgeInsets.all(16.0),
                     
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Population Data',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
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
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        initialValue: _barangay,
                                        decoration: const InputDecoration(labelText: 'Barangay'),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter barangay name';
                                          }
                                          return null;
                                        },
                                        onChanged: (value) => setState(() => _barangay = value),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: TextFormField(
                                        initialValue: _population.toString(),
                                        decoration: const InputDecoration(labelText: 'Population'),
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
                                        onChanged: (value) => _population = int.parse(value),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        initialValue: _growthRate.toString(),
                                        decoration: const InputDecoration(labelText: 'Growth Rate (%)'),
                                        keyboardType: TextInputType.number,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter growth rate';
                                          }
                                          if (double.tryParse(value) == null) {
                                            return 'Please enter a valid number';
                                          }
                                          return null;
                                        },
                                        onChanged: (value) => _growthRate = double.parse(value),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: _saveChanges,
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                                  child: const Text('Save Changes'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Last Updated: 10/22/2025 02:31 PM PST',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                       
                      
                       
                   
                 ),
           );
  }
}