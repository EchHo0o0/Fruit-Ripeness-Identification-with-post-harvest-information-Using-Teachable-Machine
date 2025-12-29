import 'package:flutter/material.dart';
// Import provider for AppLocalizations
import '../home/app_localizations.dart'; // Ensure this import is correct

class SeasonPlantingScreen extends StatelessWidget {
  const SeasonPlantingScreen({Key? key}) : super(key: key);

  // Define your data once using ONLY localization keys
  // The list now stores keys for title and description
  final List<Map<String, String>> steps = const [
    {
      'imagePath': 'assets/check.png',
      'titleKey': 'step_1_title',
      'descriptionKey': 'step_1_desc',
    },
    {
      'imagePath': 'assets/reaping.png',
      'titleKey': 'step_2_title',
      'descriptionKey': 'step_2_desc',
    },
    {
      'imagePath': 'assets/thereshing.png',
      'titleKey': 'step_3_title',
      'descriptionKey': 'step_3_desc',
    },
    {
      'imagePath': 'assets/cleaning.png',
      'titleKey': 'step_4_title',
      'descriptionKey': 'step_4_desc',
    },
    {
      'imagePath': 'assets/sorting.png',
      'titleKey': 'step_5_title',
      'descriptionKey': 'step_5_desc',
    },
    {
      'imagePath': 'assets/bagging.png',
      'titleKey': 'step_6_title',
      'descriptionKey': 'step_6_desc',
    },
    {
      'imagePath': 'assets/storage.png',
      'titleKey': 'step_7_title',
      'descriptionKey': 'step_7_desc',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final localizations =
        AppLocalizations.of(context); // Get localizations instance

    return Scaffold(
      appBar: AppBar(
        title: Text(
          // Translate the AppBar title
          localizations.translate('steps_of_proper_harvesting'),
          style: const TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.green[800],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        color: Colors.green[50],
        child: ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: steps.length,
          itemBuilder: (context, index) {
            final step = steps[index];

            // Translate the keys into actual text here
            final title = localizations.translate(step['titleKey']!);
            final description =
                localizations.translate(step['descriptionKey']!);

            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: HarvestCard(
                imagePath: step['imagePath']!,
                title: title, // Use translated title
                description: description, // Use translated description
              ),
            );
          },
        ),
      ),
    );
  }
}

// ----------------------------------------------------------------------
// HarvestCard (Only needs to pass down the translated strings)
// ----------------------------------------------------------------------

class HarvestCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;

  const HarvestCard({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // The GestureDetector wraps the Card to make the whole card clickable
    return GestureDetector(
      onTap: () {
        // Navigates to the detail screen on tap
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HarvestDetailScreen(
              title: title,
              imagePath: imagePath,
              description: description,
            ),
          ),
        );
      },
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Icon/Image on the left
                  Image.asset(imagePath,
                      height: 60, width: 60, fit: BoxFit.contain),
                  const SizedBox(width: 16),
                  // Step Title on the right
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[800],
                      ),
                    ),
                  ),
                  // Visual cue for tapping
                  Icon(Icons.chevron_right, color: Colors.green[600]),
                ],
              ),
              const SizedBox(height: 12),
              // Boxed Description Area
              Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  // Lighter color for the description box
                  color: Colors.green[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.shade300, width: 1),
                ),
                child: Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[800],
                    height: 1.4,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// ----------------------------------------------------------------------
// HarvestDetailScreen (No changes needed, it uses passed strings)
// ----------------------------------------------------------------------

class HarvestDetailScreen extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;

  const HarvestDetailScreen({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 🔥 Get screen height for dynamic image sizing (approx. half the screen)
    final double screenHeight = MediaQuery.of(context).size.height;
    final double imageHeight = screenHeight * 0.45; // 45% of screen height

    return Scaffold(
      backgroundColor: Colors.green[50], // Add background color for detail
      appBar: AppBar(
        title: Text(
          // Show just the descriptive part of the step
          title.split(':').last.trim(),
          style: const TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.green[800],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // LARGE IMAGE SECTION
            Container(
              height: imageHeight,
              color: Colors.white,
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(20.0)),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image.asset(imagePath, fit: BoxFit.contain),
                ),
              ),
            ),

            // TEXT CONTENT SECTION
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[800]),
                    textAlign: TextAlign.center,
                  ),
                  Divider(
                    color: Colors.green[200],
                    thickness: 2,
                    height: 30,
                    indent: 30,
                    endIndent: 30,
                  ),
                  const SizedBox(height: 12),
                  // DESCRIPTION IN A BOX
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Text(
                      description,
                      style: TextStyle(
                          fontSize: 16, color: Colors.grey[800], height: 1.5),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
