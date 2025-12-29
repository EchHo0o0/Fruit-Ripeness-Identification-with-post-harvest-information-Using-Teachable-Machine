import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:harvi/scan/display.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;

import 'result.dart'; // Your ResultPage
import 'dart:io';
// REQUIRED: Import your localization class
import '../home/app_localizations.dart';

// --- CONFIGURATION CONSTANT ---
const double _MIN_CONFIDENCE_THRESHOLD = 60.0;
// ------------------------------

// **Top-level function for image preprocessing (UPDATED FOR FLOAT MODEL)**
// This now returns Float32List instead of Uint8List
Future<Float32List> _preprocessImageInBackground(File imageFile) async {
  img.Image? originalImage = img.decodeImage(await imageFile.readAsBytes());
  if (originalImage == null) {
    throw Exception('Could not decode image');
  }

  // Resize to 224x224
  img.Image resizedImage =
      img.copyResize(originalImage, width: 224, height: 224);

  // Convert to Float32List and normalize values to [-1, 1]
  // Float models expect: (pixel - 127.5) / 127.5
  var convertedBytes = Float32List(1 * 224 * 224 * 3);
  var buffer = Float32List.view(convertedBytes.buffer);
  int pixelIndex = 0;

  for (var i = 0; i < 224; i++) {
    for (var j = 0; j < 224; j++) {
      var pixel = resizedImage.getPixel(j, i);

      // Red
      buffer[pixelIndex++] = (pixel.r - 127.5) / 127.5;
      // Green
      buffer[pixelIndex++] = (pixel.g - 127.5) / 127.5;
      // Blue
      buffer[pixelIndex++] = (pixel.b - 127.5) / 127.5;
    }
  }
  return convertedBytes;
}

class Scann extends StatefulWidget {
  const Scann({super.key});

  @override
  State<Scann> createState() => _ScannPageState();
}

class _ScannPageState extends State<Scann> with TickerProviderStateMixin {
  File? _image;
  late double _probability = 0.0;
  String? _result;
  List<String>? _labels;
  tfl.Interpreter? _interpreter;
  final picker = ImagePicker();
  bool _isLoading = false;

  // Map to store fruit information - NOW STORES LOCALIZATION KEYS
  // UPDATED: Matches the new label order (0-18) provided.
  final Map<String, Map<String, String>> _fruitInfo = {
    // 0
    "0 Unripe Señorita Banana": {
      "cleanResultKey": "unripeSenoritaBananaName",
      "vitaminsKey": "unripeSenoritaBananaVitamins",
      "shelfLifeKey": "unripeSenoritaBananaShelfLife",
      "generalInfoKey": "unripeSenoritaBananaGeneralInfo",
    },
    // 1
    "1 Ripe Señorita Banana": {
      "cleanResultKey": "ripeSenoritaBananaName",
      "vitaminsKey": "ripeSenoritaBananaVitamins",
      "shelfLifeKey": "ripeSenoritaBananaShelfLife",
      "generalInfoKey": "ripeSenoritaBananaGeneralInfo",
    },
    // 2
    "2 Unripe Calamansi Citrus": {
      "cleanResultKey": "unripeCalamansiCitrusName",
      "vitaminsKey": "unripeCalamansiCitrusVitamins",
      "shelfLifeKey": "unripeCalamansiCitrusShelfLife",
      "generalInfoKey": "unripeCalamansiCitrusGeneralInfo",
    },
    // 3
    "3 Ripe Calamansi Citrus": {
      "cleanResultKey": "ripeCalamansiCitrusName",
      "vitaminsKey": "ripeCalamansiCitrusVitamins",
      "shelfLifeKey": "ripeCalamansiCitrusShelfLife",
      "generalInfoKey": "ripeCalamansiCitrusGeneralInfo",
    },
    // 4
    "4 Unripe Marglobe Tomato": {
      "cleanResultKey": "unripeMarglobeTomatoName",
      "vitaminsKey": "unripeMarglobeTomatoVitamins",
      "shelfLifeKey": "unripeMarglobeTomatoShelfLife",
      "generalInfoKey": "unripeMarglobeTomatoGeneralInfo",
    },
    // 5
    "5 Ripe Marglobe Tomato": {
      "cleanResultKey": "ripeMarglobeTomatoName",
      "vitaminsKey": "ripeMarglobeTomatoVitamins",
      "shelfLifeKey": "ripeMarglobeTomatoShelfLife",
      "generalInfoKey": "ripeMarglobeTomatoGeneralInfo",
    },
    // 6
    "6 Overripe Marglobe Tomato": {
      "cleanResultKey": "overripeMarglobeTomatoName",
      "vitaminsKey": "overripeMarglobeTomatoVitamins",
      "shelfLifeKey": "overripeMarglobeTomatoShelfLife",
      "generalInfoKey": "overripeMarglobeTomatoGeneralInfo",
    },
    // 7
    "7 Unripe Bettina Papaya": {
      "cleanResultKey": "unripeBettinaPapayaName",
      "vitaminsKey": "unripeBettinaPapayaVitamins",
      "shelfLifeKey": "unripeBettinaPapayaShelfLife",
      "generalInfoKey": "unripeBettinaPapayaGeneralInfo",
    },
    // 8 (Mapped to Unripe Green Chili keys)
    "8 Unripe Sili Labuyo": {
      "cleanResultKey": "unripeGreenChiliPepperName",
      "vitaminsKey": "unripeGreenChiliPepperVitamins",
      "shelfLifeKey": "unripeGreenChiliPepperShelfLife",
      "generalInfoKey": "unripeGreenChiliPepperGeneralInfo",
    },
    // 9 (Mapped to Ripe Labuyo keys)
    "9 Ripe Sili Labuyo": {
      "cleanResultKey": "ripeLabuyoPepperName",
      "vitaminsKey": "ripeLabuyoPepperVitamins",
      "shelfLifeKey": "ripeLabuyoPepperShelfLife",
      "generalInfoKey": "ripeLabuyoPepperGeneralInfo",
    },

    // 11
    "10 Ripe Bettina Papaya": {
      "cleanResultKey": "ripeBettinaPapayaName",
      "vitaminsKey": "ripeBettinaPapayaVitamins",
      "shelfLifeKey": "ripeBettinaPapayaShelfLife",
      "generalInfoKey": "ripeBettinaPapayaGeneralInfo",
    },
    // 12
    "11 Overripe Bettina Papaya": {
      "cleanResultKey": "overripeBettinaPapayaName",
      "vitaminsKey": "overripeBettinaPapayaVitamins",
      "shelfLifeKey": "overripeBettinaPapayaShelfLife",
      "generalInfoKey": "overripeBettinaPapayaGeneralInfo",
    },
    // 13
    "12 Ripe Kirby Cucumber": {
      "cleanResultKey": "ripeKirbyCucumberName",
      "vitaminsKey": "ripeKirbyCucumberVitamins",
      "shelfLifeKey": "ripeKirbyCucumberShelfLife",
      "generalInfoKey": "ripeKirbyCucumberGeneralInfo",
    },
    // 14 (Fallback to Ripe Labuyo keys as Overripe wasn't in original)
    "13 Overripe Sili Labuyo": {
      "cleanResultKey": "overripeLabuyoPepperName", // Updated
      "vitaminsKey": "overripeLabuyoPepperVitamins", // Updated
      "shelfLifeKey": "overripeLabuyoPepperShelfLife", // Updated
      "generalInfoKey": "overripeLabuyoPepperGeneralInfo", // Updated
    },
    // 15
    "14 Overripe Calamansi Citrus": {
      "cleanResultKey": "overripeCalamansiCitrusName", // Updated
      "vitaminsKey": "overripeCalamansiCitrusVitamins", // Updated
      "shelfLifeKey": "overripeCalamansiCitrusShelfLife", // Updated
      "generalInfoKey": "overripeCalamansiCitrusGeneralInfo", // Updated
    },
    // 16
    "15 Overripe Señorita Banana": {
      "cleanResultKey": "overripeSenoritaBananaName",
      "vitaminsKey": "overripeSenoritaBananaVitamins",
      "shelfLifeKey": "overripeSenoritaBananaShelfLife",
      "generalInfoKey": "overripeSenoritaBananaGeneralInfo",
    },
    // 17 (Fallback to Ripe Kirby keys)
    "16 Overripe Kirby Cucumber": {
      "cleanResultKey": "overripeKirbyCucumberName", // Updated
      "vitaminsKey": "overripeKirbyCucumberVitamins", // Updated
      "shelfLifeKey": "overripeKirbyCucumberShelfLife", // Updated
      "generalInfoKey": "overripeKirbyCucumberGeneralInfo", // Updated
    },
    // 18
    "17 Unripe Kirby Cucumber": {
      "cleanResultKey": "unripeKirbyCucumberName", // Updated
      "vitaminsKey": "unripeKirbyCucumberVitamins", // Updated
      "shelfLifeKey": "unripeKirbyCucumberShelfLife", // Updated
      "generalInfoKey": "unripeKirbyCucumberGeneralInfo", // Updated
    },
  };

  @override
  void initState() {
    super.initState();
    loadModel().then((_) {
      loadLabels().then((loadedLabels) {
        setState(() {
          _labels = loadedLabels;
        });
      });
    });
  }

  @override
  void dispose() {
    _interpreter?.close();
    super.dispose();
  }

  // --- Confirmation Dialogs ---
  Future<void> _showConfirmationDialog(ImageSource source) async {
    // Get localizations instance
    final localizations = AppLocalizations.of(context)!;

    String title;
    String content;

    if (source == ImageSource.camera) {
      title = localizations.translate('cameraAccessTitle');
      content = localizations.translate('cameraAccessContent');
    } else {
      title = localizations.translate('uploadPhotoTitle');
      content = localizations.translate('uploadPhotoContent');
    }

    final bool? shouldProceed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: Text(localizations.translate('cancelButton'),
                  style: const TextStyle(color: Colors.red)),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: Text(localizations.translate('proceedButton'),
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );

    if (shouldProceed == true) {
      if (source == ImageSource.camera) {
        _pickImage(ImageSource.camera);
      } else {
        _pickImage(ImageSource.gallery);
      }
    }
  }

  // --- Image Picking Logic ---
  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      _setImage(File(pickedFile.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color buttonBackgroundColor =
        isDarkMode ? Colors.grey : Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.translate('fruitScannerTitle'),
            style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.green[800],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 40),
                Image.asset('assets/logo.png', height: 250, width: 250),
                const SizedBox(height: 20),
                Text(
                  localizations.translate('greetingText'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                const SizedBox(height: 30),
                GestureDetector(
                  onTap: () => _showConfirmationDialog(ImageSource.camera),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: buttonBackgroundColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      localizations.translate('scanButton'),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () => _showConfirmationDialog(ImageSource.gallery),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: buttonBackgroundColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      localizations.translate('uploadButton'),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.7),
              child: const Center(
                child: SizedBox(
                  width: 60.0,
                  height: 60.0,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth: 6.0,
                    backgroundColor: Colors.grey,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> loadModel() async {
    try {
      _interpreter = await tfl.Interpreter.fromAsset('assets/model.tflite');
    } catch (e) {
      debugPrint('Error loading model: $e');
    }
  }

  void _setImage(File image) {
    setState(() {
      _image = image;
      _isLoading = true;
    });
    runInference();
  }

  // --- Inference Logic (UPDATED FOR FLOAT MODEL) ---
  Future<void> runInference() async {
    if (_image == null || _labels == null) {
      debugPrint('Image or labels not set');
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      // 1. Use the new Float32 preprocessor
      Float32List inputBytes =
          await compute(_preprocessImageInBackground, _image!);

      // 2. Reshape input for Float model [1, 224, 224, 3]
      var input = inputBytes.reshape([1, 224, 224, 3]);

      // 3. Output buffer is now just a list of doubles (Floats)
      // We use 1 x (number of labels)
      var outputBuffer =
          List<double>.filled(_labels!.length, 0).reshape([1, _labels!.length]);

      // 4. Run inference
      _interpreter!.run(input, outputBuffer);

      // 5. Get probabilities (Float model gives direct 0.0 to 1.0 values)
      // No division by 255 is needed for Float models
      List<double> probabilities = List<double>.from(outputBuffer[0]);

      int maxScoreIndex = 0;
      double maxScore = probabilities.reduce((a, b) => a > b ? a : b);

      maxScoreIndex = probabilities.indexOf(maxScore);
      double maxScorePercentage = maxScore * 100;

      String rawLabel = _labels![maxScoreIndex].trim();

      String classificationResult =
          maxScorePercentage < _MIN_CONFIDENCE_THRESHOLD
              ? AppLocalizations.of(context)!.translate('undefinedResult')
              : rawLabel;

      debugPrint('Model Predicted Index: $maxScoreIndex');
      debugPrint('Model Predicted Raw Label (Trimmed): $rawLabel');
      debugPrint('Probability: $maxScorePercentage%');
      debugPrint('Final Classification Result: $classificationResult');

      setState(() {
        _result = classificationResult;
        _probability = maxScorePercentage;
        _isLoading = false;
      });

      navigateToResult();
    } catch (e) {
      debugPrint('Error during inference: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<List<String>> loadLabels() async {
    final labelsData =
        await DefaultAssetBundle.of(context).loadString('assets/labels.txt');
    return labelsData.split('\n');
  }

  // --- Navigation and Data Lookup Logic ---
  void navigateToResult() async {
    final localizations = AppLocalizations.of(context)!;

    if (_image == null || _result == null) {
      debugPrint('Image or result not available');
      return;
    }

    String lookupKey = _result!;
    String cleanResult;
    String vitamins;
    String shelfLife;
    String generalInfo;

    final fruitDetailsKeys = _fruitInfo[lookupKey];

    if (_result == localizations.translate('undefinedResult') ||
        fruitDetailsKeys == null) {
      cleanResult = localizations.translate('undefinedResult');
      vitamins = localizations.translate('infoNotAvailable');
      shelfLife = localizations.translate('infoNotAvailable');
      generalInfo = localizations.translate('noInfoAvailable');
    } else {
      final String cleanResultNameKey = fruitDetailsKeys["cleanResultKey"]!;
      cleanResult = localizations.translate(cleanResultNameKey);
      vitamins = localizations.translate(fruitDetailsKeys["vitaminsKey"]!);
      shelfLife = localizations.translate(fruitDetailsKeys["shelfLifeKey"]!);
      generalInfo =
          localizations.translate(fruitDetailsKeys["generalInfoKey"]!);
    }

    final DateTime now = DateTime.now();
    int hour = now.hour;
    String amPm = localizations.translate('pm');
    if (hour < 12) {
      amPm = localizations.translate('am');
    }
    if (hour >= 12) {
      if (hour > 12) {
        hour -= 12;
      }
    } else if (hour == 0) {
      hour = 12;
    }

    final String formattedDateTime =
        "${_getMonthName(now.month, localizations)} ${now.day}, ${now.year} ${hour}:${now.minute.toString().padLeft(2, '0')} $amPm";

    await DisplayPage.addResult(
      image: _image!,
      result: cleanResult,
      probability: _probability,
      dateTime: formattedDateTime,
      vitamins: vitamins,
      shelfLife: shelfLife,
      generalInfo: generalInfo,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultPage(
          image: _image!,
          result: cleanResult,
          probability: _probability,
          dateTime: formattedDateTime,
          vitamins: vitamins,
          shelfLife: shelfLife,
          generalInfo: generalInfo,
        ),
      ),
    );
  }

  String _getMonthName(int month, AppLocalizations localizations) {
    switch (month) {
      case 1:
        return localizations.translate('monthJanuary');
      case 2:
        return localizations.translate('monthFebruary');
      case 3:
        return localizations.translate('monthMarch');
      case 4:
        return localizations.translate('monthApril');
      case 5:
        return localizations.translate('monthMay');
      case 6:
        return localizations.translate('monthJune');
      case 7:
        return localizations.translate('monthJuly');
      case 8:
        return localizations.translate('monthAugust');
      case 9:
        return localizations.translate('monthSeptember');
      case 10:
        return localizations.translate('monthOctober');
      case 11:
        return localizations.translate('monthNovember');
      case 12:
        return localizations.translate('monthDecember');
      default:
        return "";
    }
  }
}
