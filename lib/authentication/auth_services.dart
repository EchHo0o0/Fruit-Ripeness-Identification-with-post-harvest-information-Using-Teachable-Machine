import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth;

  AuthService(this._auth);

  /// Provides a stream of authentication state changes.
  Stream<User?> get authStateChanges => _auth.idTokenChanges();

  User? currentUser() {
    return _auth.currentUser;
  }

  // Login method
  Future<String> login(String email, String password) async {
    if (email.trim().isEmpty || password.trim().isEmpty) {
      return "Email and password cannot be empty.";
    }

    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return "Logged In";
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        message = "Invalid email or password.";
      } else if (e.code == 'invalid-email') {
        message = "The email address is not valid.";
      } else if (e.code == 'user-disabled') {
        message = "This user account has been disabled.";
      } else {
        message = "Login failed: ${e.message ?? "An unknown error occurred."}";
      }
      return message;
    } catch (e) {
      print('Unexpected error during login: $e');
      return "An unexpected error occurred.";
    }
  }

  // 🔥 CORRECTED SIGNUP METHOD: Now only accepts 6 core arguments.
  Future<String> signUp(
    String firstName,
    String middleName,
    String lastName,
    String email,
    String password,
    String role, // The role is the 6th argument, as called in AdminsScreen
  ) async {
    try {
      // 1. Create User (This auto-signs in the new user)
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 2. Get the new user object
      User? newUser = _auth.currentUser;

      if (newUser != null) {
        // 3. Save User Data to Firestore
        String safeMiddleName = middleName.trim().isEmpty ? '' : middleName;
        String safeRole = role.trim().isEmpty ? 'user' : role;

        await FirebaseFirestore.instance
            .collection('users')
            .doc(newUser.uid)
            .set({
          'uid': newUser.uid,
          'firstName': firstName,
          'middleName': safeMiddleName,
          'lastName': lastName,
          'email': email,
          'role': safeRole,
          'age': null, // Default value for user creation
          'address': '', // Default value for user creation
        });
      }

      // 4. CRITICAL STEP: Immediately sign out the NEW user.
      // This preserves the current admin's active session.
      await _auth.signOut();

      // 5. Success
      return "Signed Up";
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'An account already exists for that email.';
      } else {
        message = e.message ?? "An error occurred during sign up.";
      }
      return message;
    } catch (e) {
      print('Unexpected error during signup: $e');
      return "An unexpected error occurred.";
    }
  }

  Future<bool> verifyCurrentAdminPassword(String password) async {
    final user = _auth.currentUser;

    if (user == null) {
      return false;
    }

    try {
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );

      await user.reauthenticateWithCredential(credential);

      return true;
    } on FirebaseAuthException catch (e) {
      print('Password verification failed: ${e.code}');
      return false;
    } catch (e) {
      print('Verification error: $e');
      return false;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
