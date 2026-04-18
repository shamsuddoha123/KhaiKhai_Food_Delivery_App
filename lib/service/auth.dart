import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> getCurrentUser() async {
    return _auth.currentUser;
  }

  Future<void> signOut() async {
    await GoogleSignIn.instance.signOut();
    await _auth.signOut();
  }

  Future<void> deleteUser() async {
    User? user = _auth.currentUser;
    await user?.delete();
  }

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<User?> signInWithGoogle() async {
    // 1. Initialize GoogleSignIn instance (singleton)
    await GoogleSignIn.instance.initialize();

    // 2. Perform authentication
    final googleUser = await GoogleSignIn.instance.authenticate();

    // 3. Obtain authentication details (Property, no await)
    final googleAuth = googleUser.authentication;

    // 4. Create credential for Firebase
    final AuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );

    UserCredential result = await _auth.signInWithCredential(credential);
    User? userDetails = result.user;

    return userDetails;
  }
}
