import 'package:flutter/material.dart';
// Note: This import brings in 'productData' (List<Map<String, dynamic>>)
import 'package:harvi/book/product_model.dart';
// Import all necessary screens for navigation
import 'package:harvi/book/preparation.dart';
import 'package:harvi/book/season.dart';
import 'package:harvi/book/fertilize.dart';
import 'package:harvi/book/harvest.dart';
import 'package:harvi/home/app_localizations.dart'; // Ensure correct path for localizations

class CategoryList extends StatelessWidget {
  const CategoryList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // FIX: Use the 'productData' list which is exported from product_model.dart
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      // FIX: Reference 'productData'
      itemCount: productData.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.85,
        mainAxisSpacing: 10.0,
        crossAxisSpacing: 10.0,
      ),
      itemBuilder: (context, index) => CategoryCard(
        // FIX: Pass the item as a Map
        productMap: productData[index],
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    Key? key,
    // FIX: Change type from 'Product' to 'Map<String, dynamic>'
    required this.productMap,
  }) : super(key: key);

  // FIX: Change type to 'Map<String, dynamic>'
  final Map<String, dynamic> productMap;

  @override
  Widget build(BuildContext context) {
    // Ensure AppLocalizations is available through your project setup
    final localizations = AppLocalizations.of(context);

    // Get the unique screen ID from the map for navigation
    // This uses the key 'screen' from your product data.
    final navigationKey = productMap['screen'];

    return GestureDetector(
      onTap: () {
        // Navigation logic based on the unique screen ID
        if (navigationKey == "Preparation") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PreparationScreen()),
          );
        } else if (navigationKey == "Fruit Information") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HarvestScreen()),
          );
        } else if (navigationKey == "Fertilizer") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FertilizerScreen()),
          );
        } else if (navigationKey == "Steps of Proper Harvesting") {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const SeasonPlantingScreen()),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(10.0),
        margin: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          // FIX: Access map values using keys and cast Color type
          color: (productMap['color'] as Color).withOpacity(0.9),
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              color: (productMap['color'] as Color).withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  // FIX: Access map values using keys
                  productMap['image'],
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Text(
                // FIX: Use 'titleKey' from the map for localization
                localizations.translate(productMap['titleKey']),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color.fromARGB(255, 31, 31, 31),
                  fontWeight: FontWeight.w700,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}
