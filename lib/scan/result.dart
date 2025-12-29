import 'dart:io';
import 'package:flutter/material.dart';
// 🔥 REQUIRED: Import your localization class
import '../home/app_localizations.dart';

class ResultPage extends StatelessWidget {
  final File image;
  final String result;
  final dynamic probability;
  final String dateTime;
  final String vitamins;
  final String shelfLife;
  final String generalInfo;

  const ResultPage({
    Key? key,
    required this.image,
    required this.result,
    required this.probability,
    required this.dateTime,
    required this.vitamins,
    required this.shelfLife,
    required this.generalInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 🔥 Get localizations instance
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        // 🔥 LOCALIZED FIX
        title: Text(
          localizations.translate('scanResultDetailsTitle'),
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontFamily: 'SofiaSans',
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black54),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 3,
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: image.existsSync()
                      ? Image.file(image, fit: BoxFit.cover)
                      : const Center(
                          child: Icon(Icons.broken_image,
                              size: 100, color: Colors.grey),
                        ),
                ),
              ),
              const SizedBox(height: 40),
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 🔥 LOCALIZED FIX
                      Text(
                        localizations.translate('detectedLabel'),
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                          fontFamily: 'SofiaSans',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        result,
                        style: const TextStyle(
                          fontSize: 32,
                          fontFamily: 'SofiaSans',
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 60, 140, 60),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // 🔥 LOCALIZED FIX
                      Text(
                        localizations.translate('confidenceLabel'),
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                          fontFamily: 'SofiaSans',
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '${(probability * 1).toStringAsFixed(2).padLeft(5, '0')}%',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 10),
                      LinearProgressIndicator(
                        value:
                            probability / 100.0, // Scale 0-100% back to 0-1.0
                        backgroundColor: Colors.grey[300],
                        color: const Color.fromARGB(255, 90, 180, 90),
                        minHeight: 10,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      const SizedBox(height: 20),
                      Divider(
                          color: Colors.grey[300], thickness: 1, height: 30),
                      // 🔥 LOCALIZED FIX
                      _buildDetailRow(Icons.calendar_today,
                          localizations.translate('scannedOnLabel'), dateTime),
                      _buildDetailRow(
                          Icons.local_florist,
                          localizations.translate('keyVitaminsLabel'),
                          vitamins),
                      _buildDetailRow(Icons.hourglass_empty,
                          localizations.translate('shelfLifeLabel'), shelfLife),
                      const SizedBox(height: 20),
                      // 🔥 LOCALIZED FIX
                      Text(
                        localizations.translate('aboutProduceLabel'),
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                          fontFamily: 'SofiaSans',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        // Use a fallback localized string if generalInfo is the default one
                        generalInfo == "No additional information available."
                            ? localizations.translate('noInfoAvailable')
                            : generalInfo,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                          fontFamily: 'SofiaSans',
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  backgroundColor: Colors.grey[200],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                ),
                child: Text(
                  // 🔥 LOCALIZED FIX
                  localizations.translate('scanAnotherButton'),
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'SofiaSans',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.green[700], size: 24),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                    fontFamily: 'SofiaSans',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                    fontFamily: 'SofiaSans',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
