import 'package:flutter/material.dart';
import 'package:harvi/home/app_localizations.dart';

class HarvestScreen extends StatefulWidget {
  const HarvestScreen({Key? key}) : super(key: key);

  @override
  _HarvestScreenState createState() => _HarvestScreenState();
}

class _HarvestScreenState extends State<HarvestScreen> {
  final TextEditingController _searchController = TextEditingController();
  // Changed type to accept maps with keys
  List<Map<String, dynamic>> allFruitData = [];
  List<Map<String, dynamic>> filteredFruitData = [];

  // 2. TEMPORARY MAP to hold the English data (simulates a large localization file)
  late Map<String, String> _englishData;

  // Helper to fetch translated text. For data-rich fields, we treat the key
  // as the lookup string. If the translation fails, we default to English.
  String _getLocalizedText(String key, BuildContext context) {
    final localizations = AppLocalizations.of(context);

    // Attempt to translate the key using the app localizations (for UI or short data)
    final translated = localizations.translate(key);

    // Check if the translated string is simply the key itself (meaning translation failed)
    // AND if we have the key in our English data map. If so, return the English text.
    if (translated == key && _englishData.containsKey(key)) {
      return _englishData[key]!;
    }

    // Otherwise, return the result from the app localizations
    return translated;
  }

  @override
  void initState() {
    super.initState();

    // Initialize English data map with all long text blocks
    _englishData = {
      'apple_name': 'Apple',
      'apple_vitamins': 'Vitamin C, Vitamin E, Iron, Zinc, Polyphenols',
      'apple_post_harvest':
          'According to A. Oyenihi 2022, Fresh apples are considered a food of moderate energy value among common fruits, while processed apple products are either comparable to fresh apples in energy value or higher because of concentration dehydrated or addition of sugars during processing.Apples are not bursting with vitamins and minerals like some other fruits, though they do provide a bit of vitamin C and potassium.  Apples are rich sources of selected micronutrients iron, zinc, vitamins C and E and polyphenols that can help in mitigating micronutrient deficienciesand chronic diseases. ',
      'banana_name': 'Banana',
      'banana_vitamins':
          'Vitamin C, Starch, Sugar, Fiber, Magnesium, Potassium',
      'banana_post_harvest':
          'According to S. Sari 2024,  Banana is an important fruit consumed globally and cultivated in humid and subtropical climes. The fruit comprises nutrients in its pulp and peel with beneficial properties. Bananas are rich in nutrients, particularly vitamin C, starch, sugar, fiber, and serve as an affordable source of vitamins, minerals, and energy for the community. The mineral content in fresh bananas includes zinc, selenium, phosphorus, manganese, iron, copper, and calcium. Consuming bananas for magnesium intake is particularly important. A single fresh banana contains 27 mg of magnesium.  ',
      'calamansi_name': 'Calamansi',
      'calamansi_vitamins':
          'Vitamin C, D-Limonene, Dietary Fiber, Phenolics, Flavonoids',
      'calamansi_post_harvest':
          'According to K. Venkatachalam 2023, Calamansi fruits are a rich source of nutrients like vitamin C, D-limonene, and dietary fiber, with various medicinal and commercial applications. Calamansi is excellent source of Vitamin C, D-Limonene, and essential oils, providing benefits to the immune system, as well as anti-inflammatory, anti-cancer, anti-diabetic, anti-angiogenic, and anti-cancer properties, and it exhibits various therapeutic effects. It also contains a good amount of dietary fiber from pectin. Its distinctive flavor and high juice content make calamondin juice a popular ingredient in many international cuisines. The juice also contains bioactive compounds, such as phenolics and flavonoids, which are a potential source of antioxidant properties. ',
      'durian_name': 'Durian',
      'durian_vitamins': 'Various Vitamins, Polyphenols, Bioactive Compounds',
      'durian_post_harvest':
          'According to G. Khaksar 2024, Durian serves as a rich source of various vitamins, each playing a crucial role in maintaining overall health and well-being.Regular consumption of fresh fruits is essential due to their abundant content of health enhancing bioactive compounds, including polyphenols and vitamins. These bioactivecompounds, renowned for their antioxidant properties, play a vital role in neutralizing freeradicals, thereby reducing levels of oxidative stress. Consequently, processes detrimentalto the development of chronic diseases, such as cancer and coronary heart disease, can bemitigated.',
      'fig_name': 'Fig',
      'fig_vitamins': 'Iron, Calcium, Copper, Potassium, Magnesium',
      'fig_post_harvest':
          'According to K. Yadav, The fig belongs to the Mulberry family, which is said to be one of the oldest known fruit plants in human civilisation.  Figs  are  a  delectable  fruit  that  is  also  high  in  minerals  such  as  iron,  calcium,  copper, potassium, and magnesium. Traditionally fig plant was used as medicine to treat many health diseases.The common Fig is a moderate size deciduous plant/shrubbelonging Moraceae or mulberry family, with tiny twisted stock  and crowned  with uneven  splits. Moraceae, sometimes known as the mulberry family,is  among  the  biggest  angiosperm  genera  in  the  tropical  and  subtropical  zones of  the  earth  comprising around 800 woody plant, epiphytes, and shrubs species.',
      'guava_name': 'Guava',
      'guava_vitamins':
          'Vitamin C, Dietary Fiber, Potassium, Lycopene, Polyphenols',
      'guava_post_harvest':
          'According to A. Zaid, Guava is a tropical fruit renowned for its rich nutritional profile and medicinal properties, making it an important fruit crop in both local and global markets. Guava is also recognized for its exceptional nutritional value, being rich in dietary fiber, vitamins notably vitamin C, minerals potassium, magnesium, and antioxidants such as lycopene and polyphenols. The fruits low-calorie profile and balanced nutrient content make it suitable for consumption in a variety of dietary regimes, including those aimed at managing diabetes and cardiovascular health. In conclusion guava  combined with its robust nutritional composition, underscores its significance in agriculture, nutrition, and health.',
      'honeydew_name': 'Honey Dew',
      'honeydew_vitamins': 'Hybrids and non-hybrids',
      'honeydew_post_harvest':
          'According to G. Lester, Honey Dew melons, hybrids and non-hybrids, are ready to eat when the peel turns pale green to cream colored and the surface feels waxy. The blossom-end gives when pressed with the thumb and they have a pleasant aroma. Less ripe and cold melons have little aroma. The majority of Honey Dew melons have green-flesh, but specialty fruit can have gold, orange, or pink-flesh. ',
      'jackfruit_name': 'Jack Fruit',
      'jackfruit_vitamins':
          'Carbohydrates, Protein, Starch, Calcium, Vitamins, Fatty Acids',
      'jackfruit_post_harvest':
          'According to S. Swami, Jackfruit Artocarpus heterophyllus Lam. is an ancient fruit and is consumed either raw or processed into different value-added products. Jackfruit seeds are normally discarded or steamed and eaten as a snack or used in some local dishes seed flour is used in some biscuit factories in various bakery products, etc. The use of jackfruit bulbs, seeds, and its other parts has also been reported since ancient times for their therapeutic qualities. The health benefits of jackfruit have been attributed to its wide range of physicochemical applications. It contains high levels of carbohydrates, protein, starch, calcium, vitamins, free sugar sucrose, fatty acids, ellagic acid, and amino acids like arginine, cystine, histidine, leucine, lysine, methionine, theanine, and tryptophan.',
      'kiwi_name': 'Kiwi',
      'kiwi_vitamins':
          'Vitamin C, Vitamin E, Flavonoids, Carotenoids, Minerals',
      'kiwi_post_harvest':
          'According to V. Pawar, Kiwi fruit native to Asia and has become worldwide due to its sensory and nutritional property. It contains high levels of bioactive compounds such as vitamin C, vitamin E, Flavonoids , caratonoids and minerals.Kiwi vines are dioecious, meaning that male and female flowers are borne on separate individuals. Generally, one male plant can facilate the pollination of three to eight female plants. The ellipsoidal kiwi fruit is a true berry and has furry brownish green skin. ',
      'lemon_name': 'Lemon',
      'lemon_vitamins': 'Flavonoids, L-ascorbic acid (Vitamin C)',
      'lemon_post_harvest':
          'According to S. Hussain 2024, Lemon is important for a healthy human skin but is also seemingly good for the mind. Consuming lemon or even inhaling its aroma aromatherapy effectively improves the mood and also lowers tension, nervousness, anxiety, tiredness, swelling, and lethargy. Lemon is also used in a many air sprays and cooling devices. Some people inhale lemon drops to improve their mental concentration attention, often by placing them on a handkerchief.Flavonoids such as erioctitrin, hesperidin, and diosmin, along with Lascorbic acid and water extract from lemon peel, present promising avenues for treating hypertension common in older individuals. Lemon consumption is associated with reduced blood cholesterol levels. Additionally, a combination of lemon juice and sugar showed the potential of lowering both diastolic and systolic blood pressure.',
      'mango_name': 'Mango',
      'mango_vitamins': 'Sugar, Protein, Fats, Vitamins',
      'mango_post_harvest':
          'According to Habib et al., mangoes provide 64-86 calories of energy. It contains sugar, protein, fats, and other nutrients. Mangoes are eaten fresh as a dessert and processed as pickles, jams, jellies, sauces, nectar, juices, cereal flakes, and chip. Generally, mangoes are edible at all stages of development, from the tiny set fruit to the mature ones. The nutritional value of mangoes depends on the variety and the developmental stage. In traditional systems of healing Mango, fruits are used to cure sunstroke, ophthalmia, eruption, intestinal disorder, infertility, and night blindness. The oil used in eczema. Seed kernel is used in hemorrhages and bleeding hemorrhoids. Seed can be applied to ulcers, bruises, leucorrhoea, and burns to treat diabetes, heartburn and vomiting, asthmatic cough, helminthiasis, chronic diarrhea, dysentery, menorrhagia, and hemoptysis.',
      'noni_name': 'Noni',
      'noni_vitamins': 'Flavonoids, Terpenoids, Alkaloids, Steroids, Vitamin C',
      'noni_post_harvest':
          'According to A. Saah, Morinda citrifolia, commonly called noni, has a long history as a medicinal plant and is reported to have a broad range of therapeutic effects, including antibacterial, antiviral, antifungal, antitumor, antihelmin, analgesic, hypotensive, anti-inflammatory, and immune enhancing effects.Photochemical analyses of ethanol and hexane extracts of noni fruit revealed the presence of flavonoids, terpenoids, alkaloids and steroids. Proximate composition of the noni fruit revealed a moisture content of 54.21, crude protein 2.18, crude fat 3.25, crude fiber 4.49, ash 0.73 and carbohydrate 35.14. The Vitamin C content was estimated using iodometric titration and found to be 134.10 mg/100g. This suggests that the noni fruit can if consumed can help promote good health.',
      'orange_name': 'Orange',
      'orange_vitamins': 'Flavonoids, Vitamin C',
      'orange_post_harvest':
          'According to S. Shuklah, Orange Citrus reticulata Blanco is a evergreen tree belongs to family Rutaceae with chromosome number. Orange is a winter fruit. Due to irrestible vivid colour, captivating taste and flavour, mandarin orange is one of the most well liked citrus fruit. Mandarin, Citrus reticulata refers to looseskinned oranges. The orange fruit is a hesperidium. This is considered to be a native of tropical and sub-tropical Asia particularly south eastern Asia and Philippines. Oranges are extensively cultivated in tropical and subtropical climatic areas in favor of their scrumptious sweet fruit which is peeled or cut and eaten whole or juice which is used either fresh or processed to get squash, ready-toserve beverages, cordial and nectar.',
      'papaya_name': 'Papaya',
      'papaya_vitamins': 'Vitamin A, Vitamin B, Vitamin C, Papain, Chymopapain',
      'papaya_post_harvest':
          'According to R. Kumar, Papaya is a popular and important fruit in tropical and subtropical parts of the world. The fruit is consumed worldwide as fresh fruit and vegetable or used as processed product. The fruit is healthy and delicious and the whole plant parts including fruit, root, bark, peel, seeds and pulp are also known to have medicinal properties. The many benefits of papaya are owed due to high content of vitamin A, B and C, proteolytic enzymes like papain and chymopapain which have antiviral, antifungal and antibacterial properties. During the last few years, major insight has been achieved regarding the biological activity and medicinal application of papaya and now it is considered a valuable neutraceutical fruit plant. In the present review, nutritional value of the fruit and medicinal properties of its various parts have been discussed to provide collective information on this multipurpose commercial fruit crop. ',
      'rambutan_name': 'Rambutan',
      'rambutan_vitamins': 'Vitamin C',
      'rambutan_post_harvest':
          ' According to P. Bhattacharjee, Rambutan is a medium-sized evergreen tree growing up to 12 15 m in height. Fruits are classified as berries, they are ovoid in shape, very juicy , mildly acidic due to high vitamin C content, and have a thick skin up to 4mm, approx. 50 w/w with soft hairs or spines. The name of this fruit comes from the vernacular Malayan language word Rambut, which means Hair in English, and refers to the soft thorny hairy overgrowth that covers the fruit surface. The pulp of the luscious fruits is white in colour, translucent, sweet to tangy in flavour, and contains a medium-sized seed. ',
      'strawberry_name': 'Strawberry',
      'strawberry_vitamins': 'Vitamin C, Fiber, Antioxidants',
      'strawberry_post_harvest':
          'According K. Sharma, Balanced nutrition is needed by delicate strawberry plants so its important to maintain the nutritional status for better growth, yield and quality of strawberry fruits. Although strawberries are a highly perishable fruit and cannot be kept for an extended amount of time, several wrapping techniques have preserved the fruit’s quality when kept at ambient temperature. Disorder like albinism can be corrected with proper spacing and spray of borax and GA3. One step toward helping farmers maximize their profits is the notion of waste utilization in horticultural crops. Therefore, the goal of doubling farmer’s income by minimizing their after-harvest losses and enhancing the demand of perishable cultivable fruit crops is achieved. ',
      'tomato_name': 'Tomato',
      'tomato_vitamins': 'Vitamins, Carotenoids, Minerals, Bioactive compounds',
      'tomato_post_harvest':
          'According to S. Vats,  Tomato, a widely consumed  crop, offers a real potential to combat human nutritional deficiencies. Tomatoes are rich in micronutrients and other bioactive compounds including vitamins, carotenoids, and minerals that are known to be essential or beneficial for human health. This review highlights the current state of the art in the molecular understanding of the nutritional aspects, conventional and molecular breeding efforts, and biofortification studies undertaken to improve the nutritional content and quality of tomato. Transcriptomics and metabolomics studies, which offer a deeper understanding of the molecular regulation of the tomato’s nutrients, are discussed. The potential uses of the wastes from the tomato processing industry.',
      'watermelon_name': 'Water Melon',
      'watermelon_vitamins':
          'Vitamin C, Pantothenic Acid, Copper, Biotin, Vitamin A, B6 & B1',
      'watermelon_post_harvest':
          'According to M. Nadeem, Watermelon is recognized all over the world as a delicious fruit that quenches the thirst that many people consume in the summer heat. There are about 1,200 varieties of watermelon. Watermelons are loaded with plentiful nutrients, such as vitamin C, pantothenic acid, copper, biotin, vitamin A, and vitamins B6 & B1. Watermelon is processed to manufacture various value-added foods, such as cookies, cakes, juice, jam, cadies, and biscuits. In this review, we discuss pre- and postharvest factors affecting watermelon nutritional concentration and antioxidant profile. Prominent factors comprise genetic and environmental constraints, processing and postharvest storage conditions, chemical treatments, temperature and humidity, packaging, and food processing conditions. ',
      'cucumber_name': 'Cucumber',
      'cucumber_vitamins':
          'Vitamins, Minerals, Phenols, Flavonoids, Carotenoids',
      'cucumber_post_harvest':
          'According to H. Javid, Cucumber fruits are an important part of the human diet, often used in salads, pickles, and sauces, due to their nutritious qualities and health benefits. They are a good source of vitamins, minerals, soluble carbohydrates, proteins, etc. The leaves, flowers, seeds, fruits, and bark of cucumber are rich in various phytoconstituents, including phenols, glycosides, alkaloids, flavonoids, carotenoids, tannins, steroids, terpenoids, phytosterols, phytoestrogens, saponins, minerals, proteins, carbohydrates, resins, and vitamins. Cucumbers are traditionally used to treat a variety of diseases, including high blood pressure, blood sugar issues, cancer, high cholesterol, kidney stones, constipation, Alzheimers disease, eczema, hypertension, atherosclerosis, and diabetes-related problems. The therapeutic/pharmaceutical value of cucumbers may be attributed to their laxative, antioxidant, anti-diabetic, analgesic, anti-hepatotoxic, anti-diarrheal, anti-fungal, anti-bacterial, thrombolytic, anti-ulcer, anti-inflammatory, cytotoxic, free radical scavenging, and wound-healing properties.',
      'grapes_name': 'Grapes',
      'grapes_vitamins': 'Polyphenols, Antioxidants',
      'grapes_post_harvest':
          'According to H. Hou, Grapes are considered one of the most important economic horticultural crops in the world. They are not only a popular fresh fruit but also serve as raw materials for wine, grape juice, and raisins, driving international trade and economic development. In addition to their unique flavor, grapes offer a variety of health benefits. These include cancer prevention, diabetes prevention, cardiovascular disease prevention, and anti-inflammatory properties. The “French paradox” is a remarkable phenomenon that demonstrates the unexpectedly low incidence of cardiovascular disease among the French, despite their consumption of high-fat, high-cholesterol cuisine . This phenomenon has garnered considerable attention and interest in the realm of health and nutrition research, particularly due to the widely held belief that the red wine consumed by the French contains beneficial components for cardiovascular health.',

      // UI Keys (should be in AppLocalizations directly)
      'fruit_info_title': 'Fruit Information',
      'search_fruits_label': 'Search Fruits',
      'key_info_label': 'Key Information:',
      'tap_for_full_info': 'Tap card for full info',
      'close_button': 'Close',
    };

    // 3. REFRACTOR allCards to use KEYS instead of hardcoded strings
    allFruitData = [
      {
        'imagePath': 'assets/apple.png',
        'vegetableKey': 'apple_name',
        'keyVitaminsKey': 'apple_vitamins',
        'postHarvestKey': 'apple_post_harvest',
      },
      {
        'imagePath': 'assets/banana.png',
        'vegetableKey': 'banana_name',
        'keyVitaminsKey': 'banana_vitamins',
        'postHarvestKey': 'banana_post_harvest',
      },
      {
        'imagePath': 'assets/calamansi.png',
        'vegetableKey': 'calamansi_name',
        'keyVitaminsKey': 'calamansi_vitamins',
        'postHarvestKey': 'calamansi_post_harvest',
      },
      {
        'imagePath': 'assets/durian.png',
        'vegetableKey': 'durian_name',
        'keyVitaminsKey': 'durian_vitamins',
        'postHarvestKey': 'durian_post_harvest',
      },
      {
        'imagePath': 'assets/fig.png',
        'vegetableKey': 'fig_name',
        'keyVitaminsKey': 'fig_vitamins',
        'postHarvestKey': 'fig_post_harvest',
      },
      {
        'imagePath': 'assets/guava.png',
        'vegetableKey': 'guava_name',
        'keyVitaminsKey': 'guava_vitamins',
        'postHarvestKey': 'guava_post_harvest',
      },
      {
        'imagePath': 'assets/honeydew.png',
        'vegetableKey': 'honeydew_name',
        'keyVitaminsKey': 'honeydew_vitamins',
        'postHarvestKey': 'honeydew_post_harvest',
      },
      {
        'imagePath': 'assets/jackfruit.png',
        'vegetableKey': 'jackfruit_name',
        'keyVitaminsKey': 'jackfruit_vitamins',
        'postHarvestKey': 'jackfruit_post_harvest',
      },
      {
        'imagePath': 'assets/kiwi.png',
        'vegetableKey': 'kiwi_name',
        'keyVitaminsKey': 'kiwi_vitamins',
        'postHarvestKey': 'kiwi_post_harvest',
      },
      {
        'imagePath': 'assets/lemon.png',
        'vegetableKey': 'lemon_name',
        'keyVitaminsKey': 'lemon_vitamins',
        'postHarvestKey': 'lemon_post_harvest',
      },
      {
        'imagePath': 'assets/mango.png',
        'vegetableKey': 'mango_name',
        'keyVitaminsKey': 'mango_vitamins',
        'postHarvestKey': 'mango_post_harvest',
      },
      {
        'imagePath': 'assets/noni.png',
        'vegetableKey': 'noni_name',
        'keyVitaminsKey': 'noni_vitamins',
        'postHarvestKey': 'noni_post_harvest',
      },
      {
        'imagePath': 'assets/orange.png',
        'vegetableKey': 'orange_name',
        'keyVitaminsKey': 'orange_vitamins',
        'postHarvestKey': 'orange_post_harvest',
      },
      {
        'imagePath': 'assets/papaya.png',
        'vegetableKey': 'papaya_name',
        'keyVitaminsKey': 'papaya_vitamins',
        'postHarvestKey': 'papaya_post_harvest',
      },
      {
        'imagePath': 'assets/rambutan.png',
        'vegetableKey': 'rambutan_name',
        'keyVitaminsKey': 'rambutan_vitamins',
        'postHarvestKey': 'rambutan_post_harvest',
      },
      {
        'imagePath': 'assets/strawberry.png',
        'vegetableKey': 'strawberry_name',
        'keyVitaminsKey': 'strawberry_vitamins',
        'postHarvestKey': 'strawberry_post_harvest',
      },
      {
        'imagePath': 'assets/tomato.png',
        'vegetableKey': 'tomato_name',
        'keyVitaminsKey': 'tomato_vitamins',
        'postHarvestKey': 'tomato_post_harvest',
      },
      {
        'imagePath': 'assets/watermelon.png',
        'vegetableKey': 'watermelon_name',
        'keyVitaminsKey': 'watermelon_vitamins',
        'postHarvestKey': 'watermelon_post_harvest',
      },
      {
        'imagePath': 'assets/cucumber.png',
        'vegetableKey': 'cucumber_name',
        'keyVitaminsKey': 'cucumber_vitamins',
        'postHarvestKey': 'cucumber_post_harvest',
      },
      {
        'imagePath': 'assets/grapes.png',
        'vegetableKey': 'grapes_name',
        'keyVitaminsKey': 'grapes_vitamins',
        'postHarvestKey': 'grapes_post_harvest',
      },
    ];

    filteredFruitData = List.from(allFruitData);
    _searchController.addListener(_filterCards);
  }

  // New: Call filterCards whenever the context dependencies change (e.g., language switch)
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _filterCards();
  }

  // 🔥 CORE FIX APPLIED HERE
  void _filterCards() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredFruitData = allFruitData.where((data) {
        final fruitKey = data['vegetableKey'] as String;

        // 1. Get the English name (e.g., "apple") for English searching
        final englishName = _englishData[fruitKey]?.toLowerCase() ?? '';

        // 2. Get the currently localized name (e.g., "mansanas") for Tagalog searching
        final localizedName =
            _getLocalizedText(fruitKey, context).toLowerCase();

        // 3. Filter based on whether the query matches the English name OR the Localized name.
        return englishName.contains(query) || localizedName.contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterCards);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get localizations instance
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        // 4. TRANSLATE APP BAR TITLE
        title: Text(localizations.translate('fruit_info_title')),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                // 4. TRANSLATE SEARCH LABEL
                labelText: localizations.translate('search_fruits_label'),
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredFruitData.length,
              itemBuilder: (context, index) {
                final data = filteredFruitData[index];
                return HarvestCard(
                  imagePath: data['imagePath'],
                  vegetableKey: data['vegetableKey'],
                  keyVitaminsKey: data['keyVitaminsKey'],
                  postHarvestKey: data['postHarvestKey'],
                  localizedTextGetter: _getLocalizedText, // Pass the function
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ----------------------------------------------------------------------
// HarvestCard component remains the same
// ----------------------------------------------------------------------

class HarvestCard extends StatefulWidget {
  final String imagePath;
  final String vegetableKey;
  final String keyVitaminsKey;
  final String postHarvestKey;
  // New: Function type to get localized text, injected from state
  final String Function(String key, BuildContext context) localizedTextGetter;

  const HarvestCard({
    required this.imagePath,
    required this.vegetableKey,
    required this.keyVitaminsKey,
    required this.postHarvestKey,
    required this.localizedTextGetter,
    Key? key,
  }) : super(key: key);

  @override
  State<HarvestCard> createState() => _HarvestCardState();
}

class _HarvestCardState extends State<HarvestCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    // 5. FETCH TRANSLATED DATA
    final localizations = AppLocalizations.of(context);
    final vegetable = widget.localizedTextGetter(widget.vegetableKey, context);
    final keyVitamins =
        widget.localizedTextGetter(widget.keyVitaminsKey, context);
    final postHarvest =
        widget.localizedTextGetter(widget.postHarvestKey, context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: _isPressed ? Colors.grey.shade300 : Colors.grey.shade400,
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: () {
          // Show dialog for detailed info
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text(vegetable),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Display the key vitamins at the top of the dialog
                    if (keyVitamins.isNotEmpty &&
                        keyVitamins != 'Not explicitly listed')
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 5. TRANSLATE DIALOG KEY INFO TITLE
                            Text(
                              localizations.translate('key_info_label'),
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              keyVitamins,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade700,
                                fontStyle: FontStyle.italic,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                            const Divider(height: 20),
                          ],
                        ),
                      ),
                    // Main Post-Harvest Information
                    Text(postHarvest, textAlign: TextAlign.justify),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  // 5. TRANSLATE DIALOG CLOSE BUTTON
                  child: Text(localizations.translate('close_button')),
                ),
              ],
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    widget.imagePath,
                    height: 120,
                    width: 120,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                vegetable, // Use translated text
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.green[800],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),

              // 👇 KEY INFORMATION BOX IN THE CARD
              if (keyVitamins.isNotEmpty &&
                  keyVitamins != 'Not explicitly listed')
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.lightGreen.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.lightGreen.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 5. TRANSLATE CARD KEY INFO TITLE
                      Text(
                        localizations.translate('key_info_label'),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        keyVitamins, // Use translated text
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              // 👆 END NEW KEY INFORMATION BOX

              const Divider(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  // 5. TRANSLATE TAP HINT TEXT
                  localizations.translate('tap_for_full_info'),
                  style: TextStyle(
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey[600],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
