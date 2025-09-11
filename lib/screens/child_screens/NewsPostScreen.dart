import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vvs_app/theme/app_colors.dart';
import 'package:vvs_app/widgets/ui_components.dart';

class NewsPostScreen extends StatefulWidget {
  const NewsPostScreen({
    super.key,
    required Map<String, dynamic> existingData,
    required String docId,
  });

  @override
  State<NewsPostScreen> createState() => _NewsPostScreenState();
}

class _NewsPostScreenState extends State<NewsPostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleC = TextEditingController();
  final _contentC = TextEditingController();
  bool _loading = false;
  File? _imageFile;

  final List<Map<String, String>> _slidesNews = [
    {
      'title': 'Warm Welcome of Guests at Airport',
      'description':
          'Guests were given a grand welcome at the airport with garlands and smiles, marking the Silver Jubilee start.',
      'url': 'https://i.ibb.co/ymWRHVpy/1.jpg',
    },
    {
      'title': 'Honoring Dignitaries on Arrival',
      'description':
          'Dignitaries were honored with shawls and garlands, symbolizing respect and gratitude.',
      'url': 'https://i.ibb.co/j9hsRwwr/2.jpg',
    },
    {
      'title': 'Welcoming by Association Members',
      'description':
          'Association members personally greeted the guests, showing unity and warm hospitality.',
      'url': 'https://i.ibb.co/s90vvZ1j/3.jpg',
    },
    {
      'title': 'Celebrating 25 Glorious Years',
      'description':
          'The event celebrates 25 years of community bonding and cultural unity.',
      'url': 'https://i.ibb.co/7NYFGN2R/4.jpg',
    },
    {
      'title': 'Traditional Felicitation Ceremony',
      'description':
          'Guests were welcomed traditionally with shawls and flowers, showcasing Indian culture.',
      'url': 'https://i.ibb.co/kssRsL8g/5.jpg',
    },
    {
      'title': 'Krishna Janmashtami & Silver Jubilee',
      'description':
          'A dual celebration created a devotional and festive atmosphere full of joy.',
      'url': 'https://i.ibb.co/0RS8GHTk/6.jpg',
    },
    {
      'title': 'Marking a Legacy with Dignity',
      'description':
          'Leaders and members united in Hyderabad to honor the legacy of Shri Akroorji Welfare Association.',
      'url': 'https://i.ibb.co/Qv22PDMw/7.jpg',
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeNews();
  }

  Future<bool> _isNewsCollectionEmpty() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('news')
        .limit(1)
        .get();
    return snapshot.docs.isEmpty;
  }

  Future<void> _initializeNews() async {
    final isEmpty = await _isNewsCollectionEmpty();
    if (isEmpty) {
      await _addInitialNews(_slidesNews);
    }
  }

  Future<void> _addInitialNews(List<Map<String, String>> slides) async {
    final batch = FirebaseFirestore.instance.batch();
    final colRef = FirebaseFirestore.instance.collection('news');

    for (var news in slides) {
      final docRef = colRef.doc(); // auto-generated ID
      batch.set(docRef, {
        'newsId': docRef.id,
        'createdBy': FirebaseAuth.instance.currentUser?.uid ?? 'admin',
        'title': news['title'],
        'content': news['description'],
        'imageUrl': news['url'],
        'timestamp': FieldValue.serverTimestamp(),
      });
    }

    await batch.commit();
  }

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
    if (_imageFile == null) return null;
    try {
      final fileName =
          'news_images/${DateTime.now().millisecondsSinceEpoch}.jpg';
      final ref = FirebaseStorage.instance.ref().child(fileName);
      final uploadTask = await ref.putFile(_imageFile!);
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      debugPrint('Upload failed: $e');
      return null;
    }
  }

  Future<void> _saveNews() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    final imageUrl = await _uploadImage();
    final docRef = await FirebaseFirestore.instance.collection('news').add({
      'createdBy': FirebaseAuth.instance.currentUser?.uid ?? 'admin',
      'title': _titleC.text.trim(),
      'content': _contentC.text.trim(),
      'imageUrl': imageUrl,
      'timestamp': FieldValue.serverTimestamp(),
    });

    await docRef.update({'newsId': docRef.id});

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
