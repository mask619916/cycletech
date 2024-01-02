import 'package:firebase_auth/firebase_auth.dart';

// Class for handling authentication-related operations
class Auth {
  // Instance of FirebaseAuth for authentication operations
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Getter to retrieve the current authenticated user
  User? get currentUser => _firebaseAuth.currentUser;

  // Stream that emits changes in the authentication state
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // Function to sign in with email and password
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    // Using FirebaseAuth to sign in with email and password
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Function to create a new user with email and password
  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    // Using FirebaseAuth to create a new user with email and password
    await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Function to sign out the current user
  Future<void> signOut() async {
    // Using FirebaseAuth to sign out the current user
    await _firebaseAuth.signOut();
  }
}
