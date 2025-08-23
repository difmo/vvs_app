import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vvs_app/theme/app_colors.dart';
import 'package:vvs_app/widgets/ui_components.dart';

class ProductPostScreen extends StatefulWidget {
  final Map<String, dynamic> existingData;
  final String docId;

  const ProductPostScreen({super.key, required this.existingData, required this.docId});

  @override
  State<ProductPostScreen> createState() => _ProductPostScreenState();
}

class _ProductPostScreenState extends State<ProductPostScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String _imageUrl = 'https://fiverr-res.cloudinary.com/images/t_main1,q_auto,f_auto,q_auto,f_auto/gigs/263409119/original/1b41a9535ca0dd1e44c6c90ecd4606bdeb5cfa8f/do-amazon-infographics-and-product-photography-editing.jpg';
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    if (widget.docId.isNotEmpty && widget.existingData.isNotEmpty) {
      _nameController.text = widget.existingData['name'] ?? '';
      _priceController.text = widget.existingData['price']?.toString() ?? '';
      _descriptionController.text = widget.existingData['description'] ?? '';
      _imageUrl = widget.existingData['imageUrl'] ?? '';
    }
  }

  Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    setState(() => _loading = true);
    final file = File(picked.path);
    final fileName = DateTime.now().millisecondsSinceEpoch.toString();

    try {
      final ref = FirebaseStorage.instance.ref().child('product_images/$fileName.jpg');
      await ref.putFile(file);
      final downloadUrl = await ref.getDownloadURL();

      setState(() {
        _imageUrl = downloadUrl;
      });
    } catch (e) {
       setState(() => _loading = false);
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Image upload failed: $e')),
      // );
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_imageUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload an image')),
      );
      return;
    }

    setState(() => _loading = true);

    final product = {
      'name': _nameController.text.trim(),
      'price': double.tryParse(_priceController.text.trim()) ?? 0,
      'description': _descriptionController.text.trim(),
      'imageUrl': _imageUrl,
      'createdAt': FieldValue.serverTimestamp(),
    };

    final collection = FirebaseFirestore.instance.collection('marketplace');

    try {
      if (widget.docId.isEmpty) {
        await collection.add(product);
      } else {
        await collection.doc(widget.docId).update(product);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(widget.docId.isEmpty ? 'Product added!' : 'Product updated!')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.docId.isEmpty ? 'Add New Product' : 'Edit Product';

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              AppTitle(title),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: _pickAndUploadImage,
                child: _imageUrl.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          _imageUrl,
                          height: 160,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Container(
                        height: 160,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey),
                          color: Colors.grey[100],
                        ),
                        alignment: Alignment.center,
                        child: const Text('Tap to upload image'),
                      ),
              ),
              const SizedBox(height: 16),
              AppInput(
                controller: _nameController,
                label: 'Product Name',
                validator: (v) =>
                    v == null || v.isEmpty ? 'Please enter product name' : null,
              ),
              const SizedBox(height: 12),
              AppInput(
                controller: _priceController,
                label: 'Price',
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Please enter price';
                  if (double.tryParse(v) == null) return 'Enter valid number';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              AppInput(
                controller: _descriptionController,
                label: 'Description',
                validator: (v) =>
                    v == null || v.isEmpty ? 'Please enter description' : null,
              ),
              const SizedBox(height: 24),
              _loading
                  ? const CircularProgressIndicator()
                  : AppButton(text: 'Submit', onPressed: _submit),
            ],
          ),
        ),
      ),
    );
  }
}
