// app_localizations.dart

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:harvi/home/language_provider.dart';
import 'package:provider/provider.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  // Define the actual localized strings here
  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'create_account': 'Create Account',
      'tap_to_add_profile': 'Tap to add profile picture',
      'first_name': 'First Name',
      'middle_name': 'Middle Name (Optional)',
      'last_name': 'Last Name',
      'age': 'Age',
      'next': 'Next',
      'back': 'Back',
      'sign_up': 'Sign Up',
      'confirm_account_creation': 'Confirm Account Creation',
      'confirm_message': 'Are you sure you want to create this account?',
      'cancel': 'Cancel',
      'create': 'Create',
      'account_created_successfully': 'Account created successfully!',
      'address': 'Address',
      'mobile_number': 'Mobile Number',
      'gender': 'Gender',
      'male': 'Male',
      'female': 'Female',
      'role': 'Role',
      'select_role': 'Select your role',
      'farmer': 'Farmer',
      'vendor': 'Vendor',
      'consumer': 'Consumer',
      'harvesting_experience_question': 'Do you have harvesting experience?',
      'yes': 'Yes',
      'no': 'No',
      'email': 'Email',
      'password': 'Password',

      "@@locale": "en",
      "welcome": "Welcome, Grower!",
      "signinMessage":
          "Sign in to cultivate knowledge and access your dashboard.",
      "email": "Email Address",
      "password": "Password",
      "forgotPassword": "Forgot Password?",
      "signIn": "Sign In",
      "noAccount": "Don't have an account? ",
      "signUpHere": "Sign up here.",
      "resetPassword": "Reset Password",
      "enterEmail": "Enter your email",
      "sendEmail": "Send Email",
      "cancel": "Cancel",
      "resetEmailSent": "Password reset email sent! Check your inbox.",
      "resetEmailFailed": "Error: Invalid email or account not found.",
      "fillAllFields": "Please fill in both email and password.",
      "userDataNotFound": "User data not found. Please contact support.",
      "loginFailed":
          "Login Failed. Please check your email and password.", // <-- FIXED: Added missing comma

      // --- Settings Screen Keys (Existing) ---
      'settings': 'Settings', // <-- FIXED: Key and value correctly paired
      'account': 'Account',
      'profile': 'Profile',
      'security_privacy': 'Security & Privacy',
      'dark_mode': 'Dark Mode',
      'support_feedback': 'Support & Feedback',
      'help_center': 'Help Center',
      'about_us': 'About Us',
      'log_out': 'Log Out',
      'confirm_logout': 'Confirm Logout',
      'confirm_logout_message':
          'Are you sure you want to log out of your account?',
      'cancel': 'Cancel',
      'yes_logout': 'Yes, Log Out',
      'language': 'Language',
      'english': 'English', // Added for language dialog
      'tagalog': 'Tagalog', // Added for language dialog

      // 🔥 NEW ANNOUNCEMENT SCREEN KEYS
      'announcements_title': 'Announcements',
      'search_announcements_hint': 'Search announcements...',
      'no_announcements_yet': 'No announcements yet.',
      'no_new_announcements': 'No new announcements.',
      'no_message': 'No Message',
      'login_to_dismiss_snack': 'Please log in to dismiss announcements.',
      'announcement_dismissed_snack':
          'Announcement dismissed for your account.',
      'announcement_details_title': 'Announcement Details',
      'no_message_available': 'No message available.',
      'no_timestamp_available': 'No timestamp available.',
      'invalid_date_format': 'Invalid date format.',
      'dismiss_confirmation_title': 'Dismiss Announcement?',
      'dismiss_confirmation_content':
          'Are you sure you want to dismiss this announcement? It will be hidden from your view.',
      'button_dismiss': 'Dismiss',
      'button_dismiss_announcement': 'Dismiss Announcement',
      'button_done': 'Done',
      // Keys with variables (placeholders needed in ARB, handled as regular strings here)
      'no_search_results_template': 'No results found for "%s".',
      'error_loading_announcements_template': 'Error loading announcements: %s',
      'failed_to_dismiss_snack_template': 'Failed to dismiss announcement: %s',

      'game_select_difficulty':
          'Select Difficulty', // AppBar title when selecting difficulty
      'game_select_difficulty_standard':
          'Select Difficulty (Standard Challenge)', // Header inside selection screen
      'game_select_difficulty_time_attack':
          'Select Difficulty (Time Attack)', // Header inside selection screen
      'difficulty_easy': 'Easy Challenge',
      'difficulty_medium': 'Medium Challenge',
      'difficulty_hard': 'Hard Challenge',
      'label_select_answer': 'Select Answer',

      // --- HomeScreen Keys (NEW) ---
      'good_morning': 'Good morning',
      'good_afternoon': 'Good afternoon',
      'good_evening': 'Good evening',
      'home_motto': 'Snap it. Scan it. Know your fruit in\nseconds!',
      'claim_daily_rewards': 'Claim Your Daily Rewards!',
      'daily_rewards_subtitle':
          'Login everyday to earn free coins and unlock bonuses!',
      'challenge_fruit_iq': 'Challenge Your Fruit IQ!',
      'guess_the_fruit': 'Guess the Fruit',
      'guess_the_fruit_subtitle':
          'Identify fruits from pictures. How many can you get right?',
      'time_attack': 'Time Attack',
      'time_attack_subtitle':
          'Scan as many fruits as possible before the clock runs out!',
      // Bottom Navigation Labels
      'repository': 'Repository',
      'guide': 'Guide',
      'announced': 'Announced',

      // ... inside 'en': { ...

      // 🔒 NEW: Privacy/Security Screen Keys
      'security': 'Security',
      'change_password_title': 'Change Password',
      'current_password': 'Current Password',
      'new_password': 'New Password',
      'confirm_new_password': 'Confirm New Password',
      'change_password_button': 'Change Password',
      'forgot_password_button': 'Forgot your current password?',
      'password_required': 'Password is required.',
      'password_min_length': 'Password must be at least 8 characters long.',
      'password_uppercase':
          'Password must contain at least one uppercase letter.',
      'password_lowercase':
          'Password must contain at least one lowercase letter.',
      'password_digit': 'Password must contain at least one digit.',
      'password_special_char':
          'Password must contain at least one special character (!@#\$%^&*(),.?":{}|<>).',
      'new_password_hint':
          'Min 8 chars, 1 uppercase, 1 lowercase, 1 digit, 1 special char',
      'confirm_password_required': 'Confirm password is required.',
      'passwords_do_not_match': 'New passwords do not match.',
      'password_change_success': 'Password changed successfully',
      'error_user_not_logged_in':
          'Error: User not logged in or email unavailable.',
      'error_reauth_failed': 'Invalid current password. Please try again.',
      'error_too_many_requests':
          'Too many failed attempts. Please try again later.',
      'error_requires_recent_login':
          'This action requires recent authentication. Please log in again and retry.',
      'error_weak_password':
          'The new password is too weak. Please use a stronger password.',
      'error_password_reset_title': 'Reset Password',
      'error_password_reset_confirm':
          'Are you sure you want to send a password reset link to ',
      'error_password_reset_link_sent': 'Password reset link sent to ',
      'error_password_reset_check_email': '. Check your inbox and spam folder.',
      'button_cancel': 'Cancel',
      'button_send_reset_link': 'Send Reset Link',
      'error_email_not_found': 'Error: Could not find your email address.',
      'error_user_not_registered': 'The email address is not registered.',
      'error_unknown': 'An unknown error occurred.',

// 👥 NEW: User List Screen Keys (UserListScreen)
      'user_list_title': 'User List',
      'search_label': 'Search by name',
      'no_users_found': 'No users found',
      'no_users_matched': 'No users matched your search',
      'tooltip_download_all': 'Download All Users PDF',
      'tooltip_view_details': 'View Details',
      'tooltip_delete_user': 'Delete User',

      // Dialogs - Generic
      'button_cancel': 'Cancel', // Assumed to exist
      'button_close': 'Close', // Assumed to exist
      'button_delete': 'Delete', // Assumed to exist (used here with red style)
      'user_details_title': 'User Details',

      // Delete Confirmation Dialog
      'delete_user_confirm_title': 'Confirm Delete',
      'delete_user_confirm_content':
          'Are you sure you want to delete this user? This action cannot be undone.',

      // PDF Generation & Download
      'button_generate_pdf': 'Generate PDF',
      'pdf_user_info_title': 'User Information',
      'pdf_all_users_title': 'All Users Information',
      'pdf_status_generating': 'PDF for %s generated and shared!',
      'pdf_status_error': 'Error generating PDF: %s',
      'pdf_all_status_generating':
          'All users PDF generated and shared successfully!',
      'pdf_all_status_error': 'Error generating all users PDF: %s',
      'pdf_no_users_to_generate': 'No users to generate PDF for.',
      'pdf_no_users_found_message': 'No users found to generate PDF for.',

      // Download All Confirmation Dialog
      'download_confirm_title': 'Download All User Information?',
      'download_confirm_content':
          'Are you sure you want to download a PDF file with all user information?',
      'button_download': 'Download',
      'failed_to_fetch_users': 'Failed to fetch users: %s',

      // List Detail Labels (Also used in PDF)
      'label_full_name': 'Full Name',
      'label_age': 'Age',
      'label_sex': 'Sex',
      'label_address': 'Address',
      'label_mobile': 'Mobile',
      'label_role': 'Role',
      'label_harvesting_exp': 'Harvesting Experience',
      'label_email': 'Email',
      'label_na': 'N/A', // For nullable experience field

      // SnackBars
      'status_user_deleted': 'User deleted successfully!',

      // ...
      // --- NEW: Daily Rewards Screen Keys ---
      'daily_rewards_title': 'Daily Rewards',
      'reward_already_claimed': 'You have already claimed this reward!',
      'claim_one_per_day': 'You can only claim one reward per day!',
      'claim_current_day_first':
          'Please claim the current day\'s reward first!',
      'your_coins_prefix': 'Your Coins: ',
      'error_loading_coins': 'Error loading coins: ',
      'daily_login_bonus_title': '🎁 Daily Login Bonus',
      'day_prefix': 'Day ',
      'coins_suffix': ' Coins',
      'claim_button': 'CLAIM',
      'claimed_overlay': 'CLAIMED',
      'claim_success_message':
          'You claimed %1\$s coins for Day %2\$s!', // %1$s=coins, %2$s=day

      // --- General / Language ---
      'english': 'English',
      'tagalog': 'Tagalog',
      'cancel': 'Cancel',

      // --- Sign In Screen Keys ---
      'sign_in': 'Sign In',
      'welcome': 'Welcome, ',
      'grower': 'Grower!',
      'signin_motto':
          'Sign in to cultivate knowledge and access your dashboard.',
      'email_address': 'Email Address',
      'forgot_password': 'Forgot Password?',
      'no_account_question': 'Don\'t have an account? ',
      'sign_up_here': 'Sign up here.',
      'reset_password': 'Reset Password',
      'enter_your_email': 'Enter your email',
      'send_email': 'Send Email',
      'fill_in_all_fields': 'Please fill in both email and password.',
      'user_data_not_found': 'User data not found. Please contact support.',
      'login_failed_check_credentials':
          'Login Failed. Please check your email and password.',
      'please_enter_your_email': 'Please enter your email.',
      'password_reset_sent': 'Password reset email sent! Check your inbox.',
      'error_invalid_email_or_account':
          'Error: Invalid email or account not found.',

      // --- Sign Up Screen Keys ---
      'create_account': 'Create Account',
      'tap_to_add_profile': 'Tap to add a profile image',
      'first_name': 'First Name',
      'middle_name': 'Middle Name',
      'middle_name_optional': 'Middle Name (Optional)',
      'last_name': 'Last Name',
      'age': 'Age',
      'next': 'Next',
      'select_role': 'Select Role',
      'farmer': 'Farmer',
      'vendor': 'Vendor',
      'consumer': 'Consumer',
      'harvesting_experience_question': 'Do you have harvesting experience?',
      'yes': 'Yes',
      'no': 'No',
      'select_sex': 'Select Sex',
      'male': 'Male',
      'female': 'Female',
      'non_binary': 'Non-binary',
      'select_barangay': 'Select Barangay',
      'mobile_number_hint': 'Mobile Number (e.g., 9123456789)',
      'back': 'Back',
      'sign_up': 'Sign Up',
      'confirm_password': 'Confirm Password',
      'confirm_account_creation': 'Confirm Account Creation',
      'create': 'Create',
      'account_created_successfully': 'Account created successfully!',
      'creating_your_account': 'Creating your account...',
      'password': 'Password', // Also used in Sign In

      'game_title_fruit_identification': 'Fruit Identification Game 🍎',
      'game_select_mode': 'Select Game Mode',

      // app_localizations.dart -> inside the 'en': { ... } map

      // --- Localization Keys for Scan Flow (scann.dart, result.dart, display.dart) ---

      // result.dart keys
      'scanResultDetailsTitle': 'Scan Result Details',
      'detectedLabel': 'Detected:',
      'confidenceLabel': 'Confidence Level:',
      'scannedOnLabel': 'Scanned On:',
      'keyVitaminsLabel': 'Key Vitamins:',
      'shelfLifeLabel': 'Typical Shelf Life:',
      'aboutProduceLabel': 'About This Produce:',
      'scanAnotherButton': 'Scan Another Fruit',
      'noInfoAvailable': 'No additional information available.',

      // display.dart keys
      'dataRepositoryTitle': 'Data Repository',
      'noResultsMessage':
          'No scan results yet.\nPerform a scan to add data to your repository!',
      'resultPrefix': 'Result:',
      'probabilityPrefix': 'Probability:',
      'dateTimePrefix': 'Date/Time:',
      'vitaminsPrefix': 'Vitamins:',
      'deleteDialogTitle': 'Delete Scan Result?',
      'deleteDialogContent':
          'Are you sure you want to delete this scan result? This action cannot be undone.',

      // scann.dart keys (Dialogs and UI)
      'cameraAccessTitle': 'Allow Camera Access 📸',
      'cameraAccessContent':
          'Do you allow Harvi to use your camera to take a photo of your fruit?',
      'uploadPhotoTitle': 'Upload Photo 🖼️',
      'uploadPhotoContent':
          'Do you want to upload a photo of your fruit from your gallery?',
      'proceedButton': 'Proceed',
      'fruitScannerTitle': 'Fruit Scanner',
      'greetingText': 'Hello! Ready to identify your next best harvest?',
      'scanButton': 'Scan Fruit',
      'uploadButton': 'Upload Fruit',
      'undefinedResult': 'Undefined',

      // --- 0: Unripe Señorita Banana ---
      'unripeSenoritaBananaName': 'Unripe Señorita Banana',
      // Replaced with General Banana Nutrition
      'unripeSenoritaBananaVitamins': 'Potassium, Vitamin C, Dietary Fiber',
      'unripeSenoritaBananaShelfLife': 'Up to 15 days at 15°C',
      'unripeSenoritaBananaGeneralInfo':
          'Highly regarded due to its rich nutrient profile, including potassium, vitamin C, and dietary fiber, which promote heart health and digestive wellness (Jian, C. 2004).',

      // --- 1: Ripe Señorita Banana ---
      'ripeSenoritaBananaName': 'Ripe Señorita Banana',
      // Replaced with General Banana Nutrition
      'ripeSenoritaBananaVitamins': 'Potassium, Vitamin C, Dietary Fiber',
      'ripeSenoritaBananaShelfLife': 'Up to 15 days at 15°C',
      'ripeSenoritaBananaGeneralInfo':
          'Highly regarded due to its rich nutrient profile, including potassium, vitamin C, and dietary fiber, which promote heart health and digestive wellness (Jian, C. 2004).',

      // --- 2: Unripe Calamansi Citrus ---
      'unripeCalamansiCitrusName': 'Unripe Calamansi Citrus',
      // Replaced with General Calamansi Nutrition
      'unripeCalamansiCitrusVitamins':
          'Low Glycaemic Index, Significant Vitamin C',
      'unripeCalamansiCitrusShelfLife': 'up to 60 days',
      'unripeCalamansiCitrusGeneralInfo':
          'Highly valued for its low glycaemic index and significant vitamin C content, which supports immune health and provides antioxidant benefits (Siner, A. 2020).',

      // --- 3: Ripe Calamansi Citrus ---
      'ripeCalamansiCitrusName': 'Ripe Calamansi Citrus',
      // Replaced with General Calamansi Nutrition
      'ripeCalamansiCitrusVitamins':
          'Low Glycaemic Index, Significant Vitamin C',
      'ripeCalamansiCitrusShelfLife':
          '5–7 days at room temperature (~25–30 °C), up to 2 weeks refrigerated',
      'ripeCalamansiCitrusGeneralInfo':
          'Highly valued for its low glycaemic index and significant vitamin C content, which supports immune health and provides antioxidant benefits (Siner, A. 2020).',

      // --- 4: Unripe Marglobe Tomato ---
      'unripeMarglobeTomatoName': 'Unripe Marglobe Tomato',
      // Replaced with General Tomato Nutrition
      'unripeMarglobeTomatoVitamins':
          'Vitamin C, Vitamin E, Various Carotenoids (Lycopene)',
      'unripeMarglobeTomatoShelfLife':
          'up to 28 days in cold storage and 14 days at room temperature',
      'unripeMarglobeTomatoGeneralInfo':
          'Its rich content of vitamins C, E, and various carotenoids, such as lycopene, further enhance its health benefits (Ibrahim, S et al. 2023). Regular consumption can support immune function and reduce the risk of chronic diseases.',

      // --- 5: Ripe Marglobe Tomato ---
      'ripeMarglobeTomatoName': 'Ripe Marglobe Tomato',
      // Replaced with General Tomato Nutrition
      'ripeMarglobeTomatoVitamins':
          'Vitamin C, Vitamin E, Various Carotenoids (Lycopene)',
      'ripeMarglobeTomatoShelfLife':
          '1–2 days at room temperature once overripe; best consumed immediately or used in cooking',
      'ripeMarglobeTomatoGeneralInfo':
          'Its rich content of vitamins C, E, and various carotenoids, such as lycopene, further enhance its health benefits (Ibrahim, S et al. 2023). Regular consumption can support immune function and reduce the risk of chronic diseases.',

      // --- 6: Overripe Marglobe Tomato ---
      'overripeMarglobeTomatoName': 'Overripe Marglobe Tomato',
      // Replaced with General Tomato Nutrition
      'overripeMarglobeTomatoVitamins':
          'Vitamin C, Vitamin E, Various Carotenoids (Lycopene)',
      'overripeMarglobeTomatoShelfLife':
          '1–2 days at room temperature once overripe; best consumed immediately or used in cooking',
      'overripeMarglobeTomatoGeneralInfo':
          'Its rich content of vitamins C, E, and various carotenoids, such as lycopene, further enhance its health benefits (Ibrahim, S et al. 2023). Regular consumption can support immune function and reduce the risk of chronic diseases.',

      // --- 7: Unripe Bettina Papaya ---
      'unripeBettinaPapayaName': 'Unripe Bettina Papaya',
      // Replaced with General Papaya Nutrition
      'unripeBettinaPapayaVitamins':
          'Vitamin C, Essential Vitamins and Minerals, Carotenoids',
      'unripeBettinaPapayaShelfLife':
          'Up to 10 days at room temperature (~25–30 °C), ripens over time',
      'unripeBettinaPapayaGeneralInfo':
          'Highly beneficial, as it provides essential vitamins and minerals, particularly vitamin C and carotenoids, which contribute to overall health and wellness (Wall, M et al. 2014). Regular consumption can support immune function and reduce the risk of chronic diseases.',

      // --- 8: Unripe Sili Labuyo ---
      'unripeGreenChiliPepperName': 'Unripe Sili Labuyo',
      // Replaced with General Pepper Nutrition
      'unripeGreenChiliPepperVitamins': 'Vitamin C, Carotenoids',
      'unripeGreenChiliPepperShelfLife':
          'Can be stored in the refrigerator for 1-2 weeks, Can be frozen for up to a year.',
      'unripeGreenChiliPepperGeneralInfo':
          'Rich in vitamins and minerals, particularly vitamin C and carotenoids, which contribute to its antioxidative properties (Guil-Guerrero et al., 2006).',

      // --- 9: Ripe Sili Labuyo ---
      'ripeLabuyoPepperName': 'Ripe Sili Labuyo',
      // Replaced with General Pepper Nutrition
      'ripeLabuyoPepperVitamins': 'Vitamin C, Carotenoids',
      'ripeLabuyoPepperShelfLife':
          '1–2 weeks at room temperature (~25–30 °C), longer if dried or refrigerated',
      'ripeLabuyoPepperGeneralInfo':
          'Rich in vitamins and minerals, particularly vitamin C and carotenoids, which contribute to its antioxidative properties (Guil-Guerrero et al., 2006).',

      // --- 10: Ripe Bettina Papaya ---
      'ripeBettinaPapayaName': 'Ripe Bettina Papaya',
      // Replaced with General Papaya Nutrition
      'ripeBettinaPapayaVitamins':
          'Vitamin C, Essential Vitamins and Minerals, Carotenoids',
      'ripeBettinaPapayaShelfLife':
          '3-5 days at room temperature once fully ripe',
      'ripeBettinaPapayaGeneralInfo':
          'Highly beneficial, as it provides essential vitamins and minerals, particularly vitamin C and carotenoids, which contribute to overall health and wellness (Wall, M et al. 2014). Regular consumption can support immune function and reduce the risk of chronic diseases.',

      // --- 11: Overripe Bettina Papaya ---
      'overripeBettinaPapayaName': 'Overripe Bettina Papaya',
      // Replaced with General Papaya Nutrition
      'overripeBettinaPapayaVitamins':
          'Vitamin C, Essential Vitamins and Minerals, Carotenoids (Diminishing)',
      'overripeBettinaPapayaShelfLife': 'Consume immediately or discard',
      'overripeBettinaPapayaGeneralInfo':
          'Highly beneficial, as it provides essential vitamins and minerals, particularly vitamin C and carotenoids, which contribute to overall health and wellness (Wall, M et al. 2014). Regular consumption can support immune function and reduce the risk of chronic diseases.',

      // --- 12: Ripe Kirby Cucumber ---
      'ripeKirbyCucumberName': 'Ripe Kirby Cucumber',
      // Replaced with General Cucumber Nutrition
      'ripeKirbyCucumberVitamins':
          'High Water Content, Vitamin A, Vitamin C, Vitamin K',
      'ripeKirbyCucumberShelfLife':
          '5–7 days under typical conditions (usually room temperature, ~25–30 °C)',
      'ripeKirbyCucumberGeneralInfo':
          'Rich in water content and essential nutrients, including vitamins A, C, and K, making them an excellent choice for hydration and overall health (Murad, H. 2016).',

      // --- 13: Overripe Sili Labuyo ---
      'overripeLabuyoPepperName': 'Overripe Labuyo Pepper',
      // Replaced with General Pepper Nutrition
      'overripeLabuyoPepperVitamins': 'Vitamin C, Carotenoids (Diminishing)',
      'overripeLabuyoPepperShelfLife': '2-3 days (fresh) or months (if dried)',
      'overripeLabuyoPepperGeneralInfo':
          'Rich in vitamins and minerals, particularly vitamin C and carotenoids, which contribute to its antioxidative properties (Guil-Guerrero et al., 2006).',

      // --- 14: Overripe Calamansi Citrus ---
      'overripeCalamansiCitrusName': 'Overripe Calamansi Citrus',
      // Replaced with General Calamansi Nutrition
      'overripeCalamansiCitrusVitamins':
          'Low Glycaemic Index, Significant Vitamin C',
      'overripeCalamansiCitrusShelfLife': '2-3 days (highly perishable)',
      'overripeCalamansiCitrusGeneralInfo':
          'Highly valued for its low glycaemic index and significant vitamin C content, which supports immune health and provides antioxidant benefits (Siner, A. 2020).',

      // --- 15: Overripe Señorita Banana ---
      'overripeSenoritaBananaName': 'Overripe Señorita Banana',
      // Replaced with General Banana Nutrition
      'overripeSenoritaBananaVitamins': 'Potassium, Vitamin C, Dietary Fiber',
      'overripeSenoritaBananaShelfLife': 'Up to 15 days at 15°C',
      'overripeSenoritaBananaGeneralInfo':
          'Highly regarded due to its rich nutrient profile, including potassium, vitamin C, and dietary fiber, which promote heart health and digestive wellness (Jian, C. 2004).',

      // --- 16: Overripe Kirby Cucumber ---
      'overripeKirbyCucumberName': 'Overripe Kirby Cucumber',
      // Replaced with General Cucumber Nutrition
      'overripeKirbyCucumberVitamins':
          'High Water Content, Vitamin A, Vitamin C, Vitamin K',
      'overripeKirbyCucumberShelfLife': 'Consume immediately or discard',
      'overripeKirbyCucumberGeneralInfo':
          'Rich in water content and essential nutrients, including vitamins A, C, and K, making them an excellent choice for hydration and overall health (Murad, H. 2016).',

      // --- 17: Unripe Kirby Cucumber ---
      'unripeKirbyCucumberName': 'Unripe Kirby Cucumber',
      // Replaced with General Cucumber Nutrition
      'unripeKirbyCucumberVitamins':
          'High Water Content, Vitamin A, Vitamin C, Vitamin K',
      'unripeKirbyCucumberShelfLife': '10-14 days in refrigerator',
      'unripeKirbyCucumberGeneralInfo':
          'Rich in water content and essential nutrients, including vitamins A, C, and K, making them an excellent choice for hydration and overall health (Murad, H. 2016).',

      // General utility buttons (used in scan flow)
      'cancelButton': 'Cancel',
      'deleteButton': 'Delete',

      // Date/Time formatting keys (used in scann.dart)
      'monthJanuary': 'January',
      'monthFebruary': 'February',
      'monthMarch': 'March',
      'monthApril': 'April',
      'monthMay': 'May',
      'monthJune': 'June',
      'monthJuly': 'July',
      'monthAugust': 'August',
      'monthSeptember': 'September',
      'monthOctober': 'October',
      'monthNovember': 'November',
      'monthDecember': 'December',
      'am': 'AM',
      'pm': 'PM',

      // --- GENERAL FALLBACKS ---
      'infoNotAvailable': 'N/A', // Used for vitamins/shelf life if not found

      // ====================================================================
      // --- FRUIT DETAILS (IDs 0 - 17) ---
      // ====================================================================

      // --- 0: Unripe Señorita Banana ---
      'fruit_0_name': 'Unripe Señorita Banana',
      'fruit_0_vitamins_key': 'Potassium, Vitamin C, Dietary Fiber',
      'fruit_0_shelfLife_key': 'Up to 15 days at 15°C',
      'fruit_0_info_key':
          'Bananas are grown in tropical areas. Unripe bananas are firm and starchy. Promotes heart health and digestive wellness.',

      // --- 1: Ripe Señorita Banana ---
      'fruit_1_name': 'Ripe Señorita Banana',
      'fruit_1_vitamins_key': 'Potassium, Vitamin C, Dietary Fiber',
      'fruit_1_shelfLife_key': 'Up to 15 days at 15°C',
      'fruit_1_info_key':
          'Bananas are grown in tropical areas. Ripe bananas support heart health and digestive wellness due to their nutrient profile.',

      // --- 2: Unripe Calamansi Citrus ---
      'fruit_2_name': 'Unripe Calamansi Citrus',
      'fruit_2_vitamins_key': 'Vitamin C (High content), Low Glycaemic Index',
      'fruit_2_shelfLife_key': 'Up to 60 days',
      'fruit_2_info_key':
          'Unripe Calamansi is green and firm. Valued for immune health and antioxidant benefits.',

      // --- 3: Ripe Calamansi Citrus ---
      'fruit_3_name': 'Ripe Calamansi Citrus',
      'fruit_3_vitamins_key': 'Vitamin C (High content), Low Glycaemic Index',
      'fruit_3_shelfLife_key': '5–7 days at room temperature (~25–30 °C)',
      'fruit_3_info_key':
          'Calamansi is native to the Philippines. Its high Vitamin C content supports immune health and provides antioxidants.',

      // --- 4: Unripe Marglobe Tomato ---
      'fruit_4_name': 'Unripe Marglobe Tomato',
      'fruit_4_vitamins_key': 'Vitamin C, Vitamin E, Carotenoids (Lycopene)',
      'fruit_4_shelfLife_key': 'Up to 28 days in cold storage',
      'fruit_4_info_key':
          'Unripe tomatoes are firm and green. Regular consumption can support immune function and reduce chronic disease risks.',

      // --- 5: Ripe Marglobe Tomato ---
      'fruit_5_name': 'Ripe Marglobe Tomato',
      'fruit_5_vitamins_key': 'Vitamin C, Vitamin E, Carotenoids (Lycopene)',
      'fruit_5_shelfLife_key': '1–2 days at room temperature once overripe',
      'fruit_5_info_key':
          'Marglobe is a tomato variety known for its round shape. Its nutrients support immune function and reduce chronic disease risks.',

      // --- 6: Overripe Marglobe Tomato ---
      'fruit_6_name': 'Overripe Marglobe Tomato',
      'fruit_6_vitamins_key': 'Vitamin C, Vitamin E, Carotenoids (Lycopene)',
      'fruit_6_shelfLife_key': 'Consume immediately',
      'fruit_6_info_key':
          'Overripe fruits are soft and best used in sauces. Still contains vitamins that support immune function.',

      // --- 7: Unripe Bettina Papaya ---
      'fruit_7_name': 'Unripe Bettina Papaya',
      'fruit_7_vitamins_key': 'Vitamin C, Carotenoids',
      'fruit_7_shelfLife_key': 'Up to 10 days at room temperature',
      'fruit_7_info_key':
          'Unripe Bettina papaya is firmer and used in "tinola". Provides essential vitamins contributing to overall health.',

      // --- 8: Unripe Sili Labuyo ---
      'fruit_8_name': 'Unripe Sili Labuyo',
      'fruit_8_vitamins_key': 'Vitamin C, Carotenoids',
      'fruit_8_shelfLife_key': '1-2 weeks in refrigerator',
      'fruit_8_info_key':
          'Green chilies are often the unripe version. They are rich in vitamins and minerals with antioxidative properties.',

      // --- 9: Ripe Sili Labuyo ---
      'fruit_9_name': 'Ripe Sili Labuyo',
      'fruit_9_vitamins_key': 'Vitamin C, Carotenoids',
      'fruit_9_shelfLife_key': '1–2 weeks at room temperature',
      'fruit_9_info_key':
          'Labuyo chili is one of the hottest native peppers. Rich in Vitamin C and Carotenoids for antioxidative benefits.',

      // --- 10: Ripe Bettina Papaya ---
      'fruit_10_name': 'Ripe Bettina Papaya',
      'fruit_10_vitamins_key': 'Vitamin C, Carotenoids',
      'fruit_10_shelfLife_key': '3–5 days in refrigerator',
      'fruit_10_info_key':
          'Ripe Bettina papaya has sweet, orange flesh. Supports immune function and reduces risk of chronic diseases.',

      // --- 11: Overripe Bettina Papaya ---
      'fruit_11_name': 'Overripe Bettina Papaya',
      'fruit_11_vitamins_key': 'Vitamin C, Carotenoids',
      'fruit_11_shelfLife_key': 'Consume immediately',
      'fruit_11_info_key':
          'Overripe papaya becomes very soft. It remains a source of Vitamin C and Carotenoids.',

      // --- 12: Ripe Kirby Cucumber ---
      'fruit_12_name': 'Ripe Kirby Cucumber',
      'fruit_12_vitamins_key':
          'Vitamin A, Vitamin C, Vitamin K, High Water Content',
      'fruit_12_shelfLife_key': '5–7 days under typical conditions',
      'fruit_12_info_key':
          'Cucumbers are grown year-round. An excellent choice for hydration and overall health.',

      // --- 13: Overripe Sili Labuyo ---
      'fruit_13_name': 'Overripe Sili Labuyo',
      'fruit_13_vitamins_key': 'Vitamin C, Carotenoids',
      'fruit_13_shelfLife_key': '2-3 days (fresh) or months (if dried)',
      'fruit_13_info_key':
          'Overripe Labuyo peppers often appear shriveled. They still contain carotenoids which contribute to antioxidative properties.',

      // --- 14: Overripe Calamansi Citrus ---
      'fruit_14_name': 'Overripe Calamansi Citrus',
      'fruit_14_vitamins_key': 'Vitamin C (High content)',
      'fruit_14_shelfLife_key': '2-3 days (highly perishable)',
      'fruit_14_info_key':
          'Overripe Calamansi has loose, orange skin. Still valued for Vitamin C content supporting immune health.',

      // --- 15: Overripe Señorita Banana ---
      'fruit_15_name': 'Overripe Señorita Banana',
      'fruit_15_vitamins_key': 'Potassium, Vitamin C, Dietary Fiber',
      'fruit_15_shelfLife_key': 'Consume immediately',
      'fruit_15_info_key':
          'Overripe bananas are very sweet. They remain rich in Potassium and Fiber for heart health.',

      // --- 16: Overripe Kirby Cucumber ---
      'fruit_16_name': 'Overripe Kirby Cucumber',
      'fruit_16_vitamins_key': 'Vitamin A, Vitamin C, Vitamin K',
      'fruit_16_shelfLife_key': 'Consume immediately or discard',
      'fruit_16_info_key':
          'Overripe cucumbers turn yellow. While texture degrades, they contain essential nutrients like Vitamins A, C, and K.',

      // --- 17: Unripe Kirby Cucumber ---
      'fruit_17_name': 'Unripe Kirby Cucumber',
      'fruit_17_vitamins_key':
          'Vitamin A, Vitamin C, Vitamin K, High Water Content',
      'fruit_17_shelfLife_key': '10-14 days in refrigerator',
      'fruit_17_info_key':
          'Unripe Kirby cucumbers are small and firm. Excellent for hydration and overall health due to water and vitamin content.',
      // --- UI LABELS ---
      // ====================================================================

      // Difficulty Selection

      // Mode Selection

      'game_mode_standard_title': 'Standard Challenge 🧠',

      'game_mode_standard_desc':
          'Fixed number of questions. Test your knowledge across different difficulty stages.',

      'game_mode_time_attack_title': 'Time Attack ⏱️',

      'game_mode_time_attack_desc':
          'Rapid-fire questions with a time limit! Answer as many as possible to maximize earnings.',

      // Difficulty Selection

      'game_select_difficulty_standard':
          'Select Difficulty for Standard Challenge',

      'game_select_difficulty_time_attack': 'Select Difficulty for Time Attack',

      'difficulty_easy': 'Easy',

      'difficulty_medium': 'Medium',

      'difficulty_hard': 'Hard',

      'label_cost': 'cost',

      'label_coins_per_correct': 'coins/correct answer',

      'label_seconds_short': 's',
      // --- 24 Fruit Class Names (English) ---
      'fruit_0_name': 'Unripe Señorita Banana',
      'fruit_1_name': 'Ripe Señorita Banana',
      'fruit_2_name': 'Unripe Calamansi Citrus',
      'fruit_3_name': 'Ripe Calamansi Citrus',
      'fruit_4_name': 'Unripe Marglobe Tomato',
      'fruit_5_name': 'Ripe Marglobe Tomato',
      'fruit_6_name': 'Overripe Marglobe Tomato',
      'fruit_7_name': 'Unripe Bettina Papaya',
      'fruit_8_name': 'Unripe Sili Labuyo',
      'fruit_9_name': 'Ripe Sili Labuyo',
      'fruit_10_name': 'Ripe Bettina Papaya',
      'fruit_11_name': 'Overripe Bettina Papaya',
      'fruit_12_name': 'Ripe Kirby Cucumber',
      'fruit_13_name': 'Overripe Sili Labuyo',
      'fruit_14_name': 'Overripe Calamansi Citrus',
      'fruit_15_name': 'Overripe Señorita Banana',
      'fruit_16 name': 'Overripe Kirby Cucumber',
      'fruit_17_name': 'Unripe Kirby Cucumber',

// ====================================================================
// --- 72 Fruit Detail Keys (English) ---
// ====================================================================
      // ====================================================================
      // --- NEW 19 Fruit Class Names & Details (English) ---
      // ====================================================================

      'start_challenge_title_template':
          'Start {difficulty} - {modeName}?', // {difficulty}, {modeName} placeholders
      'challenge_time_info_standard': 'A set number of questions.',
      'challenge_time_info_time_attack_template':
          'You have {duration} seconds to answer as many as possible.', // {duration} placeholder
      'challenge_confirmation_message_template':
          'This game costs {cost} coins and rewards {reward} coins per correct answer. Are you sure you want to play?', // {cost}, {reward} placeholders
      'start': 'Start',

      // Status/Feedback
      'status_started_template':
          '{difficulty} {mode} started! {cost} coins deducted.', // {difficulty}, {mode}, {cost} placeholders
      'status_not_enough_coins_template':
          'Not enough coins! You need {cost} coins.', // {cost} placeholder
      'dialog_confirm_submission_title': 'Confirm Submission',
      'dialog_confirm_submission_content':
          'Are you sure you want to submit this answer?',
      'submit': 'Submit',
      'submit_answer': 'Submit Answer',
      'validation_select_option': 'Please select an option.',
      'validation_type_answer': 'Please type an answer.',
      'feedback_correct': 'Correct!',
      'feedback_incorrect_is_template':
          'Incorrect. It\'s {correctAnswer}.', // {correctAnswer} placeholder

      // Question & Input Hints
      'question_hard_standard':
          'Identify the harvesting step AND its order (e.g., "1. check" or "1. pagsasako")',
      'question_hard_time_attack': 'Identify the correct harvesting step',
      'question_easy_medium': 'Identify the fruit name',
      'input_hint_hard_standard':
          'Type the order and step (e.g., 1. check or 1. pagsasako)',
      'input_hint_easy_medium': 'Type the fruit name (English or Tagalog)',
      'label_score': 'Score:',
      'label_question_short': 'Q:',
      'label_time_short': 'Time:',

      // Game Result Dialog
      'game_over_challenge_title': 'Challenge Over!',
      'game_over_time_attack_title': 'Time Attack Over!',
      'game_result_standard_template':
          'You scored {score} out of {total} in the {difficulty} stage!', // {score}, {total}, {difficulty} placeholders
      'game_result_time_attack_template':
          'You identified {score} items in the {difficulty} Time Attack!', // {score}, {difficulty} placeholders
      'game_result_master': '🎉 Congratulations! You are a master!',
      'game_result_coins_earned_template':
          'Coins earned: {coins}', // {coins} placeholder
      'play_again': 'Play Again',
      'back_to_home': 'Back to Home',

      // Quit Dialog
      'dialog_quit_game_title': 'Quit Game?',
      'dialog_quit_game_content':
          'Are you sure you want to quit the current game? Your progress and potential earnings will be lost.',
      'no_continue': 'No, continue',
      'yes_quit': 'Yes, quit',

      // --- Validation & Error Keys (Sign Up) ---
      'please_select_option': 'Please select an option',
      'please_enter_field': 'Please enter {field}', // {field} is a placeholder
      'alphabetical_only':
          'Please enter only alphabetical characters for {field}',
      'please_enter_age': 'Please enter your age',
      'please_enter_valid_age': 'Please enter a valid age',
      'please_enter_mobile': 'Please enter your mobile number',
      'mobile_number_format': 'Enter 10 digits (e.g., 9xxxxxxxxx).',
      'please_enter_email': 'Please enter email',
      'please_enter_valid_email': 'Enter a valid email',
      'please_enter_password': 'Please enter password',
      'password_strength_requirements':
          'Password must be at least 8 characters,\ninclude uppercase, lowercase, number, and special character',
      'please_confirm_password': 'Please confirm password',
      'passwords_do_not_match': 'Passwords do not match',
      'please_select_all_options': 'Please select all required options.',
      'invalid_email_format': 'Invalid email format',
      'email_already_in_use': 'This email is already in use.',
      'account_creation_failed': 'Account Creation Failed: {error}',
      'unexpected_error': 'Unexpected Error: {error}',

      // 👤 NEW: Profile Detail Screen Keys
      'edit_profile': 'Edit Profile',
      'welcome_message': 'Welcome, ',
      'welcome_default': 'Welcome!',
      'change_profile_picture': 'Change Profile Picture',
      'first_name': 'First Name',
      'middle_name': 'Middle Name (Optional)',
      'last_name': 'Last Name',
      'first_name_required': 'First Name is required.',
      'last_name_required': 'Last Name is required.',
      'save_changes': 'Save Changes',
      'profile_update_success': 'Profile updated successfully',
      'error_load_profile': 'Failed to load profile data.',
      'error_saving_profile': 'An unexpected error occurred while saving.',
      'save_confirmation_title': 'Save Changes?',
      'save_confirmation_content':
          'Are you sure you want to save your profile changes?',
      'button_save': 'Save',
// ...
// --- NEW: General Utility Keys (if not already present) ---
      'cancel': 'Cancel',
      'start': 'Start',
      'play_again': 'Play Again',
      'back_to_home': 'Back to Home',

// --- NEW: Stage Names (used internally and in UI) ---
      'stage_easy': 'Easy',
      'stage_medium': 'Medium',
      'stage_hard': 'Hard',

// --- NEW: Fruit Identification Game Keys ---
      'game_title': 'Fruit Identification Game',
      'game_challenge': '%s Challenge', // E.g., Easy Challenge
      'game_choose_challenge': 'Choose Your Challenge!',
      'coins_per_correct_answer':
          ' %s coins/correct answer', // E.g., 5 coins/correct answer

// Game Mechanics
      'game_mechanics_title': 'Game Mechanics:',
      'game_mechanics_body_1':
          'A coin cost will be deducted per stage you choose. Guess the fruit name for Easy and Medium difficulties. For Hard difficulty, identify the harvesting step AND its correct order number (e.g., "1. check").',
      'game_mechanics_body_2': 'You will earn coins for each correct answer.',

// Game Prompts
      'game_fruit_question_prompt': 'Identify the fruit name',
      'game_hard_question_prompt':
          'Identify the harvesting step AND its order (e.g., "1. check")',
      'game_answer_hint': 'Type your answer',
      'game_submit_answer': 'Submit Answer',
      'loading_images': 'Loading images...',
      'game_question_counter': 'Question %d / %d', // Question 1 / 10

      // 📢 NEW: Admin Announcement Screen Keys (AdminAnnouncementScreen)
      'announcement_title_screen': 'Admin Announcements',
      'field_title': 'Title',
      'field_description': 'Description',
      'button_post_announcement': 'Post Announcement',
      'no_announcements_found': 'No announcements found.',

      // Post Confirmation Dialog
      'post_confirm_title': 'Post Announcement?',
      'post_confirm_content':
          'Are you sure you want to post this announcement?',
      'button_post': 'Post',

      // Edit Dialog
      'edit_dialog_title': 'Edit Announcement',
      'edit_field_label': 'Message',

      // Edit Save Confirmation Dialog
      'save_changes_title': 'Save Changes?',
      'save_changes_content':
          'Are you sure you want to save the changes to this announcement?',
      'button_save': 'Save',

      // Delete Confirmation Dialog
      'delete_confirm_title': 'Delete Announcement?',
      'delete_confirm_content':
          'Are you sure you want to delete this announcement? This action cannot be undone.',
      'button_delete': 'Delete',

      // View Dialog
      'view_dialog_title': 'Announcement',
      'button_close': 'Close',

      // General Buttons & Statuses
      'button_cancel': 'Cancel', // Assumed already exists
      'status_announcement_posted': 'Announcement Posted',
      'status_announcement_saved': 'Announcement Saved',
      'status_announcement_deleted': 'Announcement Deleted',
      'list_no_title': 'No Title',
      'list_no_date': 'No Date',
      'list_no_message': 'No Message',

      // ...

// Confirmation & Feedback
      'game_quit_title': 'Quit Game?',
      'game_quit_content':
          'Are you sure you want to quit the current game? Your progress and potential earnings for this round will be lost.',
      'game_quit_no': 'No, continue',
      'game_quit_yes': 'Yes, quit',
      'game_start_confirm_title': 'Start %s Game?',
      'game_start_confirm_content':
          'This game costs %d coins. Are you sure you want to play?',
      'game_start_snackbar': 'Game started! %d coins deducted.',
      'game_not_enough_coins':
          'Not enough coins to play the %s stage! You need %d coins.',
      'game_feedback_correct': 'Correct!',
      'game_feedback_incorrect':
          'Incorrect. It\'s %s.', // Requires correct answer in UPPERCASE

// Game Result
      'game_over_title': 'Game Over!',
      'game_result_score': 'You scored %d out of %d in the %s stage!',
      'game_result_master': '🎉 Congratulations! 🎉\nYou are a master!',
      'game_result_well_done': 'Well done! Keep practicing!',
      'game_result_good_effort': 'Good effort! Try again to improve!',
      'game_result_coins_earned': 'Coins earned: %d',
// ... inside 'en': { ...

      // ℹ️ NEW: About Us Screen Keys
      'about_us': 'About Us',
      'app_slogan': 'Your Fruit Identification Companion',

      // Mission & Vision
      'mission_vision_title': 'Our Mission & Vision 🌱',
      'mission_vision_body':
          'Harvi is dedicated to making the fascinating world of fruits accessible to everyone. Our mission is to empower users with instant fruit identification, fostering a deeper appreciation for nature\'s bounty and promoting healthy living through knowledge.',

// 👑 NEW: Admin Screen Keys
      'admin_dashboard_title': 'Admin Dashboard',
      'admin_welcome_subtext': 'Welcome back to your dashboard.',
      'quick_actions_title': 'Quick Actions',
      'manage_users': 'Manage Users',
      'create_admin_account': 'Create Admin Account',
      'create_announcement': 'Create Announcement',
      // 'settings': 'Settings', // Already exists

      // --- Time-based greetings (used in AdminScreen & HomeScreen) ---
      'good_morning': 'Good Morning',
      'good_afternoon': 'Good Afternoon',
// ignore: equal_keys_in_map
      'good_evening': 'Good Evening',
// ... existing keys
// 👑 NEW: Admin Account Creation Screen Keys (AdminsScreen)
      'create_admin_title': 'Create Admin',
      'field_first_name': 'First Name',
      'field_middle_name': 'Middle Name (Optional)',
      'field_last_name': 'Last Name',
      'field_email': 'Email',
      'field_password': 'Password',
      'field_confirm_password': 'Confirm Password',
      'name_required': 'Name is required.', // General validation for First/Last
      'name_invalid_char':
          'Only alphabetical letters and symbols like \'-\' are allowed.',
      'email_required': 'Email is required.',
      'email_invalid': 'Enter a valid email address.',
      'password_required': 'Password is required.',
      'password_strong_policy':
          '8+ chars, incl. uppercase, lowercase, number, special.',
      'passwords_must_match': 'Passwords do not match.',
      'button_create': 'Create',

// Dialog & Verification
      'verify_identity_title': 'Verify Your Identity (Current Admin)',
      'verify_password_field': 'Your Current Password',
      'error_enter_password': 'Please enter your password.',
      'error_verification_failed':
          'Incorrect password or authorization failed.',
      'button_verify': 'Verify',

// Success Dialog
      'admin_creation_success_title': 'Admin Created Successfully! 🎉',
      'admin_creation_success_message':
          'The new admin account for %s has been created. \n\n You are required to log out to switch to or verify the new account.', // %s is the email
      'button_log_out_now': 'Log Out Now',
      'button_cancel': 'Cancel', // Already exists, but kept for context

// General Error/Status
      'status_signed_up':
          'Signed Up', // Should match the success message from AuthService
// ...

      // How It Works
      'how_it_works_title': 'How It Works 📷',
      'how_it_works_body':
          'The app uses advanced image recognition technology to analyze and identify fruits. Simply point your device\'s camera, and the app will provide instant, accurate results, including details about the fruit. It\'s simple, fast, and fun!',

      // Team
      'team_title': 'Meet the Team 🧑‍💻',
      'role_developers': 'Developers:',
      'role_adviser': 'Adviser:',
      'role_technical_critique': 'Technical Critique:',

      // Contact
      'contact_us_title': 'Contact Us 📧',
      'contact_us_body':
          'Have questions or feedback? We\'d love to hear from you! Reach out to us at: harvi@gmail.com',
// ...

      // ... inside 'en': { ...
      // ❓ NEW: Help Center Screen Keys
      'faq_title': 'Frequently Asked Questions',
      'safety_disclaimer_title': 'Important Safety Disclaimer ⚠️',
      'safety_disclaimer_content':
          'The app is for informational purposes and educational use only. Do not consume any fruit based solely on the app\'s identification. Always consult a professional or a reliable guide before consuming wild or unknown fruits.',

      // ❓ NEW: Help Center FAQ Content - Titles
      'faq_title_getting_started': 'Getting Started',
      'faq_title_troubleshooting': 'Troubleshooting',
      'faq_title_features': 'Features',

      // ❓ NEW: Help Center FAQ Content - Q/A
      'faq_q_identify_fruit': 'How do I identify a fruit? 🍎',
      'faq_a_identify_fruit':
          'Simply open the camera in the app and point it at a fruit. Make sure the fruit is well-lit and in focus. Tap the screen to take a photo, and the app will provide the identification results.',
      'faq_q_good_photo': 'What makes a good photo? 📸',
      'faq_a_good_photo':
          'For best results, use clear lighting, place the fruit on a neutral background, and get as close as possible while keeping the entire fruit in the frame.',
      'faq_q_cant_identify': 'What if the app can\'t identify a fruit? 🤔',
      'faq_a_cant_identify':
          'Our database is always growing, but it may not contain every variety. Try taking another picture from a different angle or with better lighting. If it\'s still unidentified, you can contribute the fruit\'s photo through the email!',
      'faq_q_inaccurate': 'Why is the identification inaccurate? 🧐',
      'faq_a_inaccurate':
          'The accuracy of the app relies heavily on the quality of the photo. Ensure the image is not blurry, overexposed, or obscured by other objects. Our machine learning model is continuously learning and improving.',
      'faq_q_learning_guide': 'What is the Learning Guide? 📚',
      'faq_a_learning_guide':
          'The Learning Guide provides comprehensive information about fruits and proper harvesting techniques. You can access it by tapping on any identified fruit photo.',
      'faq_q_announcements': 'How do Announcements work? 📣',
      'faq_a_announcements':
          'Announcements are created and managed by the app administrators. They provide important updates, news, and special messages to all users.',
      'faq_q_games': 'What are the games? 🎮',
      'faq_a_games':
          'Harvi features two fun games: "Guess the Photo" and "Timed Guess Photo." These are designed to entertain and challenge you while also offering daily rewards!',
      'faq_q_save_list': 'How does the Save List work? ✅',
      'faq_a_save_list':
          'The Save List automatically saves all fruits you have successfully identified. You no longer need to manually save them, ensuring your collection is always up to date.',
// ...

      // 🕹️ NEW: Game/Quiz Screen Keys
      'game_start_button': 'Start Game',
      'game_next_question': 'Next Question',
      'game_submit_answer': 'Submit',
      'game_correct': 'Correct!',
      'game_incorrect': 'Incorrect.',
      'game_time_up': 'Time’s Up!',
      'game_score': 'Your Score:',
      'game_high_score': 'High Score:',
      'game_play_again': 'Play Again',
      'game_exit': 'Exit',
      'guess_the_fruit_instruction': 'Which fruit is this?',
      'time_attack_instruction': 'Quickly identify the fruit displayed.',
      'time_remaining': 'Time Remaining:',

      // --- NEW: Horticulture Screen Keys ---
      'learning_guides': 'Learning Guides',
      'horticulture_banner_title': 'Get the Best Insights on Fruits!',
      'horticulture_banner_body':
          'Learn about fruits,\nfrom nutrition to harvesting tips.',
      'categories_title': 'Categories',

      // ... (Your existing keys) ...
      'middle_name': 'Middle Name', // Used for validation message
      'middle_name_optional': 'Middle Name (Optional)',
      'confirm_password': 'Confirm Password',
      'select_sex': 'Select Sex',
      'non_binary': 'Non-binary',
      'select_barangay': 'Select Barangay',
      'mobile_number_hint': 'Mobile Number (e.g., 9123456789)',
      'creating_your_account': 'Creating your account...',

      // Validation & Error Keys
      'please_select_option': 'Please select an option',
      'please_enter_field': 'Please enter {field}', // {field} is a placeholder
      'alphabetical_only':
          'Please enter only alphabetical characters for {field}',
      'please_enter_age': 'Please enter your age',
      'please_enter_valid_age': 'Please enter a valid age',
      'please_enter_mobile': 'Please enter your mobile number',
      'mobile_number_format': 'Enter 10 digits (e.g., 9xxxxxxxxx).',
      'please_enter_email': 'Please enter email',
      'please_enter_valid_email': 'Enter a valid email',
      'please_enter_password': 'Please enter password',
      'password_strength_requirements':
          'Password must be at least 8 characters,\ninclude uppercase, lowercase, number, and special character',
      'please_confirm_password': 'Please confirm password',
      'passwords_do_not_match': 'Passwords do not match',
      'please_select_all_options': 'Please select all required options.',
      'invalid_email_format': 'Invalid email format',
      'email_already_in_use': 'This email is already in use.',
      'account_creation_failed': 'Account Creation Failed: {error}',
      'unexpected_error': 'Unexpected Error: {error}',
      'confirm_account_message':
          'Are you sure you want to create this account?',

      // 🕹️ NEW: Game/Quiz Screen Keys
      'fruit_identification_game': 'Fruit Identification Game',
      'choose_your_challenge': 'Choose Your Challenge!',
      'game_mechanics': 'Game Mechanics:',
      'mechanics_desc_part1':
          'A coin cost will be deducted per stage you choose. Guess the fruit name for Easy and Medium difficulties. For Hard difficulty, identify the harvesting step AND its correct order number (e.g., "1. check").',
      'mechanics_desc_part2': 'You will earn coins for each correct answer.',
      'coins_per_correct_answer': 'coins/correct answer',

      'start_game': 'Start',
      'game_costs_message_part1': 'This game costs',
      'game_costs_message_part2': 'coins. Are you sure you want to play?',

      'game_started_message': 'Game started!',
      'game_coins_deducted': 'coins deducted.',
      'not_enough_coins_message_part1': 'Not enough coins to play the',
      'not_enough_coins_message_part2': 'stage! You need',
      'not_enough_coins_message_part3': 'coins.',

      'loading_images': 'Loading images...',
      'question': 'Question',
      'score': 'Score',
      'easy_medium_stage_instruction': 'Identify the fruit name',
      'hard_stage_instruction':
          'Identify the harvesting step AND its order (e.g., "1. check")',
      'type_your_answer': 'Type your answer',
      // ignore: equal_keys_in_map
      'game_submit_answer': 'Submit Answer',

      // ignore: equal_keys_in_map
      'game_correct': 'Correct!',
      // ignore: equal_keys_in_map
      'game_incorrect': 'Incorrect.',

      'game_over_title': 'Game Over!',
      'final_score_message_part1': 'You scored',
      'final_score_message_part2': 'out of',
      'final_score_message_part3': 'in the',
      'final_score_message_part4': 'stage!',
      'master_result_message': '🎉 Congratulations! 🎉\nYou are a master!',
      'good_result_message': 'Well done! Keep practicing!',
      'poor_result_message': 'Good effort! Try again to improve!',
      'congratulations_message': '🎉 Congratulations! 🎉\nYou are a master!',
      'coins_earned': 'Coins earned',
      'game_play_again': 'Play Again',

      // 🕹️ NEW: Quit Challenge Dialog Keys
      'quit_challenge_title': 'Quit Challenge?',
      'quit_challenge_content':
          'Are you sure you want to end the current game? Your score will not be saved.',
      'quit_challenge_no': 'No, Continue',
      'quit_challenge_yes': 'Yes, Quit', // Added 'yes' option for clarity

      // 🍎 NEW: Harvesting/Product Keys
      'product_list_title': 'Products',
      'fruit_information': 'Fruit Information',
      'steps_of_proper_harvesting': 'Steps of Proper Harvesting',

      // 📝 HarvestScreen UI Keys
      'fruit_info_title': 'Fruit Information',
      'search_fruits_label': 'Search Fruits',
      'key_info_label': 'Key Information:',
      'tap_for_full_info': 'Tap card for full info',
      'close_button': 'Close',

      // 🍎 FRUIT DATA TRANSLATIONS (HarvestScreen Content - English) 🍎
      'apple_name': 'Apple',
      'apple_vitamins': 'Vitamin C, Vitamin E, Iron, Zinc, Polyphenols',
      'apple_post_harvest':
          'According to A. Oyenihi 2022, Fresh apples are considered a food of moderate energy value among common fruits, while processed apple products are either comparable to fresh apples in energy value or higher because of concentration dehydrated or addition of sugars during processing. Apples are rich sources of selected micronutrients iron, zinc, vitamins C and E and polyphenols that can help in mitigating micronutrient deficiencies and chronic diseases.',

      'banana_name': 'Banana',
      'banana_vitamins':
          'Vitamin C, Starch, Sugar, Fiber, Magnesium, Potassium',
      'banana_post_harvest':
          'According to S. Sari 2024, Banana is an important fruit consumed globally and cultivated in humid and subtropical climes. The fruit comprises nutrients in its pulp and peel with beneficial properties. Bananas are rich in nutrients, particularly vitamin C, starch, sugar, fiber, and serve as an affordable source of vitamins, minerals, and energy for the community.',

      'calamansi_name': 'Calamansi',
      'calamansi_vitamins':
          'Vitamin C, D-Limonene, Dietary Fiber, Phenolics, Flavonoids',
      'calamansi_post_harvest':
          'According to K. Venkatachalam 2023, Calamansi fruits are a rich source of nutrients like vitamin C, D-limonene, and dietary fiber, which have diverse medical and commercial applications. Calamansi has immune-boosting benefits, as well as anti-inflammatory, anti-cancer, anti-diabetic, and other therapeutic effects. Its unique flavor and high juice content make calamansi juice a popular ingredient in many international cuisines.',

      'durian_name': 'Durian',
      'durian_vitamins': 'Various Vitamins, Polyphenols, Bioactive Compounds',
      'durian_post_harvest':
          'According to G. Khaksar 2024, Durian serves as a rich source of various vitamins, each playing a crucial role in maintaining overall health. Regular consumption of fresh fruits is essential due to its abundant content of health-enhancing bioactive compounds, including polyphenols and vitamins. These compounds play a critical role in neutralizing free radicals, thereby mitigating oxidative stress.',

      'fig_name': 'Fig',
      'fig_vitamins': 'Iron, Calcium, Copper, Potassium, Magnesium',
      'fig_post_harvest':
          'According to K. Yadav, Fig belongs to the Mulberry family, which is said to be one of the oldest known cultivated fruits in human civilization. Figs are a delicious fruit that are also rich in minerals like iron, calcium, copper, potassium, and magnesium. The fig plant is traditionally used as medicine to cure many health ailments.',

      'guava_name': 'Guava',
      'guava_vitamins':
          'Vitamin C, Dietary Fiber, Potassium, Lycopene, Polyphenols',
      'guava_post_harvest':
          'According to A. Zaid, Guava is a tropical fruit known for its rich nutritional profile and medicinal properties. Guava possesses exceptional nutritional value, being rich in dietary fiber, vitamins (especially vitamin C), minerals (potassium, magnesium), and antioxidants like lycopene and polyphenols. The fruit\'s low-calorie profile makes it suitable for various dietary regimes.',

      'honeydew_name': 'Honeydew Melon',
      'honeydew_vitamins': 'Hybrids and non-hybrids',
      'honeydew_post_harvest':
          'According to G. Lester, Honey Dew melons, hybrids and non-hybrids, are ready to eat when the rind turns pale green to cream and the surface feels waxy. The blossom end softens when pressed with the thumb and they possess a pleasant aroma. Less ripe and cold melon possess little aroma.',

      'jackfruit_name': 'Jackfruit',
      'jackfruit_vitamins':
          'Carbohydrates, Protein, Starch, Calcium, Vitamins, Fatty Acids',
      'jackfruit_post_harvest':
          'According to S. Swami, Jackfruit (Artocarpus heterophyllus Lam.) is an ancient fruit and is eaten raw or processed into different products. Jackfruit seeds are commonly discarded or steamed and consumed as a snack or used in certain local dishes. The health benefits of jackfruit are attributed to its wide range of physicochemical applications.',

      'kiwi_name': 'Kiwi',
      'kiwi_vitamins':
          'Vitamin C, Vitamin E, Flavonoids, Carotenoids, Minerals',
      'kiwi_post_harvest':
          'According to V. Pawar, Kiwi fruit is native to Asia and became popular globally because of its sensory and nutritional property. It contains high levels of bioactive compounds such as vitamin C, vitamin E, Flavonoids, carotenoids, and minerals. The ellipsoidal kiwi fruit is a true berry and has a hairy brownish green skin.',

      'lemon_name': 'Lemon',
      'lemon_vitamins': 'Flavonoids, L-ascorbic acid (Vitamin C)',
      'lemon_post_harvest':
          'According to S. Hussain 2024, Lemon is vital for healthy human skin but seems to be excellent for the mind too. Lemon consumption or even inhaling its aroma (aromatherapy) effectively improves mood and also decreases tension, nervousness, anxiety, fatigue, inflammation, and lethargy. Lemon is also used in many air sprays and cooling devices.',

      'mango_name': 'Mango',
      'mango_vitamins': 'Sugar, Protein, Fats, Vitamins',
      'mango_post_harvest':
          'According to Habib et al., mangoes provide 64-86 calories of energy. It contains sugar, protein, fats, and other nutrients. Mangoes are eaten fresh as a dessert and are processed as pickles, jams, jellies, sauces, nectar, juices, cereal flakes, and chips. In the traditional system of healing, Mango fruits are used to cure sunstroke, ophthalmia, eruption, intestinal disorder, infertility, and night blindness.',

      'noni_name': 'Noni',
      'noni_vitamins': 'Flavonoids, Terpenoids, Alkaloids, Steroids, Vitamin C',
      'noni_post_harvest':
          'According to A. Saah, Morinda citrifolia, commonly called noni, has a long history as a medicinal plant and is reported to have a wide range of therapeutic effects, including antibacterial, antiviral, antifungal, antitumor, and immune enhancing effects. This suggests that noni fruit can aid in promoting good health.',

      'orange_name': 'Orange',
      'orange_vitamins': 'Flavonoids, Vitamin C',
      'orange_post_harvest':
          'According to S. Shuklah, Orange (Citrus reticulata Blanco) is an evergreen tree belonging to the family Rutaceae. Mandarin orange is a winter fruit. Due to the irresistible bright color, appetizing flavor and aroma, mandarin orange is one of the most favorite citrus fruit. Mandarin oranges are widely cultivated in tropical and subtropical climates.',

      'papaya_name': 'Papaya',
      'papaya_vitamins': 'Vitamin A, Vitamin B, Vitamin C, Papain, Chymopapain',
      'papaya_post_harvest':
          'According to R. Kumar, Papaya is a popular and important fruit in tropical and subtropical parts of the world. The fruit is consumed throughout the world as fresh fruit and vegetable or used as processed product. The whole part of the plant, including the fruit, root, bark, seeds, and pulp are also known to possess medicinal properties. The multiple benefits of papaya are attributed to its high content of vitamins A, B, and C, and proteolytic enzymes like papain and chymopapain.',

      'rambutan_name': 'Rambutan',
      'rambutan_vitamins': 'Vitamin C',
      'rambutan_post_harvest':
          'According to P. Bhattacharjee, Rambutan is a medium-sized evergreen tree. The fruits are classified as berries, they are ovoid in shape, very juicy, and slightly acidic due to the high vitamin C content. The name of this fruit is derived from the Malayan word Rambut, which means hair in English, and refers to the soft spiny hairs covering the surface of the fruit.',

      'strawberry_name': 'Strawberry',
      'strawberry_vitamins': 'Vitamin C, Fiber, Antioxidants',
      'strawberry_post_harvest':
          'According to K. Sharma, The balance of nutrition is required by the delicate strawberry plant so it is vital to maintain the nutritional status for better growth, yield, and quality of strawberries. Although strawberries are a highly perishable fruit, numerous wrapping techniques maintained the quality of fruit when kept at ambient temperature.',

      'tomato_name': 'Tomato',
      'tomato_vitamins': 'Vitamins, Carotenoids, Minerals, Bioactive compounds',
      'tomato_post_harvest':
          'According to S. Vats, Tomato, a widely consumed crop, offers a true potential to combat human nutritional deficiencies. Tomatoes are rich in micronutrients and other bioactive compounds including vitamins, carotenoids, and minerals which are known to be essential or beneficial for human health.',

      'watermelon_name': 'Watermelon',
      'watermelon_vitamins':
          'Vitamin C, Pantothenic Acid, Copper, Biotin, Vitamin A, B6 & B1',
      'watermelon_post_harvest':
          'According to M. Nadeem, Watermelon is globally recognized as a delicious thirst-quenching fruit eaten by many people in the summer heat. There are almost 1,200 varieties of watermelon. Watermelons are packed with many nutrients, such as Vitamin C, pantothenic acid, copper, biotin, Vitamin A, and Vitamins B6 and B1.',

      'cucumber_name': 'Cucumber',
      'cucumber_vitamins':
          'Vitamins, Minerals, Phenols, Flavonoids, Carotenoids',
      'cucumber_post_harvest':
          'According to H. Javid, Cucumbers are an essential part of the human diet, often used in salads, pickles, and sauces, due to their nutritious qualities and health benefits. They are a good source of vitamins, minerals, soluble carbohydrates, proteins, etc. Cucumbers are traditionally used to treat various diseases, including high blood pressure, blood sugar issues, and other problems.',

      'grapes_name': 'Grapes',
      'grapes_vitamins': 'Polyphenols, Antioxidants',
      'grapes_post_harvest':
          'According to H. Hou, Grapes are considered one of the most important economic horticultural crops in the world. They are not only popular fresh fruits but also serve as raw materials for wine, grape juice, and raisins. Grapes offer a variety of health benefits. These include cancer prevention, diabetes prevention, cardiovascular disease prevention, and anti-inflammatory properties.',

      // 🛠️ NEW: SeasonPlantingScreen Keys (Steps)
      'step_1_title': 'Step 1: Check the Weather and Fruits',
      'step_1_desc':
          'Before harvesting, check the weather for potential rain or extreme heat. Also, check if the fruits have reached the correct ripeness.',
      'step_2_title': 'Step 2: Use Hands or Cutter',
      'step_2_desc':
          'Use your hands for delicate fruits or those with weak stems. For stronger stems, use a cutter or shears. Handle all fruits carefully.',
      'step_3_title': 'Step 3: Threshing (Initial Cleaning)',
      'step_3_desc':
          'Perform an initial light cleaning, such as gentle brushing or a quick rinse, to remove loose debris. This prepares the fruits for further handling.',
      'step_4_title': 'Step 4: Cleaning',
      'step_4_desc':
          'Washing removes dirt, residues, and contaminants, improving appeal and reducing spoilage. Note that cleaning can damage delicate fruits if not done carefully.',
      'step_5_title': 'Step 5: Sorting',
      'step_5_desc':
          'Categorize fruits by size, color, ripeness, and quality based on market standards to ensure uniform batches.',
      'step_6_title': 'Step 6: Bagging',
      'step_6_desc':
          'Package the sorted fruits in suitable containers to protect them from damage and contamination during transport and handling.',
      'step_7_title': 'Step 7: Storage',
      'step_7_desc':
          'Keep the harvested fruits under appropriate temperature, humidity, and ventilation to extend shelf life and maintain quality.',
    },
    'tl': {
      // Tagalog (Filipino)

      // --- Settings Screen Keys (Existing) ---
      'settings': 'Mga Setting',
      'account': 'Account',
      'profile': 'Profile',
      'security_privacy': 'Seguridad at Privacy',
      'dark_mode': 'Dark Mode',
      'support_feedback': 'Suporta at Feedback',
      'help_center': 'Sentro ng Tulong',
      'about_us': 'Tungkol Sa Amin',
      'log_out': 'Mag-log Out',
      'confirm_logout': 'Kumpirmahin ang Pag-log Out',
      'confirm_logout_message':
          'Sigurado ka bang gusto mong mag-log out sa iyong account?',
      'cancel': 'Kanselahin',
      'yes_logout': 'Oo, Mag-log Out',
      'language': 'Wika',
      'english': 'English',
      'tagalog': 'Tagalog',

      'daily_rewards_title': 'Araw-araw na Gantimpala',
      'reward_already_claimed': 'Naklaim mo na ang gantimpalang ito!',
      'claim_one_per_day':
          'Maaari ka lamang mag-claim ng isang gantimpala bawat araw!',
      'claim_current_day_first':
          'I-claim muna ang gantimpala para sa kasalukuyang araw!',
      'your_coins_prefix': 'Iyong Barya: ',
      'error_loading_coins': 'Error sa pag-load ng barya: ',
      'daily_login_bonus_title': '🎁 Pang-araw-araw na Bonus sa Pag-login',
      'day_prefix': 'Araw ',
      'coins_suffix': ' Barya',
      'claim_button': 'I-CLAIM',
      'claimed_overlay': 'NA-CLAIM',
      'claim_success_message':
          'Nag-claim ka ng %1\$s barya para sa Araw %2\$s!',

      'create_account': 'Gumawa ng Account',
      'tap_to_add_profile': 'Pindutin upang magdagdag ng larawan sa profile',
      'first_name': 'Pangalan',
      'middle_name': 'Gitnang Pangalan (Opsyonal)',
      'last_name': 'Apelyido',
      'age': 'Edad',
      'next': 'Susunod',
      'back': 'Bumalik',
      'sign_up': 'Magrehistro',
      'confirm_account_creation': 'Kumpirmahin ang Paglikha ng Account',
      'confirm_message': 'Sigurado ka bang gusto mong gumawa ng account?',
      'cancel': 'Kanselahin',
      'create': 'Likhain',
      'account_created_successfully': 'Matagumpay na nalikha ang account!',
      'address': 'Address',
      'mobile_number': 'Numero ng Telepono',
      'gender': 'Kasarian',
      'male': 'Lalaki',
      'female': 'Babae',
      'role': 'Tungkulin',
      'select_role': 'Piliin ang iyong tungkulin',
      'farmer': 'Magsasaka',
      'vendor': 'Nagbebenta',
      'consumer': 'Mamimili',
      'harvesting_experience_question': 'May karanasan ka ba sa pag-aani?',
      'yes': 'Oo',
      'no': 'Hindi',
      'email': 'Email',
      'password': 'Password',

      // ℹ️ NEW: About Us Screen Keys
      // ignore: equal_keys_in_map
      'about_us': 'Tungkol Sa Amin',
      'app_slogan': 'Ang Iyong Kasama sa Pagkilala ng Prutas',

      // Misyon at Bisyon
      'mission_vision_title': 'Ang Aming Misyon at Bisyon 🌱',
      'mission_vision_body':
          'Ang Harvi ay nakatuon sa paggawa ng kamangha-manghang mundo ng mga prutas na madaling ma-access ng lahat. Ang aming misyon ay bigyan ng kapangyarihan ang mga user sa mabilis na pagtukoy ng prutas, pagpapatibay ng mas malalim na pagpapahalaga sa kasaganaan ng kalikasan, at pagtataguyod ng malusog na pamumuhay sa pamamagitan ng kaalaman.',

      // Paano Ito Gumagana
      'how_it_works_title': 'Paano Ito Gumagana 📷',
      'how_it_works_body':
          'Gumagamit ang app ng advanced na teknolohiya sa pagkilala ng imahe upang suriin at tukuyin ang mga prutas. Itutok lamang ang camera ng iyong device, at ang app ay magbibigay ng mabilis, tumpak na resulta, kasama ang mga detalye tungkol sa prutas. Ito ay simple, mabilis, at masaya!',

// 👥 BAGONG: User List Screen Keys (UserListScreen)
      'user_list_title': 'Listahan ng Gumagamit',
      'search_label': 'Maghanap gamit ang pangalan',
      'no_users_found': 'Walang nakitang gumagamit',
      'no_users_matched': 'Walang gumagamit na tumugma sa iyong hinanap',
      'tooltip_download_all': 'I-download ang PDF ng Lahat ng Gumagamit',
      'tooltip_view_details': 'Tingnan ang Detalye',
      'tooltip_delete_user': 'Burahin ang Gumagamit',

      // Dialogs - Generic
      'button_cancel': 'Kanselahin',
      'button_close': 'Isara',
      'button_delete': 'Burahin',

      // Delete Confirmation Dialog
      'delete_user_confirm_title': 'Kumpirmahin ang Pagbura',
      'delete_user_confirm_content':
          'Sigurado ka bang gusto mong burahin ang gumagamit na ito? Hindi ito mababawi.',
      'user_details_title': 'Detalye ng Gumagamit',

      // PDF Generation & Download
      'button_generate_pdf': 'Bumuo ng PDF',
      'pdf_user_info_title': 'Impormasyon ng Gumagamit',
      'pdf_all_users_title': 'Impormasyon ng Lahat ng Gumagamit',
      'pdf_status_generating': 'Ang PDF para sa %s ay nabuo at naibahagi!',
      'pdf_status_error': 'Error sa pagbuo ng PDF: %s',
      'pdf_all_status_generating':
          'Matagumpay na nabuo at naibahagi ang PDF ng lahat ng gumagamit!',
      'pdf_all_status_error':
          'Error sa pagbuo ng PDF ng lahat ng gumagamit: %s',
      'pdf_no_users_to_generate': 'Walang gumagamit para mabuo ang PDF.',
      'pdf_no_users_found_message':
          'Walang nakitang gumagamit para mabuo ang PDF.',

      // Download All Confirmation Dialog
      'download_confirm_title':
          'I-download ang Impormasyon ng Lahat ng Gumagamit?',
      'download_confirm_content':
          'Sigurado ka bang gusto mong mag-download ng PDF file kasama ang impormasyon ng lahat ng gumagamit?',
      'button_download': 'I-download',
      'failed_to_fetch_users': 'Nabigo sa pagkuha ng mga gumagamit: %s',

      // List Detail Labels (Also used in PDF)
      'label_full_name': 'Buong Pangalan',
      'label_age': 'Edad',
      'label_sex': 'Kasarian',
      'label_address': 'Address',
      'label_mobile': 'Mobile',
      'label_role': 'Tungkulin',
      'label_harvesting_exp': 'Karanasan sa Pag-aani',
      'label_email': 'Email',
      'label_na': 'Hindi Tiyak',
// --- NEWLY ADDED GAME LOCALIZATION KEYS ---
      'game_select_difficulty':
          'Pumili ng Antas ng Hamon', // AppBar title when selecting difficulty
      'game_select_difficulty_standard':
          'Pumili ng Antas (Standard Challenge)', // Header inside selection screen
      'game_select_difficulty_time_attack':
          'Pumili ng Antas (Time Attack)', // Header inside selection screen
      'difficulty_easy': 'Madali na Hamon', // User-requested translation
      'difficulty_medium':
          'Katamtamtaman na Hamon', // User-requested translation
      'difficulty_hard': 'Mahirap na Hamon', // User-requested translation
      'label_select_answer':
          'Pumili ng Sagot', // Fix for !!labe;_selelct_answer!!
      // SnackBars
      'status_user_deleted': 'Matagumpay na nabura ang gumagamit!',
      // Team
      'team_title': 'Kilalanin ang Team 🧑‍💻',
      'role_developers': 'Mga Developer:',
      'role_adviser': 'Tagapayo:',
      'role_technical_critique': 'Pagsusuri sa Teknikal:',

      // Contact
      'contact_us_title': 'Makipag-ugnay Sa Amin 📧',
      'contact_us_body':
          'May mga katanungan o feedback? Gusto naming marinig mula sa iyo! Makipag-ugnay sa amin sa: harvi@gmail.com',
// ...
      'learning_guides': 'Gabay sa Pag-aaral',
      'horticulture_banner_title':
          'Kumuha ng Pinakamahusay na Kaalaman sa mga Prutas!',
      'horticulture_banner_body':
          'Matuto tungkol sa mga prutas,\nmula sa nutrisyon hanggang sa mga tip sa pag-aani.',
      'categories_title': 'Mga Kategorya',

      // 🔥 NEW ANNOUNCEMENT SCREEN KEYS
      'announcements_title': 'Mga Anunsyo',
      'search_announcements_hint': 'Maghanap ng mga anunsyo...',
      'no_announcements_yet': 'Wala pang anunsyo.',
      'no_new_announcements': 'Walang bagong anunsyo.',
      'no_message': 'Walang Mensahe',
      'login_to_dismiss_snack': 'Paki-login para i-dismiss ang anunsyo.',
      'announcement_dismissed_snack':
          'Ang anunsyo ay na-dismiss sa iyong account.',
      'announcement_details_title': 'Mga Detalye ng Anunsyo',
      'no_message_available': 'Walang mensaheng makikita.',
      'no_timestamp_available': 'Walang makitang timestamp.',
      'invalid_date_format': 'Di-wastong format ng petsa.',
      'dismiss_confirmation_title': 'I-dismiss ang Anunsyo?',
      'dismiss_confirmation_content':
          'Sigurado ka bang gusto mong i-dismiss ang anunsyo na ito? Itatago ito sa iyong paningin.',
      'button_dismiss': 'I-dismiss',
      'button_dismiss_announcement': 'I-dismiss ang Anunsyo',
      'button_done': 'Tapos',
      // Keys with variables (placeholders needed in ARB, handled as regular strings here)
      'no_search_results_template': 'Walang nakitang resulta para sa "%s".',
      'error_loading_announcements_template':
          'Error sa pag-load ng anunsyo: %s',
      'failed_to_dismiss_snack_template': 'Nabigong i-dismiss ang anunsyo: %s',

      // --- HomeScreen Keys (NEW) ---
      'good_morning': 'Magandang umaga',
      'good_afternoon': 'Magandang hapon',
      'good_evening': 'Magandang gabi',
      'home_motto': 'I-snap. I-scan. Kilalanin ang prutas sa ilang segundo!',
      'claim_daily_rewards': 'Kunin ang Iyong Pang-araw-araw na Gantimpala!',
      'daily_rewards_subtitle':
          'Mag-log in araw-araw para kumita ng libreng barya at mag-unlock ng bonus!',
      'challenge_fruit_iq': 'Subukan ang Iyong Kaalaman sa Prutas!',
      'guess_the_fruit': 'Hulaan ang Prutas',
      'guess_the_fruit_subtitle':
          'Kilalanin ang mga prutas mula sa larawan. Ilan ang tama mo?',
      'time_attack': 'Atake sa Oras',
      'time_attack_subtitle':
          'I-scan ang maraming prutas bago maubos ang oras!',
      // Bottom Navigation Labels
      'repository': 'Talaan',
      'guide': 'Gabay',
      'announced': 'Anunsyo',

      // ... (Your existing keys) ...
      'middle_name': 'Gitnang Pangalan',
      'middle_name_optional': 'Gitnang Pangalan (Opsyonal)',
      'confirm_password': 'Kumpirmahin ang Password',
      'select_sex': 'Piliin ang Kasarian',
      'non_binary': 'Non-binary',
      'select_barangay': 'Piliin ang Barangay',
      'mobile_number_hint': 'Numero ng Mobile (hal., 9123456789)',
      'creating_your_account': 'Ginagawa ang iyong account...',

      // Validation & Error Keys (Tagalog)
      'please_select_option': 'Pakipili ng isang opsyon',
      'please_enter_field': 'Pakilagay ang {field}',
      'alphabetical_only':
          'Mangyaring maglagay lamang ng mga alpabetikong character para sa {field}',
      'please_enter_age': 'Pakilagay ang iyong edad',
      'please_enter_valid_age': 'Pakilagay ng wastong edad',
      'please_enter_mobile': 'Pakilagay ang iyong mobile number',
      'mobile_number_format': 'Ilagay ang 10 numero (hal., 9xxxxxxxxx).',
      'please_enter_email': 'Pakilagay ang email',
      'please_enter_valid_email': 'Maglagay ng wastong email',
      'please_enter_password': 'Pakilagay ang password',
      'password_strength_requirements':
          'Ang password ay dapat may 8+ karakter,\nisang malaki at maliit na letra,\nisang numero, at isang espesyal na karakter',
      'please_confirm_password': 'Pakikumpirma ang password',
      'passwords_do_not_match': 'Hindi tugma ang mga password',
      'please_select_all_options':
          'Pakipili ang lahat ng kinakailangang opsyon.',
      'invalid_email_format': 'Di-wasto ang format ng email',
      'email_already_in_use': 'Ginagamit na ang email na ito.',
      'account_creation_failed': 'Nabigo ang Paglikha ng Account: {error}',
      'unexpected_error': 'Hindi Inaasahang Error: {error}',
      'confirm_account_message':
          'Sigurado ka bang gusto mong gawin ang account na ito?',

      // app_localizations.dart -> inside the 'tl': { ... } map

      // --- 0: Hindi Hinog na Señorita Saging ---
      'unripeSenoritaBananaName': 'Hindi Hinog na Señorita Saging',
      'unripeSenoritaBananaVitamins':
          'Potassium, Vitamin C, Dietary Fiber (Pandiyeta Hibla)',
      'unripeSenoritaBananaShelfLife': 'Hanggang 15 araw sa 15°C',
      'unripeSenoritaBananaGeneralInfo':
          'Lubos na pinahahalagahan dahil saaman nitong nutrient profile, kabilang ang potassium, vitamin C, at dietary fiber, na nagpapabuti sa kalusugan ng puso at panunaw (Jian, C. 2004).',

      // --- 1: Hinog na Señorita Saging ---
      'ripeSenoritaBananaName': 'Hinog na Señorita Saging',
      'ripeSenoritaBananaVitamins':
          'Potassium, Vitamin C, Dietary Fiber (Pandiyeta Hibla)',
      'ripeSenoritaBananaShelfLife': 'Hanggang 15 araw sa 15°C',
      'ripeSenoritaBananaGeneralInfo':
          'Lubos na pinahahalagahan dahil saaman nitong nutrient profile, kabilang ang potassium, vitamin C, at dietary fiber, na nagpapabuti sa kalusugan ng puso at panunaw (Jian, C. 2004).',

      // --- 2: Hindi Hinog na Calamansi Citrus ---
      'unripeCalamansiCitrusName': 'Hindi Hinog na Calamansi Citrus',
      'unripeCalamansiCitrusVitamins':
          'Mababang Glycaemic Index, Mahalagang Vitamin C',
      'unripeCalamansiCitrusShelfLife': 'hanggang 60 araw',
      'unripeCalamansiCitrusGeneralInfo':
          'Lubos na pinahahalagahan dahil sa mababang glycaemic index at mataas na nilalaman ng Vitamin C, na sumusuporta sa kalusugan ng immune system at nagbibigay ng antioxidant benefits (Siner, A. 2020).',

      // --- 3: Hinog na Calamansi Citrus ---
      'ripeCalamansiCitrusName': 'Hinog na Calamansi Citrus',
      'ripeCalamansiCitrusVitamins':
          'Mababang Glycaemic Index, Mahalagang Vitamin C',
      'ripeCalamansiCitrusShelfLife':
          '5–7 araw sa room temperature (~25–30 °C), hanggang 2 linggo kung nakarefridge',
      'ripeCalamansiCitrusGeneralInfo':
          'Lubos na pinahahalagahan dahil sa mababang glycaemic index at mataas na nilalaman ng Vitamin C, na sumusuporta sa kalusugan ng immune system at nagbibigay ng antioxidant benefits (Siner, A. 2020).',

      // --- 4: Hindi Hinog na Marglobe Kamatis ---
      'unripeMarglobeTomatoName': 'Hindi Hinog na Marglobe Kamatis',
      'unripeMarglobeTomatoVitamins':
          'Vitamin C, Vitamin E, Iba\'t Ibang Carotenoids (Lycopene)',
      'unripeMarglobeTomatoShelfLife':
          'hanggang 28 araw sa cold storage at 14 araw sa room temperature',
      'unripeMarglobeTomatoGeneralInfo':
          'Angaman nitong Vitamin C, E, at iba\'t ibang carotenoids, tulad ng lycopene, ay nagpapahusay pa sa benepisyo nito sa kalusugan (Ibrahim, S et al. 2023). Ang regular na pagkain ay sumusuporta sa immune function at nagpapababa ng panganib ng chronic diseases.',

      // --- 5: Hinog na Marglobe Kamatis ---
      'ripeMarglobeTomatoName': 'Hinog na Marglobe Kamatis',
      'ripeMarglobeTomatoVitamins':
          'Vitamin C, Vitamin E, Iba\'t Ibang Carotenoids (Lycopene)',
      'ripeMarglobeTomatoShelfLife':
          '1–2 araw sa room temperature kapag overripe; mas mainam na agad na kainin o gamitin sa pagluluto',
      'ripeMarglobeTomatoGeneralInfo':
          'Angaman nitong Vitamin C, E, at iba\'t ibang carotenoids, tulad ng lycopene, ay nagpapahusay pa sa benepisyo nito sa kalusugan (Ibrahim, S et al. 2023). Ang regular na pagkain ay sumusuporta sa immune function at nagpapababa ng panganib ng chronic diseases.',

      // --- 6: Sobrang Hinog na Marglobe Kamatis ---
      'overripeMarglobeTomatoName': 'Sobrang Hinog na Marglobe Kamatis',
      'overripeMarglobeTomatoVitamins':
          'Vitamin C, Vitamin E, Iba\'t Ibang Carotenoids (Lycopene)',
      'overripeMarglobeTomatoShelfLife':
          '1–2 araw sa room temperature kapag overripe; mas mainam na agad na kainin o gamitin sa pagluluto',
      'overripeMarglobeTomatoGeneralInfo':
          'Angaman nitong Vitamin C, E, at iba\'t ibang carotenoids, tulad ng lycopene, ay nagpapahusay pa sa benepisyo nito sa kalusugan (Ibrahim, S et al. 2023). Ang regular na pagkain ay sumusuporta sa immune function at nagpapababa ng panganib ng chronic diseases.',

      // --- 7: Hindi Hinog na Bettina Papaya ---
      'unripeBettinaPapayaName': 'Hindi Hinog na Bettina Papaya',
      'unripeBettinaPapayaVitamins':
          'Vitamin C, Mahahalagang Bitamina at Mineral, Carotenoids',
      'unripeBettinaPapayaShelfLife':
          'Hanggang 10 araw sa room temperature (~25–30 °C), humihinog sa paglipas ng panahon',
      'unripeBettinaPapayaGeneralInfo':
          'Lubos na kapaki-pakinabang, dahil nagbibigay ito ng mahahalagang bitamina at mineral, lalo na ang vitamin C at carotenoids, na nag-aambag sa pangkalahatang kalusugan at kagalingan (Wall, M et al. 2014). Ang regular na pagkain ay sumusuporta sa immune function at nagpapababa ng panganib ng chronic diseases.',

      // --- 8: Hindi Hinog na Sili Labuyo ---
      'unripeGreenChiliPepperName': 'Hindi Hinog na Sili Labuyo',
      'unripeGreenChiliPepperVitamins': 'Vitamin C, Carotenoids',
      'unripeGreenChiliPepperShelfLife':
          'Maaaring itago sa refrigerator ng 1-2 linggo, Maaaring i-freeze nang hanggang isang taon.',
      'unripeGreenChiliPepperGeneralInfo':
          'Mayaman sa bitamina at mineral, lalo na ang vitamin C at carotenoids, na nag-aambag sa anti-oxidative properties nito (Guil-Guerrero et al., 2006).',

      // --- 9: Hinog na Sili Labuyo ---
      'ripeLabuyoPepperName': 'Hinog na Sili Labuyo',
      'ripeLabuyoPepperVitamins': 'Vitamin C, Carotenoids',
      'ripeLabuyoPepperShelfLife':
          '1–2 linggo sa room temperature (~25–30 °C), mas matagal kung tuyo o nakarefridge',
      'ripeLabuyoPepperGeneralInfo':
          'Mayaman sa bitamina at mineral, lalo na ang vitamin C at carotenoids, na nag-aambag sa anti-oxidative properties nito (Guil-Guerrero et al., 2006).',

      // --- 10: Hinog na Bettina Papaya ---
      'ripeBettinaPapayaName': 'Hinog na Bettina Papaya',
      'ripeBettinaPapayaVitamins':
          'Vitamin C, Mahahalagang Bitamina at Mineral, Carotenoids',
      'ripeBettinaPapayaShelfLife':
          '3-5 araw sa room temperature kapag ganap na hinog',
      'ripeBettinaPapayaGeneralInfo':
          'Lubos na kapaki-pakinabang, dahil nagbibigay ito ng mahahalagang bitamina at mineral, lalo na ang vitamin C at carotenoids, na nag-aambag sa pangkalahatang kalusugan at kagalingan (Wall, M et al. 2014). Ang regular na pagkain ay sumusuporta sa immune function at nagpapababa ng panganib ng chronic diseases.',

      // --- 11: Sobrang Hinog na Bettina Papaya ---
      'overripeBettinaPapayaName': 'Sobrang Hinog na Bettina Papaya',
      'overripeBettinaPapayaVitamins':
          'Vitamin C, Mahahalagang Bitamina at Mineral, Carotenoids (Bumababa)',
      'overripeBettinaPapayaShelfLife': 'Kainin kaagad o itapon',
      'overripeBettinaPapayaGeneralInfo':
          'Lubos na kapaki-pakinabang, dahil nagbibigay ito ng mahahalagang bitamina at mineral, lalo na ang vitamin C at carotenoids, na nag-aambag sa pangkalahatang kalusugan at kagalingan (Wall, M et al. 2014). Ang regular na pagkain ay sumusuporta sa immune function at nagpapababa ng panganib ng chronic diseases.',

      // --- 12: Hinog na Kirby Pipino ---
      'ripeKirbyCucumberName': 'Hinog na Kirby Pipino',
      'ripeKirbyCucumberVitamins':
          'Mataas na Tubig, Vitamin A, Vitamin C, Vitamin K',
      'ripeKirbyCucumberShelfLife':
          '5–7 araw sa ilalim ng karaniwang kondisyon (karaniwan ay room temperature, ~25–30 °C)',
      'ripeKirbyCucumberGeneralInfo':
          'Mayaman sa nilalaman ng tubig at mahahalagang nutrients, kabilang ang vitamin A, C, at K, ginagawa itong mahusay na pagpipilian para sa hydration at pangkalahatang kalusugan (Murad, H. 2016).',

      // --- 13: Sobrang Hinog na Sili Labuyo ---
      'overripeLabuyoPepperName': 'Sobrang Hinog na Sili Labuyo',
      'overripeLabuyoPepperVitamins': 'Vitamin C, Carotenoids (Bumababa)',
      'overripeLabuyoPepperShelfLife': '2-3 araw (sariwa) o buwan (kung tuyo)',
      'overripeLabuyoPepperGeneralInfo':
          'Mayaman sa bitamina at mineral, lalo na ang vitamin C at carotenoids, na nag-aambag sa anti-oxidative properties nito (Guil-Guerrero et al., 2006).',

      // --- 14: Sobrang Hinog na Calamansi Citrus ---
      'overripeCalamansiCitrusName': 'Sobrang Hinog na Calamansi Citrus',
      'overripeCalamansiCitrusVitamins':
          'Mababang Glycaemic Index, Mahalagang Vitamin C',
      'overripeCalamansiCitrusShelfLife': '2-3 araw (madaling masira)',
      'overripeCalamansiCitrusGeneralInfo':
          'Lubos na pinahahalagahan dahil sa mababang glycaemic index at mataas na nilalaman ng Vitamin C, na sumusuporta sa kalusugan ng immune system at nagbibigay ng antioxidant benefits (Siner, A. 2020).',

      // --- 15: Sobrang Hinog na Señorita Saging ---
      'overripeSenoritaBananaName': 'Sobrang Hinog na Señorita Saging',
      'overripeSenoritaBananaVitamins':
          'Potassium, Vitamin C, Dietary Fiber (Pandiyeta Hibla)',
      'overripeSenoritaBananaShelfLife': 'Hanggang 15 araw sa 15°C',
      'overripeSenoritaBananaGeneralInfo':
          'Lubos na pinahahalagahan dahil sa yaman nitong nutrient profile, kabilang ang potassium, vitamin C, at dietary fiber, na nagpapabuti sa kalusugan ng puso at panunaw (Jian, C. 2004).',

      // --- 16: Sobrang Hinog na Kirby Pipino ---
      'overripeKirbyCucumberName': 'Sobrang Hinog na Kirby Pipino',
      'overripeKirbyCucumberVitamins':
          'Mataas na Tubig, Vitamin A, Vitamin C, Vitamin K',
      'overripeKirbyCucumberShelfLife': 'Kainin kaagad o itapon',
      'overripeKirbyCucumberGeneralInfo':
          'Mayaman sa nilalaman ng tubig at mahahalagang nutrients, kabilang ang vitamin A, C, at K, ginagawa itong mahusay na pagpipilian para sa hydration at pangkalahatang kalusugan (Murad, H. 2016).',

      // --- 17: Hindi Hinog na Kirby Pipino ---
      'unripeKirbyCucumberName': 'Hindi Hinog na Kirby Pipino',
      'unripeKirbyCucumberVitamins':
          'Mataas na Tubig, Vitamin A, Vitamin C, Vitamin K',
      'unripeKirbyCucumberShelfLife': '10-14 araw sa refrigerator',
      'unripeKirbyCucumberGeneralInfo':
          'Mayaman sa nilalaman ng tubig at mahahalagang nutrients, kabilang ang vitamin A, C, at K, ginagawa itong mahusay na pagpipilian para sa hydration at pangkalahatang kalusugan (Murad, H. 2016).',

      // 🕹️ NEW: Game/Quiz Screen Keys
      'game_start_button': 'Simulan ang Laro',
      'game_next_question': 'Susunod na Tanong',
      'game_submit_answer': 'Isumite',
      'game_correct': 'Tama!',
      'game_incorrect': 'Mali.',
      'game_time_up': 'Ubós na ang Oras!',
      'game_score': 'Ang Iyong Puntos:',
      'game_high_score': 'Pinakamataas na Puntos:',
      'game_play_again': 'Maglaro Muli',
      'game_exit': 'Lumabas',
      'guess_the_fruit_instruction': 'Anong prutas ito?',
      'time_attack_instruction': 'Mabilis na tukuyin ang ipinapakitang prutas.',
      'time_remaining': 'Natitirang Oras:',

      // ====================================================================
// --- 24 Fruit Class Names (Tagalog) ---
// ====================================================================
      // ====================================================================
      // --- NEW 19 Fruit Class Names (Tagalog) ---
      // ====================================================================
      // --- 24 Fruit Class Names (Tagalog) ---
      'fruit_0_name': 'Hilaw na Saging na Señorita',
      'fruit_1_name': 'Hinog na Saging na Señorita',
      'fruit_2_name': 'Hilaw na Kalamansi',
      'fruit_3_name': 'Hinog na Kalamansi',
      'fruit_4_name': 'Hilaw na Kamatis na Marglobe',
      'fruit_5_name': 'Hinog na Kamatis na Marglobe',
      'fruit_6_name': 'Sobrang Hinog na Kamatis na Marglobe',
      'fruit_7_name': 'Hilaw na Papaya na Bettina',
      'fruit_8_name': 'Hilaw na Siling Labuyo',
      'fruit_9_name': 'Hinog na Siling Labuyo',
      'fruit_10_name': 'Hinog na Papaya na Bettina',
      'fruit_11_name': 'Sobrang Hinog na Papaya na Bettina',
      'fruit_12_name': 'Hinog na Pipino na Kirby',
      'fruit_13_name': 'Sobrang Hinog na Siling Labuyo',
      'fruit_14_name': 'Sobrang Hinog na Kalamansi',
      'fruit_15_name': 'Sobrang Hinog na Saging na Señorita',
      'fruit_16_name': 'Sobrang Hinog na Pipino na Kirby',
      'fruit_17_name': 'Hilaw na Pipino na Kirby',
      // app_localizations.dart -> inside the 'tl': { ... } map

      // --- Localization Keys for Scan Flow (scann.dart, result.dart, display.dart) ---

      // result.dart keys
      'scanResultDetailsTitle': 'Detalye ng Resulta ng Pag-scan',
      'detectedLabel': 'Natukoy:',
      'confidenceLabel': 'Antas ng Kumpiyansa:',
      'scannedOnLabel': 'Na-scan Noong:',
      'keyVitaminsLabel': 'Pangunahing Bitamina:',
      'shelfLifeLabel': 'Karaniwang Buhay ng Imbakan:',
      'aboutProduceLabel': 'Tungkol sa Produktong Ito:',
      'scanAnotherButton': 'Mag-scan ng Iba Pang Prutas',
      'noInfoAvailable': 'Walang karagdagang impormasyon na magagamit.',

      // display.dart keys
      'dataRepositoryTitle': 'Imbakan ng Datos',
      'noResultsMessage':
          'Wala pang resulta ng pag-scan.\nMagsagawa ng pag-scan upang magdagdag ng datos sa iyong imbakan!',
      'resultPrefix': 'Resulta:',
      'probabilityPrefix': 'Kumpiyansa:',
      'dateTimePrefix': 'Petsa/Oras:',
      'vitaminsPrefix': 'Mga Bitamina:',
      'deleteDialogTitle': 'Burahin ang Resulta ng Pag-scan?',
      'deleteDialogContent':
          'Sigurado ka bang nais mong burahin ang resultang ito ng pag-scan? Hindi na ito mababawi.',

      // scann.dart keys (Dialogs and UI)
      'cameraAccessTitle': 'Pahintulutan ang Pag-access sa Camera 📸',
      'cameraAccessContent':
          'Pinapayagan mo ba ang Harvi na gamitin ang iyong camera upang kumuha ng larawan ng iyong prutas?',
      'uploadPhotoTitle': 'Mag-upload ng Larawan 🖼️',
      'uploadPhotoContent':
          'Nais mo bang mag-upload ng larawan ng iyong prutas mula sa iyong gallery?',
      'proceedButton': 'Magpatuloy',
      'fruitScannerTitle': 'Fruit Scanner',
      'greetingText':
          'Kumusta! Handa na bang tukuyin ang iyong susunod na pinakamahusay na ani?',
      'scanButton': 'I-scan ang Prutas',
      'uploadButton': 'I-upload ang Prutas',
      'undefinedResult': 'Hindi Natukoy',

      // General utility buttons (used in scan flow)
      'cancelButton': 'Kanselahin',
      'deleteButton': 'Burahin',

      // Date/Time formatting keys (used in scann.dart)
      'monthJanuary': 'Enero',
      'monthFebruary': 'Pebrero',
      'monthMarch': 'Marso',
      'monthApril': 'Abril',
      'monthMay': 'Mayo',
      'monthJune': 'Hunyo',
      'monthJuly': 'Hulyo',
      'monthAugust': 'Agosto',
      'monthSeptember': 'Setyembre',
      'monthOctober': 'Oktubre',
      'monthNovember': 'Nobyembre',
      'monthDecember': 'Disyembre',
      'am': 'AM', // Commonly left as AM in Tagalog/Filipino context
      'pm': 'PM', // Commonly left as PM in Tagalog/Filipino context

// ====================================================================
// --- 72 Fruit Detail Keys (Tagalog) ---
// ====================================================================
// ====================================================================
      // --- NEW 19 Fruit Class Names & Details (Tagalog) ---

      // 👑 BAGONG: Admin Screen Keys (Tagalog)
      'admin_dashboard_title': 'Admin Dashboard',
      'admin_welcome_subtext': 'Maligayang pagbabalik sa iyong dashboard.',
      'quick_actions_title': 'Mabilis na Aksyon',
      'manage_users': 'Pamahalaan ang mga User', // Manage Users
      'create_admin_account': 'Gumawa ng Admin Account', // Create Admin Account
      'create_announcement': 'Gumawa ng Anunsyo', // Create Announcement
      // 'settings': 'Mga Setting', // Already exists (assuming)

      // --- Time-based greetings (used in AdminScreen & HomeScreen) ---
// ignore: equal_keys_in_map
      'good_morning': 'Magandang Umaga',
      'good_afternoon': 'Magandang Hapon',
      'good_evening': 'Magandang Gabi',

      // 🕹️ NEW: Game/Quiz Screen Keys
      'fruit_identification_game': 'Laro sa Pagtukoy ng Prutas',
      'choose_your_challenge': 'Piliin ang Iyong Hamon!',
      'game_mechanics': 'Mekanika ng Laro:',
      'mechanics_desc_part1':
          'Isang halaga ng barya ang ibabawas sa bawat yugto na pipiliin mo. Hulaan ang pangalan ng prutas para sa Easy at Medium na antas. Para sa Hard na antas, tukuyin ang hakbang sa pag-aani AT ang tamang numero ng pagkakasunud-sunod nito (hal., "1. check").',
      'mechanics_desc_part2': 'Kikita ka ng barya para sa bawat tamang sagot.',
      'coins_per_correct_answer': 'barya/tamang sagot',

      'start_game': 'Simulan ang',
      'game_costs_message_part1': 'Ang larong ito ay nagkakahalaga ng',
      'game_costs_message_part2': 'barya. Sigurado ka bang gusto mong maglaro?',

      'game_started_message': 'Nagsimula na ang laro!',
      'game_coins_deducted': 'barya ang ibinawas.',
      'not_enough_coins_message_part1': 'Hindi sapat ang barya para laruin ang',
      'not_enough_coins_message_part2': 'na yugto! Kailangan mo ng',
      'not_enough_coins_message_part3': 'barya.',

      // --- Fruit Identification Game Keys ---
      'game_title_fruit_identification': 'Larong Pagtukoy ng Prutas 🍎',
      'game_select_mode': 'Pumili ng Uri ng Laro',

      // Mode Selection
      'game_mode_standard_title': 'Karaniwang Hamon 🧠',
      'game_mode_standard_desc':
          'Takdang bilang ng tanong. Subukan ang iyong kaalaman sa iba\'t ibang antas ng kahirapan.',
      'game_mode_time_attack_title': 'Hamon sa Oras ⏱️',
      'game_mode_time_attack_desc':
          'Mabilisang tanong na may limitasyon sa oras! Sagutin ang pinakamarami para mapalaki ang kita.',

      // Difficulty Selection
      'game_select_difficulty_standard':
          'Pumili ng Antas ng Kahirapan para sa Karaniwang Hamon',
      'game_select_difficulty_time_attack':
          'Pumili ng Antas ng Kahirapan para sa Hamon sa Oras',
      'difficulty_easy': 'Madali',
      'difficulty_medium': 'Katamtaman',
      'difficulty_hard': 'Mahirap',
      'label_cost': 'halaga',
      'label_coins_per_correct': 'barya/tamang sagot',
      'label_seconds_short': 's',

      // Confirmation Dialog
      'start_challenge_title_template':
          'Simulan ang {difficulty} - {modeName}?',
      'challenge_time_info_standard': 'Isang takdang bilang ng tanong.',
      'challenge_time_info_time_attack_template':
          'Mayroon kang {duration} segundo para sagutin ang pinakamarami.',
      'challenge_confirmation_message_template':
          'Ang larong ito ay nagkakahalaga ng {cost} barya at may gantimpala na {reward} barya bawat tamang sagot. Sigurado ka ba na gusto mong maglaro?',
      'start': 'Simulan',

      // Status/Feedback
      'status_started_template':
          'Nagsimula na ang {difficulty} {mode}! {cost} barya ang ibinawas.',
      'status_not_enough_coins_template':
          'Hindi sapat ang barya! Kailangan mo ng {cost} barya.',
      'dialog_confirm_submission_title': 'Kumpirmahin ang Pagsumite',
      'dialog_confirm_submission_content':
          'Sigurado ka ba na gusto mong isumite ang sagot na ito?',
      'submit': 'Isumite',
      'submit_answer': 'Isumite ang Sagot',
      'validation_select_option': 'Pakipili ng isang opsyon.',
      'validation_type_answer': 'Pakilagay ang iyong sagot.',
      'feedback_correct': 'Tama!',
      'feedback_incorrect_is_template': 'Mali. Ito ay {correctAnswer}.',

      // Question & Input Hints
      'question_hard_standard':
          'Tukuyin ang hakbang sa pag-aani AT ang pagkakasunud-sunod nito (hal., "1. check" o "1. pagsasako")',
      'question_hard_time_attack': 'Tukuyin ang tamang hakbang sa pag-aani',
      'question_easy_medium': 'Tukuyin ang pangalan ng prutas',
      'input_hint_hard_standard':
          'I-type ang pagkakasunud-sunod at hakbang (hal., 1. check o 1. pagsasako)',
      'input_hint_easy_medium':
          'I-type ang pangalan ng prutas (English o Tagalog)',
      'label_score': 'Puntos:',
      'label_question_short': 'T:',
      'label_time_short': 'Oras:',

      // Game Result Dialog
      'game_over_challenge_title': 'Tapos na ang Hamon!',
      'game_over_time_attack_title': 'Tapos na ang Hamon sa Oras!',
      'game_result_standard_template':
          'Naka-iskor ka ng {score} sa {total} sa {difficulty} na antas!',
      'game_result_time_attack_template':
          'Nakilala mo ang {score} item sa {difficulty} Hamon sa Oras!',
      'game_result_master': '🎉 Pagbati! Ikaw ay isang master!',
      'game_result_coins_earned_template': 'Kinita na barya: {coins}',
      'play_again': 'Maglaro Uli',
      'back_to_home': 'Bumalik sa Home',

      // Quit Dialog
      'dialog_quit_game_title': 'Umalis sa Laro?',
      'dialog_quit_game_content':
          'Sigurado ka ba na gusto mong umalis sa kasalukuyang laro? Mawawala ang iyong progreso at potensyal na kikitain.',
      'no_continue': 'Hindi, ipagpatuloy',
      'yes_quit': 'Oo, umalis',

      "@@locale": "ph",
      "welcome": "Maligayang Pagdating, Grower!",
      "signinMessage":
          "Mag-sign in upang ma-access ang iyong dashboard at kaalaman.",
      "email": "Email Address",
      "password": "Password",
      "forgotPassword": "Nakalimutan ang Password?",
      "signIn": "Mag-sign In",
      "noAccount": "Wala ka pang account? ",
      "signUpHere": "Mag-sign up dito.",
      "resetPassword": "I-reset ang Password",
      "enterEmail": "Ilagay ang iyong email",
      "sendEmail": "Ipadala ang Email",
      "cancel": "Kanselahin",
      "resetEmailSent":
          "Naipadala na ang password reset email! Suriin ang iyong inbox.",
      "resetEmailFailed":
          "Error: Hindi valid ang email o hindi makita ang account.",
      "fillAllFields": "Paki-fill ang parehong email at password.",
      "userDataNotFound":
          "Hindi makita ang user data. Makipag-ugnayan sa support.",
      "loginFailed": "Nabigong mag-login. Suriin ang iyong email at password."
          'loading_images'
          'Naglo-load ng mga larawan...',
      'question': 'Tanong',
      'score': 'Score',
      'easy_medium_stage_instruction': 'Tukuyin ang pangalan ng prutas',
      'hard_stage_instruction':
          'Tukuyin ang hakbang sa pag-aani AT ang pagkakasunud-sunod nito (hal., "1. check")',
      'type_your_answer': 'I-type ang iyong sagot',
      // ignore: equal_keys_in_map
      'game_submit_answer': 'Isumite ang Sagot',

      // ignore: equal_keys_in_map
      'game_correct': 'Tama!',
      // ignore: equal_keys_in_map
      'game_incorrect': 'Mali.',

      'game_over_title': 'Tapos na ang Laro!',
      'final_score_message_part1': 'Naka-score ka ng',
      'final_score_message_part2': 'sa',
      'final_score_message_part3': 'sa yugtong',
      'final_score_message_part4': '!',
      'master_result_message': '🎉 Pagbati! 🎉\nIkaw ay isang master!',
      'good_result_message': 'Magaling! Magpatuloy sa pagsasanay!',
      'poor_result_message':
          'Magandang pagsisikap! Subukang muli para gumaling!',
      'congratulations_message': '🎉 Pagbati! 🎉\nIkaw ay isang master!',
      'coins_earned': 'Kinita na barya',
      // ignore: equal_keys_in_map
      'game_play_again': 'Maglaro Muli',

      'cancel': 'Kanselahin',
      'start': 'Simulan',
      'play_again': 'Maglaro Muli',
      'back_to_home': 'Bumalik sa Home',

// --- NEW: Stage Names (used internally and in UI) ---
      'stage_easy': 'Madali',
      'stage_medium': 'Katamtaman',
      'stage_hard': 'Mahirap',

// --- NEW: Fruit Identification Game Keys ---
      'game_title': 'Laro sa Pagkilala ng Prutas',
      'game_challenge': '%s na Hamon', // E.g., Madaling Hamon
      'game_choose_challenge': 'Piliin ang Iyong Hamon!',
      'coins_per_correct_answer':
          ' %s na barya/tamang sagot', // E.g., 5 na barya/tamang sagot

// Game Mechanics
      'game_mechanics_title': 'Mekanika ng Laro:',
      'game_mechanics_body_1':
          'Babawasan ng halaga ng barya ang bawat yugto na pipiliin mo. Hulaan ang pangalan ng prutas para sa Madali at Katamtamang mga antas. Para sa Mahirap na antas, tukuyin ang hakbang sa pag-aani AT ang tamang numero ng pagkakasunud-sunod nito (hal., "1. check").',
      'game_mechanics_body_2':
          'Makakakuha ka ng mga barya para sa bawat tamang sagot.',

// Game Prompts
      'game_fruit_question_prompt': 'Tukuyin ang pangalan ng prutas',
      'game_hard_question_prompt':
          'Tukuyin ang hakbang sa pag-aani AT ang pagkakasunud-sunod nito (hal., "1. check")',
      'game_answer_hint': 'I-type ang iyong sagot',
      'game_submit_answer': 'Isumite ang Sagot',
      'loading_images': 'Naglo-load ng mga larawan...',
      'game_question_counter': 'Tanong %d / %d', // Tanong 1 / 10

      'announcement_title_screen': 'Mga Anunsyo ng Admin',
      'field_title': 'Pamagat',
      'field_description': 'Deskripsyon',
      'button_post_announcement': 'I-post ang Anunsyo',
      'no_announcements_found': 'Walang nakitang anunsyo.',

      // Post Confirmation Dialog
      'post_confirm_title': 'I-post ang Anunsyo?',
      'post_confirm_content':
          'Sigurado ka bang gusto mong i-post ang anunsyo na ito?',
      'button_post': 'I-post',

      // --- General / Language ---
      'english': 'English',
      'tagalog': 'Tagalog',
      'cancel': 'Kanselahin',

      // --- Sign In Screen Keys ---
      'sign_in': 'Mag-sign In',
      'welcome': 'Maligayang pagdating, ',
      'grower': 'Magsasaka!',
      'signin_motto':
          'Mag-sign in upang linangin ang kaalaman at i-access ang iyong dashboard.',
      'email_address': 'Email Adress',
      'forgot_password': 'Nakalimutan ang Password?',
      'no_account_question': 'Wala ka bang account? ',
      'sign_up_here': 'Mag-sign up dito.',
      'reset_password': 'I-reset ang Password',
      'enter_your_email': 'Ilagay ang iyong email',
      'send_email': 'Ipadala ang Email',
      'fill_in_all_fields': 'Pakilagay ang email at password.',
      'user_data_not_found':
          'Hindi nakita ang data ng user. Makipag-ugnay sa suporta.',
      'login_failed_check_credentials':
          'Nabigo ang Pag-log In. Pakitiyak ang iyong email at password.',
      'please_enter_your_email': 'Pakilagay ang iyong email.',
      'password_reset_sent':
          'Naipadala na ang email para sa pag-reset ng password! Tingnan ang iyong inbox.',
      'error_invalid_email_or_account':
          'Error: Di-wastong email o hindi nakita ang account.',

      // --- Sign Up Screen Keys ---
      'create_account': 'Gumawa ng Account',
      'tap_to_add_profile': 'Pindutin upang magdagdag ng larawan ng profile',
      'first_name': 'Unang Pangalan',
      'middle_name': 'Gitnang Pangalan',
      'middle_name_optional': 'Gitnang Pangalan (Opsyonal)',
      'last_name': 'Huling Pangalan',
      'age': 'Edad',
      'next': 'Susunod',
      'select_role': 'Pumili ng Tungkulin',
      'farmer': 'Magsasaka',
      'vendor': 'Vendor',
      'consumer': 'Mamimili',
      'harvesting_experience_question': 'May karanasan ka ba sa pag-aani?',
      'yes': 'Oo',
      'no': 'Hindi',
      'select_sex': 'Piliin ang Kasarian',
      'male': 'Lalaki',
      'female': 'Babae',
      'non_binary': 'Non-binary',
      'select_barangay': 'Pumili ng Barangay',
      'mobile_number_hint': 'Numero ng Mobile (hal., 9123456789)',
      'back': 'Bumalik',
      'sign_up': 'Mag-sign Up',
      'confirm_password': 'Kumpirmahin ang Password',
      'confirm_account_creation': 'Kumpirmahin ang Paglikha ng Account',
      'create': 'Gumawa',
      'account_created_successfully': 'Matagumpay na nagawa ang account!',
      'creating_your_account': 'Ginagawa ang iyong account...',
      'password': 'Password', // Also used in Sign In

      // --- Validation & Error Keys (Sign Up) ---
      'please_select_option': 'Pakipili ng isang opsyon',
      'please_enter_field': 'Pakilagay ang {field}',
      'alphabetical_only':
          'Mangyaring maglagay lamang ng mga alpabetikong character para sa {field}',
      'please_enter_age': 'Pakilagay ang iyong edad',
      'please_enter_valid_age': 'Pakilagay ng wastong edad',
      'please_enter_mobile': 'Pakilagay ang iyong mobile number',
      'mobile_number_format': 'Ilagay ang 10 numero (hal., 9xxxxxxxxx).',
      'please_enter_email': 'Pakilagay ang email',
      'please_enter_valid_email': 'Maglagay ng wastong email',
      'please_enter_password': 'Pakilagay ang password',
      'password_strength_requirements':
          'Ang password ay dapat may 8+ karakter,\nisang malaki at maliit na letra,\nisang numero, at isang espesyal na karakter',
      'please_confirm_password': 'Pakikumpirma ang password',
      'passwords_do_not_match': 'Hindi tugma ang mga password',
      'please_select_all_options':
          'Pakipili ang lahat ng kinakailangang opsyon.',
      'invalid_email_format': 'Di-wasto ang format ng email',
      'email_already_in_use': 'Ginagamit na ang email na ito.',
      'account_creation_failed': 'Nabigo ang Paglikha ng Account: {error}',
      'unexpected_error': 'Hindi Inaasahang Error: {error}',

      // Edit Dialog
      'edit_dialog_title': 'I-edit ang Anunsyo',
      'edit_field_label': 'Mensahe',

      // Edit Save Confirmation Dialog
      'save_changes_title': 'I-save ang Pagbabago?',
      'save_changes_content':
          'Sigurado ka bang gusto mong i-save ang pagbabago sa anunsyo na ito?',
      'button_save': 'I-save',

      // Delete Confirmation Dialog
      'delete_confirm_title': 'Burahin ang Anunsyo?',
      'delete_confirm_content':
          'Sigurado ka bang gusto mong burahin ang anunsyo na ito? Hindi ito mababawi.',
      'button_delete': 'Burahin',

      // View Dialog
      'view_dialog_title': 'Anunsyo',
      'button_close': 'Isara',

      // General Buttons & Statuses
      'button_cancel': 'Kanselahin',
      'status_announcement_posted': 'Na-post ang Anunsyo',
      'status_announcement_saved': 'Na-save ang Anunsyo',
      'status_announcement_deleted': 'Nabura ang Anunsyo',
      'list_no_title': 'Walang Pamagat',
      'list_no_date': 'Walang Petsa',
      'list_no_message': 'Walang Mensahe',

      // ...

// Confirmation & Feedback
      'game_quit_title': 'Umalis sa Laro?',
      'game_quit_content':
          'Sigurado ka bang gusto mong umalis sa kasalukuyang laro? Mawawala ang iyong progreso at potensyal na kita para sa round na ito.',
      'game_quit_no': 'Hindi, ipagpatuloy',
      'game_quit_yes': 'Oo, umalis',
      'game_start_confirm_title': 'Simulan ang %s Laro?',
      'game_start_confirm_content':
          'Ang larong ito ay nagkakahalaga ng %d barya. Sigurado ka bang gusto mong maglaro?',
      'game_start_snackbar': 'Nagsimula ang laro! %d na barya ang ibinawas.',
      'game_not_enough_coins':
          'Hindi sapat ang barya para maglaro sa %s na yugto! Kailangan mo ng %d barya.',
      'game_feedback_correct': 'Tama!',
      'game_feedback_incorrect': 'Mali. Ito ay %s.',

// Game Result
      'game_over_title': 'Tapos na ang Laro!',
      'game_result_score': 'Naka-iskor ka ng %d sa %d sa %s na yugto!',
      'game_result_master': '🎉 Pagbati! 🎉\nIkaw ay isang master!',
      'game_result_well_done': 'Magaling! Magpatuloy sa pagsasanay!',
      'game_result_good_effort':
          'Magandang pagsisikap! Subukan muli para mapabuti!',
      'game_result_coins_earned': 'Mga barya na nakuha: %d',

      // 🕹️ NEW: Quit Challenge Dialog Keys
      'quit_challenge_title': 'Umalis sa Hamon?',
      'quit_challenge_content':
          'Sigurado ka bang gusto mong tapusin ang kasalukuyang laro? Hindi mase-save ang iyong puntos.',
      'quit_challenge_no': 'Hindi, Ipagpatuloy',
      'quit_challenge_yes': 'Oo, Umalis', // Added 'yes' option for clarity

      // 🍎 NEW: Harvesting/Product Keys
      'product_list_title': 'Mga Produkto',
      'fruit_information': 'Impormasyon sa Prutas',
      'steps_of_proper_harvesting': 'Mga Hakbang sa Tamang Pag-aani',

      // ... inside 'tl': { ...
      // ❓ NEW: Help Center Screen Keys
      'faq_title': 'Mga Madalas Itanong',
      'safety_disclaimer_title': 'Mahalagang Paalala sa Kaligtasan ⚠️',
      'safety_disclaimer_content':
          'Ang app ay para sa impormasyon at edukasyonal na gamit lamang. Huwag kumonsumo ng anumang prutas batay lamang sa pagtukoy ng app. Laging kumonsulta sa isang propesyonal o maaasahang gabay bago kumain ng ligaw o hindi kilalang prutas.',

      // ❓ NEW: Help Center FAQ Content - Titles
      'faq_title_getting_started': 'Pagsisimula',
      'faq_title_troubleshooting': 'Pagsasaayos ng Problema',
      'faq_title_features': 'Mga Tampok',

      // ... existing Tagalog keys

// 👑 BAGONG: Admin Account Creation Screen Keys (AdminsScreen)
      'create_admin_title': 'Gumawa ng Admin',
      'field_first_name': 'Pangalan',
      'field_middle_name': 'Panggitnang Pangalan (Opsyonal)',
      'field_last_name': 'Apelyido',
      'field_email': 'Email',
      'field_password': 'Password',
      'field_confirm_password': 'Kumpirmahin ang Password',
      'name_required': 'Kinakailangan ang Pangalan.',
      'name_invalid_char':
          'Mga alpabetong letra at simbolo tulad ng \'-\' lang ang pinapayagan.',
      'email_required': 'Kinakailangan ang Email.',
      'email_invalid': 'Maglagay ng wastong email address.',
      'password_required': 'Kinakailangan ang Password.',
      'password_strong_policy':
          '8+ chars, kasama ang uppercase, lowercase, numero, at special char.',
      'passwords_must_match': 'Hindi tugma ang mga password.',
      'button_create': 'Gumawa',

// Dialog & Verification
      'verify_identity_title':
          'I-verify ang Iyong Identity (Kasalukuyang Admin)',
      'verify_password_field': 'Iyong Kasalukuyang Password',
      'error_enter_password': 'Paki-lagay ang iyong password.',
      'error_verification_failed': 'Maling password o nabigo ang awtorisasyon.',
      'button_verify': 'I-verify',

// Success Dialog
      'admin_creation_success_title': 'Matagumpay na Nalikha ang Admin! 🎉',
      'admin_creation_success_message':
          'Nalikha na ang bagong admin account para sa %s. \n\n Kailangan mong mag-log out para mag-switch o i-verify ang bagong account.',
      'button_log_out_now': 'Mag-Log Out Na',
      'button_cancel': 'Kanselahin', // Already exists, but kept for context

// General Error/Status
      'status_signed_up': 'Signed Up',
// ...

      // ❓ NEW: Help Center FAQ Content - Q/A
      'faq_q_identify_fruit': 'Paano ako magpapakilala ng prutas? 🍎',
      'faq_a_identify_fruit':
          'Buksan lang ang camera sa app at itutok ito sa prutas. Siguraduhin na maliwanag at nakafocus ang prutas. I-tap ang screen para kumuha ng larawan, at ibibigay ng app ang resulta ng pagtukoy.',
      'faq_q_good_photo': 'Ano ang bumubuo sa isang magandang larawan? 📸',
      'faq_a_good_photo':
          'Para sa pinakamahusay na resulta, gumamit ng malinaw na ilaw, ilagay ang prutas sa isang neutral na background, at lumapit hangga\'t maaari habang pinapanatili ang buong prutas sa frame.',
      'faq_q_cant_identify':
          'Paano kung hindi matukoy ng app ang isang prutas? 🤔',
      'faq_a_cant_identify':
          'Patuloy na lumalaki ang aming database, ngunit maaaring hindi nito naglalaman ang lahat ng uri. Subukan ang isa pang larawan mula sa ibang anggulo o may mas mahusay na ilaw. Kung hindi pa rin matukoy, maaari mong i-contribute ang larawan ng prutas sa pamamagitan ng "Magpadala ng Feedback" na seksyon!',
      'faq_q_inaccurate': 'Bakit hindi tumpak ang pagtukoy? 🧐',
      'faq_a_inaccurate':
          'Ang katumpakan ng app ay lubos na umaasa sa kalidad ng larawan. Siguraduhin na ang larawan ay hindi malabo, labis na nalantad sa liwanag, o natatakpan ng ibang bagay. Ang aming modelo ng machine learning ay patuloy na natututo at nagpapabuti.',
      'faq_q_learning_guide': 'Ano ang Learning Guide? 📚',
      'faq_a_learning_guide':
          'Ang Learning Guide ay nagbibigay ng komprehensibong impormasyon tungkol sa mga prutas at tamang pamamaraan ng pag-aani. Maaari mo itong ma-access sa pamamagitan ng pag-tap sa anumang natukoy na larawan ng prutas.',
      'faq_q_announcements': 'Paano gumagana ang Mga Anunsyo? 📣',
      'faq_a_announcements':
          'Ang mga Anunsyo ay ginawa at pinamamahalaan ng mga administrator ng app. Nagbibigay sila ng mahahalagang update, balita, at espesyal na mensahe sa lahat ng user.',
      'faq_q_games': 'Ano ang mga laro? 🎮',
      'faq_a_games':
          'Nagtatampok ang Harvi ng dalawang nakakatuwang laro: "Hulaan ang Larawan" at "Timed Hulaan ang Larawan." Dinisenyo ang mga ito upang aliwin at hamunin ka habang nag-aalok din ng pang-araw-araw na gantimpala!',
      'faq_q_save_list': 'Paano gumagana ang Save List? ✅',
      'faq_a_save_list':
          'Awtomatikong sine-save ng Save List ang lahat ng prutas na matagumpay mong natukoy. Hindi mo na kailangang i-save nang manu-mano ang mga ito, tinitiyak na laging updated ang iyong koleksyon.',
// ...
// ... inside 'tl': { ...

      // 🔒 NEW: Privacy/Security Screen Keys
      'security': 'Seguridad',
      'change_password_title': 'Palitan ang Password',
      'current_password': 'Kasalukuyang Password',
      'new_password': 'Bagong Password',
      'confirm_new_password': 'Kumpirmahin ang Bagong Password',
      'change_password_button': 'Palitan ang Password',
      'forgot_password_button': 'Nakalimutan ang kasalukuyang password?',
      'password_required': 'Kinakailangan ang Password.',
      'password_min_length':
          'Ang password ay dapat may hindi bababa sa 8 karakter.',
      'password_uppercase':
          'Ang password ay dapat may hindi bababa sa isang malaking letra.',
      'password_lowercase':
          'Ang password ay dapat may hindi bababa sa isang maliit na letra.',
      'password_digit':
          'Ang password ay dapat may hindi bababa sa isang numero.',
      'password_special_char':
          'Ang password ay dapat may hindi bababa sa isang special na karakter (!@#\$%^&*(),.?":{}|<>).',
      'new_password_hint':
          'Min 8 karakter, 1 malaking letra, 1 maliit na letra, 1 numero, 1 special na karakter',
      'confirm_password_required':
          'Kinakailangan ang kumpirmasyon ng password.',
      'passwords_do_not_match': 'Hindi tugma ang mga bagong password.',
      'password_change_success': 'Matagumpay na napalitan ang password',
      'error_user_not_logged_in':
          'Error: Hindi naka-log in ang user o walang email.',
      'error_reauth_failed':
          'Mali ang kasalukuyang password. Pakisubukan muli.',
      'error_too_many_requests':
          'Masyadong maraming nabigong pagsubok. Pakisubukan mamaya.',
      'error_requires_recent_login':
          'Ang aksyon na ito ay nangangailangan ng kamakailang pag-authenticate. Mag-log in muli at subukan.',
      'error_weak_password':
          'Masyadong mahina ang bagong password. Gumamit ng mas malakas na password.',
      'error_password_reset_title': 'I-reset ang Password',
      'error_password_reset_confirm':
          'Sigurado ka bang nais mong magpadala ng password reset link sa ',
      'error_password_reset_link_sent': 'Naipadala ang password reset link sa ',
      'error_password_reset_check_email':
          '. Tingnan ang iyong inbox at spam folder.',
      'button_cancel': 'Kanselahin',
      'button_send_reset_link': 'Ipadala ang Reset Link',
      'error_email_not_found': 'Error: Hindi mahanap ang iyong email address.',
      'error_user_not_registered': 'Ang email address ay hindi nakarehistro.',
      'error_unknown': 'May hindi inaasahang error na naganap.',

      // 👤 NEW: Profile Detail Screen Keys
      'edit_profile': 'I-edit ang Profile',
      'welcome_message': 'Maligayang Pagdating, ',
      'welcome_default': 'Maligayang Pagdating!',
      'change_profile_picture': 'Palitan ang Larawan ng Profile',
      'first_name': 'Unang Pangalan',
      'middle_name': 'Gitnang Pangalan (Opsyonal)',
      'last_name': 'Apelyido',
      'first_name_required': 'Kinakailangan ang Unang Pangalan.',
      'last_name_required': 'Kinakailangan ang Apelyido.',
      'save_changes': 'I-save ang Pagbabago',
      'profile_update_success': 'Matagumpay na na-update ang Profile',
      'error_load_profile': 'Nabigong i-load ang data ng profile.',
      'error_saving_profile':
          'May hindi inaasahang error na naganap habang nagse-save.',
      'save_confirmation_title': 'I-save ang Pagbabago?',
      'save_confirmation_content':
          'Sigurado ka bang gusto mong i-save ang pagbabago sa iyong profile?',
      'button_save': 'I-save',
// ...

      // 📝 HarvestScreen UI Keys
      'fruit_info_title': 'Impormasyon sa Prutas',
      'search_fruits_label': 'Maghanap ng Prutas',
      'key_info_label': 'Pangunahing Impormasyon:',
      'tap_for_full_info': 'Pindutin ang card para sa buong impormasyon',
      'close_button': 'Isara',

      // 🍎 FRUIT DATA TRANSLATIONS (HarvestScreen Content - Tagalog) 🍎
      'apple_name': 'Mansanas',
      'apple_vitamins': 'Bitamina C, Bitamina E, Bakal, Zinc, Polyphenols',
      'apple_post_harvest':
          'Ayon kay A. Oyenihi (2022), ang mga sariwang mansanas ay itinuturing na pagkain ng katamtamang halaga ng enerhiya sa mga karaniwang prutas, habang ang mga naprosesong produkto ng mansanas ay maihahambing sa sariwang mansanas sa halaga ng enerhiya o mas mataas dahil sa konsentrasyon, pagka-dehydrated, o pagdaragdag ng asukal sa panahon ng pagproseso. Ang mga mansanas ay mayaman sa piling micronutrients na bakal, zinc, bitamina C at E, at polyphenols na makakatulong sa pagpapagaan ng micronutrient deficiencies at mga malalang sakit.',

      'banana_name': 'Saging',
      'banana_vitamins':
          'Bitamina C, Starch, Asukal, Fiber, Magnesium, Potassium',
      'banana_post_harvest':
          'Ayon kay S. Sari (2024), ang saging ay isang mahalagang prutas na kinokonsumo sa buong mundo at nilinang sa mga humid at subtropical na klima. Ang prutas ay naglalaman ng mga sustansya sa pulp at balat nito na may kapaki-pakinabang na katangian. Ang saging ay mayaman sa sustansya, lalo na sa bitamina C, starch, asukal, fiber, at nagsisilbing isang abot-kayang pinagmulan ng bitamina, mineral, at enerhiya para sa komunidad.',

      'calamansi_name': 'Kalamansi',
      'calamansi_vitamins':
          'Bitamina C, D-Limonene, Dietary Fiber, Phenolics, Flavonoids',
      'calamansi_post_harvest':
          'Ayon kay K. Venkatachalam (2023), ang mga kalamansi ay isang mayamang pinagmumulan ng mga sustansya tulad ng bitamina C, D-limonene, at dietary fiber, na may iba\'t ibang medikal at komersyal na aplikasyon. Ang kalamansi ay may mga benepisyo sa immune system, pati na rin anti-inflammatory, anti-cancer, anti-diabetic, at iba pang therapeutic effects. Ang natatanging lasa at mataas na nilalaman ng katas nito ay ginagawang popular na sangkap ang kalamansi juice sa maraming internasyonal na lutuin.',

      'durian_name': 'Durian',
      'durian_vitamins':
          'Iba\'t Ibang Bitamina, Polyphenols, Bioactive Compounds',
      'durian_post_harvest':
          'Ayon kay G. Khaksar (2024), ang Durian ay nagsisilbing mayamang pinagmumulan ng iba\'t ibang bitamina, bawat isa ay may mahalagang papel sa pagpapanatili ng pangkalahatang kalusugan. Ang regular na pagkonsumo ng mga sariwang prutas ay mahalaga dahil sa masaganang nilalaman nito ng bioactive compounds na nagpapahusay sa kalusugan, kabilang ang polyphenols at bitamina. Ang mga compound na ito ay may mahalagang papel sa pag-neutralize ng free radicals, sa gayon ay binabawasan ang oxidative stress.',

      'fig_name': 'Igos',
      'fig_vitamins': 'Bakal, Calcium, Copper, Potassium, Magnesium',
      'fig_post_harvest':
          'Ayon kay K. Yadav, ang igos ay kabilang sa pamilya ng Mulberry, na sinasabing isa sa pinakamatandang kilalang tanim na prutas sa sibilisasyon ng tao. Ang mga igos ay isang masarap na prutas na mayaman din sa mineral tulad ng bakal, calcium, copper, potassium, at magnesium. Tradisyonal na ginagamit ang halaman ng igos bilang gamot upang gamutin ang maraming sakit sa kalusugan.',

      'guava_name': 'Bayabas',
      'guava_vitamins':
          'Bitamina C, Dietary Fiber, Potassium, Lycopene, Polyphenols',
      'guava_post_harvest':
          'Ayon kay A. Zaid, ang Bayabas ay isang tropical na prutas na kilala sa mayaman nitong nutritional profile at mga katangian ng panggamot. Ang bayabas ay may pambihirang nutritional value, na mayaman sa dietary fiber, bitamina (lalo na bitamina C), mineral (potassium, magnesium), at antioxidants tulad ng lycopene at polyphenols. Ang low-calorie profile ng prutas ay ginagawa itong angkop para sa iba\'t ibang dietary regimes.',

      'honeydew_name': 'Honeydew Melon',
      'honeydew_vitamins': 'Hybrids at non-hybrids',
      'honeydew_post_harvest':
          'Ayon kay G. Lester, ang Honey Dew melons, hybrids at non-hybrids, ay handa nang kainin kapag ang balat ay naging maputlang berde hanggang cream at ang ibabaw ay tila waxy. Ang dulo ng bulaklak ay lumalambot kapag pinindot ng hinlalaki at mayroon silang kaaya-ayang aroma. Ang mas hindi hinog at malamig na melon ay walang gaanong aroma.',

      'jackfruit_name': 'Langka',
      'jackfruit_vitamins':
          'Carbohydrates, Protina, Starch, Calcium, Bitamina, Fatty Acids',
      'jackfruit_post_harvest':
          'Ayon kay S. Swami, ang Langka (*Artocarpus heterophyllus Lam.*) ay isang sinaunang prutas at kinakain nang hilaw o pinoproseso sa iba\'t ibang produkto. Ang mga buto ng langka ay karaniwang itinatapon o pinasingawan at kinakain bilang meryenda o ginagamit sa ilang lokal na pagkain. Ang mga benepisyo sa kalusugan ng langka ay iniuugnay sa malawak na hanay ng physicochemical applications nito.',

      'kiwi_name': 'Kiwi',
      'kiwi_vitamins':
          'Bitamina C, Bitamina E, Flavonoids, Carotenoids, Minerals',
      'kiwi_post_harvest':
          'Ayon kay V. Pawar, ang Kiwi fruit ay katutubong sa Asia at naging kilala sa buong mundo dahil sa sensory at nutritional property nito. Naglalaman ito ng mataas na antas ng bioactive compounds tulad ng bitamina C, bitamina E, Flavonoids, carotenoids, at minerals. Ang ellipsoidal na kiwi fruit ay isang tunay na berry at may balat na may buhok at may kulay na brownish green.',

      'lemon_name': 'Lemon',
      'lemon_vitamins': 'Flavonoids, L-ascorbic acid (Bitamina C)',
      'lemon_post_harvest':
          'Ayon kay S. Hussain (2024), ang Lemon ay mahalaga para sa malusog na balat ng tao ngunit tila mahusay din para sa isip. Ang pagkonsumo ng lemon o kahit na paglanghap ng aroma nito (aromatherapy) ay epektibong nagpapabuti sa mood at nagpapababa rin ng tensyon, nerbiyos, pagkabalisa, pagod, pamamaga, at lethargy. Ang lemon ay ginagamit din sa maraming air sprays at cooling devices. ',

      'mango_name': 'Mangga',
      'mango_vitamins': 'Asukal, Protina, Fats, Bitamina',
      'mango_post_harvest':
          'Ayon kay Habib et al., ang mga mangga ay nagbibigay ng 64-86 calories ng enerhiya. Naglalaman ito ng asukal, protina, fats, at iba pang sustansya. Ang mga mangga ay kinakain nang sariwa bilang dessert at pinoproseso bilang pickles, jams, jellies, sauces, nectar, juices, cereal flakes, at chips. Sa tradisyonal na sistema ng pagpapagaling, ginagamit ang mga prutas ng Mangga upang pagalingin ang sunstroke, ophthalmia, eruption, intestinal disorder, infertility, at night blindness.',

      'noni_name': 'Noni',
      'noni_vitamins':
          'Flavonoids, Terpenoids, Alkaloids, Steroids, Bitamina C',
      'noni_post_harvest':
          'Ayon kay A. Saah, ang Morinda citrifolia, na karaniwang tinatawag na noni, ay may mahabang kasaysayan bilang isang medicinal plant at iniulat na may malawak na hanay ng therapeutic effects, kabilang ang antibacterial, antiviral, antifungal, antitumor, at immune enhancing effects. Iminumungkahi nito na ang noni fruit ay maaaring makatulong sa pagtataguyod ng mabuting kalusugan.',

      'orange_name': 'Dalandan/Orange',
      'orange_vitamins': 'Flavonoids, Bitamina C',
      'orange_post_harvest':
          'Ayon kay S. Shuklah, ang Orange (*Citrus reticulata Blanco*) ay isang evergreen tree na kabilang sa pamilya Rutaceae. Ang dalandan ay isang prutas ng taglamig. Dahil sa hindi mapigilang matingkad na kulay, nakakaakit na lasa at aroma, ang mandarin orange ay isa sa pinakapaboritong citrus fruit. Malawakang nilinang ang mga dalandan sa mga tropical at subtropical na klima.',

      'papaya_name': 'Papaya',
      'papaya_vitamins':
          'Bitamina A, Bitamina B, Bitamina C, Papain, Chymopapain',
      'papaya_post_harvest':
          'Ayon kay R. Kumar, ang Papaya ay isang popular at mahalagang prutas sa tropical at subtropical na bahagi ng mundo. Ang prutas ay kinokonsumo sa buong mundo bilang sariwang prutas at gulay o ginagamit bilang processed product. Ang buong bahagi ng halaman, kabilang ang prutas, ugat, balat, buto, at pulp ay kilala rin na may medicinal properties. Ang maraming benepisyo ng papaya ay iniuugnay sa mataas na nilalaman ng bitamina A, B, at C, at proteolytic enzymes tulad ng papain at chymopapain.',

      'rambutan_name': 'Rambutan',
      'rambutan_vitamins': 'Bitamina C',
      'rambutan_post_harvest':
          'Ayon kay P. Bhattacharjee, ang Rambutan ay isang medium-sized evergreen tree. Ang mga prutas ay inuri bilang berries, ang mga ito ay ovoid sa hugis, napaka-katas, at bahagyang acidic dahil sa mataas na nilalaman ng bitamina C. Ang pangalan ng prutas na ito ay nagmula sa salitang Malayan na *Rambut*, na nangangahulugang buhok sa Ingles, at tumutukoy sa malambot na tinik na balahibo na tumatakip sa ibabaw ng prutas.',

      'strawberry_name': 'Strawberry',
      'strawberry_vitamins': 'Bitamina C, Fiber, Antioxidants',
      'strawberry_post_harvest':
          'Ayon kay K. Sharma, ang balanse ng nutrisyon ay kailangan ng maselang halaman ng strawberry kaya mahalagang panatilihin ang nutritional status para sa mas mahusay na paglaki, ani, at kalidad ng mga strawberry. Kahit na ang mga strawberry ay isang lubhang perishable na prutas, maraming wrapping techniques ang nagpanatili sa kalidad ng prutas kapag itinatago sa ambient temperature.',

      'tomato_name': 'Kamatis',
      'tomato_vitamins': 'Bitamina, Carotenoids, Minerals, Bioactive compounds',
      'tomato_post_harvest':
          'Ayon kay S. Vats, ang Kamatis, isang malawakang kinokonsumo na pananim, ay nag-aalok ng tunay na potensyal upang labanan ang nutritional deficiencies ng tao. Ang mga kamatis ay mayaman sa micronutrients at iba pang bioactive compounds kabilang ang bitamina, carotenoids, at mineral na kilala na mahalaga o kapaki-pakinabang para sa kalusugan ng tao. ',

      'watermelon_name': 'Pakwan',
      'watermelon_vitamins':
          'Bitamina C, Pantothenic Acid, Copper, Biotin, Bitamina A, B6 & B1',
      'watermelon_post_harvest':
          'Ayon kay M. Nadeem, ang Pakwan ay kinikilala sa buong mundo bilang isang masarap na prutas na nagpapawi ng uhaw na kinakain ng maraming tao sa init ng tag-init. Mayroong halos 1,200 uri ng pakwan. Ang mga pakwan ay puno ng maraming sustansya, tulad ng bitamina C, pantothenic acid, copper, biotin, bitamina A, at bitamina B6 at B1.',

      'cucumber_name': 'Pipino',
      'cucumber_vitamins':
          'Bitamina, Minerals, Phenols, Flavonoids, Carotenoids',
      'cucumber_post_harvest':
          'Ayon kay H. Javid, ang mga pipino ay isang mahalagang bahagi ng diyeta ng tao, na madalas ginagamit sa salads, pickles, at sauces, dahil sa kanilang nutritious qualities at health benefits. Ang mga ito ay isang magandang pinagmumulan ng bitamina, mineral, soluble carbohydrates, protina, atbp. Tradisyonal na ginagamit ang mga pipino upang gamutin ang iba\'t ibang sakit, kabilang ang mataas na presyon ng dugo, isyu sa asukal sa dugo, at iba pang problema.',

      'grapes_name': 'Ubas',
      'grapes_vitamins': 'Polyphenols, Antioxidants',
      'grapes_post_harvest':
          'Ayon kay H. Hou, ang mga Ubas ay itinuturing na isa sa pinakamahalagang economic horticultural crops sa mundo. Hindi lang sila popular na sariwang prutas kundi nagsisilbi ring raw materials para sa alak, grape juice, at raisins. Nag-aalok ang mga ubas ng iba\'t ibang benepisyo sa kalusugan. Kasama rito ang pag-iwas sa kanser, pag-iwas sa diabetes, pag-iwas sa cardiovascular disease, at anti-inflammatory properties.',

      // 🛠️ (Existing translations for Steps)
      'step_1_title': 'Hakbang 1: Suriin ang Panahon at Prutas',
      'step_1_desc':
          'Bago mag-ani, suriin ang panahon para sa posibleng ulan o matinding init. Suriin din kung ang mga prutas ay umabot na sa tamang pagkahinog.',
      'step_2_title': 'Hakbang 2: Gumamit ng Kamay o Pamutol',
      'step_2_desc':
          'Gamitin ang iyong mga kamay para sa maselan na prutas o may mahinang tangkay. Para sa mas matibay na tangkay, gumamit ng pamutol o gunting. Hawakan ang lahat ng prutas nang maingat.',
      'step_3_title': 'Hakbang 3: Paggiik (Paunang Paglilinis)',
      'step_3_desc':
          'Magsagawa ng paunang magaan na paglilinis, tulad ng pagdampi o mabilisang banlaw, upang alisin ang maluwag na dumi. Naghahanda ito sa mga prutas para sa karagdagang paghawak.',
      'step_4_title': 'Hakbang 4: Paglilinis',
      'step_4_desc':
          'Inaalis ng paghuhugas ang dumi, residue, at kontaminant, nagpapabuti sa anyo at nagpapabawas sa pagkasira. Tandaan na ang paglilinis ay maaaring makasira sa maselan na prutas kung hindi gagawin nang maingat.',
      'step_5_title': 'Hakbang 5: Paghihiwalay',
      'step_5_desc':
          'Ikategorya ang mga prutas ayon sa laki, kulay, pagkahinog, at kalidad batay sa pamantayan ng merkado upang matiyak ang pare-parehong mga batch.',
      'step_6_title': 'Hakbang 6: Pagbabalot',
      'step_6_desc':
          'Ibalot ang mga nahiwalay na prutas sa angkop na lalagyan upang protektahan ang mga ito mula sa pinsala at kontaminasyon sa panahon ng transportasyon at paghawak.',
      'step_7_title': 'Hakbang 7: Imbakan',
      'step_7_desc':
          'Panatilihin ang mga inani na prutas sa ilalim ng angkop na temperatura, halumigmig, at bentilasyon upang pahabain ang buhay-istante at mapanatili ang kalidad.',
    },
  };

  // ✅ ADD THIS NEW one in its place:
  String translate(String key) {
    // 1. Try to get the string from the current locale
    String? translatedString = _localizedValues[locale.languageCode]?[key];

    // 2. If it's null (missing), fall back to the English map
    if (translatedString == null) {
      translatedString = _localizedValues['en']?[key];
    }

    // 3. If it's STILL null (missing from 'en'), return the key itself
    //    so the app doesn't crash and you can see which key is missing.
    return translatedString ?? '!!$key!!'; // Returns !!key_name!! if missing
  }

  // Static method to easily retrieve the instance from context
  static AppLocalizations of(BuildContext context) {
    // Note: We use listen: false because we don't need to rebuild the AppLocalizations instance
    // whenever the locale changes. The app rebuilds when the locale is updated in main.dart
    // (or wherever your MaterialApp is wrapped).
    final locale = Provider.of<LanguageProvider>(context, listen: false).locale;
    return AppLocalizations(locale);
  }

  // Helper method to get the current language code
  String get currentLanguageCode => locale.languageCode;
}
