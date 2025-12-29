import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart'
    as http; // Import http package for network images

class MonitorPage extends StatefulWidget {
  final List<Map<String, dynamic>> reports;

  const MonitorPage({Key? key, required this.reports}) : super(key: key);

  @override
  _MonitorPageState createState() => _MonitorPageState();
}

class _MonitorPageState extends State<MonitorPage> {
  // Static list to hold saved results, mimicking DisplayPage's functionality
  static List<Map<String, dynamic>> savedResults = [];

  // Method to request storage permission
  Future<void> requestStoragePermission() async {
    if (await Permission.storage.request().isGranted) {
      // Permission is granted
      return;
    } else {
      // Permission is denied
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Storage permission is required to save the PDF.')),
      );
    }
  }

  Future<Uint8List?> _getImageData(String imagePath) async {
    if (imagePath.startsWith('http')) {
      // Load image from URL
      try {
        final response = await http.get(Uri.parse(imagePath));
        if (response.statusCode == 200) {
          return response.bodyBytes;
        }
      } catch (e) {
        print('Error fetching image from URL: $e');
      }
    } else {
      // Load image from file
      try {
        final file = File(imagePath);
        if (await file.exists()) {
          return await file.readAsBytes();
        }
      } catch (e) {
        print('Error reading image file: $e');
      }
    }
    return null; // Return null if image loading fails
  }

  Future<void> _deleteReport(BuildContext context, int index) async {
    try {
      String reportId = widget.reports[index]['reportId'];

      // Delete the report from Firestore
      await FirebaseFirestore.instance
          .collection('reports')
          .doc(reportId)
          .delete();

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Report deleted successfully')),
      );

      // Remove the report from the list and refresh the UI
      setState(() {
        widget.reports.removeAt(index);
      });
    } catch (e) {
      // Handle errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete report: $e')),
      );
    }
  }

  Future<void> _exportSingleReport(int index) async {
    await requestStoragePermission(); // Request permission before saving

    final pdf = pw.Document();
    final report = widget.reports[index];

    // Ensure the report has the required fields
    if (report['result'] != null &&
        report['probability'] != null &&
        report['dateTime'] != null &&
        report['userFullName'] != null) {
      // Get image data
      final imageData = await _getImageData(report['imagePath']);

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              if (imageData != null) // Add image if available
                pw.Image(pw.MemoryImage(imageData)),
              pw.Text('Result: ${report['result']}',
                  style: pw.TextStyle(fontSize: 20)),
              pw.Text(
                  'Probability: ${(report['probability'] * 100).toStringAsFixed(2)}%',
                  style: pw.TextStyle(fontSize: 16)),
              pw.Text('Date: ${report['dateTime']}',
                  style: pw.TextStyle(fontSize: 16)),
              pw.Text('User: ${report['userFullName']}',
                  style: pw.TextStyle(fontSize: 16)),
            ],
          ),
        ),
      );

      // Save the PDF
      final output =
          await getExternalStorageDirectory(); // Use external storage on a physical device
      final file =
          File("${output?.path}/report_${report['reportId'] ?? 'unknown'}.pdf");
      await file.writeAsBytes(await pdf.save());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('PDF saved to ${file.path}')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Report data is incomplete.')),
      );
    }
  }

  Future<void> _exportAllReports() async {
    final pdf = pw.Document();

    if (widget.reports.isNotEmpty) {
      for (var report in widget.reports) {
        // Ensure each report has the required fields
        if (report['result'] != null &&
            report['probability'] != null &&
            report['dateTime'] != null &&
            report['userFullName'] != null) {
          // Get image data
          final imageData = await _getImageData(report['imagePath']);

          pdf.addPage(
            pw.Page(
              build: (pw.Context context) => pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  if (imageData != null) // Add image if available
                    pw.Image(pw.MemoryImage(imageData)),
                  pw.Text('Result: ${report['result']}',
                      style: pw.TextStyle(fontSize: 20)),
                  pw.Text(
                      'Probability: ${(report['probability'] * 100).toStringAsFixed(2)}%',
                      style: pw.TextStyle(fontSize: 16)),
                  pw.Text('Date: ${report['dateTime']}',
                      style: pw.TextStyle(fontSize: 16)),
                  pw.Text('User: ${report['userFullName']}',
                      style: pw.TextStyle(fontSize: 16)),
                  pw.Divider(),
                ],
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('One or more reports have incomplete data.')),
          );
        }
      }

      // Save the PDF only if there are any pages added
      final output = await getExternalStorageDirectory();
      final file = File("${output?.path}/all_reports.pdf");
      await file.writeAsBytes(await pdf.save());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('All reports PDF saved to ${file.path}')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No reports available to export.')),
      );
    }
  }

  /// Displays the saved results in a new page.
  /// This function replicates the core functionality of the original DisplayPage.
  void _displaySavedResults(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('Saved Results'),
          ),
          body: _MonitorPageState.savedResults.isEmpty
              ? const Center(
                  child: Text(
                    'No saved results yet.',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : ListView.builder(
                  itemCount: _MonitorPageState.savedResults.length,
                  itemBuilder: (context, index) {
                    // Extract saved data
                    File image = _MonitorPageState.savedResults[index]['image'];
                    String result =
                        _MonitorPageState.savedResults[index]['result'];
                    dynamic probability =
                        _MonitorPageState.savedResults[index]['probability'];
                    String dateTime =
                        _MonitorPageState.savedResults[index]['dateTime'];

                    return ListTile(
                      leading: Image.file(
                        image,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      title: Text('Result: $result'),
                      subtitle: Text(
                          'Probability: ${(probability * 100).toStringAsFixed(2)}%'),
                      trailing: Text(dateTime),
                    );
                  },
                ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Monitor Reports'),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: _exportAllReports,
          ),
          IconButton(
            icon: const Icon(Icons.history), // Example icon for "Saved Results"
            onPressed: () => _displaySavedResults(context),
          ),
        ],
      ),
      body: widget.reports.isEmpty
          ? const Center(child: Text('No reports available'))
          : ListView.builder(
              itemCount: widget.reports.length,
              itemBuilder: (context, index) {
                final report = widget.reports[index];
                return Card(
                  child: ListTile(
                    leading: report['imagePath'].startsWith('http')
                        ? Image.network(
                            report['imagePath'],
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.error, size: 50);
                            },
                          )
                        : Image.file(
                            File(report['imagePath']),
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.error, size: 50);
                            },
                          ),
                    title: Text(report['result']),
                    subtitle: Text(
                      'Probability: ${(report['probability'] * 100).toStringAsFixed(2)}%\n'
                      'Date: ${report['dateTime']}\n'
                      'User: ${report['userFullName']}',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.picture_as_pdf,
                              color: Colors.blue),
                          onPressed: () => _exportSingleReport(index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            bool confirm = await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Confirm Delete'),
                                  content: const Text(
                                      'Are you sure you want to delete this report?'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(true),
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                );
                              },
                            );

                            if (confirm == true) {
                              await _deleteReport(context, index);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
