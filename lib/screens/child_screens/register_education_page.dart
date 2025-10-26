import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterEducationPage extends StatefulWidget {
  const RegisterEducationPage({super.key});

  @override
  State<RegisterEducationPage> createState() => _RegisterEducationPageState();
}

class _RegisterEducationPageState extends State<RegisterEducationPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController orgNameController = TextEditingController();
  final TextEditingController orgTypeController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController websiteController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController fileNameController =
  TextEditingController(text: 'No file chosen');

  // Image
  File? _pickedImageMobile;
  Uint8List? _pickedImageWeb;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  final Color _focusColor = const Color(0xFF42A5F5);
  final Color _vvsGold = const Color(0xFFFF6F00);

  bool _isLoading = false;

  @override
  void dispose() {
    orgNameController.dispose();
    orgTypeController.dispose();
    addressController.dispose();
    contactController.dispose();
    websiteController.dispose();
    descriptionController.dispose();
    fileNameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    if (_isLoading) return;
    final picker = ImagePicker();
    final XFile? pickedFile =
    await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);

    if (pickedFile != null) {
      if (kIsWeb) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _pickedImageWeb = bytes;
          _pickedImageMobile = null;
          fileNameController.text = 'Image Selected';
        });
      } else {
        setState(() {
          _pickedImageMobile = File(pickedFile.path);
          _pickedImageWeb = null;
          fileNameController.text = 'Image Selected';
        });
      }
    }
  }

  Future<String?> _uploadImage() async {
    try {
      final fileName =
          'education_images/${DateTime.now().millisecondsSinceEpoch}.jpg';
      final ref = _storage.ref().child(fileName);

      if (kIsWeb && _pickedImageWeb != null) {
        await ref.putData(_pickedImageWeb!);
      } else if (_pickedImageMobile != null) {
        await ref.putFile(_pickedImageMobile!);
      } else {
        return null;
      }

      return await ref.getDownloadURL();
    } catch (e) {
      debugPrint('Error uploading image: $e');
      return null;
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      String? imageUrl = await _uploadImage();

      final educationData = {
        'orgName': orgNameController.text.trim(),
        'orgType': orgTypeController.text.trim(),
        'address': addressController.text.trim(),
        'contact': contactController.text.trim(),
        'website': websiteController.text.trim(),
        'description': descriptionController.text.trim(),
        'imageUrl': imageUrl ?? '',
        'createdAt': DateTime.now(),
      };

      await _firestore.collection('educational_organisations').add(educationData);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Organisation registered successfully!')),
      );
      Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving data: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ------------------ Reusable Widgets ------------------

  Widget _buildLabel(String label) =>
      Text(label, style: const TextStyle(fontWeight: FontWeight.bold));

  Widget _buildTextField(TextEditingController controller,
      {TextInputType inputType = TextInputType.text, bool isRequired = true}) {
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      enabled: !_isLoading,
      validator: (value) {
        if (isRequired && (value == null || value.isEmpty)) {
          return 'This field is required';
        }
        return null;
      },
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: _focusColor, width: 1.5),
        ),
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
              if (isRequired && controller.text.isEmpty) {
                return 'This field is required';
              }
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

  // ------------------ UI ------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Educational Organisation Registration")),
      body: AbsorbPointer(
        absorbing: _isLoading,
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Provide your organisation details below',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20),

                    _buildTextFieldWithLabel('Organisation Name*', orgNameController),
                    _buildTextFieldWithLabel(
                        'Organisation Type (School/College/Coaching)*',
                        orgTypeController),
                    _buildTextFieldWithLabel('Address*', addressController),
                    _buildTextFieldWithLabel('Contact*', contactController,
                        inputType: TextInputType.phone),
                    _buildTextFieldWithLabel('Website', websiteController,
                        isRequired: false, inputType: TextInputType.url),
                    _buildTextFieldWithLabel('Description', descriptionController,
                        isRequired: false),

                    const SizedBox(height: 20),
                    const Text('Upload Image',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    ElevatedButton(
                      onPressed: _pickImage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[200],
                        elevation: 0,
                      ),
                      child: const Text('Choose File',
                          style: TextStyle(color: Colors.black)),
                    ),
                    const SizedBox(height: 10),

                    if (_pickedImageMobile != null)
                      Image.file(_pickedImageMobile!,
                          height: 150, width: 150, fit: BoxFit.cover)
                    else if (_pickedImageWeb != null)
                      Image.memory(_pickedImageWeb!,
                          height: 150, width: 150, fit: BoxFit.cover),

                    Text(fileNameController.text,
                        style: const TextStyle(color: Colors.green)),

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
                              backgroundColor: _vvsGold,
                              foregroundColor: Colors.white,
                            ),
                            child: _isLoading
                                ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                                : const Text('Submit'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
            if (_isLoading)
              Container(
                color: Colors.black.withOpacity(0.2),
              ),
          ],
        ),
      ),
    );
  }
}
