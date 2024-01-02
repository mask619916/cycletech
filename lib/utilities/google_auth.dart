import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

// Class for handling Google Sign-In
class GoogleAuth {
  // Function to initiate the Google Sign-In process
  signInWithGoogle() async {
    // Start the Google Sign-In process and get the user account
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    // Check if the user canceled the Google Sign-In process
    if (gUser == null) {
      // Return or handle accordingly, e.g., show a message to the user
      return null;
    }

    // Obtain authentication details from the Google Sign-In request
    final GoogleSignInAuthentication gAuth = await gUser.authentication;

    // Create new credentials for the user using Google Sign-In details
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    // Sign in with the created credentials and return the result
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
