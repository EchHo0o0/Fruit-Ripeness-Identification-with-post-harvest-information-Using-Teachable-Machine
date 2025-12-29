import 'package:flutter/material.dart';
import 'dart:math';
import 'package:harvi/coin_pocket_manager.dart';

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
  final Map<String, List<String>> _fruitStages = {
    'Easy': [
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
    ],
    'Medium': [
      'calamansi.png', 'durian.png', 'jackfruit.png', 'rambutan.png',
      'tomato.png', 'cucumber.png', 'grapes.png', 'fig.png',
      'noni.png', // Removed honeydew
    ],
    // Hard stage will now focus on identifying the *order* of steps
    // The images themselves will be presented in a random order,
    // and the player must guess the *name of the step* AND *its sequential number*.
    'Hard': [
      'check.png', // 1. Check
      'reaping.png', // 2. Reaping
      'thereshing.png', // 3. Threshing
      'cleaning.png', // 4. Cleaning
      'bagging.png', // 5. Bagging (removed sorting)
      'storage.png', // 6. Storage
    ],
  };

  // Hard stage answers will now include the expected order number
  // e.g., "1. check", "2. reaping", etc.
  final Map<String, String> _hardStageExpectedAnswers = {
    'check.png': '1. check',
    'reaping.png': '2. reaping',
    'thereshing.png': '3. threshing',
    'cleaning.png': '4. cleaning',
    'bagging.png': '5. bagging',
    'storage.png': '6. storage',
  };

  final Map<String, int> _stageCosts = {
    'Easy': 10,
    'Medium': 50,
    'Hard': 100,
  };

  final Map<String, int> _stageRewards = {
    'Easy': 5,
    'Medium': 10,
    'Hard': 15,
  };

  String _currentStage = '';
  List<String> _currentStageFruits = [];
  int _currentIndex = 0;
  int _score = 0;
  TextEditingController _answerController = TextEditingController();
  String? _feedbackMessage;
  bool _isAnswerCorrect = false;
  bool _gameStarted = false;
  int _initialCoins = 0;

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

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

  void _startGame(String stage) async {
    int cost = _stageCosts[stage]!;
    bool canDeduct = await CoinPocketManager.deductCoins(widget.userId, cost);

    if (canDeduct) {
      setState(() {
        _currentStage = stage;
        _currentStageFruits = List.from(_fruitStages[stage]!)
          ..shuffle(Random());
        _currentIndex = 0;
        _score = 0;
        _feedbackMessage = null;
        _isAnswerCorrect = false;
        _answerController.clear();
        _gameStarted = true;
        _loadInitialCoins();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Game started! $cost coins deducted.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Not enough coins to play the $stage stage! You need $cost coins.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _checkAnswer() async {
    if (!_gameStarted) return;

    String userAnswer = _answerController.text.trim().toLowerCase();
    String correctExpectedAnswer; // Changed name for clarity

    if (_currentStage == 'Hard') {
      correctExpectedAnswer =
          _hardStageExpectedAnswers[_currentStageFruits[_currentIndex]]!
              .toLowerCase();
      // For Hard mode, the user must input "N. step_name"
    } else {
      correctExpectedAnswer = _currentStageFruits[_currentIndex]
          .replaceAll('.png', '')
          .toLowerCase();
    }

    setState(() {
      if (userAnswer == correctExpectedAnswer) {
        _score++;
        _feedbackMessage = 'Correct!';
        _isAnswerCorrect = true;
        CoinPocketManager.addCoins(
            widget.userId, _stageRewards[_currentStage]!);
        _loadInitialCoins();
      } else {
        _feedbackMessage =
            'Incorrect. It\'s ${correctExpectedAnswer.toUpperCase()}.';
        _isAnswerCorrect = false;
      }
    });

    await Future.delayed(const Duration(milliseconds: 800));

    if (!mounted) return;

    setState(() {
      _answerController.clear();
      _feedbackMessage = null;
      _isAnswerCorrect = false;

      if (_currentIndex < _currentStageFruits.length - 1) {
        _currentIndex++;
      } else {
        _gameStarted = false;
        _showGameResultDialog();
      }
    });
  }

  void _showGameResultDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        final totalEarnedCoins = _score * (_stageRewards[_currentStage] ?? 0);

        if (_score == _currentStageFruits.length) {
          _animationController.forward(from: 0.0);
        }

        return AlertDialog(
          title: const Text('Game Over!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'You scored $_score out of ${_currentStageFruits.length} in the $_currentStage stage!',
                textAlign: TextAlign.center,
              ),
              if (_score == _currentStageFruits.length)
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      Image.asset('assets/congratulations.gif',
                          height: 100,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.star,
                                  size: 80, color: Colors.amber)),
                      const Text(
                        '🎉 Congratulations! 🎉\nYou are a master!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,
                        ),
                      ),
                    ],
                  ),
                )
              else if (_score > _currentStageFruits.length / 2)
                const Text(
                  'Well done! Keep practicing!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.blue,
                  ),
                )
              else
                const Text(
                  'Good effort! Try again to improve!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.red,
                  ),
                ),
              const SizedBox(height: 20),
              Text(
                'Coins earned: $totalEarnedCoins',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Play Again'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _gameStarted = false;
                });
              },
            ),
            TextButton(
              child: const Text('Back to Home'),
              onPressed: () {
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
    return Scaffold(
      appBar: AppBar(
        title: Text(_gameStarted
            ? '$_currentStage Challenge'
            : 'Fruit Identification Game'),
        backgroundColor: Theme.of(context).colorScheme.primary,
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
      body: _gameStarted ? _buildGameContent() : _buildStageSelection(),
    );
  }

  Widget _buildStageSelection() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Choose Your Challenge!',
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Game Mechanics:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'A coin cost will be deducted per stage you choose. Guess the fruit name for Easy and Medium difficulties. For Hard difficulty, identify the harvesting step AND its correct order number (e.g., "1. check").',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'You will earn coins for each correct answer.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
          _buildStageButton('Easy', _stageCosts['Easy']!, Colors.green),
          const SizedBox(height: 20),
          _buildStageButton('Medium', _stageCosts['Medium']!, Colors.orange),
          const SizedBox(height: 20),
          _buildStageButton('Hard', _stageCosts['Hard']!, Colors.red),
        ],
      ),
    );
  }

  Widget _buildStageButton(String stage, int cost, Color buttonColor) {
    int reward = _stageRewards[stage] ?? 0;
    return SizedBox(
      width: 280,
      height: 70,
      child: ElevatedButton(
        onPressed: () => _startGame(stage),
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
              '$stage (${cost} coins)',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              '${reward} coins/correct answer',
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameContent() {
    if (_currentStageFruits.isEmpty) {
      return const Center(child: Text('Loading images...'));
    }

    String currentImage = _currentStageFruits[_currentIndex];
    String imagePath = 'assets/$currentImage';

    String currentQuestionText;
    if (_currentStage == 'Hard') {
      currentQuestionText =
          'Identify the harvesting step AND its order (e.g., "1. check")';
    } else {
      currentQuestionText = 'Identify the fruit name';
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Question ${_currentIndex + 1} / ${_currentStageFruits.length}', // Added question counter
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            'Score: $_score',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Text(
            currentQuestionText,
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
                color: Colors.white,
                border: Border.all(color: Colors.grey, width: 2),
                borderRadius: BorderRadius.circular(15),
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
          TextField(
            controller: _answerController,
            decoration: InputDecoration(
              hintText: 'Type your answer',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              suffixIcon: IconButton(
                icon: const Icon(Icons.send),
                onPressed: _checkAnswer,
              ),
            ),
            onSubmitted: (_) => _checkAnswer(),
            enabled: _gameStarted &&
                (_currentStage != 'Hard' ||
                    _currentIndex < _currentStageFruits.length),
          ),
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
          ElevatedButton(
            onPressed: _checkAnswer,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text(
              'Submit Answer',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
