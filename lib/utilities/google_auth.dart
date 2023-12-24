import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

// google sign in
class GoogleAuth {
  // start for user to sign in process
  signInWithGoogle() async {
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
// obtain auth from request
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;
    // create new credential for user
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    // sign in return to firebase
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
