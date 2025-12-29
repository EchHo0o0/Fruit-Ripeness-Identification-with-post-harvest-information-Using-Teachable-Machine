import 'package:flutter/material.dart';
// Ensure this import is correct
import 'package:harvi/home/app_localizations.dart';
import 'harvest.dart'; // Make sure these files exist or replace with appropriate screen
import 'season.dart'; // Make sure these files exist or replace with appropriate screen

// Product list is now defined globally, but the titles are keys
List<Map<String, dynamic>> productData = [
  {
    'id': 2,
    'titleKey': 'fruit_information', // Localization Key
    'image': 'assets/season.png',
    'color': const Color(0xFF9ba0fc),
    'screen': 'Fruit Information', // Unique ID for screen navigation
  },
  {
    'id': 4,
    'titleKey': 'steps_of_proper_harvesting', // Localization Key
    'image': 'assets/harvests.png',
    'color': const Color(0xFFff6374),
    'screen': 'Steps of Proper Harvesting', // Unique ID for screen navigation
  },
];

class ProductList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localizations =
        AppLocalizations.of(context); // Get localizations instance

    return Scaffold(
      appBar: AppBar(
        // Translate the AppBar title
        title: Text(localizations.translate('product_list_title'),
            style: const TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.green,
        elevation: 4.0,
      ),
      body: ListView.builder(
        itemCount: productData.length,
        itemBuilder: (context, index) {
          final product = productData[index];
          // Translate the product title for display
          final translatedTitle = localizations.translate(product['titleKey']);

          return Card(
            color: product['color'],
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Container(
              height: 180,
              child: ListTile(
                contentPadding: const EdgeInsets.all(15),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    product['image'],
                    fit: BoxFit.cover,
                    width: 60,
                    height: 60,
                  ),
                ),
                title: Text(
                  translatedTitle, // Use translated title
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  final screenId =
                      product['screen']; // Use the fixed screen ID for logic

                  // Navigation logic based on the fixed screen ID
                  if (screenId == "Fruit Information") {
                    // Assuming HarvestScreen is the screen for Fruit Information
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HarvestScreen()),
                    );
                  } else if (screenId == "Steps of Proper Harvesting") {
                    // Assuming SeasonPlantingScreen is the screen for Harvesting Steps
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SeasonPlantingScreen()),
                    );
                  } else {
                    print("No matching screen for: $screenId");
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

// NOTE: You need to ensure the main() function and the necessary imports
// are set up to use your LanguageProvider and the AppLocalizations class
// for the translation to actually work.

void main() {
  runApp(MaterialApp(
    home: ProductList(),
    debugShowCheckedModeBanner: false,
  ));
}
