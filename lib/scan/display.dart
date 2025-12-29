import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:harvi/scan/result.dart';
// 🔥 REQUIRED: Import your localization class
import '../home/app_localizations.dart';

// This class will now be responsible for both displaying and saving results
class DisplayPage extends StatefulWidget {
  // Removed 'required String userId' as it's not used in this class's state logic
  const DisplayPage({Key? key, required String userId}) : super(key: key);

  // Static method to add a scan result for the current user
  static Future<void> addResult({
    required File image,
    required String result,
    required double probability,
    required String dateTime,
    required String vitamins,
    required String shelfLife,
    required String generalInfo,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final user = FirebaseAuth.instance.currentUser;
    // Use user.uid for consistency if available, otherwise fallback to email or 'guest'
    // user.uid is generally preferred as it's stable even if email changes.
    final String userIdentifier = user?.uid ?? user?.email ?? 'guest';

    // Load existing results for this user
    final savedResultsString = prefs.getString('savedResults_$userIdentifier');
    List<Map<String, dynamic>> currentResults = [];
    if (savedResultsString != null) {
      currentResults = List<Map<String, dynamic>>.from(
        json.decode(savedResultsString),
      );
    }

    // Add the new result
    currentResults.add({
      'imagePath':
          image.path, // Save the image path, not the File object directly
      'result': result,
      'probability': probability,
      'dateTime': dateTime,
      'vitamins': vitamins,
      'shelfLife': shelfLife,
      'generalInfo': generalInfo,
    });

    // Save the updated list for this specific user
    await prefs.setString(
      'savedResults_$userIdentifier',
      json.encode(currentResults),
    );
    debugPrint('Scan result saved for user: $userIdentifier'); // For debugging
  }

  @override
  State<DisplayPage> createState() => _DisplayPageState();
}

class _DisplayPageState extends State<DisplayPage> {
  List<Map<String, dynamic>> scanResults = [];

  @override
  void initState() {
    super.initState();
    _loadResults();
    // Listen for auth state changes to reload results if user logs in/out
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      _loadResults();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _loadResults() async {
    final prefs = await SharedPreferences.getInstance();
    final user = FirebaseAuth.instance.currentUser;
    // Use user.uid for consistency if available, otherwise fallback to email or 'guest'
    final String userIdentifier = user?.uid ?? user?.email ?? 'guest';
    final savedResults = prefs.getString('savedResults_$userIdentifier');

    if (savedResults != null) {
      setState(() {
        // Deserialize and reverse the list so the newest result is at the top
        scanResults = List<Map<String, dynamic>>.from(
          json.decode(savedResults),
        ).reversed.toList();
      });
    } else {
      setState(() {
        scanResults = [];
      });
    }
    debugPrint(
      'Loaded ${scanResults.length} results for user: $userIdentifier',
    ); // For debugging
  }

  Future<void> _deleteResult(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final user = FirebaseAuth.instance.currentUser;
    final String userIdentifier = user?.uid ?? user?.email ?? 'guest';

    // Find the actual index in the saved (non-reversed) list
    final actualIndex = scanResults.length - 1 - index;

    // Delete the image file from storage if it exists
    final imagePath = scanResults[index]['imagePath'];
    if (imagePath != null) {
      final file = File(imagePath);
      if (await file.exists()) {
        try {
          await file.delete();
          debugPrint('Deleted image file: $imagePath');
        } catch (e) {
          debugPrint('Error deleting image file: $e');
        }
      }
    }

    setState(() {
      scanResults.removeAt(index);
    });

    // Re-save the non-reversed list (get current saved data, modify, and save back)
    final savedResultsString = prefs.getString('savedResults_$userIdentifier');
    if (savedResultsString != null) {
      List<Map<String, dynamic>> savedList =
          List<Map<String, dynamic>>.from(json.decode(savedResultsString));

      // Check if the original list is long enough and the calculated index is valid
      if (actualIndex >= 0 && actualIndex < savedList.length) {
        savedList.removeAt(actualIndex);
        await prefs.setString(
            'savedResults_$userIdentifier', json.encode(savedList));
      } else {
        // Fallback: If calculation fails, just save the current reversed list as the new source (which is safer)
        await prefs.setString(
          'savedResults_$userIdentifier',
          json.encode(scanResults.reversed.toList()),
        );
      }
    }

    debugPrint(
      'Deleted result at index $index for user: $userIdentifier',
    ); // For debugging
  }

  // New function to show the confirmation dialog for deletion
  Future<void> _showDeleteConfirmationDialog(int index) async {
    // 🔥 Get localizations instance
    final localizations = AppLocalizations.of(context)!;

    bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          // 🔥 LOCALIZED FIX
          title: Text(localizations.translate('deleteDialogTitle')),
          content: Text(
            // 🔥 LOCALIZED FIX
            localizations.translate('deleteDialogContent'),
          ),
          actions: <Widget>[
            TextButton(
              // 🔥 LOCALIZED FIX
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(localizations.translate('cancelButton')),
            ),
            TextButton(
              // 🔥 LOCALIZED FIX
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(localizations.translate('deleteButton'),
                  style: const TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      _deleteResult(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    // 🔥 Get localizations instance
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      // 🔥 LOCALIZED FIX
      appBar:
          AppBar(title: Text(localizations.translate('dataRepositoryTitle'))),
      body: scanResults.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  // 🔥 LOCALIZED FIX
                  localizations.translate('noResultsMessage'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ),
            )
          : ListView.builder(
              itemCount: scanResults.length,
              itemBuilder: (context, index) {
                final resultData = scanResults[index];
                final imageFile = File(resultData['imagePath']);

                final String result = resultData['result'] as String? ?? 'N/A';
                final double probability =
                    (resultData['probability'] as num?)?.toDouble() ?? 0.0;
                final String dateTime =
                    resultData['dateTime'] as String? ?? 'N/A';
                final String vitamins =
                    resultData['vitamins'] as String? ?? 'N/A';
                final String shelfLife =
                    resultData['shelfLife'] as String? ?? 'N/A';
                final String generalInfo =
                    resultData['generalInfo'] as String? ?? 'N/A';

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  child: ListTile(
                    leading: imageFile.existsSync()
                        ? Image.file(
                            imageFile,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          )
                        : const Icon(
                            Icons.broken_image,
                            size: 50,
                            color: Colors.grey,
                          ),
                    // 🔥 LOCALIZED FIX
                    title: Text(
                      '${localizations.translate('resultPrefix')} $result',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 🔥 LOCALIZED FIX
                        Text(
                          '${localizations.translate('probabilityPrefix')} ${probability.toStringAsFixed(2)}%',
                        ),
                        Text(
                            '${localizations.translate('dateTimePrefix')} $dateTime'),
                        if (vitamins != 'N/A')
                          Text(
                              '${localizations.translate('vitaminsPrefix')} $vitamins'),
                        if (shelfLife != 'N/A')
                          Text(
                              '${localizations.translate('shelfLifeLabel')}: $shelfLife'),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () => _showDeleteConfirmationDialog(
                        index,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ResultPage(
                            image: imageFile,
                            result: result,
                            probability: probability,
                            dateTime: dateTime,
                            vitamins: vitamins,
                            shelfLife: shelfLife,
                            generalInfo: generalInfo,
                          ),
                        ),
                      ).then((_) {
                        _loadResults();
                      });
                    },
                  ),
                );
              },
            ),
    );
  }
}
