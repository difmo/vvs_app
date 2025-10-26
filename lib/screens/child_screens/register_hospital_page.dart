import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class RegisterHospitalPage extends StatefulWidget {
  const RegisterHospitalPage({super.key});

  @override
  State<RegisterHospitalPage> createState() => _RegisterHospitalPageState();
}

class _RegisterHospitalPageState extends State<RegisterHospitalPage> {
  final _formKey = GlobalKey<FormState>();

  // Step 1 Controllers
  final TextEditingController orgNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController districtController = TextEditingController();
  final TextEditingController websiteController = TextEditingController();
  final TextEditingController opdController = TextEditingController();
  final TextEditingController doctorsController = TextEditingController();

  // Step 2 Controllers
  final TextEditingController officerNameController = TextEditingController();
  final TextEditingController designationController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();
  final TextEditingController landlineNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController headOfOrgController = TextEditingController();

  // Image Controller
  final TextEditingController fileNameController =
  TextEditingController(text: 'No file chosen');

  // State Variables
  String orgType = 'Hospital';
  String governmentType = 'Select Government Type';
  bool hmisRegistered = false;

  // Picked Image
  XFile? _pickedImageWeb;
  File? _pickedImageMobile;

  // Colors
  final Color _focusColor = const Color(0xFF42A5F5);

  @override
  void dispose() {
    orgNameController.dispose();
    addressController.dispose();
    stateController.dispose();
    districtController.dispose();
    websiteController.dispose();
    opdController.dispose();
    doctorsController.dispose();
    officerNameController.dispose();
    designationController.dispose();
    mobileNumberController.dispose();
    landlineNumberController.dispose();
    emailController.dispose();
    headOfOrgController.dispose();
    fileNameController.dispose();
    super.dispose();
  }

  // ----------------- Image Picker -----------------
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
    await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        if (kIsWeb) {
          _pickedImageWeb = pickedFile;
          _pickedImageMobile = null;
        } else {
          _pickedImageMobile = File(pickedFile.path);
          _pickedImageWeb = null;
        }
        fileNameController.text = 'Image Selected';
      });
    }
  }

  // ----------------- Upload Image -----------------
  Future<String?> _uploadImage() async {
    try {
      final fileName = 'hospitals/${DateTime.now().millisecondsSinceEpoch}.jpg';
      final storageRef = FirebaseStorage.instance.ref().child(fileName);

      if (kIsWeb && _pickedImageWeb != null) {
        final bytes = await _pickedImageWeb!.readAsBytes();
        await storageRef.putData(bytes);
      } else if (_pickedImageMobile != null) {
        await storageRef.putFile(_pickedImageMobile!);
      } else {
        return null;
      }

      return await storageRef.getDownloadURL();
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }

  // ----------------- Submit Form -----------------
  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    String? imageUrl = await _uploadImage();

    final hospitalData = {
      'orgName': orgNameController.text.trim(),
      'address': addressController.text.trim(),
      'state': stateController.text.trim(),
      'district': districtController.text.trim(),
      'website': websiteController.text.trim(),
      'opd': opdController.text.trim(),
      'doctors': doctorsController.text.trim(),
      'orgType': orgType,
      'governmentType': governmentType,
      'hmisRegistered': hmisRegistered,
      'officerName': officerNameController.text.trim(),
      'designation': designationController.text.trim(),
      'mobile': mobileNumberController.text.trim(),
      'landline': landlineNumberController.text.trim(),
      'email': emailController.text.trim(),
      'headOfOrg': headOfOrgController.text.trim(),
      'imageUrl': imageUrl,
      'createdAt': FieldValue.serverTimestamp(),
    };

    try {
      await FirebaseFirestore.instance
          .collection('hospitals')
          .add(hospitalData);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Hospital registered successfully!')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving data: $e')),
      );
    }
  }

  // ----------------- UI -----------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Hospital Registration")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Two quick steps to list your health resources',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),

              _buildTextFieldWithLabel('Organization Name*', orgNameController),
              _buildTextFieldWithLabel('Address*', addressController),
              _buildTextFieldWithLabel('State*', stateController),
              _buildTextFieldWithLabel('District*', districtController),
              _buildTextFieldWithLabel('Website', websiteController, isRequired: false),

              const SizedBox(height: 10),
              _buildLabel('Organization Type'),
              _buildDropdown(
                  value: orgType,
                  items: const ['Hospital', 'Clinic', 'Medical Store', 'Laboratory', 'Others'],
                  onChanged: (val) => setState(() => orgType = val!)),

              const SizedBox(height: 16),
              _buildLabel('Government'),
              _buildDropdown(
                  value: governmentType,
                  items: const ['Select Government Type', 'Central', 'State', 'Municipal'],
                  onChanged: (val) => setState(() => governmentType = val!)),

              const SizedBox(height: 16),
              const Text('HMIS Registered', style: TextStyle(fontWeight: FontWeight.w500)),
              _buildHmisRadioRow(),

              _buildTextFieldWithLabel('Average OPD per Day', opdController, isRequired: false, inputType: TextInputType.number),
              _buildTextFieldWithLabel('Number of Doctors', doctorsController, isRequired: false, inputType: TextInputType.number),

              const Divider(thickness: 1.5),
              const SizedBox(height: 10),
              const Text("Officer Details", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              _buildTextFieldWithLabel('Officer\'s Name*', officerNameController),
              _buildTextFieldWithLabel('Designation*', designationController),
              _buildTextFieldWithLabel('Mobile Number*', mobileNumberController, inputType: TextInputType.phone),
              _buildTextFieldWithLabel('Landline Number', landlineNumberController, isRequired: false, inputType: TextInputType.phone),
              _buildTextFieldWithLabel('Email*', emailController, inputType: TextInputType.emailAddress),
              _buildTextFieldWithLabel('Head of Organization*', headOfOrgController),

              const SizedBox(height: 20),
              const Text('Upload Image'),
              const SizedBox(height: 5),
              ElevatedButton(
                onPressed: _pickImage,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[200], elevation: 0),
                child: const Text('Choose File', style: TextStyle(color: Colors.black)),
              ),
              const SizedBox(height: 10),
              if (_pickedImageMobile != null)
                Image.file(_pickedImageMobile!, height: 150, width: 150, fit: BoxFit.cover)
              else if (_pickedImageWeb != null)
                FutureBuilder(
                  future: _pickedImageWeb!.readAsBytes(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                      return Image.memory(snapshot.data!, height: 150, width: 150, fit: BoxFit.cover);
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
              Text(fileNameController.text, style: const TextStyle(color: Colors.green)),
              const SizedBox(height: 30),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        _formKey.currentState?.reset();
                        setState(() {
                          _pickedImageMobile = null;
                          _pickedImageWeb = null;
                          fileNameController.text = 'No file chosen';
                        });
                      },
                      child: const Text('Reset'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF6F00),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Submit'),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  // ----------------- Reusable Widgets -----------------
  Widget _buildLabel(String label) =>
      Text(label, style: const TextStyle(fontWeight: FontWeight.bold));

  Widget _buildTextField(TextEditingController controller,
      {TextInputType inputType = TextInputType.text, bool isRequired = true}) {
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      validator: (value) {
        if (isRequired && (value == null || value.isEmpty)) return 'This field is required';
        return null;
      },
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: _focusColor, width: 1.5)),
        isDense: true,
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
    );
  }

  Widget _buildTextFieldWithLabel(String label, TextEditingController controller,
      {bool isRequired = true, TextInputType inputType = TextInputType.text}) {
    return Builder(builder: (context) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel(label),
          FormField(
            validator: (v) {
              if (isRequired && (controller.text.isEmpty))
                return 'This field is required';
              return null;
            },
            builder: (fieldState) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (fieldState.hasError)
                    Padding(
                      padding: const EdgeInsets.only(top: 2, bottom: 2),
                      child: Text(fieldState.errorText!,
                          style: const TextStyle(
                              color: Colors.red, fontSize: 12)),
                    ),
                  _buildTextField(controller,
                      inputType: inputType, isRequired: isRequired),
                ],
              );
            },
          ),
          const SizedBox(height: 10),
        ],
      );
    });
  }

  Widget _buildDropdown(
      {required String value,
        required List<String> items,
        required ValueChanged<String?> onChanged}) {
    return DropdownButtonFormField<String>(
      value: value,
      items:
      items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChanged,
      decoration: const InputDecoration(border: OutlineInputBorder()),
    );
  }

  Widget _buildHmisRadioRow() {
    return Row(
      children: [
        Row(
          children: [
            Radio<bool>(
                value: true,
                groupValue: hmisRegistered,
                onChanged: (val) => setState(() => hmisRegistered = val!)),
            const Text('Yes')
          ],
        ),
        const SizedBox(width: 16),
        Row(
          children: [
            Radio<bool>(
                value: false,
                groupValue: hmisRegistered,
                onChanged: (val) => setState(() => hmisRegistered = val!)),
            const Text('No')
          ],
        ),
      ],
    );
  }
}
