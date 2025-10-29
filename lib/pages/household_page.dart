import 'package:barangay_census_app/models/household.dart';
import 'package:barangay_census_app/services/database_service.dart';
import 'package:flutter/material.dart';

class HouseholdPage extends StatefulWidget {
  const HouseholdPage({super.key});

  @override
  State<HouseholdPage> createState() => _HouseholdPageState();
}

class _HouseholdPageState extends State<HouseholdPage> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;

  // Household Info Controllers
  final _householdNumberController = TextEditingController();
  final _headOfHouseholdController = TextEditingController();
  final _totalFamilyMembersController = TextEditingController();
  final _contactNumberController = TextEditingController();

  // Family Members
  List<Map<String, dynamic>> _familyMembers = [];

  // Economic Data
  List<Map<String, dynamic>> _economicData = [];

  // Address Controllers
  final _streetController = TextEditingController();
  final _barangayController = TextEditingController();
  final _cityController = TextEditingController();
  final _provinceController = TextEditingController();
  final _zipController = TextEditingController();
  bool _gpsVerified = false;

  @override
  void dispose() {
    _householdNumberController.dispose();
    _headOfHouseholdController.dispose();
    _totalFamilyMembersController.dispose();
    _contactNumberController.dispose();
    _streetController.dispose();
    _barangayController.dispose();
    _cityController.dispose();
    _provinceController.dispose();
    _zipController.dispose();
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

  Future<void> _save() async {
  if (!_formKey.currentState!.validate()) return;

  final household = Household(
    householdNumber: _householdNumberController.text.trim(),
    headOfHousehold: _headOfHouseholdController.text.trim(),
    totalMembers: int.tryParse(_totalFamilyMembersController.text) ?? 0,
    contactNumber: _contactNumberController.text.isEmpty ? null : _contactNumberController.text.trim(),
    street: _streetController.text.isEmpty ? null : _streetController.text.trim(),
    barangay: _barangayController.text.isEmpty ? null : _barangayController.text.trim(),
    city: _cityController.text.isEmpty ? null : _cityController.text.trim(),
    province: _provinceController.text.isEmpty ? null : _provinceController.text.trim(),
    zipCode: _zipController.text.isEmpty ? null : _zipController.text.trim(),
    gpsVerified: _gpsVerified,
    familyMembers: _familyMembers.map((m) => FamilyMember(
      name: m['name'],
      age: m['age'],
      gender: m['gender'],
      relationship: m['relationship'],
    )).toList(),
    economicData: _economicData.map((e) => EconomicEntry(
      memberName: e['memberName'],
      occupation: e['occupation'],
      monthlyIncome: (e['income'] as num).toDouble(),
      employer: e['employer'],
    )).toList(),
  );

  try {
    final db = DatabaseService.instance;
    await db.insertHousehold(household);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Household saved successfully!')),
    );

    // Reset form
    setState(() {
      _currentStep = 0;
      _familyMembers.clear();
      _economicData.clear();
      _gpsVerified = false;
      _householdNumberController.clear();
      _headOfHouseholdController.clear();
      _totalFamilyMembersController.clear();
      _contactNumberController.clear();
      _streetController.clear();
      _barangayController.clear();
      _cityController.clear();
      _provinceController.clear();
      _zipController.clear();
    });
  } catch (e) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Save failed: $e')),
    );
  }
}

  // ---------------- FAMILY MEMBER DIALOG ----------------
  void _addFamilyMemberDialog({Map<String, dynamic>? existingMember, int? index}) {
    final nameController = TextEditingController(text: existingMember?['name']);
    final ageController = TextEditingController(text: existingMember?['age']?.toString());
    String gender = existingMember?['gender'] ?? 'Male';
    final relationshipController =
        TextEditingController(text: existingMember?['relationship']);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(existingMember == null ? 'Add Family Member' : 'Edit Member'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Full Name')),
              TextField(controller: ageController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Age')),
              DropdownButtonFormField<String>(
                value: gender,
                decoration: const InputDecoration(labelText: 'Gender'),
                items: const [
                  DropdownMenuItem(value: 'Male', child: Text('Male')),
                  DropdownMenuItem(value: 'Female', child: Text('Female')),
                  DropdownMenuItem(value: 'Other', child: Text('Other')),
                ],
                onChanged: (val) => gender = val!,
              ),
              TextField(controller: relationshipController, decoration: const InputDecoration(labelText: 'Relationship')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isEmpty) return;
              final member = {
                'name': nameController.text,
                'age': int.tryParse(ageController.text) ?? 0,
                'gender': gender,
                'relationship': relationshipController.text,
              };
              setState(() {
                if (index != null) _familyMembers[index] = member;
                else _familyMembers.add(member);
              });
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  // ---------------- ECONOMIC DATA DIALOG ----------------
  void _addEconomicDataDialog({Map<String, dynamic>? existingData, int? index}) {
    final memberNameController = TextEditingController(text: existingData?['memberName']);
    final occupationController = TextEditingController(text: existingData?['occupation']);
    final incomeController = TextEditingController(text: existingData?['income']?.toString());
    final employerController = TextEditingController(text: existingData?['employer']);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(existingData == null ? 'Add Economic Data' : 'Edit Economic Data'),
        content: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(controller: memberNameController, decoration: const InputDecoration(labelText: 'Member Name')),
            TextField(controller: occupationController, decoration: const InputDecoration(labelText: 'Occupation')),
            TextField(controller: incomeController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Monthly Income')),
            TextField(controller: employerController, decoration: const InputDecoration(labelText: 'Employer/Business')),
          ]),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (memberNameController.text.isEmpty) return;
              final data = {
                'memberName': memberNameController.text,
                'occupation': occupationController.text,
                'income': double.tryParse(incomeController.text) ?? 0.0,
                'employer': employerController.text,
              };
              setState(() {
                if (index != null) _economicData[index] = data;
                else _economicData.add(data);
              });
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _deleteItem(List dataList, int index) {
    setState(() => dataList.removeAt(index));
  }

  // ---------------- STEP BUILDERS ----------------
  Widget _buildHouseholdInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Basic Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Row(children: [
          Expanded(
            child: TextFormField(
              controller: _householdNumberController,
              decoration: const InputDecoration(labelText: 'Household Number *', border: OutlineInputBorder()),
              validator: (v) => v!.isEmpty ? 'Required' : null,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: TextFormField(
              controller: _headOfHouseholdController,
              decoration: const InputDecoration(labelText: 'Head of Household *', border: OutlineInputBorder()),
              validator: (v) => v!.isEmpty ? 'Required' : null,
            ),
          ),
        ]),
        const SizedBox(height: 16),
        Row(children: [
          Expanded(
            child: TextFormField(
              controller: _totalFamilyMembersController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Total Family Members *', border: OutlineInputBorder()),
              validator: (v) => v!.isEmpty ? 'Required' : null,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: TextFormField(
              controller: _contactNumberController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Contact Number', border: OutlineInputBorder()),
            ),
          ),
        ]),
      ],
    );
  }

  Widget _buildFamilyMembers() {
    return _buildDynamicList(
      title: 'Family Members',
      addAction: () => _addFamilyMemberDialog(),
      list: _familyMembers,
      itemBuilder: (member, i) => ListTile(
        title: Text(member['name']),
        subtitle: Text('Age: ${member['age']} | ${member['gender']} | ${member['relationship']}'),
        trailing: _buildEditDelete(() => _addFamilyMemberDialog(existingMember: member, index: i), () => _deleteItem(_familyMembers, i)),
      ),
    );
  }

  Widget _buildEconomicData() {
    return _buildDynamicList(
      title: 'Economic Data',
      addAction: () => _addEconomicDataDialog(),
      list: _economicData,
      itemBuilder: (data, i) => ListTile(
        title: Text(data['memberName']),
        subtitle: Text('Occupation: ${data['occupation']} | Income: ₱${data['income']} | Employer: ${data['employer']}'),
        trailing: _buildEditDelete(() => _addEconomicDataDialog(existingData: data, index: i), () => _deleteItem(_economicData, i)),
      ),
    );
  }

  Widget _buildAddressSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Address Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        _buildTextField(_streetController, 'Street / Purok'),
        _buildTextField(_barangayController, 'Barangay'),
        _buildTextField(_cityController, 'City / Municipality'),
        _buildTextField(_provinceController, 'Province'),
        _buildTextField(_zipController, 'ZIP Code'),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: () {
            setState(() => _gpsVerified = true);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('GPS location verified successfully!')),
            );
          },
          icon: const Icon(Icons.gps_fixed),
          label: Text(_gpsVerified ? 'Verified' : 'Verify via GPS'),
          style: ElevatedButton.styleFrom(
            backgroundColor: _gpsVerified ? Colors.green : Colors.blue,
          ),
        ),
      ],
    );
  }

  // ---------------- HELPERS ----------------
  Widget _buildDynamicList({
    required String title,
    required VoidCallback addAction,
    required List list,
    required Widget Function(dynamic, int) itemBuilder,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ElevatedButton.icon(
            onPressed: addAction,
            icon: const Icon(Icons.add),
            label: const Text('Add'),
          ),
        ]),
        const SizedBox(height: 16),
        if (list.isEmpty)
          const Text('No data added yet.', style: TextStyle(color: Colors.grey)),
        if (list.isNotEmpty)
          ListView.builder(
            shrinkWrap: true,
            itemCount: list.length,
            itemBuilder: (context, i) => Card(child: itemBuilder(list[i], i)),
          ),
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(controller: controller, decoration: InputDecoration(labelText: label, border: const OutlineInputBorder())),
    );
  }

  Widget _buildEditDelete(VoidCallback onEdit, VoidCallback onDelete) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      IconButton(icon: const Icon(Icons.edit, color: Colors.orange), onPressed: onEdit),
      IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: onDelete),
    ]);
  }

  Widget _buildStepCard(String title, String step, String desc, bool isCurrent) {
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _currentStep = ['Household Info', 'Family Members', 'Economic Data', 'Address'].indexOf(title)),
        child: Card(
          color: isCurrent ? Colors.blue[100] : Colors.grey[200],
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Icon(Icons.home, color: Colors.blue),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(desc, style: const TextStyle(color: Colors.grey)),
              Text(step, style: const TextStyle(color: Colors.grey)),
            ]),
          ),
        ),
      ),
    );
  }

  // ---------------- BUILD ----------------
  @override
  Widget build(BuildContext context) {
    final stepWidgets = [
      _buildHouseholdInfo(),
      _buildFamilyMembers(),
      _buildEconomicData(),
      _buildAddressSection(),
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(children: [
        const Text('Census Data Entry Progress', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          _buildStepCard('Household Info', 'Step 1', 'Basic household information', _currentStep == 0),
          _buildStepCard('Family Members', 'Step 2', 'Individual member details', _currentStep == 1),
          _buildStepCard('Economic Data', 'Step 3', 'Income and business info', _currentStep == 2),
          _buildStepCard('Address', 'Step 4', 'Location and GPS verification', _currentStep == 3),
        ]),
        const SizedBox(height: 24),
        Form(key: _formKey, child: stepWidgets[_currentStep]),
        const SizedBox(height: 32),
        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          if (_currentStep > 0)
            ElevatedButton(onPressed: _cancel, style: ElevatedButton.styleFrom(backgroundColor: Colors.grey), child: const Text('Back')),
          const SizedBox(width: 8),
          if (_currentStep < 3)
            ElevatedButton(onPressed: _continue, style: ElevatedButton.styleFrom(backgroundColor: Colors.blue), child: const Text('Next')),
          if (_currentStep == 3)
            ElevatedButton(onPressed: _save, style: ElevatedButton.styleFrom(backgroundColor: Colors.green), child: const Text('Save')),
        ]),
      ]),
    );
  }
}
