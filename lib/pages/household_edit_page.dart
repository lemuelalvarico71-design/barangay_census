
import 'dart:io';
import 'dart:typed_data';
import 'package:barangay_census_app/models/household.dart';
import 'package:barangay_census_app/services/auth_service.dart';
import 'package:barangay_census_app/services/database_service.dart';
import 'package:camera/camera.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class HouseholdEditPage extends StatefulWidget {
  final Household household;
  const HouseholdEditPage({super.key, required this.household});

  @override
  State<HouseholdEditPage> createState() => _HouseholdEditPageState();
}

class _HouseholdEditPageState extends State<HouseholdEditPage> {
  late final Household _original = widget.household;

  final _formKey = GlobalKey<FormState>();

  // Camera
  List<CameraDescription>? _cameras;

  CameraController? _cameraController;
  bool _isCameraReady = false;
  Uint8List? _householdHeadPhotoBytes;

  // Controllers
  late final TextEditingController _householdNumberController;
  late final TextEditingController _headOfHouseholdController;
  late final TextEditingController _contactNumberController;
  late final TextEditingController _streetController;
  late final TextEditingController _barangayController;
  late final TextEditingController _cityController;
  late final TextEditingController _provinceController;
  late final TextEditingController _censusYearController;

  int? _censusYear;

  List<Map<String, dynamic>> _familyMembers = [];
  List<Map<String, dynamic>> _economicData = [];

  @override
  void initState() {
    super.initState();

    // Initialize controllers with existing data
    _householdNumberController = TextEditingController(text: _original.householdNumber);
    _headOfHouseholdController = TextEditingController(text: _original.headOfHousehold);
    _contactNumberController = TextEditingController(text: _original.contactNumber ?? '');
    _streetController = TextEditingController(text: _original.street ?? '');
    _barangayController = TextEditingController(text: _original.barangay ?? '');
    _cityController = TextEditingController(text: _original.city ?? '');
    _provinceController = TextEditingController(text: _original.province ?? '');
    _censusYear = _original.censusYear;
    _censusYearController = TextEditingController(text: _original.censusYear.toString());

    // Load head photo
    _householdHeadPhotoBytes = _original.headPhoto;

    // Load family members
    _familyMembers = _original.familyMembers.map((m) => {
      'name': m.name,
      'age': m.age,
      'gender': m.gender,
      'relationship': m.relationship,
      'philsys_image': m.philsysImage,
      'education_status': m.educationStatus,
      'year_level': m.yearLevel,
      'course': m.course,
      'employment_status': m.employmentStatus,
    }).toList();

    // Load economic data
    _economicData = _original.economicData.map((e) => {
      'memberName': e.memberName,
      'occupation': e.occupation,
      'income': e.monthlyIncome,
      'employer': e.employer,
    }).toList();
  }

  @override
  void dispose() {
    _householdNumberController.dispose();
    _headOfHouseholdController.dispose();
    _contactNumberController.dispose();
    _streetController.dispose();
    _barangayController.dispose();
    _cityController.dispose();
    _provinceController.dispose();
    _censusYearController.dispose();
    _cameraController?.dispose();
    super.dispose();
  }

  // ────── CAMERA & PHOTO (Same as Add Page) ──────
  Future<void> _takeHeadPhoto() async {
    if (_isCameraReady && _cameraController != null) {
      _showCameraPreview();
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Initializing camera...')));

    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No camera found')));
        return;
      }

      _cameraController = CameraController(cameras[0], ResolutionPreset.high, enableAudio: false);
      await _cameraController!.initialize();
      if (!mounted) return;
      setState(() => _isCameraReady = true);
      _showCameraPreview();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Camera error: $e')));
    }
  }

  void _showCameraPreview() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => WillPopScope(
        onWillPop: () async {
          await _cameraController?.dispose();
          _cameraController = null;
          setState(() => _isCameraReady = false);
          return true;
        },
        child: AlertDialog(
          title: const Text('Update Head Photo'),
          content: SizedBox(
            width: 400,
            height: 400,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: CameraPreview(_cameraController!),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                await _cameraController?.dispose();
                _cameraController = null;
                setState(() => _isCameraReady = false);
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.camera),
              label: const Text('Capture'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () async {
                try {
                  final xFile = await _cameraController!.takePicture();
                  final bytes = await xFile.readAsBytes();
                  setState(() => _householdHeadPhotoBytes = bytes);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Photo updated!')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed: $e')));
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickCensusYear() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(_censusYear ?? DateTime.now().year),
      firstDate: DateTime(2000),
      lastDate: DateTime(DateTime.now().year + 5),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(colorScheme: const ColorScheme.light(primary: Colors.purple)),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        _censusYear = picked.year;
        _censusYearController.text = picked.year.toString();
      });
    }
  }

  // ────── SAVE UPDATE ──────
  Future<void> _updateHousehold() async {
    if (!_formKey.currentState!.validate() || _censusYear == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    final updatedHousehold = Household(
      id: _original.id,
      householdNumber: _householdNumberController.text.trim(),
      headOfHousehold: _headOfHouseholdController.text.trim(),
      totalMembers: _familyMembers.length + 1, // Head + members
      contactNumber: _contactNumberController.text.isEmpty ? null : _contactNumberController.text.trim(),
      street: _streetController.text.isEmpty ? null : _streetController.text.trim(),
      barangay: _barangayController.text.isEmpty ? null : _barangayController.text.trim(),
      city: _cityController.text.isEmpty ? null : _cityController.text.trim(),
      province: _provinceController.text.isEmpty ? null : _provinceController.text.trim(),
      censusYear: _censusYear!,
      headPhoto: _householdHeadPhotoBytes,
      familyMembers: _familyMembers.map((m) => FamilyMember(
        name: m['name'],
        age: m['age'],
        gender: m['gender'],
        relationship: m['relationship'],
        philsysImage: m['philsys_image'],
        educationStatus: m['education_status'],
        yearLevel: m['year_level'],
        course: m['course'],
        employmentStatus: m['employment_status'],
      )).toList(),
      economicData: _economicData.map((e) => EconomicEntry(
        memberName: e['memberName'],
        occupation: e['occupation'],
        monthlyIncome: e['income'],
        employer: e['employer'],
      )).toList(),
    );

    try {
      await DatabaseService.instance.updateHousehold(updatedHousehold); // You need this method
      final user = AuthService.getCurrentUser();
      await DatabaseService.instance.logActivity(
        action: 'Update Household',
        fullname: user?['fullname'] ?? 'Unknown',
        role: user?['role'] ?? 'Unknown',
        userId: user?['id'],
        description: 'Updated household: ${updatedHousehold.householdNumber}',
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Household updated successfully!'), backgroundColor: Colors.green),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Update failed: $e')));
    }
  }

  // Reuse all your dialog & UI methods from HouseholdPage
  // Paste these exactly from your HouseholdPage.dart:
  void _addFamilyMemberDialog({Map<String, dynamic>? existingMember, int? index}) { /* SAME AS ADD PAGE */ }
  void _addEconomicDataDialog({Map<String, dynamic>? existingData, int? index}) { /* SAME */ }
   Widget _buildUploadArea(VoidCallback onPick) {
    return DragTarget<File>(
      onAccept: (file) async {
        final bytes = await file?.readAsBytes();
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
                    color:
                        isDragging
                            ? Colors.purple.shade700
                            : Colors.purple.shade600,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Upload PhilSys ID',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color:
                          isDragging
                              ? Colors.purple.shade700
                              : Colors.purple.shade700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Click or drag image here',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.purple.shade400,
                    ),
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

   Widget _buildHouseholdInfo() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Basic Information'),
      Row(
        children: [
          SizedBox(
            
              height: 110,
             
            child: Row(
              children: [
          // ────── HEAD OF HOUSEHOLD PHOTO PREVIEW WITH ICONS ──────
          Stack(
            children: [
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400, width: 1.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _householdHeadPhotoBytes != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(7),
                        child: Image.memory(
                          _householdHeadPhotoBytes!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      )
                    : Center(
                      child: 
                          Icon(Icons.person_outline, size: 45, color: Colors.grey),
                          
                      ),
              ),

    // ────── Floating Action Icons (Only when NO photo) ──────
    if (_householdHeadPhotoBytes == null) ...[
      // Camera Icon (bottom-left)
      Positioned(
  bottom: 6,
  right: 40,
  child: GestureDetector(
    onTap: () => _takeHeadPhoto(), // ← Remove the conditional!
    child: Container(
      padding: const EdgeInsets.all(6),
      decoration: const BoxDecoration(
        color: Colors.purple,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))
        ],
      ),
      child: const Icon(Icons.camera_alt, size: 15, color: Colors.white),
    ),
  ),
),

      // Upload Icon (Bottom-right)
      Positioned(
        bottom: 6,
        right: 6,
        child: GestureDetector(
          onTap: () async {
            final result = await FilePicker.platform.pickFiles(
              type: FileType.image,
              withData: true,
            );
            if (result != null && result.files.single.bytes != null) {
              setState(() {
                _householdHeadPhotoBytes = result.files.single.bytes!;
              });
            }
          },
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))
              ],
            ),
            child: const Icon(Icons.upload, size: 15, color: Colors.white),
          ),
        ),
      ),
    ]

    // ────── Small Edit/Remove Icons (Only when photo EXISTS) ──────
    else ...[
      Positioned(
        top: 4,
        right: 4,
        child: Row(
          children: [
            // Retake (Camera)
           GestureDetector(
  onTap: () => _takeHeadPhoto(), // ← Remove conditional here too!
  child: Container(
    padding: const EdgeInsets.all(4),
    decoration: const BoxDecoration(
      color: Colors.white,
      shape: BoxShape.circle,
      boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 3)],
    ),
    child: const Icon(Icons.camera_alt, size: 16, color: Colors.purple),
  ),
),
            const SizedBox(width: 4),
            // Remove
            GestureDetector(
              onTap: () => setState(() => _householdHeadPhotoBytes = null),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 3)],
                ),
                child: const Icon(Icons.close, size: 16, color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    ],
  ],
),
            
        ],
              
            ), 
        
            ),
           

          SizedBox(width: 10,), 
          Expanded(
            child: Container(
               width: double.infinity,
                
              decoration: BoxDecoration(
                //color: Colors.green, 
              ),
            
              child: Column(
                children: [
              TextFormField(
              controller: _householdNumberController,
              decoration: const InputDecoration(
                labelText: 'Household Number *',
                border: OutlineInputBorder(),
              ),
              validator: (v) => v!.isEmpty ? 'Required' : null,
            ),
SizedBox(height: 10,),

 TextFormField(
              controller: _headOfHouseholdController,
              decoration: const InputDecoration(
                labelText: 'Head of Household *',
                border: OutlineInputBorder(),
              ),
              validator: (v) => v!.isEmpty ? 'Required' : null,
            ),





                ],


              ),
            
            ),
          ), 

          SizedBox(width: 10,), 
          Expanded(
            child: Container(
               width: double.infinity,
               
              decoration: BoxDecoration(
                //color: Colors.yellow, 
              ),
              child: Column(
                children: [
TextFormField(
              controller: _contactNumberController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Contact Number',
                border: OutlineInputBorder(),
              ),
            ),
SizedBox(height: 10,), 
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
              ),
            
            
            ),
          ), 

          SizedBox(width: 10,)

        ],
      ), 
    
      
    ],
  );
}

  Widget _buildFamilyMembers() {
    return _dynamicList(
      title: 'Family Members',
      addAction: () => _addFamilyMemberDialog(),
      list: _familyMembers,
      itemBuilder:
          (m, i) => Card(
            child: ListTile(
              title: Text(m['name']),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Age: ${m['age']} | ${m['gender']} | ${m['relationship']}',
                  ),
                  if (m['education_status'] != null)
                    Text(
                      'Education: ${m['education_status']}'
                      '${m['education_status'] == 'Undergraduate' ? ' - ${m['year_level']} ${m['course']}' : ''}'
                      '${m['education_status'] == 'Graduate' ? ' - ${m['employment_status']}' : ''}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.blueGrey,
                      ),
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
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.orange),
                    onPressed:
                        () =>
                            _addFamilyMemberDialog(existingMember: m, index: i),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteItem(_familyMembers, i),
                  ),
                ],
              ),
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

  void _removeImageForMember(int index) {
    setState(() {
      _familyMembers[index]['philsys_image'] = null;
    });
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
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ElevatedButton.icon(
              onPressed: addAction,
              icon: const Icon(Icons.add),
              label: const Text('Add'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (list.isEmpty)
          const Text(
            'No data added yet.',
            style: TextStyle(color: Colors.grey),
          ),
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


    Widget _buildEconomicData() {
    return _dynamicList(
      title: 'Economic Data',
      addAction: () => _addEconomicDataDialog(),
      list: _economicData,
      itemBuilder:
          (d, i) => ListTile(
            title: Text(d['memberName']),
            subtitle: Text(
              'Occupation: ${d['occupation']} | Income: ₱${d['income']} | Employer: ${d['employer']}',
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.orange),
                  onPressed:
                      () => _addEconomicDataDialog(existingData: d, index: i),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteItem(_economicData, i),
                ),
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
      ],
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


  void _deleteItem(List list, int index) =>
      setState(() => list.removeAt(index));

  // ────── Section Builders ──────
  Widget _sectionTitle(String title) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
  );

  Widget _textField(TextEditingController ctrl, String label) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: TextFormField(
      controller: ctrl,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Household #${_original.householdNumber}'),
        backgroundColor: Colors.white,
      ),
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
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _updateHousehold,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                  ),
                  child: const Text('Update Household', style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}