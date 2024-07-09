import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  ///instance of firebase
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// SingIn Future
  Future<UserCredential> signInWithEmailPassword(email, password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  /// SingUp Future
  Future<UserCredential> signUpWithEmailPassword(email, password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  ///SignOut Future
  Future<void> signOut() async {
    return await _auth.signOut();
  }
}
