import 'package:flutter/material.dart';

class HouseholdPage extends StatefulWidget {
  const HouseholdPage({super.key});

  @override
  State<HouseholdPage> createState() => _HouseholdPageState();
}

class _HouseholdPageState extends State<HouseholdPage> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;
  final _householdNumberController = TextEditingController();
  final _headOfHouseholdController = TextEditingController();
  final _totalFamilyMembersController = TextEditingController();
  final _contactNumberController = TextEditingController();
  final _typeOfDwellingController = TextEditingController();
  final _tenureStatusController = TextEditingController();
  final _roofMaterialController = TextEditingController();
  final _wallMaterialController = TextEditingController();
  final _numberOfRoomsController = TextEditingController();
  final _floorAreaController = TextEditingController();

  @override
  void dispose() {
    _householdNumberController.dispose();
    _headOfHouseholdController.dispose();
    _totalFamilyMembersController.dispose();
    _contactNumberController.dispose();
    _typeOfDwellingController.dispose();
    _tenureStatusController.dispose();
    _roofMaterialController.dispose();
    _wallMaterialController.dispose();
    _numberOfRoomsController.dispose();
    _floorAreaController.dispose();
    super.dispose();
  }

  void _continue() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _currentStep += 1;
      });
    }
  }

  void _cancel() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep -= 1;
      });
    }
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Household data saved!')),
      );
      setState(() {
        _currentStep = 0; // Reset to start after saving
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return 
          Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Census Data Entry Progress',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildStepCard('Household Info', 'Step 1', 'Basic household information', _currentStep == 0),
                        _buildStepCard('Family Members', 'Step 2', 'Individual member details', _currentStep == 1),
                        _buildStepCard('Economic Data', 'Step 3', 'Income and business information', _currentStep == 2),
                        _buildStepCard('Address', 'Step 4', 'Location and GPS verification', _currentStep == 3),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (_currentStep == 0)
                            Column(
                              children: [
                                const Text(
                                  'Basic Information',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        controller: _householdNumberController,
                                        decoration: const InputDecoration(
                                          labelText: 'Household Number *',
                                          hintText: 'Enter household number',
                                          border: OutlineInputBorder(),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter household number';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: TextFormField(
                                        controller: _headOfHouseholdController,
                                        decoration: const InputDecoration(
                                          labelText: 'Head of Household *',
                                          hintText: 'Enter head of household name',
                                          border: OutlineInputBorder(),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter head of household name';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        controller: _totalFamilyMembersController,
                                        decoration: const InputDecoration(
                                          labelText: 'Total Family Members *',
                                          hintText: 'Enter number of family members',
                                          border: OutlineInputBorder(),
                                        ),
                                        keyboardType: TextInputType.number,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter number of family members';
                                          }
                                          if (int.tryParse(value) == null) {
                                            return 'Please enter a valid number';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: TextFormField(
                                        controller: _contactNumberController,
                                        decoration: const InputDecoration(
                                          labelText: 'Contact Number',
                                          hintText: 'Enter contact number',
                                          border: OutlineInputBorder(),
                                        ),
                                        keyboardType: TextInputType.phone,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          if (_currentStep == 1)
                            Column(
                              children: [
                                const Text(
                                  'Family Members',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 16),
                                // Add family member entry fields here (placeholder)
                                const Text('Family member details to be added'),
                              ],
                            ),
                          if (_currentStep == 2)
                            Column(
                              children: [
                                const Text(
                                  'Economic Data',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 16),
                                // Add economic data fields here (placeholder)
                                const Text('Economic data to be added'),
                              ],
                            ),
                          if (_currentStep == 3)
                            Column(
                              children: [
                                const Text(
                                  'Address',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 16),
                                // Add address fields here (placeholder)
                                const Text('Address details to be added'),
                              ],
                            ),
                          const SizedBox(height: 32),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (_currentStep > 0)
                                ElevatedButton(
                                  onPressed: _cancel,
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                                  child: const Text('Back'),
                                ),
                              const SizedBox(width: 8),
                              if (_currentStep < 3)
                                ElevatedButton(
                                  onPressed: _continue,
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                                  child: const Text('Next'),
                                ),
                              if (_currentStep == 3)
                                ElevatedButton(
                                  onPressed: _save,
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                                  child: const Text('Save'),
                                ),
                            ],
                          ),
                        ],
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

  Widget _buildStepCard(String title, String step, String description, bool isCurrent) {
    return Expanded(
      child: Card(
        color: isCurrent ? Colors.blue[100] : Colors.grey[200],
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.home, color: Colors.blue),
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