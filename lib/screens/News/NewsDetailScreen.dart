import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vvs_app/theme/app_colors.dart';

class NewsDetailScreen extends StatelessWidget {
  final Map<String, dynamic> newsData;

  const NewsDetailScreen({super.key, required this.newsData});

  @override
  Widget build(BuildContext context) {
    final title = newsData['title'] ?? '';
    final content = newsData['content'] ?? '';
    final imageUrl = newsData['imageUrl'] ?? '';
    final timestamp = newsData['timestamp'];
    String date = '';
    if (timestamp != null) {
      DateTime? dateTime;
      if (timestamp is String) {
        dateTime = DateTime.tryParse(timestamp);
      } else if (timestamp is DateTime) {
        dateTime = timestamp;
      } else if (timestamp is dynamic && timestamp.toDate != null) {
        dateTime = timestamp.toDate();
      }
      if (dateTime != null) {
        date = DateFormat('MMMM dd, yyyy').format(dateTime);
      }
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('News Details'),
        backgroundColor: AppColors.primary,
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imageUrl.isNotEmpty)
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => Dialog(
                      insetPadding: EdgeInsets.zero,
                      backgroundColor: Colors.transparent,
                      child: SizedBox.expand(
                        child: GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: InteractiveViewer(
                            panEnabled: true,
                            minScale: 1,
                            maxScale: 4,
                            child: Image.network(imageUrl, fit: BoxFit.contain),
                          ),
                        ),
                      ),
                    ),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    imageUrl,
                    width: double.infinity,
                    height: 220,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              date,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Text(content, style: const TextStyle(fontSize: 16, height: 1.6)),
          ],
        ),
      ),
    );
  }
}
