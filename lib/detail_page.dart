// lib/pages/detail_page.dart (or lib/detail_page.dart)

import 'dart:io'; // Import File
import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  final Map<String, dynamic> resultData;

  const DetailPage({
    Key? key,
    required this.resultData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Safely extract data, expecting 'image' to be a File
    final File? image = resultData['image'] as File?;
    final String result = resultData['result'] as String? ?? 'N/A';
    final double probability = resultData['probability'] as double? ?? 0.0;
    final String dateTime = resultData['dateTime'] as String? ?? 'N/A';
    final String vitamins = resultData['vitamins'] as String? ?? 'N/A';
    final String shelfLife = resultData['shelfLife'] as String? ?? 'N/A';
    final String generalInfo =
        resultData['generalInfo'] as String? ?? 'No additional information.';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail View'),
        backgroundColor: Colors.green[700],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), // Back arrow icon
          onPressed: () {
            Navigator.pop(context); // Pops the current route off the stack
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (image != null && image.existsSync())
              Container(
                height: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  image: DecorationImage(
                    image: FileImage(image),
                    fit: BoxFit.cover,
                  ),
                ),
              )
            else // Placeholder if image is null or doesn't exist
              Container(
                height: 250,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: const Center(
                  child:
                      Icon(Icons.broken_image, size: 100, color: Colors.grey),
                ),
              ),
            const SizedBox(height: 20),
            _buildInfoRow('Detected:', result),
            _buildInfoRow(
                'Confidence:', '${(probability * 100).toStringAsFixed(2)}%'),
            _buildInfoRow('Scanned On:', dateTime),
            _buildInfoRow('Key Vitamins:', vitamins),
            _buildInfoRow('Typical Shelf Life:', shelfLife),
            const SizedBox(height: 20),
            const Text(
              'General Information:',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
            ),
            const SizedBox(height: 8),
            Text(
              generalInfo,
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build a consistent info row
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label ',
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }
}
