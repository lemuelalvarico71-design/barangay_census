import 'package:barangay_census_app/services/auth_service.dart';
import 'package:barangay_census_app/services/database_service.dart';
import 'package:flutter/material.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0; // 0 = list, 1 = add

  List<Map<String, dynamic>> _users = [];
  bool _isLoading = true;

  // Form controllers
  final _fullnameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  String _role = 'Secretary';

  // For PH time display
  String get _nowPH => DateTime.now()
      .toUtc()
      .add(const Duration(hours: 8))
      .toString()
      .substring(0, 19);

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  // ────── LOAD USERS ──────
  Future<void> _loadUsers() async {
    setState(() => _isLoading = true);
    try {
      final users = await DatabaseService.instance.getAllUsers();
      setState(() => _users = users);
    } catch (e) {
      _showSnack('Load failed: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // ────── NAVIGATION ──────
  void _goToAdd() => setState(() => _currentStep = 1);

  void _cancel() {
    setState(() {
      _currentStep = 0;
      _formKey.currentState?.reset();
      _fullnameCtrl.clear();
      _emailCtrl.clear();
      _usernameCtrl.clear();
      _passwordCtrl.clear();
      _role = 'Secretary';
    });
  }

  // ────── SAVE USER ──────
  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final fullname = _fullnameCtrl.text.trim();
    final email = _emailCtrl.text.trim();
    final username = _usernameCtrl.text.trim();
    final password = _passwordCtrl.text;
  

    // ── Prevent duplicate username / email / role ──
    final duplicate = _users.any((u) =>
        u['username'] == username ||
        u['email'] == email);

    if (duplicate) {
      _showSnack(
          'Cannot add: username, email, or role ($_role) already taken.');
      return;
    }

    try {
      await DatabaseService.instance.insertUser(
        fullname: fullname,
        email: email,
        username: username,
        password: password,
        role: _role,
      );

      final currentUser = AuthService.getCurrentUser();
await DatabaseService.instance.logActivity(
  action: 'Add User',
  fullname: currentUser?['fullname'] ?? 'System',
  role: currentUser?['_role'] ?? 'Admin',
  userId: currentUser?['id'],
  description: 'Created user: $username ($_role)',
);

      await _loadUsers(); // refresh
      _cancel();

      _showSnack('User added successfully!');
    } catch (e) {
      _showSnack('Save failed: $e');
    }
  }

  // ────── DELETE USER ──────
  Future<void> _deleteUser(int id, int index) async {
    final ok = await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Delete User?'),
            content: const Text('This action cannot be undone.'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child:
                      const Text('Delete', style: TextStyle(color: Colors.red))),
            ],
          ),
        ) ??
        false;

    if (!ok) return;

    try {
      await DatabaseService.instance.deleteUser(id);
      setState(() => _users.removeAt(index));
      _showSnack('User deleted');
    } catch (e) {
      _showSnack('Delete failed: $e');
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  // ────── UI ──────
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
     
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('User Management',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),

            // Step cards
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 350,
                  child: _stepCard('View Users', 'Step 1', 'List all users', _currentStep == 0),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // STEP 1 – List
            if (_currentStep == 0) _buildUserList(),

            // STEP 2 – Form
            if (_currentStep == 1) _buildAddUserForm(),

            const SizedBox(height: 16),

            // ...existing code...

            const SizedBox(height: 8),
            Text('Last Updated: $_nowPH',
                style: const TextStyle(fontSize: 14, color: Colors.grey)),
          ],
        ),
      
    );
  }

  // ────── STEP CARD ──────
  Widget _stepCard(String title, String step, String desc, bool active) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          gradient: active
              ? LinearGradient(
                  colors: [Colors.blue.shade100, Colors.blue.shade50],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : LinearGradient(
                  colors: [Colors.grey.shade200, Colors.grey.shade100],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      color: active ? Colors.blueAccent : Colors.grey,
                      shape: BoxShape.circle,
                      boxShadow: active
                          ? [BoxShadow(color: Colors.blueAccent.withOpacity(0.2), blurRadius: 6)]
                          : [],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    step,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: active ? Colors.blueAccent : Colors.grey[600],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: active ? Colors.blueAccent : Colors.black87,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                desc,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ────── USER LIST ──────
  Widget _buildUserList() {
    if (_isLoading) return const Center(child: CircularProgressIndicator());

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: _users.isEmpty
            ? const Center(
                child:
                    Text('No users yet. Add one!', style: TextStyle(color: Colors.grey)))
            : LayoutBuilder(
                builder: (context, constraints) => SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints(minWidth: constraints.maxWidth),
                    child: DataTable(
                      columns: const [
                        DataColumn(
                            label: Text('Full Name',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text('Email',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text('Username',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text('Role',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Actions')),
                      ],
                      rows: _users.asMap().entries.map((e) {
                        final i = e.key;
                        final u = e.value;
                        return DataRow(cells: [
                          DataCell(Text(u['fullname'] ?? '')),
                          DataCell(Text(u['email'] ?? '')),
                          DataCell(Text(u['username'] ?? '')),
                          DataCell(Chip(
                            label: Text(u['role'],
                                style: const TextStyle(color: Colors.white)),
                            backgroundColor:
                                u['role'] == 'Secretary' ? Colors.purple : Colors.orange,
                          )),
                          DataCell(
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteUser(u['id'] as int, i),
                            ),
                          ),
                        ]);
                      }).toList(),
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  // ────── ADD USER FORM ──────
  Widget _buildAddUserForm() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Full Name
              TextFormField(
                controller: _fullnameCtrl,
                decoration: const InputDecoration(
                    labelText: 'Full Name *', border: OutlineInputBorder()),
                validator: (v) => v!.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),

              // Email
              TextFormField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                    labelText: 'Email *', border: OutlineInputBorder()),
                validator: (v) =>
                    v!.contains('@') ? null : 'Enter a valid email',
              ),
              const SizedBox(height: 12),

              // Username
              TextFormField(
                controller: _usernameCtrl,
                decoration: const InputDecoration(
                    labelText: 'Username *', border: OutlineInputBorder()),
                validator: (v) => v!.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),

              // Password
              TextFormField(
                controller: _passwordCtrl,
                obscureText: true,
                decoration: const InputDecoration(
                    labelText: 'Password *', border: OutlineInputBorder()),
                validator: (v) =>
                    v!.length >= 6 ? null : 'Minimum 6 characters',
              ),
              const SizedBox(height: 12),

              // Role (only two options)
              DropdownButtonFormField<String>(
                value: _role,
                decoration: const InputDecoration(
                    labelText: 'Role *', border: OutlineInputBorder()),
                items: ['Secretary', 'Captain']
                    .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                    .toList(),
                onChanged: (v) => setState(() => _role = v!),
              ),
              const SizedBox(height: 24),
 
              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(onPressed: _cancel, child: const Text('Cancel')),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _save,
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: const Text('Save User'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}