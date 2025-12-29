import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:harvi/coin_pocket_manager.dart'; // Import the new coin manager
import '../home/app_localizations.dart';

class DailyRewardsScreen extends StatefulWidget {
  final String userId; // Pass the current user's ID

  const DailyRewardsScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _DailyRewardsScreenState createState() => _DailyRewardsScreenState();
}

class _DailyRewardsScreenState extends State<DailyRewardsScreen> {
  List<bool> _rewardsClaimed = List.generate(7, (index) => false);
  int _currentStreakDay = 0;
  DateTime? _lastClaimDate;

  final List<int> _coinRewards = [10, 15, 20, 25, 30, 35, 40]; // Coins per day

  @override
  void initState() {
    super.initState();
    _loadDailyRewardState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _loadDailyRewardState() async {
    final prefs = await SharedPreferences.getInstance();
    final String userPrefix = widget.userId;

    setState(() {
      _rewardsClaimed = List<bool>.from((prefs
                  .getStringList('${userPrefix}_rewardsClaimed') ??
              List.generate(7, (_) => false).map((e) => e.toString()).toList())
          .map((e) => e == 'true'));

      _currentStreakDay = prefs.getInt('${userPrefix}_currentStreakDay') ?? 0;

      String? lastClaimDateString =
          prefs.getString('${userPrefix}_lastClaimDate');
      if (lastClaimDateString != null) {
        _lastClaimDate = DateTime.parse(lastClaimDateString);
      }
    });

    // Call check and reset after loading, but ensure it doesn't prematurely reset
    _checkAndResetDailyRewards();
  }

  Future<void> _saveDailyRewardState() async {
    final prefs = await SharedPreferences.getInstance();
    final String userPrefix = widget.userId;

    await prefs.setStringList('${userPrefix}_rewardsClaimed',
        _rewardsClaimed.map((e) => e.toString()).toList());
    await prefs.setInt('${userPrefix}_currentStreakDay', _currentStreakDay);
    if (_lastClaimDate != null) {
      await prefs.setString(
          '${userPrefix}_lastClaimDate', _lastClaimDate!.toIso8601String());
    } else {
      // If _lastClaimDate is null, ensure it's removed from prefs
      await prefs.remove('${userPrefix}_lastClaimDate');
    }
  }

  void _checkAndResetDailyRewards() {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);

    if (_lastClaimDate == null) {
      // This is the first time the user is claiming, or after a full reset
      return;
    }

    DateTime lastClaimDay = DateTime(
        _lastClaimDate!.year, _lastClaimDate!.month, _lastClaimDate!.day);
    int daysDifference = today.difference(lastClaimDay).inDays;

    if (daysDifference > 1) {
      // User missed a day or more, reset streak and rewards
      setState(() {
        _rewardsClaimed = List.generate(7, (index) => false);
        _currentStreakDay = 0;
        _lastClaimDate = null; // Clear last claim date to signify a fresh start
      });
      _saveDailyRewardState();
    } else if (daysDifference == 1) {
      // It's a new day, streak continues.
      // If the current streak day is 0 (meaning yesterday was Day 6 and it rolled over),
      // then we need to reset the claimed status for the new week.
      if (_currentStreakDay == 0) {
        setState(() {
          _rewardsClaimed = List.generate(7, (index) => false);
        });
        _saveDailyRewardState();
      }
    }
    // If daysDifference == 0, it's the same day, no reset needed.
  }

  void _claimReward(int dayIndex) async {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    final localizations = AppLocalizations.of(context);

    if (_rewardsClaimed[dayIndex]) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(localizations.translate('reward_already_claimed')),
          backgroundColor: Colors.blueGrey,
        ),
      );
      return;
    }

    // --- Start of New Logic Check for Claiming on Same Day ---
    if (_lastClaimDate != null) {
      DateTime lastClaimDay = DateTime(
          _lastClaimDate!.year, _lastClaimDate!.month, _lastClaimDate!.day);
      if (today.difference(lastClaimDay).inDays == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(localizations.translate('claim_one_per_day')),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }
    }
    // --- End of New Logic Check for Claiming on Same Day ---

    // Ensure user claims the current day's reward in the streak
    if (dayIndex != _currentStreakDay) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(localizations.translate('claim_current_day_first')),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _rewardsClaimed[dayIndex] = true;
      _currentStreakDay = (dayIndex + 1) % 7; // Roll over after Day 6
      _lastClaimDate = now; // Update last claim date to now
    });

    int coinsEarned = _coinRewards[dayIndex];
    await CoinPocketManager.addCoins(widget.userId, coinsEarned);
    await _saveDailyRewardState(); // Save state immediately after claim

    // Constructing the success message using localization and string replacement
    String successMessage = localizations
        .translate('claim_success_message')
        .replaceAll('%1\$s', coinsEarned.toString())
        .replaceAll('%2\$s', (dayIndex + 1).toString());

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(successMessage),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    // 🔥 NEW LOGIC: Check if a claim is allowed today (i.e., new calendar day since last claim) 🔥
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    bool isClaimAllowedToday = _lastClaimDate == null ||
        (_lastClaimDate != null &&
            today
                    .difference(DateTime(_lastClaimDate!.year,
                        _lastClaimDate!.month, _lastClaimDate!.day))
                    .inDays >
                0);

    // 🔥 DYNAMIC THEME COLORS 🔥
    final Color backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final Color cardColor = Theme.of(context).cardColor;
    final Color primaryColor = Theme.of(context).colorScheme.primary;
    // onBackground will be dark in Light Mode and light in Dark Mode
    final Color onBackgroundColor = Theme.of(context).colorScheme.onBackground;

    final Color primaryAccent =
        primaryColor; // Use primary color for main cards
    final Color secondaryAccent =
        Colors.green.shade400; // Green for rewards title
    final Color currentDayHighlight = Colors.amber.shade400; // Bright highlight

    return Scaffold(
      // Use system background color
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(localizations.translate('daily_rewards_title'),
            style: TextStyle(color: onBackgroundColor)), // Localized
        // Use system card or primary color for AppBar
        backgroundColor: cardColor,
        iconTheme: IconThemeData(color: onBackgroundColor),
        elevation: 4,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              backgroundColor,
              // Use a slightly darker shade for the gradient bottom for depth
              backgroundColor.withOpacity(0.9),
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: FutureBuilder<int>(
                  future: CoinPocketManager.getCoins(widget.userId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator(color: primaryAccent);
                    } else if (snapshot.hasError) {
                      return Text(
                          '${localizations.translate('error_loading_coins')}${snapshot.error}', // Localized prefix
                          style: const TextStyle(color: Colors.redAccent));
                    } else {
                      return Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25)),
                        // Use the dynamic primary color for the coin card
                        color: primaryAccent,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25.0, vertical: 15.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.monetization_on,
                                  color: Colors.amber, size: 35),
                              const SizedBox(width: 10),
                              Text(
                                '${localizations.translate('your_coins_prefix')}${snapshot.data ?? 0}', // Localized prefix
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  // Fixed to white for contrast on the primary color card
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 3.0,
                                      color: Colors.black54,
                                      offset: Offset(1.5, 1.5),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
              const SizedBox(height: 30),
              Text(
                localizations.translate('daily_login_bonus_title'), // Localized
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: secondaryAccent, // Light green for the title
                  shadows: [
                    Shadow(
                      blurRadius: 1.0,
                      color: Colors.black45,
                      offset: Offset(0.5, 0.5),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.95,
                ),
                itemCount: 7,
                itemBuilder: (context, index) {
                  bool isClaimed = _rewardsClaimed[index];
                  bool isCurrentDay = index == _currentStreakDay;

                  // 🔥 Condition to determine if the claim button should be visible/active 🔥
                  bool isClaimActionable =
                      isCurrentDay && !isClaimed && isClaimAllowedToday;

                  // --- Theme Styling Adjustments ---
                  Color boxColor =
                      isClaimed ? cardColor.withOpacity(0.5) : cardColor;

                  // Text color uses onBackgroundColor for contrast
                  Color textColor = isClaimed
                      ? onBackgroundColor.withOpacity(0.3)
                      : onBackgroundColor.withOpacity(0.9);

                  // Icon color remains vibrant
                  Color iconColor = isClaimed
                      ? Colors.green.shade500
                      : Colors.orange.shade400;

                  // Highlighted border uses a bright amber
                  Color borderColor = isClaimActionable
                      ? currentDayHighlight // Bright yellow/amber for emphasis
                      : cardColor; // Use card color for non-current borders
                  double borderWidth = isClaimActionable ? 4.0 : 1.0;
                  double elevation = isClaimActionable
                      ? 12.0
                      : 6.0; // Higher elevation for current day

                  return GestureDetector(
                    // Only allow tap to claim if it's actionable (current day AND allowed today)
                    onTap: isClaimActionable ? () => _claimReward(index) : null,
                    child: Card(
                      elevation: elevation,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side:
                            BorderSide(color: borderColor, width: borderWidth),
                      ),
                      color: boxColor,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${localizations.translate('day_prefix')}${index + 1}', // Localized prefix
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: textColor,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Icon(
                                    isClaimed
                                        ? Icons.check_circle_rounded
                                        : Icons.card_giftcard,
                                    color: iconColor,
                                    size: 35,
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    '${_coinRewards[index]}${localizations.translate('coins_suffix')}', // Localized suffix
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: textColor,
                                    ),
                                  ),
                                  // The claim button is only shown if the reward is actionable
                                  if (isClaimActionable) ...[
                                    const SizedBox(height: 6),
                                    ElevatedButton(
                                      onPressed: () => _claimReward(index),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green.shade600,
                                        foregroundColor: Colors
                                            .white, // Fixed to white for claim button text
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        elevation: 5,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 18, vertical: 4),
                                        textStyle: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      child: Text(localizations.translate(
                                          'claim_button')), // Localized
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                          if (isClaimed)
                            Positioned.fill(
                              child: Center(
                                child: Text(
                                  localizations.translate(
                                      'claimed_overlay'), // Localized
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900,
                                    color:
                                        Colors.green.shade400.withOpacity(0.5),
                                    letterSpacing: 2.0,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 1.5,
                                        color: Colors.black.withOpacity(0.4),
                                        offset: const Offset(1.0, 1.0),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
