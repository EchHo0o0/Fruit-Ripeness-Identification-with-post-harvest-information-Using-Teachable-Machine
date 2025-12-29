import 'package:flutter/material.dart';

class PreparationScreen extends StatefulWidget {
  const PreparationScreen({Key? key}) : super(key: key);

  @override
  _PreparationScreenState createState() => _PreparationScreenState();
}

class _PreparationScreenState extends State<PreparationScreen> {
  // Track visibility and color of each preparation step
  List<bool> isVisible = [false, false, false, false, false, false, false, false, false];

  // Colors for each icon when selected
  final List<Color> selectedColors = [
    Colors.red[700]!,
    Colors.blue[700]!,
    Colors.purple[700]!,
    Colors.orange[700]!,
    Colors.brown[700]!,
    Colors.teal[700]!,
    Colors.pink[700]!,
    Colors.indigo[700]!,
    Colors.cyan[700]!,
  ];

  // Default color for icons
  final Color defaultColor = Colors.green[700]!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Preparation Before Planting Vegetables',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Soil Testing
            PreparationStep(
              icon: Icons.science,
              title: 'Soil Testing',
              description:
                  'Check the soil’s pH level and nutrient content. Ideal vegetable garden soil should be loamy, well-drained, and rich in organic matter.',
              isVisible: isVisible[0],
              iconColor: isVisible[0] ? selectedColors[0] : defaultColor,
              onTap: () {
                setState(() {
                  isVisible[0] = !isVisible[0];
                });
              },
            ),
            SizedBox(height: 16),
            // Land Preparation
            PreparationStep(
              icon: Icons.landscape,
              title: 'Land Preparation',
              description:
                  'Clear weeds and debris, till the soil, and add organic compost or aged manure. Mulch to conserve moisture and suppress weeds.',
              isVisible: isVisible[1],
              iconColor: isVisible[1] ? selectedColors[1] : defaultColor,
              onTap: () {
                setState(() {
                  isVisible[1] = !isVisible[1];
                });
              },
            ),
            SizedBox(height: 16),
            // Seed Selection
            PreparationStep(
              icon: Icons.local_florist,
              title: 'Seed Selection',
              description:
                  'Choose seeds suitable for your local climate and soil type to maximize growth potential and yield.',
              isVisible: isVisible[2],
              iconColor: isVisible[2] ? selectedColors[2] : defaultColor,
              onTap: () {
                setState(() {
                  isVisible[2] = !isVisible[2];
                });
              },
            ),
            SizedBox(height: 16),
            // Pest Management
            PreparationStep(
              icon: Icons.bug_report,
              title: 'Pest Management',
              description:
                  'Install barriers or apply organic pest control measures to protect young plants from pests.',
              isVisible: isVisible[3],
              iconColor: isVisible[3] ? selectedColors[3] : defaultColor,
              onTap: () {
                setState(() {
                  isVisible[3] = !isVisible[3];
                });
              },
            ),
            SizedBox(height: 16),
            // Equipment or Tools
            PreparationStep(
              icon: Icons.construction,
              title: 'Equipment or Tools',
              description:
                  'Gather essential tools like a hoe, rake, shovel, gloves, and watering can. Consider using a garden fork for turning soil and pruning shears for plant maintenance.',
              isVisible: isVisible[4],
              iconColor: isVisible[4] ? selectedColors[4] : defaultColor,
              onTap: () {
                setState(() {
                  isVisible[4] = !isVisible[4];
                });
              },
            ),
            SizedBox(height: 16),
            // Irrigation Setup (NEW)
            PreparationStep(
              icon: Icons.water_drop,
              title: 'Irrigation Setup',
              description:
                  'Plan and install a drip irrigation or soaker hose system to ensure consistent moisture for your plants. Proper irrigation saves water and reduces plant stress.',
              isVisible: isVisible[5],
              iconColor: isVisible[5] ? selectedColors[5] : defaultColor,
              onTap: () {
                setState(() {
                  isVisible[5] = !isVisible[5];
                });
              },
            ),
            SizedBox(height: 16),
            // Composting (NEW)
            PreparationStep(
              icon: Icons.eco,
              title: 'Composting',
              description:
                  'Prepare compost to enrich the soil. Use food scraps, lawn clippings, and other organic materials to create nutrient-rich compost for your garden.',
              isVisible: isVisible[6],
              iconColor: isVisible[6] ? selectedColors[6] : defaultColor,
              onTap: () {
                setState(() {
                  isVisible[6] = !isVisible[6];
                });
              },
            ),
            SizedBox(height: 16),
            // Raised Bed Preparation (NEW)
            PreparationStep(
              icon: Icons.fence,
              title: 'Raised Bed Preparation',
              description:
                  'Build raised beds to improve soil drainage, increase planting space, and make plant management easier. Raised beds also prevent soil compaction.',
              isVisible: isVisible[7],
              iconColor: isVisible[7] ? selectedColors[7] : defaultColor,
              onTap: () {
                setState(() {
                  isVisible[7] = !isVisible[7];
                });
              },
            ),
            SizedBox(height: 16),
            // Crop Rotation Planning (NEW)
            PreparationStep(
              icon: Icons.rotate_right,
              title: 'Crop Rotation Planning',
              description:
                  'Plan for crop rotation to improve soil health and prevent the buildup of pests and diseases. Rotate crops every season to maintain a balanced soil nutrient profile.',
              isVisible: isVisible[8],
              iconColor: isVisible[8] ? selectedColors[8] : defaultColor,
              onTap: () {
                setState(() {
                  isVisible[8] = !isVisible[8];
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Reusable Widget for each preparation step
class PreparationStep extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final bool isVisible;
  final Color iconColor;
  final VoidCallback onTap;

  const PreparationStep({
    Key? key,
    required this.icon,
    required this.title,
    required this.description,
    required this.isVisible,
    required this.iconColor,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.green[50],
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 40,
                  color: iconColor,
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[900],
                    ),
                  ),
                ),
              ],
            ),
            // Show description if visible
            if (isVisible)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  description,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[800],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
