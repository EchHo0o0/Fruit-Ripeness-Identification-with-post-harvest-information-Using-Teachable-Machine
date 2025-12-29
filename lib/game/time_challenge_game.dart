// time_challenge_game.dart (FINAL UPDATED CODE with ALL Null Safety Fixes)

import 'package:flutter/material.dart';
import 'dart:async'; // For Timer
import 'dart:math'; // For Random
import '../coin_pocket_manager.dart'; // Ensure this path is correct
// 🎯 NEW: Import your AppLocalizations class
import '../home/app_localizations.dart';

class TimeChallengeGame extends StatefulWidget {
  final String userId;

  // ✅ CONSTRUCTOR CHECK: userId is required and non-nullable
  const TimeChallengeGame({Key? key, required this.userId}) : super(key: key);

  @override
  _TimeChallengeGameState createState() => _TimeChallengeGameState();
}

class _TimeChallengeGameState extends State<TimeChallengeGame>
    with SingleTickerProviderStateMixin {
  // --- 1. GAME DATA ---
  final List<String> _allFruits = [
    'apple.png',
    'banana.png',
    'orange.png',
    'strawberry.png',
    'watermelon.png',
    'lemon.png',
    'mango.png',
    'guava.png',
    'kiwi.png',
    'papaya.png',
    'calamansi.png',
    'durian.png',
    'jackfruit.png',
    'rambutan.png',
    'tomato.png',
    'cucumber.png',
    'grapes.png',
    'fig.png',
    'noni.png',
  ];

  // Harvesting Steps (Hard Mode - English Keys)
  final List<Map<String, dynamic>> _harvestingStepsHardMode = [
    {'image_name': 'check.png', 'answer_key': 'step_check_key'},
    {'image_name': 'reaping.png', 'answer_key': 'step_reaping_key'},
    {'image_name': 'thereshing.png', 'answer_key': 'step_threshing_key'},
    {'image_name': 'cleaning.png', 'answer_key': 'step_cleaning_key'},
    {'image_name': 'bagging.png', 'answer_key': 'step_bagging_key'},
    {'image_name': 'storage.png', 'answer_key': 'step_storage_key'},
  ];

  // 🎯 NEW: Mapping for both English and Tagalog answers for Hard Mode
  final Map<String, String> _englishHarvestingAnswers = {
    'step_check_key': 'check',
    'step_reaping_key': 'reaping',
    'step_threshing_key': 'threshing',
    'step_cleaning_key': 'cleaning',
    'step_bagging_key': 'bagging',
    'step_storage_key': 'storage',
  };

  // 🎯 NEW: Tagalog answers for Hard Mode (Requires corresponding keys in AppLocalizations)
  final Map<String, String> _tagalogHarvestingAnswers = {
    'step_check_key': 'suriin',
    'step_reaping_key': 'pag-ani', // General term for reaping/harvesting
    'step_threshing_key': 'paggiik',
    'step_cleaning_key': 'paglilinis',
    'step_bagging_key': 'pagbabalot',
    'step_storage_key': 'imbakan',
  };

  // All possible fruit and step names (normalized) for answer checking.
  final List<String> _allFruitAndStepNames = [
    'apple', 'banana', 'orange', 'strawberry', 'watermelon', 'lemon',
    'mango', 'guava', 'kiwi', 'papaya', 'calamansi', 'durian',
    'jackfruit', 'rambutan', 'tomato', 'cucumber', 'grapes', 'fig', 'noni',
    'check', 'reaping', 'threshing', 'cleaning', 'bagging',
    'storage', // English steps
    'mansanas', 'saging', 'dalandan', 'strawberry', 'pakwan', 'lemon',
    'mangga', 'bayabas', 'kiwi', 'papaya', 'kalamansi', 'durian',
    'langka', 'rambutan', 'kamatis', 'pipino', 'ubas', 'igos', 'noni',
    'suriin', 'pag-ani', 'paggiik', 'paglilinis', 'pagbabalot', 'imbakan',
  ];

  // UPDATED REWARD STRUCTURE: Easy 5, Medium 10, Hard 15
  final Map<String, Map<String, int>> _difficultySettings = {
    'Easy': {'duration': 60, 'cost': 20, 'reward': 5},
    'Medium': {'duration': 40, 'cost': 100, 'reward': 10},
    'Hard': {'duration': 30, 'cost': 200, 'reward': 15},
  };

  // --- 2. GAME STATE VARIABLES ---
  late List<String> _shuffledEasyMediumItems;
  late List<Map<String, dynamic>> _shuffledHardItems;
  String _currentDifficulty = '';
  int _currentIndex = 0;
  int _score = 0;
  String? _feedbackMessage;
  bool _isAnswerCorrect = false;
  bool _gameStarted = false;
  int _initialCoins = 0;

  Timer? _timer;
  int _remainingTime = 0;

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  List<String> _currentOptions = [];
  String? _selectedOption;
  final TextEditingController _answerController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // ✅ Safety: Load coins immediately
    _loadInitialCoins();
    _shuffledEasyMediumItems = List.from(_allFruits)..shuffle(Random());
    _shuffledHardItems = List.from(_harvestingStepsHardMode)..shuffle(Random());

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticOut,
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animationController.dispose();
    _answerController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialCoins() async {
    _initialCoins = await CoinPocketManager.getCoins(widget.userId);
    if (mounted) {
      setState(() {});
    }
  }

  // --- 3. HELPER METHODS ---

  // 🎯 MODIFIED: Normalization helper
  String _normalizeString(String? input) {
    if (input == null) return '';
    return input.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
  }

  // 🎯 UPDATED: Method to find the correct answer for display based on locale/type
  String _getCorrectAnswer(String assetName) {
    // 1. Remove file extension and normalize (e.g., 'apple.png' -> 'apple')
    String englishName = _normalizeString(assetName.replaceAll('.png', ''));

    // 2. Get the current language code
    final T_localizations = AppLocalizations.of(context);
    final currentLocale = T_localizations.currentLanguageCode;
    String translatedName = englishName; // Default to English

    // Check against the list of all normalized fruit names to find its Tagalog equivalent
    if (currentLocale == 'tl') {
      switch (englishName) {
        case 'apple':
          translatedName = 'mansanas';
          break;
        case 'banana':
          translatedName = 'saging';
          break;
        case 'orange':
          translatedName = 'dalandan';
          break;
        case 'watermelon':
          translatedName = 'pakwan';
          break;
        case 'mango':
          translatedName = 'mangga';
          break;
        case 'guava':
          translatedName = 'bayabas';
          break;
        case 'calamansi':
          translatedName = 'kalamansi';
          break;
        case 'jackfruit':
          translatedName = 'langka';
          break;
        case 'tomato':
          translatedName = 'kamatis';
          break;
        case 'cucumber':
          translatedName = 'pipino';
          break;
        case 'grapes':
          translatedName = 'ubas';
          break;
        case 'fig':
          translatedName = 'igos';
          break;
        // The remaining fruits are similar/same (strawberry, lemon, kiwi, papaya, durian, rambutan, noni)
        default:
          translatedName = englishName;
          break;
      }
    }

    // For Hard Mode Steps, the assetName is the step image name (e.g., 'check.png')
    // Find the corresponding English key and translate it if necessary.
    if (translatedName.contains('step_') || _currentDifficulty == 'Hard') {
      final stepKey = _harvestingStepsHardMode.firstWhere(
        (step) => step['image_name'] == assetName,
        orElse: () => {'answer_key': englishName},
      )['answer_key'];

      // 🔥 Note: The lookup here can use '!' because `stepKey` should be guaranteed
      // by the `_harvestingStepsHardMode` list structure if the asset name exists.
      if (currentLocale == 'tl' &&
          _tagalogHarvestingAnswers.containsKey(stepKey)) {
        return _tagalogHarvestingAnswers[stepKey]!;
      } else if (_englishHarvestingAnswers.containsKey(stepKey)) {
        return _englishHarvestingAnswers[stepKey]!;
      }
    }

    return translatedName;
  }

  // Back button confirmation logic (MODIFIED for localization)
  Future<bool> _onWillPop() async {
    final T = AppLocalizations.of(context).translate;

    if (!_gameStarted || _remainingTime <= 0) {
      _timer?.cancel();
      return true;
    }

    _timer?.cancel(); // Pause the timer while the dialog is open

    return (await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(T('quit_challenge_title')),
            content: Text(T('quit_challenge_message')),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  _startTimer(); // Resume the timer
                  Navigator.of(context).pop(false); // Stay
                },
                child: Text(T('no_continue')),
              ),
              TextButton(
                onPressed: () {
                  _timer?.cancel();
                  Navigator.of(context).pop(true); // Allow pop
                },
                child: Text(T('yes_quit')),
              ),
            ],
          ),
        )) ??
        false;
  }

  // Confirmation Dialog (MODIFIED for localization)
  void _showConfirmationDialog(String difficulty) {
    final T = AppLocalizations.of(context).translate;
    final settings = _difficultySettings[difficulty]!;
    int cost = settings['cost']!;
    int duration = settings['duration']!;
    int reward = settings['reward']!;

    String translatedDifficulty = difficulty == 'Easy'
        ? T('easy_difficulty')
        : difficulty == 'Medium'
            ? T('medium_difficulty')
            : T('hard_difficulty');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(T('start_challenge_title')
              .replaceAll('{difficulty}', translatedDifficulty)),
          content: Text(T('start_challenge_message')
              .replaceAll('{cost}', cost.toString())
              .replaceAll('{duration}', duration.toString())
              .replaceAll('{reward}', reward.toString())),
          actions: <Widget>[
            TextButton(
              child: Text(T('cancel')),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(T('start')),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
                _startGame(difficulty); // Start the game
              },
            ),
          ],
        );
      },
    );
  }

  void _startGame(String difficulty) async {
    final T = AppLocalizations.of(context).translate;
    final settings = _difficultySettings[difficulty]!;
    int cost = settings['cost']!;
    int duration = settings['duration']!;

    bool canDeduct = await CoinPocketManager.deductCoins(widget.userId, cost);
    String translatedDifficulty = difficulty == 'Easy'
        ? T('easy_difficulty')
        : difficulty == 'Medium'
            ? T('medium_difficulty')
            : T('hard_difficulty');

    if (canDeduct) {
      setState(() {
        _currentDifficulty = difficulty;
        _gameStarted = true;
        _score = 0;
        _currentIndex = 0;
        _remainingTime = duration;
        _feedbackMessage = null;
        _isAnswerCorrect = false;
        _selectedOption = null;
        _answerController.clear();

        if (difficulty == 'Hard') {
          _shuffledHardItems = List.from(_harvestingStepsHardMode)
            ..shuffle(Random());
          _setHardModeQuestion();
        } else {
          _shuffledEasyMediumItems = List.from(_allFruits)..shuffle(Random());
        }
        // ✅ Reload initial coins to reflect deduction
        _loadInitialCoins();
        _startTimer();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(T('challenge_started_snackbar')
                .replaceAll('{difficulty}', translatedDifficulty)
                .replaceAll('{cost}', cost.toString()))),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(T('not_enough_coins_snackbar')
              .replaceAll('{difficulty}', translatedDifficulty)
              .replaceAll('{cost}', cost.toString())),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          _endGame();
        }
      });
    });
  }

  void _endGame() {
    _timer?.cancel();
    if (mounted) {
      setState(() {
        _gameStarted = false;
      });
      // ✅ Reload coins here so the home screen sees the latest value
      _loadInitialCoins();
      _showGameResultDialog();
    }
  }

  // MODIFIED: Generate incorrect options with null safety
  List<String> _generateIncorrectOptions(String correctAnswerKey, int count) {
    final currentLocale = AppLocalizations.of(context).currentLanguageCode;
    List<String> incorrects = [];

    // Get the list of all hard mode answer keys
    List<String> allKeys = _englishHarvestingAnswers.keys.toList();
    List<String> pool = List.from(allKeys)..remove(correctAnswerKey);
    pool.shuffle(Random());

    // Take the 'count' number of incorrect keys
    for (int i = 0; i < count && i < pool.length; i++) {
      // 🔥 FIX: Use null-aware operator (?? '') to safely access map values
      String translatedOption = currentLocale == 'tl'
          ? (_tagalogHarvestingAnswers[pool[i]] ?? '')
          : (_englishHarvestingAnswers[pool[i]] ?? '');

      // Only add if the translation resulted in a non-empty string
      if (translatedOption.isNotEmpty) {
        incorrects.add(translatedOption);
      }
    }
    return incorrects;
  }

  // MODIFIED: Set Hard Mode Question with null safety
  void _setHardModeQuestion() {
    final currentLocale = AppLocalizations.of(context).currentLanguageCode;

    if (_currentIndex < _shuffledHardItems.length) {
      final currentStep = _shuffledHardItems[_currentIndex];
      final String correctAnswerKey = currentStep['answer_key'];

      // Get the correct answer string based on the current locale
      String correctOption;
      // 🔥 FIX: Use null-aware operator (?? '') to safely access map values
      if (currentLocale == 'tl') {
        correctOption =
            _tagalogHarvestingAnswers[correctAnswerKey] ?? 'MISSING_TL';
      } else {
        correctOption =
            _englishHarvestingAnswers[correctAnswerKey] ?? 'MISSING_EN';
      }

      List<String> options = [];
      // Ensure the correct option is added, even if it's the missing fallback
      options.add(correctOption);
      options.addAll(_generateIncorrectOptions(correctAnswerKey, 2));
      options.shuffle(Random());

      setState(() {
        _currentOptions = options.map((o) => o.toUpperCase()).toList();
        _selectedOption = null;
      });
    }
  }

  // 🎯 FIX APPLIED HERE: Safely accessing map values using ?? ''
  // Method to check the user's answer against both English and Tagalog correct answers
  bool _isAnswerCorrectUniversal(String userAnswer, String assetName) {
    final normalizedUserAnswer = _normalizeString(userAnswer);

    // For Easy/Medium (Fruits): Check against the image name (English) AND the Tagalog equivalent
    if (_currentDifficulty != 'Hard') {
      String englishAnswer = _normalizeString(assetName.replaceAll('.png', ''));
      // We get the tagalog name but normalize it to handle potential spacing issues
      String tagalogAnswer = _normalizeString(_getCorrectAnswer(assetName));

      // The key: check if the normalized user answer matches EITHER English or Tagalog
      return normalizedUserAnswer == englishAnswer ||
          normalizedUserAnswer == tagalogAnswer;
    }

    // For Hard (Steps): Check against all known English and Tagalog step names
    final String answerKey = _shuffledHardItems[_currentIndex]['answer_key'];

    // 🔥 FIX: Use null-aware operator (?? '') to safely access map values
    final String englishAnswer =
        _normalizeString(_englishHarvestingAnswers[answerKey] ?? '');
    final String tagalogAnswer =
        _normalizeString(_tagalogHarvestingAnswers[answerKey] ?? '');

    return normalizedUserAnswer == englishAnswer ||
        normalizedUserAnswer == tagalogAnswer;
  }

  void _checkAnswer({String? selectedAnswer}) async {
    if (!_gameStarted || _remainingTime <= 0) return;

    final T = AppLocalizations.of(context).translate;

    // Safety check for null selectedAnswer in Hard mode, though it should be prevented by button logic
    String userAnswer;
    if (_currentDifficulty == 'Hard') {
      if (selectedAnswer == null) return;
      userAnswer = selectedAnswer;
    } else {
      userAnswer = _answerController.text;
    }

    if (userAnswer.isEmpty) {
      setState(() {
        _feedbackMessage = T('please_answer');
      });
      return;
    }

    // Determine the asset name for the current item
    String currentAsset;
    if (_currentDifficulty == 'Hard') {
      currentAsset = _shuffledHardItems[_currentIndex]['image_name'];
    } else {
      currentAsset = _shuffledEasyMediumItems[
          _currentIndex % _shuffledEasyMediumItems.length];
    }

    final bool isCorrect = _isAnswerCorrectUniversal(userAnswer, currentAsset);
    // Get the correct name for display (must be in the current locale for feedback)
    String correctName = _getCorrectAnswer(currentAsset);

    setState(() {
      if (isCorrect) {
        _score++;
        _feedbackMessage = T('correct_answer');
        _isAnswerCorrect = true;
        // The coin management is correct, adding to the total.
        CoinPocketManager.addCoins(
            widget.userId, _difficultySettings[_currentDifficulty]!['reward']!);
        _loadInitialCoins();
      } else {
        _feedbackMessage = T('incorrect_answer_is')
            .replaceAll('{correct_answer}', correctName.toUpperCase());
        _isAnswerCorrect = false;
      }
    });

    await Future.delayed(const Duration(milliseconds: 800));

    if (!mounted) return;

    setState(() {
      _answerController.clear();
      _selectedOption = null;
      _feedbackMessage = null;
      _isAnswerCorrect = false;

      _currentIndex++;
      if (_currentDifficulty == 'Hard') {
        if (_currentIndex >= _shuffledHardItems.length) {
          _shuffledHardItems.shuffle(Random());
          _currentIndex = 0;
        }
        _setHardModeQuestion();
      } else {
        if (_currentIndex >= _shuffledEasyMediumItems.length) {
          _shuffledEasyMediumItems.shuffle(Random());
          _currentIndex = 0;
        }
      }
    });
  }

  // Game Result Dialog (MODIFIED for localization)
  void _showGameResultDialog() {
    final T = AppLocalizations.of(context).translate;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        final reward = _difficultySettings[_currentDifficulty]!['reward']!;
        final totalEarnedCoins = _score * reward;

        if (_score > 0) {
          _animationController.forward(from: 0.0);
        }

        return AlertDialog(
          title: Text(T('time_up')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(T('game_result_message')
                  .replaceAll('{score}', _score.toString())
                  .replaceAll('{total_coins}', totalEarnedCoins.toString())),
              if (_score > 0)
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      // Triggering a celebratory GIF image
                      Image.asset(
                        'assets/congratulations.gif',
                        height: 100,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.star,
                                size: 80, color: Colors.amber),
                      ),
                      Text(
                        T('congratulations'),
                        style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.green),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text(T('play_again')),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _gameStarted = false;
                });
              },
            ),
            TextButton(
              child: Text(T('back_to_home')),
              onPressed: () {
                _timer?.cancel();
                Navigator.of(context).pop();
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final T = AppLocalizations.of(context).translate;
    String currentImageFileName;

    if (_gameStarted && _currentDifficulty == 'Hard') {
      if (_shuffledHardItems.isEmpty) {
        currentImageFileName = 'placeholder_image.png';
      } else {
        currentImageFileName =
            _shuffledHardItems[_currentIndex % _shuffledHardItems.length]
                ['image_name'];
      }
    } else if (_gameStarted) {
      if (_shuffledEasyMediumItems.isEmpty) {
        currentImageFileName = 'placeholder_image.png';
      } else {
        currentImageFileName = _shuffledEasyMediumItems[
            _currentIndex % _shuffledEasyMediumItems.length];
      }
    } else {
      // Default placeholder image for the stage selection screen (if needed)
      currentImageFileName = 'apple.png';
    }
    String imagePath = 'assets/$currentImageFileName';

    // Wrapping the Scaffold with WillPopScope
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text(_gameStarted
              ? T('challenge_title').replaceAll(
                  '{difficulty}',
                  _currentDifficulty == 'Easy'
                      ? T('easy_difficulty')
                      : _currentDifficulty == 'Medium'
                          ? T('medium_difficulty')
                          : T('hard_difficulty'))
              : T('time_challenge_title')),
          backgroundColor: Colors.blue,
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Center(
                child: Row(
                  children: [
                    const Icon(Icons.monetization_on, color: Colors.amber),
                    const SizedBox(width: 5),
                    Text(
                      '$_initialCoins',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        body: _gameStarted
            ? _buildGameContent(imagePath)
            : _buildStageSelection(),
      ),
    );
  }

  // Stage Selection Screen (MODIFIED for localization)
  Widget _buildStageSelection() {
    final T = AppLocalizations.of(context).translate;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(10.0),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              T('choose_challenge'),
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),

            // Instruction Card (Localized)
            Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(horizontal: 10.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      T('game_instructions_title'),
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      T('game_instructions_desc'),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),
            _buildDifficultyButton('Easy'),
            const SizedBox(height: 25),
            _buildDifficultyButton('Medium'),
            const SizedBox(height: 25),
            _buildDifficultyButton('Hard'),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Difficulty Button (MODIFIED for localization)
  Widget _buildDifficultyButton(String difficulty) {
    final T = AppLocalizations.of(context).translate;
    final settings = _difficultySettings[difficulty]!;
    int cost = settings['cost']!;
    int reward = settings['reward']!;

    String translatedDifficulty = difficulty == 'Easy'
        ? T('easy_difficulty')
        : difficulty == 'Medium'
            ? T('medium_difficulty')
            : T('hard_difficulty');

    Color buttonColor;
    if (difficulty == 'Easy') {
      buttonColor = Colors.green;
    } else if (difficulty == 'Medium') {
      buttonColor = Colors.orange;
    } else {
      buttonColor = Colors.red;
    }

    return SizedBox(
      width: 280,
      height: 60,
      child: ElevatedButton(
        onPressed: () => _showConfirmationDialog(difficulty),
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          foregroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 3,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              T('difficulty_button_main')
                  .replaceAll('{difficulty}', translatedDifficulty)
                  .replaceAll('{cost}', cost.toString()),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              T('difficulty_button_sub')
                  .replaceAll('{reward}', reward.toString()),
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  // Game Content (MODIFIED for localization)
  Widget _buildGameContent(String imagePath) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: _buildGameColumn(imagePath),
    );
  }

  Widget _buildGameColumn(String imagePath) {
    final T = AppLocalizations.of(context).translate;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        // Timer and Score
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(T('score').replaceAll('{score}', _score.toString()),
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(
              T('time').replaceAll('{time}', _remainingTime.toString()),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: _remainingTime <= 10 ? Colors.red : Colors.green,
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),

        // Image Display
        Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              imagePath,
              height: 200,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => Column(
                children: [
                  const SizedBox(height: 50),
                  const Icon(Icons.broken_image, size: 80, color: Colors.grey),
                  Text(T('image_not_found'), textAlign: TextAlign.center),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 15),

        // Hard Mode (Multiple Choice) vs Easy/Medium Mode (Text Input)
        if (_currentDifficulty == 'Hard')
          _buildHardModeInput()
        else
          _buildEasyMediumInput(),

        const SizedBox(height: 10),

        // Feedback Message
        if (_feedbackMessage != null)
          Text(
            _feedbackMessage!,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: _isAnswerCorrect ? Colors.green : Colors.red,
            ),
          ),
      ],
    );
  }

  // Easy/Medium Input (MODIFIED for localization)
  Widget _buildEasyMediumInput() {
    final T = AppLocalizations.of(context).translate;

    return Column(
      children: [
        TextField(
          controller: _answerController,
          decoration: InputDecoration(
            labelText: T('type_item_name'),
            border: const OutlineInputBorder(),
          ),
          onSubmitted: (_) => _checkAnswer(),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: _checkAnswer,
          child: Text(T('submit_answer')),
        ),
      ],
    );
  }

  // Hard Mode Input (MODIFIED for localization)
  Widget _buildHardModeInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: _currentOptions.map((option) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                _selectedOption = option;
              });
              _checkAnswer(selectedAnswer: option);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  _selectedOption == option ? Colors.blue : Colors.grey[300],
              foregroundColor:
                  _selectedOption == option ? Colors.white : Colors.black,
              padding: const EdgeInsets.all(15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              option, // Option is already localized and uppercase
              style: const TextStyle(fontSize: 16),
            ),
          ),
        );
      }).toList(),
    );
  }
}
