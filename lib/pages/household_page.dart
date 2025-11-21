import 'dart:io';
import 'dart:typed_data';

import 'package:barangay_census_app/models/household.dart';
import 'package:barangay_census_app/services/database_service.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class HouseholdPage extends StatefulWidget {
  const HouseholdPage({super.key});

  @override
  State<HouseholdPage> createState() => _HouseholdPageState();
}

class _HouseholdPageState extends State<HouseholdPage> {
  final _formKey = GlobalKey<FormState>();

  // ────── Controllers ──────
  final _householdNumberController = TextEditingController();
  final _headOfHouseholdController = TextEditingController();
  final _totalFamilyMembersController = TextEditingController();
  final _contactNumberController = TextEditingController();

  final _streetController = TextEditingController();
  final _barangayController = TextEditingController();
  final _cityController = TextEditingController();
  final _provinceController = TextEditingController();
  final _zipController = TextEditingController();

  // ────── Census Year ──────
  int? _censusYear;
  final _censusYearController = TextEditingController();

  // ────── Dynamic lists ──────
  List<Map<String, dynamic>> _familyMembers = [];
  List<Map<String, dynamic>> _economicData = [];

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
    _censusYearController.dispose();
    super.dispose();
  }

  // ────── Year Picker ──────
  Future<void> _pickCensusYear() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year),
      firstDate: DateTime(2000),
      lastDate: DateTime(now.year + 5),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.purple,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _censusYear = picked.year;
        _censusYearController.text = picked.year.toString();
      });
    }
  }

  // ────── Image Picker (Desktop) ──────
  Future<void> _pickImageForMember(int index) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
      withData: true,
    );

    if (result != null && result.files.single.bytes != null) {
      final bytes = result.files.single.bytes!;
      setState(() {
        _familyMembers[index]['philsys_image'] = bytes;
      });
    }
  }

  void _removeImageForMember(int index) {
    setState(() {
      _familyMembers[index]['philsys_image'] = null;
    });
  }

  // ────── Save ──────
  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_censusYear == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select Census Year')),
      );
      return;
    }

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
      familyMembers: _familyMembers
          .map((m) => FamilyMember(
                name: m['name'],
                age: m['age'],
                gender: m['gender'],
                relationship: m['relationship'],
                philsysImage: m['philsys_image'] as Uint8List?,
                educationStatus: m['education_status'],
                yearLevel: m['year_level'],
                course: m['course'],
                employmentStatus: m['employment_status'],
              ))
          .toList(),
      economicData: _economicData
          .map((e) => EconomicEntry(
                memberName: e['memberName'],
                occupation: e['occupation'],
                monthlyIncome: (e['income'] as num).toDouble(),
                employer: e['employer'],
              ))
          .toList(),
      censusYear: _censusYear!, // ← SAVE YEAR
    );

    try {
      await DatabaseService.instance.insertHousehold(household);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Household saved successfully!')),
      );

      // Reset
      setState(() {
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
        _censusYear = null;
        _censusYearController.clear();
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Save failed: $e')),
      );
    }
  }


void _addFamilyMemberDialog({Map<String, dynamic>? existingMember, int? index}) {
  final nameCtrl = TextEditingController(text: existingMember?['name']);
  final ageCtrl = TextEditingController(text: existingMember?['age']?.toString());
  String gender = existingMember?['gender'] ?? 'Male';
  final relCtrl = TextEditingController(text: existingMember?['relationship']);

  // ────── Educational Fields ──────
  String? educationStatus = existingMember?['education_status'];
  final yearLevelCtrl = TextEditingController(text: existingMember?['year_level']);
  final courseCtrl = TextEditingController(text: existingMember?['course']);
  String? employmentStatus = existingMember?['employment_status'];

  Uint8List? dialogImageBytes = existingMember?['philsys_image'] as Uint8List?;
  final dialogKey = GlobalKey();

  Future<void> pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
      withData: true,
    );
    if (result != null && result.files.single.bytes != null) {
      dialogImageBytes = result.files.single.bytes!;
      (dialogKey.currentContext as Element?)?.markNeedsBuild();
    }
  }

  void removeImage() {
    dialogImageBytes = null;
    (dialogKey.currentContext as Element?)?.markNeedsBuild();
  }

  showDialog(
    context: context,
    builder: (_) => StatefulBuilder(
      builder: (context, setDialogState) {
        return AlertDialog(
          key: dialogKey,
          title: Text(existingMember == null ? 'Add Family Member' : 'Edit Member'),
          content: SingleChildScrollView(
            child: SizedBox(
              width: 600,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name
                  TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Full Name')),
                  const SizedBox(height: 12),

                  // Age
                  TextField(controller: ageCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Age')),
                  const SizedBox(height: 12),

                  // Gender
                  DropdownButtonFormField<String>(
                    value: gender,
                    decoration: const InputDecoration(labelText: 'Gender'),
                    items: const [
                      DropdownMenuItem(value: 'Male', child: Text('Male')),
                      DropdownMenuItem(value: 'Female', child: Text('Female')),
                      DropdownMenuItem(value: 'Other', child: Text('Other')),
                    ],
                    onChanged: (v) { gender = v!; setDialogState(() {}); },
                  ),
                  const SizedBox(height: 12),

                  // Relationship
                  TextField(controller: relCtrl, decoration: const InputDecoration(labelText: 'Relationship')),
                  const SizedBox(height: 16),

                  // ────── Educational Status ──────
                  const Text('Educational Status', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),

                  DropdownButtonFormField<String>(
                    value: educationStatus,
                    hint: const Text('Select status'),
                    decoration: const InputDecoration(border: OutlineInputBorder()),
                    items: [
                      'None',
                      'Elementary',
                      'High School',
                      'Undergraduate',
                      'Graduate',
                      'Vocational',
                      'Post-Graduate',
                    ].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                    onChanged: (v) {
                      educationStatus = v;
                      yearLevelCtrl.clear();
                      courseCtrl.clear();
                      employmentStatus = null;
                      setDialogState(() {});
                    },
                  ),
                  const SizedBox(height: 12),

                  // ────── Conditional: Undergraduate ──────
                  if (educationStatus == 'Undergraduate') ...[
                    TextField(controller: yearLevelCtrl, decoration: const InputDecoration(labelText: 'Year Level (e.g., 1st Year)')),
                    const SizedBox(height: 12),
                    TextField(controller: courseCtrl, decoration: const InputDecoration(labelText: 'Course (e.g., BS Computer Science)')),
                    const SizedBox(height: 12),
                  ],

                  // ────── Conditional: Graduate ──────
                  if (educationStatus == 'Graduate')
                    Column(
                      children: [
                        RadioListTile<String>(
                          title: const Text('Employed'),
                          value: 'Employed',
                          groupValue: employmentStatus,
                          onChanged: (v) { employmentStatus = v; setDialogState(() {}); },
                        ),
                        RadioListTile<String>(
                          title: const Text('Unemployed'),
                          value: 'Unemployed',
                          groupValue: employmentStatus,
                          onChanged: (v) { employmentStatus = v; setDialogState(() {}); },
                        ),
                      ],
                    ),

                  // ────── PhilSys ID Upload ──────
                  const Text('PhilSys ID', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  dialogImageBytes == null
                      ? _buildUploadArea(pickImage)
                      : _buildDialogImagePreview(dialogImageBytes!, pickImage, removeImage),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                if (nameCtrl.text.isEmpty) return;

                // Validation
                if (educationStatus == 'Undergraduate' && (yearLevelCtrl.text.isEmpty || courseCtrl.text.isEmpty)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Year Level and Course are required for Undergraduate')),
                  );
                  return;
                }
                if (educationStatus == 'Graduate' && employmentStatus == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please select Employed or Unemployed')),
                  );
                  return;
                }

                final member = {
                  'name': nameCtrl.text.trim(),
                  'age': int.tryParse(ageCtrl.text) ?? 0,
                  'gender': gender,
                  'relationship': relCtrl.text.trim(),
                  'philsys_image': dialogImageBytes,
                  'education_status': educationStatus,
                  'year_level': educationStatus == 'Undergraduate' ? yearLevelCtrl.text.trim() : null,
                  'course': educationStatus == 'Undergraduate' ? courseCtrl.text.trim() : null,
                  'employment_status': educationStatus == 'Graduate' ? employmentStatus : null,
                };

                setState(() {
                  if (index != null) {
                    _familyMembers[index] = member;
                  } else {
                    _familyMembers.add(member);
                  }
                });
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    ),
  );
}

Widget _buildUploadArea(VoidCallback onPick) {
  return DragTarget<File>(
    onAccept: (file) async {
      final bytes = await file.readAsBytes();
      // Trigger rebuild via parent StatefulBuilder
      // (We use a callback to avoid direct setState in dialog)
    },
    builder: (context, candidateData, rejectedData) {
      final isDragging = candidateData.isNotEmpty;
      return DottedBorder(

        child: InkWell(
          onTap: onPick,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDragging ? Colors.purple.shade50 : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.cloud_upload_outlined,
                  size: 32,
                  color: isDragging ? Colors.purple.shade700 : Colors.purple.shade600,
                ),
                const SizedBox(height: 8),
                Text(
                  'Upload PhilSys ID',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDragging ? Colors.purple.shade700 : Colors.purple.shade700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Click or drag image here',
                  style: TextStyle(fontSize: 11, color: Colors.purple.shade400),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

Widget _buildDialogImagePreview(
  Uint8List bytes,
  VoidCallback onChange,
  VoidCallback onRemove,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.memory(
          bytes,
          height: 120,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
      const SizedBox(height: 8),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton.icon(
            onPressed: onChange,
            icon: const Icon(Icons.edit, size: 16, color: Colors.orange),
            label: const Text('Change', style: TextStyle(fontSize: 12)),
          ),
          TextButton.icon(
            onPressed: onRemove,
            icon: const Icon(Icons.delete, size: 16, color: Colors.red),
            label: const Text('Remove', style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    ],
  );
}
  // ────── Economic Data Dialog (unchanged) ──────
  void _addEconomicDataDialog({Map<String, dynamic>? existingData, int? index}) {
    final nameCtrl = TextEditingController(text: existingData?['memberName']);
    final occCtrl = TextEditingController(text: existingData?['occupation']);
    final incCtrl = TextEditingController(text: existingData?['income']?.toString());
    final empCtrl = TextEditingController(text: existingData?['employer']);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(existingData == null ? 'Add Economic Data' : 'Edit Economic Data'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Member Name')),
              TextField(controller: occCtrl, decoration: const InputDecoration(labelText: 'Occupation')),
              TextField(
                controller: incCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Monthly Income'),
              ),
              TextField(controller: empCtrl, decoration: const InputDecoration(labelText: 'Employer/Business')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (nameCtrl.text.isEmpty) return;
              final data = {
                'memberName': nameCtrl.text,
                'occupation': occCtrl.text,
                'income': double.tryParse(incCtrl.text) ?? 0.0,
                'employer': empCtrl.text,
              };
              setState(() {
                if (index != null) {
                  _economicData[index] = data;
                } else {
                  _economicData.add(data);
                }
              });
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _deleteItem(List list, int index) => setState(() => list.removeAt(index));

// ────── Section Builders ──────
  Widget _sectionTitle(String title) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      );

  Widget _buildHouseholdInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Basic Information'),
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
        const SizedBox(height: 12),
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
        const SizedBox(height: 12),

        // ────── CENSUS YEAR FIELD ──────
        TextFormField(
          controller: _censusYearController,
          readOnly: true,
          decoration: InputDecoration(
            labelText: 'Census Year *',
            border: const OutlineInputBorder(),
            suffixIcon: const Icon(Icons.calendar_today, color: Colors.purple),
          ),
          onTap: _pickCensusYear,
          validator: (v) => _censusYear == null ? 'Required' : null,
        ),
      ],
    );
  }

  Widget _buildFamilyMembers() {
    return _dynamicList(
      title: 'Family Members',
      addAction: () => _addFamilyMemberDialog(),
      list: _familyMembers,
      itemBuilder: (m, i) => Card(
  child: ListTile(
    title: Text(m['name']),
    subtitle: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Age: ${m['age']} | ${m['gender']} | ${m['relationship']}'),
        if (m['education_status'] != null)
          Text(
            'Education: ${m['education_status']}'
            '${m['education_status'] == 'Undergraduate' ? ' - ${m['year_level']} ${m['course']}' : ''}'
            '${m['education_status'] == 'Graduate' ? ' - ${m['employment_status']}' : ''}',
            style: const TextStyle(fontSize: 12, color: Colors.blueGrey),
          ),
        const SizedBox(height: 8),
        m['philsys_image'] == null
            ? _buildUploadButton(i)
            : _buildMemberImagePreview(m['philsys_image'], i),
      ],
    ),
    trailing: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(icon: const Icon(Icons.edit, color: Colors.orange), onPressed: () => _addFamilyMemberDialog(existingMember: m, index: i)),
        IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _deleteItem(_familyMembers, i)),
      ],
    ),
  ),
),
    );
  }

  Widget _buildUploadButton(int index) {
    return SizedBox(
      width: 120,
      child: ElevatedButton.icon(
        onPressed: () => _pickImageForMember(index),
        icon: const Icon(Icons.add_photo_alternate_outlined, size: 16),
        label: const Text('PhilSys ID', style: TextStyle(fontSize: 12)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.purple.shade100,
          foregroundColor: Colors.purple.shade700,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        ),
      ),
    );
  }

  Widget _buildMemberImagePreview(Uint8List bytes, int index) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.memory(bytes, width: 60, height: 60, fit: BoxFit.cover),
        ),
        const SizedBox(width: 8),
        Column(
          children: [
            TextButton.icon(
              onPressed: () => _pickImageForMember(index),
              icon: const Icon(Icons.edit, size: 14, color: Colors.orange),
              label: const Text('Change', style: TextStyle(fontSize: 12)),
            ),
            TextButton.icon(
              onPressed: () => _removeImageForMember(index),
              icon: const Icon(Icons.delete, size: 14, color: Colors.red),
              label: const Text('Remove', style: TextStyle(fontSize: 12)),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEconomicData() {
    return _dynamicList(
      title: 'Economic Data',
      addAction: () => _addEconomicDataDialog(),
      list: _economicData,
      itemBuilder: (d, i) => ListTile(
        title: Text(d['memberName']),
        subtitle: Text('Occupation: ${d['occupation']} | Income: ₱${d['income']} | Employer: ${d['employer']}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
                icon: const Icon(Icons.edit, color: Colors.orange),
                onPressed: () => _addEconomicDataDialog(existingData: d, index: i)),
            IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _deleteItem(_economicData, i)),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Address Information'),
        _textField(_streetController, 'Street / Purok'),
        _textField(_barangayController, 'Barangay'),
        _textField(_cityController, 'City / Municipality'),
        _textField(_provinceController, 'Province'),
        _textField(_zipController, 'ZIP Code'),
      ],
    );
  }

  Widget _dynamicList({
    required String title,
    required VoidCallback addAction,
    required List list,
    required Widget Function(dynamic, int) itemBuilder,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ElevatedButton.icon(onPressed: addAction, icon: const Icon(Icons.add), label: const Text('Add')),
          ],
        ),
        const SizedBox(height: 12),
        if (list.isEmpty)
          const Text('No data added yet.', style: TextStyle(color: Colors.grey)),
        if (list.isNotEmpty)
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: list.length,
            itemBuilder: (_, i) => itemBuilder(list[i], i),
          ),
      ],
    );
  }

  Widget _textField(TextEditingController ctrl, String label) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: TextFormField(
          controller: ctrl,
          decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Household Census')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHouseholdInfo(),
                const SizedBox(height: 24),
                _buildFamilyMembers(),
                const SizedBox(height: 24),
                _buildEconomicData(),
                const SizedBox(height: 24),
                _buildAddressSection(),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Save Household', style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}