// fruit_identification_game.dart
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:harvi/coin_pocket_manager.dart';
// NOTE: Ensure this import path is correct for your AppLocalizations class
// If you use a custom file (e.g., in /l10n/app_localizations.dart), update the path.
import '../home/app_localizations.dart';

// Enum to define the two main modes of play
enum GameMode { standardChallenge, timeAttack }

class FruitIdentificationGame extends StatefulWidget {
  final String userId;

  const FruitIdentificationGame({Key? key, required this.userId})
      : super(key: key);

  @override
  _FruitIdentificationGameState createState() =>
      _FruitIdentificationGameState();
}

class _FruitIdentificationGameState extends State<FruitIdentificationGame>
    with SingleTickerProviderStateMixin {
  // --- Game Data (Combined from both original classes) ---

  // Images for Easy/Medium (Fruit Identification)
  final List<String> _fruitImages = [
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

  // Images for Hard/Harvesting (Order + Step Identification)
  final List<String> _hardStageImages = [
    'check.png',
    'reaping.png',
    'thereshing.png',
    'cleaning.png',
    'bagging.png',
    'storage.png',
  ];

  // Answers for Hard/Harvesting (Combined from both original hard maps)
  final Map<String, String> _hardStageExpectedAnswers = {
    'check.png': 'check', // Time Attack answer (no number)
    'reaping.png': 'reaping',
    'thereshing.png': 'threshing',
    'cleaning.png': 'cleaning',
    'bagging.png': 'bagging',
    'storage.png': 'storage',
  };

  // Full map including order for Standard Challenge Hard Mode
  final Map<String, String> _hardStageExpectedAnswersStandard = {
    'check.png': '1. check',
    'reaping.png': '2. reaping',
    'thereshing.png': '3. threshing',
    'cleaning.png': '4. cleaning',
    'bagging.png': '5. bagging',
    'storage.png': '6. storage',
  };

  // NEW: Map of normalized image base name (e.g., 'apple') to a list of ALL acceptable normalized answers (English and Tagalog).
  final Map<String, List<String>> _allAcceptedAnswers = {
    // --- Fruits (Easy/Medium) ---
    'apple': ['apple', 'mansanas'],
    'banana': ['banana', 'saging'],
    'orange': ['orange', 'kahel', 'dalandan'],
    'strawberry': ['strawberry'], // Tagalog term is generally the same
    'watermelon': ['watermelon', 'pakwan'],
    'lemon': ['lemon', 'dayap'],
    'mango': ['mango', 'mangga'],
    'guava': ['guava', 'bayabas'],
    'kiwi': ['kiwi'],
    'papaya': ['papaya'],
    'calamansi': ['calamansi', 'kalamansi'],
    'durian': ['durian'],
    'jackfruit': ['jackfruit', 'langka'],
    'rambutan': ['rambutan'],
    'tomato': ['tomato', 'kamatis'],
    'cucumber': ['cucumber', 'pipino'],
    'grapes': ['grapes', 'ubas'],
    'fig': ['fig', 'igos'],
    'noni': ['noni'],

    // --- Hard Stage Steps (Base Names) ---
    'check': ['check', 'suri', 'pagtsek'],
    'reaping': ['reaping', 'pag-aani', 'pagani'],
    'threshing': ['threshing', 'paggiik', 'paggiik'],
    'cleaning': ['cleaning', 'paglilinis', 'paglinis'],
    'bagging': ['bagging', 'pagsasako'],
    'storage': ['storage', 'imbakan', 'pag-iimbak'],
  };

  // Stage/Difficulty Settings (Combined and Unified)
  final Map<String, Map<String, int>> _difficultySettings = {
    'Easy': {
      'standard_cost': 10,
      'standard_reward': 5,
      'time_cost': 20,
      'time_reward': 5,
      'time_duration': 60
    },
    'Medium': {
      'standard_cost': 50,
      'standard_reward': 10,
      'time_cost': 100,
      'time_reward': 10,
      'time_duration': 40
    },
    'Hard': {
      'standard_cost': 100,
      'standard_reward': 15,
      'time_cost': 200,
      'time_reward': 15,
      'time_duration': 30
    },
  };

  // --- Game State Variables ---
  GameMode? _currentGameMode;
  String _currentDifficulty = ''; // 'Easy', 'Medium', or 'Hard'
  List<String> _currentImages = []; // Images for the current game
  int _currentIndex = 0;
  int _score = 0;
  String? _feedbackMessage;
  bool _isAnswerCorrect = false;
  bool _gameStarted = false;
  int _initialCoins = 0;

  // Time Attack Variables
  Timer? _timer;
  int _remainingTime = 0;
  List<String> _currentOptions = []; // For Hard/Time Attack (multiple choice)
  String? _selectedOption; // For Hard/Time Attack

  // Animation Variables
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  final TextEditingController _answerController = TextEditingController();

  // --- Lifecycle and Initialization ---

  @override
  void initState() {
    super.initState();
    _loadInitialCoins();
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
    _answerController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialCoins() async {
    _initialCoins = await CoinPocketManager.getCoins(widget.userId);
    if (mounted) {
      setState(() {});
    }
  }

  String _normalizeString(String? input) {
    if (input == null) return '';
    return input
        .replaceAll('.png', '')
        .replaceAll('\u00a0', ' ')
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'\s+'), ' ');
  }

  // --- Confirmation and Start Logic (Unified) ---

  void _showConfirmationDialog(String difficulty, GameMode mode) {
    // FIX: Use .translate()
    final loc = AppLocalizations.of(context);
    final settings = _difficultySettings[difficulty]!;
    final isStandard = mode == GameMode.standardChallenge;

    int cost = isStandard ? settings['standard_cost']! : settings['time_cost']!;
    int reward =
        isStandard ? settings['standard_reward']! : settings['time_reward']!;
    int duration = isStandard ? 0 : settings['time_duration']!;

    // FIX: Use .translate() for mode name and split
    String modeName = isStandard
        ? loc.translate('game_mode_standard_title').split(' ')[0]
        : loc.translate('game_mode_time_attack_title').split(' ')[0];

    // FIX: Use .translate() for time info template
    String timeInfo = isStandard
        ? loc.translate('challenge_time_info_standard')
        : loc
            .translate('challenge_time_info_time_attack_template')
            .replaceAll('{duration}', duration.toString());

    // FIX: Use .translate() for title template
    String title = loc
        .translate('start_challenge_title_template')
        .replaceAll('{difficulty}', difficulty)
        .replaceAll('{modeName}', modeName);

    // FIX: Use .translate() for message template
    String message = loc
        .translate('challenge_confirmation_message_template')
        .replaceAll('{cost}', cost.toString())
        .replaceAll('{reward}', reward.toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text('$timeInfo\n\n$message'),
          actions: <Widget>[
            TextButton(
              // FIX: Use .translate() for cancel
              child: Text(loc.translate('cancel')),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              // FIX: Use .translate() for start
              child: Text(loc.translate('start')),
              onPressed: () {
                Navigator.of(context).pop();
                _startGame(difficulty, mode);
              },
            ),
          ],
        );
      },
    );
  }

  void _startGame(String difficulty, GameMode mode) async {
    // FIX: Use .translate()
    final loc = AppLocalizations.of(context);
    final settings = _difficultySettings[difficulty]!;
    final isStandard = mode == GameMode.standardChallenge;
    int cost = isStandard ? settings['standard_cost']! : settings['time_cost']!;

    bool canDeduct = await CoinPocketManager.deductCoins(widget.userId, cost);

    if (canDeduct) {
      setState(() {
        _currentGameMode = mode;
        _currentDifficulty = difficulty;
        _currentIndex = 0;
        _score = 0;
        _feedbackMessage = null;
        _isAnswerCorrect = false;
        _answerController.clear();
        _selectedOption = null;
        _gameStarted = true;
        _loadInitialCoins();

        if (difficulty == 'Hard') {
          _currentImages = List.from(_hardStageImages)..shuffle(Random());
          if (mode == GameMode.timeAttack) {
            _setHardModeQuestionOptions();
          }
        } else {
          // Easy/Medium use a subset of the fruit images
          _currentImages = List.from(_fruitImages)..shuffle(Random());
          // Standard Challenge stops after 6 questions for Easy/Medium
          if (mode == GameMode.standardChallenge) {
            _currentImages = _currentImages.take(6).toList();
          }
        }
      });

      if (mode == GameMode.timeAttack) {
        _remainingTime = settings['time_duration']!;
        _startTimer();
      }

      // FIX: Use .translate() for mode name and template
      String modeName = isStandard
          ? loc.translate('game_mode_standard_title').split(' ')[0]
          : loc.translate('game_mode_time_attack_title').split(' ')[0];

      String startMessage = loc
          .translate('status_started_template')
          .replaceAll('{difficulty}', difficulty)
          .replaceAll('{mode}', modeName)
          .replaceAll('{cost}', cost.toString());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(startMessage)),
      );
    } else {
      // FIX: Use .translate() for not enough coins template
      String notEnoughMessage = loc
          .translate('status_not_enough_coins_template')
          .replaceAll('{cost}', cost.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(notEnoughMessage),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // ... (Time Attack Logic remains the same) ...

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

  // Generate 3 random options for Hard/Time Attack
  List<String> _generateIncorrectOptions(String correctOption, int count) {
    // Collect all *English* base answers from the Hard Stage (used for comparison)
    List<String> pool = List.from(_hardStageExpectedAnswers.values);

    // Remove the correct English base answer from the pool
    pool.removeWhere(
        (item) => _normalizeString(item) == _normalizeString(correctOption));
    pool.shuffle(Random());

    // Now, retrieve the full list of ALL acceptable answers (English and Tagalog) for the incorrect options
    List<String> incorrectOptions = [];
    int counter = 0;
    while (incorrectOptions.length < count && counter < pool.length) {
      String baseName = pool[counter];
      List<String> acceptedAnswers = _allAcceptedAnswers[baseName]!;

      // Add one random acceptable name for the incorrect base name
      acceptedAnswers.shuffle(Random());
      if (acceptedAnswers.isNotEmpty) {
        incorrectOptions.add(acceptedAnswers.first);
      }
      counter++;
    }

    return incorrectOptions;
  }

  void _setHardModeQuestionOptions() {
    if (_currentIndex < _currentImages.length) {
      final imageName = _currentImages[_currentIndex];
      String correctEnglishBaseOption =
          _hardStageExpectedAnswers[imageName]!; // e.g., 'check'

      // Get all acceptable answers (English/Tagalog) for the correct option
      List<String> correctOptionsPool =
          _allAcceptedAnswers[correctEnglishBaseOption]!;

      // Choose one random correct answer (can be English or Tagalog) to display
      String correctOption =
          correctOptionsPool[Random().nextInt(correctOptionsPool.length)];

      List<String> options = [];
      options.add(correctOption);

      // Get incorrect options based on English base names, but display a random accepted translation
      options.addAll(_generateIncorrectOptions(correctEnglishBaseOption,
          3)); // Use 3 incorrect options for a total of 4
      options.shuffle(Random());

      setState(() {
        _currentOptions = options;
        _selectedOption = null;
      });
    }
  }

  // --- Answer Checking (Unified) ---

  // REPLACED _submitAnswer with _confirmAndSubmitAnswer
  Future<void> _submitAnswer() async {
    // FIX: Use .translate()
    final loc = AppLocalizations.of(context);

    // Only Hard Time Attack submits instantly on selection, so we only need confirmation for Standard
    if (_currentGameMode == GameMode.timeAttack &&
        _currentDifficulty == 'Hard') {
      // Hard Time Attack uses _checkAnswer directly in _buildOptionsGrid
      return;
    }

    // Standard Challenge Confirmation Dialog (for Easy/Medium and Hard)
    final confirmed = await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              // FIX: Use .translate()
              title: Text(loc.translate('dialog_confirm_submission_title')),
              content: Text(loc.translate('dialog_confirm_submission_content')),
              actions: <Widget>[
                TextButton(
                  // FIX: Use .translate()
                  child: Text(loc.translate('cancel')),
                  onPressed: () => Navigator.of(context).pop(false),
                ),
                ElevatedButton(
                  // Using a primary-themed button for confirmation
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                  ),
                  // FIX: Use .translate()
                  child: Text(loc.translate('submit')),
                  onPressed: () => Navigator.of(context).pop(true),
                ),
              ],
            );
          },
        ) ??
        false;

    if (confirmed) {
      _checkAnswer();
    }
  }

  // UPDATED: Now checks against all acceptable (English/Tagalog) answers.
  void _checkAnswer({String? selectedAnswer}) async {
    // FIX: Use .translate()
    final loc = AppLocalizations.of(context);
    if (!_gameStarted ||
        (_currentGameMode == GameMode.timeAttack && _remainingTime <= 0))
      return;

    String userAnswer;
    List<String> acceptableNormalizedAnswers = [];
    String displayAnswerForFeedback =
        ''; // Keep English for consistent feedback

    bool isHard = _currentDifficulty == 'Hard';
    bool isStandard = _currentGameMode == GameMode.standardChallenge;
    int reward = isStandard
        ? _difficultySettings[_currentDifficulty]!['standard_reward']!
        : _difficultySettings[_currentDifficulty]!['time_reward']!;

    String currentImage = _currentImages[_currentIndex % _currentImages.length];
    String currentImageBaseName = currentImage.replaceAll('.png', '');

    if (isHard) {
      if (isStandard) {
        // Standard Hard Mode: Answer must be 'N. step' or 'N. TagalogStep'

        // Get the English-based ordered answer for the display feedback
        String orderedEnglish = _hardStageExpectedAnswersStandard[
            currentImage]!; // e.g., '1. check'
        String orderPrefix = orderedEnglish.split('.').first; // e.g., '1'
        String baseName =
            _hardStageExpectedAnswers[currentImage]!; // e.g., 'check'

        // Use the base name to get all acceptable non-ordered answers (e.g., 'check', 'suri')
        List<String> baseAnswers = _allAcceptedAnswers[baseName]!;

        // Create the final list of acceptable ordered answers (e.g., '1. check', '1. suri')
        acceptableNormalizedAnswers = baseAnswers
            .map((ans) => _normalizeString('$orderPrefix. $ans'))
            .toList();

        userAnswer = _normalizeString(_answerController.text);
        displayAnswerForFeedback = orderedEnglish.toUpperCase();
      } else {
        // Time Attack Hard Mode: Answer is selected option (e.g., 'check' or 'suri')
        String correctEnglishBaseName =
            _hardStageExpectedAnswers[currentImage]!; // e.g., 'check'

        // Get all acceptable answers for the step name (e.g., 'check', 'suri')
        acceptableNormalizedAnswers =
            _allAcceptedAnswers[correctEnglishBaseName]!;

        userAnswer = _normalizeString(selectedAnswer);
        displayAnswerForFeedback = correctEnglishBaseName.toUpperCase();

        if (selectedAnswer == null) {
          setState(() {
            // FIX: Use .translate()
            _feedbackMessage = loc.translate('validation_select_option');
          });
          return;
        }
      }
    } else {
      // Easy/Medium: Answer is the fruit name
      String correctEnglishBaseName = currentImageBaseName;

      // Get all acceptable answers for the fruit name (e.g., 'apple', 'mansanas')
      acceptableNormalizedAnswers =
          _allAcceptedAnswers[correctEnglishBaseName]!;

      userAnswer = _normalizeString(_answerController.text);
      displayAnswerForFeedback = correctEnglishBaseName.toUpperCase();
    }

    // Final check if the user's normalized answer is in the list of acceptable normalized answers
    bool isCorrect = acceptableNormalizedAnswers.contains(userAnswer);

    if (userAnswer.isEmpty && isStandard && isHard == false) {
      setState(() {
        // FIX: Use .translate()
        _feedbackMessage = loc.translate('validation_type_answer');
        _isAnswerCorrect = false;
      });
      return;
    }

    setState(() {
      if (isCorrect) {
        _score++;
        // FIX: Use .translate()
        _feedbackMessage = loc.translate('feedback_correct');
        _isAnswerCorrect = true;
        CoinPocketManager.addCoins(widget.userId, reward);
        _loadInitialCoins();
      } else {
        // FIX: Use .translate() for incorrect template
        _feedbackMessage = loc
            .translate('feedback_incorrect_is_template')
            .replaceAll('{correctAnswer}', displayAnswerForFeedback);
        _isAnswerCorrect = false;
      }
    });

    await Future.delayed(const Duration(milliseconds: 800));

    if (!mounted) return;

    // Move to the next question
    setState(() {
      _answerController.clear();
      _selectedOption = null;
      _feedbackMessage = null;
      _isAnswerCorrect = false;

      if (_currentGameMode == GameMode.standardChallenge) {
        if (_currentIndex < _currentImages.length - 1) {
          _currentIndex++;
        } else {
          _gameStarted = false;
          _endGame();
        }
      } else {
        // Time Attack: Loop through images
        _currentIndex++;
        if (_currentIndex >= _currentImages.length) {
          _currentImages.shuffle(Random()); // Reshuffle for more variety
          _currentIndex = 0;
        }
        if (_currentDifficulty == 'Hard') {
          _setHardModeQuestionOptions();
        }
      }
    });
  }

  void _endGame() {
    _timer?.cancel();
    if (mounted) {
      setState(() {
        _gameStarted = false;
      });
      _showGameResultDialog();
    }
  }

  // --- Dialogs ---

  void _showGameResultDialog() {
    // FIX: Use .translate()
    final loc = AppLocalizations.of(context);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        final settings = _difficultySettings[_currentDifficulty]!;
        final rewardPerQuestion = _currentGameMode == GameMode.standardChallenge
            ? settings['standard_reward']!
            : settings['time_reward']!;
        final totalEarnedCoins = _score * rewardPerQuestion;

        if (_score > 0) {
          _animationController.forward(from: 0.0);
        }

        // FIX: Use .translate() for titles
        String modeName = _currentGameMode == GameMode.standardChallenge
            ? loc.translate('game_over_challenge_title')
            : loc.translate('game_over_time_attack_title');

        String resultText;
        if (_currentGameMode == GameMode.standardChallenge) {
          // FIX: Use .translate() for standard template
          resultText = loc
              .translate('game_result_standard_template')
              .replaceAll('{score}', _score.toString())
              .replaceAll('{total}', _currentImages.length.toString())
              .replaceAll('{difficulty}', _currentDifficulty);
        } else {
          // FIX: Use .translate() for time attack template
          resultText = loc
              .translate('game_result_time_attack_template')
              .replaceAll('{score}', _score.toString())
              .replaceAll('{difficulty}', _currentDifficulty);
        }

        return AlertDialog(
          title: Text(modeName),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(resultText, textAlign: TextAlign.center),
              const SizedBox(height: 10),
              if (_currentGameMode == GameMode.standardChallenge &&
                  _score == _currentImages.length)
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    children: [
                      Image.asset('assets/congratulations.gif',
                          height: 80,
                          errorBuilder: (c, e, s) => const Icon(Icons.star,
                              size: 60, color: Colors.amber)),
                      // FIX: Use .translate()
                      Text(loc.translate('game_result_master'),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.purple)),
                    ],
                  ),
                )
              else if (_score > 0)
                ScaleTransition(
                  scale: _scaleAnimation,
                  child:
                      const Icon(Icons.thumb_up, size: 60, color: Colors.blue),
                ),
              const SizedBox(height: 20),
              Text(
                // FIX: Use .translate() for coins earned template
                loc
                    .translate('game_result_coins_earned_template')
                    .replaceAll('{coins}', totalEarnedCoins.toString()),
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              // FIX: Use .translate()
              child: Text(loc.translate('play_again')),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _gameStarted = false;
                  _currentGameMode = null; // Back to mode selection
                });
              },
            ),
            TextButton(
              // FIX: Use .translate()
              child: Text(loc.translate('back_to_home')),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(true); // Pop to HomeScreen
              },
            ),
          ],
        );
      },
    );
  }

  // --- Back Button Logic Fix ---
  Future<bool> _onWillPop() async {
    // FIX: Use .translate()
    final loc = AppLocalizations.of(context);
    if (_gameStarted) {
      _timer?.cancel(); // Pause the timer

      final quit = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              // FIX: Use .translate()
              title: Text(loc.translate('dialog_quit_game_title')),
              content: Text(loc.translate('dialog_quit_game_content')),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    if (_currentGameMode == GameMode.timeAttack)
                      _startTimer(); // Resume the timer
                    Navigator.of(context).pop(false); // Stay
                  },
                  // FIX: Use .translate()
                  child: Text(loc.translate('no_continue')),
                ),
                TextButton(
                  onPressed: () {
                    _timer?.cancel();
                    setState(() {
                      _gameStarted = false;
                    });
                    Navigator.of(context).pop(true); // Allow pop out of dialog
                  },
                  // FIX: Use .translate()
                  child: Text(loc.translate('yes_quit')),
                ),
              ],
            ),
          ) ??
          false;

      if (quit) return false; // Handled by setState, prevent default pop
      return false; // Prevent pop if user cancels
    } else if (_currentGameMode != null) {
      // If on difficulty selection, go back to mode selection
      setState(() {
        _currentGameMode = null;
      });
      return false; // Prevent default pop
    }
    // If on mode selection, allow default pop (back to home screen)
    return true;
  }

  // --- Widgets ---

  Widget _buildModeAndDifficultySelection() {
    // FIX: Use .translate()
    final loc = AppLocalizations.of(context);
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                loc.translate('game_select_mode'),
                style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              // --- Standard Challenge Card ---
              _buildModeCard(
                loc.translate('game_mode_standard_title'),
                loc.translate('game_mode_standard_desc'),
                GameMode.standardChallenge,
                Colors.deepPurple[400]!, // FIX: Replaced .shade400 with [400]!
              ),
              const SizedBox(height: 20),
              // --- Time Attack Card ---
              _buildModeCard(
                loc.translate('game_mode_time_attack_title'),
                loc.translate('game_mode_time_attack_desc'),
                GameMode.timeAttack,
                Colors.deepOrange[600]!, // FIX: Replaced .shade600 with [600]!
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModeCard(
      String title, String description, GameMode mode, Color color) {
    return Card(
      elevation: 8, // Increased elevation
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
        ),
        child: InkWell(
          onTap: () => setState(() => _currentGameMode = mode),
          borderRadius: BorderRadius.circular(15),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 10),
                Text(
                  description,
                  style: TextStyle(
                      fontSize: 16, color: Colors.white.withOpacity(0.9)),
                ),
                const SizedBox(height: 15),
                const Align(
                  alignment: Alignment.centerRight,
                  child: Icon(Icons.chevron_right, // Changed arrow for design
                      color: Colors.white,
                      size: 28),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDifficultySelection() {
    // FIX: Use .translate()
    final loc = AppLocalizations.of(context);
    // Correctly uses the specialized keys for the header inside the selection screen
    String title = _currentGameMode == GameMode.standardChallenge
        ? loc.translate('game_select_difficulty_standard')
        : loc.translate('game_select_difficulty_time_attack');

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          // FIX: Replaced .shade600 with [600]!
          // Uses the keys that now contain the requested "Madali na Hamon" translations
          _buildStageButton(
              loc.translate('difficulty_easy'), 'Easy', Colors.green[600]!),
          const SizedBox(height: 20),
          // FIX: Replaced .shade600 with [600]!
          _buildStageButton(loc.translate('difficulty_medium'), 'Medium',
              Colors.orange[600]!),
          const SizedBox(height: 20),
          // FIX: Replaced .shade600 with [600]!
          _buildStageButton(
              loc.translate('difficulty_hard'), 'Hard', Colors.red[600]!),
        ],
      ),
    );
  }

  Widget _buildStageButton(
      String localizedDifficulty, String keyDifficulty, Color buttonColor) {
    // FIX: Use .translate()
    final loc = AppLocalizations.of(context);
    final settings = _difficultySettings[keyDifficulty]!;
    final isStandard = _currentGameMode == GameMode.standardChallenge;
    int cost = isStandard ? settings['standard_cost']! : settings['time_cost']!;
    int reward =
        isStandard ? settings['standard_reward']! : settings['time_reward']!;

    return SizedBox(
      width: 280,
      height: 70,
      child: ElevatedButton(
        onPressed: () =>
            _showConfirmationDialog(keyDifficulty, _currentGameMode!),
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          foregroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 5, // Increased elevation for better design
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  localizedDifficulty,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 5),
                const Icon(Icons.monetization_on,
                    color: Colors.amber, size: 20),
                Text(
                  // FIX: Use .translate()
                  ' $cost ${loc.translate('label_cost')}',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            Text(
              // FIX: Use .translate()
              '$reward ${loc.translate('label_coins_per_correct')}',
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameContent() {
    // FIX: Use .translate()
    final loc = AppLocalizations.of(context);
    String currentImage = _currentImages[_currentIndex % _currentImages.length];

    // PATH CONFIRMED: This assumes all image files are directly in the assets/ folder.
    String imagePath = 'assets/$currentImage';

    bool isHard = _currentDifficulty == 'Hard';
    bool isStandard = _currentGameMode == GameMode.standardChallenge;

    String questionText;
    if (isHard) {
      // FIX: Use .translate() for question keys
      questionText = isStandard
          ? loc.translate('question_hard_standard')
          : loc.translate('question_hard_time_attack');
    } else {
      questionText = loc.translate('question_easy_medium');
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Score and Timer/Progress Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // FIX: Use .translate()
              Text(
                '${loc.translate('label_score')} $_score',
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              if (_currentGameMode == GameMode.standardChallenge)
                // FIX: Use .translate()
                Text(
                  '${loc.translate('label_question_short')} ${_currentIndex + 1} / ${_currentImages.length}',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w500),
                ),
              if (_currentGameMode == GameMode.timeAttack)
                Text(
                  // FIX: Use .translate()
                  '${loc.translate('label_time_short')} $_remainingTime ${loc.translate('label_seconds_short')}',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: _remainingTime <= 10 ? Colors.red : Colors.green,
                  ),
                ),
            ],
          ),
          const Divider(),
          const SizedBox(height: 10),
          Text(
            questionText,
            style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.deepPurple),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                border: Border.all(color: Colors.grey, width: 2),
                borderRadius: BorderRadius.circular(15),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2))
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(13),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                        child: Icon(Icons.broken_image,
                            size: 100, color: Colors.grey));
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Input/Options Area
          if (isHard && _currentGameMode == GameMode.timeAttack)
            _buildOptionsGrid(),
          if (!isHard || isStandard) _buildTextFieldInput(isHard),

          const SizedBox(height: 10),
          if (_feedbackMessage != null)
            Text(
              _feedbackMessage!,
              style: TextStyle(
                color: _isAnswerCorrect ? Colors.green : Colors.red,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          const SizedBox(height: 20),
          if (!isHard || isStandard)
            ElevatedButton(
              onPressed: _submitAnswer, // Use new submit logic
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(
                // FIX: Use .translate()
                loc.translate('submit_answer'),
                style: const TextStyle(fontSize: 18),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTextFieldInput(bool isHard) {
    // FIX: Use .translate()
    final loc = AppLocalizations.of(context);
    // UPDATED HINT (using translate)
    String hint = isHard
        ? loc.translate('input_hint_hard_standard')
        : loc.translate('input_hint_easy_medium');

    return TextField(
      controller: _answerController,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        // Removed suffixIcon with arrow
      ),
      onSubmitted: (_) => _submitAnswer(), // Submit on keyboard action
      enabled: _gameStarted,
    );
  }

  Widget _buildOptionsGrid() {
    // FIX: Use .translate()
    final loc = AppLocalizations.of(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            // Key is correct here, and now defined in app_localizations.dart
            loc.translate('label_select_answer'),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3.5,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: _currentOptions.length,
          itemBuilder: (context, index) {
            String option = _currentOptions[index];
            bool isSelected = option == _selectedOption;

            return ElevatedButton(
              onPressed: () {
                setState(() {
                  _selectedOption = option;
                });
                // Time Attack submission is instant on option selection
                _checkAnswer(selectedAnswer: option);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isSelected
                    ? Theme.of(context).colorScheme.secondary
                    : Colors
                        .blueGrey[400]!, // FIX: Replaced .shade400 with [400]!
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                elevation: 3,
              ),
              child: Text(option.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16)),
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // FIX: Use .translate()
    final loc = AppLocalizations.of(context);
    String currentTitle = loc.translate('game_title_fruit_identification');
    if (_gameStarted) {
      // FIX: Use .translate() for mode name and split
      String modeLabel = _currentGameMode == GameMode.standardChallenge
          ? loc.translate('game_mode_standard_title').split(' ')[0]
          : loc.translate('game_mode_time_attack_title').split(' ')[0];
      currentTitle = '$_currentDifficulty $modeLabel';
    } else if (_currentGameMode != null) {
      // FIXED: Uses the new 'game_select_difficulty' key to show "Select Difficulty"
      currentTitle = loc.translate('game_select_difficulty');
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(currentTitle),
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
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
            ? _buildGameContent()
            : (_currentGameMode == null
                ? _buildModeAndDifficultySelection()
                : _buildDifficultySelection()),
      ),
    );
  }
}
