import 'package:flutter/material.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;
  final List<Map<String, String>> _users = [
    {'name': 'Juan Dela Cruz', 'role': 'Captain', 'contact': '0917-123-4567'},
    {'name': 'Maria Santos', 'role': 'Secretary', 'contact': '0918-234-5678'},
    {'name': 'Pedro Garcia', 'role': 'Treasurer', 'contact': '0919-345-6789'},
    {'name': 'Ana Reyes', 'role': 'Kagawad', 'contact': '0920-456-7890'},
  ];
  String _name = '';
  String _role = '';
  String _contact = '';

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
        _users.add({'name': _name, 'role': _role, 'contact': _contact});
        _currentStep = 0; // Back to view
        _name = '';
        _role = '';
        _contact = '';
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('User added!')));
    }
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
              'User Management',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStepCard(
                  'View Users',
                  'Step 1',
                  'View existing users',
                  _currentStep == 0,
                ),
                _buildStepCard(
                  'Add User',
                  'Step 2',
                  'Add new user',
                  _currentStep == 1,
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_currentStep == 0)
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Name')),
                      DataColumn(label: Text('Role')),
                      DataColumn(label: Text('Contact')),
                    ],
                    rows:
                        _users
                            .map(
                              (user) => DataRow(
                                cells: [
                                  DataCell(Text(user['name']!)),
                                  DataCell(Text(user['role']!)),
                                  DataCell(Text(user['contact']!)),
                                ],
                              ),
                            )
                            .toList(),
                  ),
                ),
              ),
            if (_currentStep == 1)
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Name *',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter name';
                            }
                            return null;
                          },
                          onChanged: (value) => _name = value,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Role *',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter role';
                            }
                            return null;
                          },
                          onChanged: (value) => _role = value,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Contact *',
                          ),
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter contact';
                            }
                            return null;
                          },
                          onChanged: (value) => _contact = value,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _save,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          child: const Text('Add User'),
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: const Text('Add New User'),
                  ),
                if (_currentStep == 1)
                  ElevatedButton(
                    onPressed: _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
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

  Widget _buildStepCard(
    String title,
    String step,
    String description,
    bool isCurrent,
  ) {
    return Expanded(
      child: Card(
        color: isCurrent ? Colors.blue[100] : Colors.grey[200],
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.group, color: Colors.blue),
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
