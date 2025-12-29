import 'package:shared_preferences/shared_preferences.dart';

class CoinPocketManager {
  static const String _coinKeyPrefix = 'userCoins_';

  /// Adds coins to a specific user's pocket.
  static Future<void> addCoins(String userId, int amount) async {
    if (amount < 0) return; // Prevent adding negative coins
    final prefs = await SharedPreferences.getInstance();
    int currentCoins = prefs.getInt('$_coinKeyPrefix$userId') ?? 0;
    await prefs.setInt('$_coinKeyPrefix$userId', currentCoins + amount);
  }

  /// Deducts coins from a specific user's pocket.
  /// Returns true if deduction was successful, false otherwise (e.g., insufficient coins).
  static Future<bool> deductCoins(String userId, int amount) async {
    if (amount < 0) return false; // Prevent deducting negative coins
    final prefs = await SharedPreferences.getInstance();
    int currentCoins = prefs.getInt('$_coinKeyPrefix$userId') ?? 0;
    if (currentCoins >= amount) {
      await prefs.setInt('$_coinKeyPrefix$userId', currentCoins - amount);
      return true;
    }
    return false; // Insufficient coins
  }

  /// Gets the current coin balance for a specific user.
  static Future<int> getCoins(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('$_coinKeyPrefix$userId') ?? 0;
  }
}
