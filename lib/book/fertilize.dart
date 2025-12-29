import 'package:flutter/material.dart';

class FertilizerScreen extends StatelessWidget {
  const FertilizerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Organic and Inorganic Fertilizer Use',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Synthetic Fertilizer
            FertilizerCard(
              fertilizer: 'Synthetic Fertilizer',
              type: 'Inorganic',
              usage: 'Apply weekly during the growing season.',
              description:
                  'Provides plants with essential nutrients quickly. Use a balanced N-P-K formula for general vegetable growth.',
            ),
            SizedBox(height: 16),
            // Pop of Worm
            FertilizerCard(
              fertilizer: 'Pop of Worm',
              type: 'Organic',
              usage: 'Use once every two weeks.',
              description:
                  'Derived from worm castings, rich in beneficial microorganisms. Helps improve soil structure and promotes root growth.',
            ),
            SizedBox(height: 16),
            // Compost
            FertilizerCard(
              fertilizer: 'Compost',
              type: 'Organic',
              usage: 'Incorporate into the soil at the beginning of the season.',
              description:
                  'Improves soil health by adding organic matter, enhancing water retention, and providing slow-release nutrients.',
            ),
            SizedBox(height: 16),
            // Fish Emulsion
            FertilizerCard(
              fertilizer: 'Fish Emulsion',
              type: 'Organic',
              usage: 'Apply every 2-3 weeks.',
              description:
                  'A natural source of nitrogen, phosphorus, and potassium. Great for leafy green vegetables and soil microbial health.',
            ),
            SizedBox(height: 16),
            // Chicken Manure
            FertilizerCard(
              fertilizer: 'Chicken Manure',
              type: 'Organic',
              usage: 'Use sparingly once a month.',
              description:
                  'High in nitrogen and suitable for heavy feeders. Compost for at least 6 months before using to reduce the risk of burning plants.',
            ),
          ],
        ),
      ),
    );
  }
}

// Reusable Widget for each fertilizer card
class FertilizerCard extends StatelessWidget {
  final String fertilizer;
  final String type;
  final String usage;
  final String description;

  const FertilizerCard({
    Key? key,
    required this.fertilizer,
    required this.type,
    required this.usage,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.lightGreen[50],
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            fertilizer,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.green[800],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Type: $type',
            style: TextStyle(
              fontSize: 16,
              color: Colors.brown[700],
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Usage: $usage',
            style: TextStyle(
              fontSize: 16,
              color: Colors.green[700],
            ),
          ),
          SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }
}
