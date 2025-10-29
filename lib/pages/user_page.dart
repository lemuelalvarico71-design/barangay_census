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
    {'name': 'lemuel', 'role': 'Captain', 'contact': '0917-123-4567'},
  ];

  String _name = '';
  String _role = '';
  String _contact = '';

  // Step navigation
  void _continue() {
    setState(() => _currentStep = 1);
  }

  void _cancel() {
    setState(() {
      _currentStep = 0;
      _formKey.currentState?.reset();
      _name = '';
      _role = '';
      _contact = '';
    });
  }

  // Save new user
  void _save() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _users.add({'name': _name, 'role': _role, 'contact': _contact});
        _currentStep = 0;
        _name = '';
        _role = '';
        _contact = '';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ User added successfully!')),
      );
    }
  }

  // Delete a user
  void _deleteUser(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this user?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Cancel
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              setState(() {
                _users.removeAt(index);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('🗑️ User deleted successfully!')),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
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

            // Step cards
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

            // STEP 1: View users
            if (_currentStep == 0)
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _users.isEmpty
                      ? const Center(
                          child: Text(
                            'No users available. Click “Add New User” to add one.',
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                      : DataTable(
                          columns: const [
                            DataColumn(label: Text('Name')),
                            DataColumn(label: Text('Role')),
                            DataColumn(label: Text('Contact')),
                            DataColumn(label: Text('Actions')),
                          ],
                          rows: List.generate(_users.length, (index) {
                            final user = _users[index];
                            return DataRow(cells: [
                              DataCell(Text(user['name']!)),
                              DataCell(Text(user['role']!)),
                              DataCell(Text(user['contact']!)),
                              DataCell(
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _deleteUser(index),
                                ),
                              ),
                            ]);
                          }),
                        ),
                ),
              ),

            // STEP 2: Add user form
            if (_currentStep == 1)
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          decoration:
                              const InputDecoration(labelText: 'Name *'),
                          validator: (value) => value == null || value.isEmpty
                              ? 'Please enter name'
                              : null,
                          onSaved: (value) => _name = value ?? '',
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          decoration:
                              const InputDecoration(labelText: 'Role *'),
                          validator: (value) => value == null || value.isEmpty
                              ? 'Please enter role'
                              : null,
                          onSaved: (value) => _role = value ?? '',
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          decoration:
                              const InputDecoration(labelText: 'Contact *'),
                          keyboardType: TextInputType.phone,
                          validator: (value) => value == null || value.isEmpty
                              ? 'Please enter contact'
                              : null,
                          onSaved: (value) => _contact = value ?? '',
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: _cancel,
                              child: const Text('Cancel'),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: _save,
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green),
                              child: const Text('Save User'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 16),

            // Bottom controls
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (_currentStep == 0)
                  ElevatedButton(
                    onPressed: _continue,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent),
                    child: const Text('Add New User'),
                  ),
              ],
            ),

            const SizedBox(height: 8),
            const Text(
              'Last Updated: 10/28/2025 08:45 PM PST',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepCard(
      String title, String step, String description, bool isCurrent) {
    return Expanded(
      child: Card(
        color: isCurrent ? Colors.blue[100] : Colors.grey[200],
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.group, color: isCurrent ? Colors.blue : Colors.grey),
              const SizedBox(height: 8),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(description, style: const TextStyle(color: Colors.grey)),
              Text(step, style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}
