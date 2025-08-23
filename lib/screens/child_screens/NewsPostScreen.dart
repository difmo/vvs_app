import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vvs_app/theme/app_colors.dart';
import 'package:vvs_app/widgets/ui_components.dart';

class NewsPostScreen extends StatefulWidget {
  const NewsPostScreen({super.key, required Map<String, dynamic> existingData, required String docId});

  @override
  State<NewsPostScreen> createState() => _NewsPostScreenState();
}

class _NewsPostScreenState extends State<NewsPostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleC = TextEditingController();
  final _contentC = TextEditingController();
  bool _loading = false;
  File? _imageFile;

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (picked != null) {
      setState(() => _imageFile = File(picked.path));
    }
  }

  Future<String?> _uploadImage() async {
    return "https://media.istockphoto.com/id/1673064753/vector/breaking-news-world-map-background.webp?s=2048x2048&w=is&k=20&c=CekEVwLcYO46upoi3bvfN2VDZv0Imf9cxcRLiOwK4fE=";
    // if (_imageFile == null) return null;
    // try {
    //   final fileName = 'news_images/${DateTime.now().millisecondsSinceEpoch}.jpg';
    //   final ref = FirebaseStorage.instance.ref().child(fileName);
    //   final uploadTask = await ref.putFile(_imageFile!);
    //   return await uploadTask.ref.getDownloadURL();
    // } catch (e) {
    //   debugPrint('Upload failed: $e');
    //   return null;
    // }
  }

  Future<void> _saveNews() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    final imageUrl = await _uploadImage();

    await FirebaseFirestore.instance.collection('news').add({
      'title': _titleC.text.trim(),
      'content': _contentC.text.trim(),
      'imageUrl': imageUrl,
      'timestamp': FieldValue.serverTimestamp(),
    });

    setState(() => _loading = false);
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('News posted!')));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Post News')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              if (_imageFile != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    _imageFile!,
                    height: 180,
                    fit: BoxFit.cover,
                  ),
                ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.image),
                label: const Text('Add Image'),
              ),
              const SizedBox(height: 16),
              AppInput(
                controller: _titleC,
                label: 'Title',
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              AppInput(
                controller: _contentC,
                label: 'Content',
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 24),
              _loading
                  ? const CircularProgressIndicator()
                  : AppButton(text: 'POST NEWS', onPressed: _saveNews),
            ],
          ),
        ),
      ),
    );
  }
}
