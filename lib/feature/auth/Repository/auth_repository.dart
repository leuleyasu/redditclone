import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:reddit_clone/core/providers/firebase_providers.dart';
import 'package:reddit_clone/logger.dart';

final authRepositoryProvider = Provider((ref) => AuthRepository(
    firebaseAuth: ref.read(firebaseAuth),
    googleSignIn: ref.read(googleSignIn)));

class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  AuthRepository({required FirebaseAuth firebaseAuth, required GoogleSignIn googleSignIn})
      : _firebaseAuth = firebaseAuth,
        _googleSignIn = googleSignIn;

  Future<void> signInWithGoogle() async {
    try {
      GoogleSignInAccount? account = await _googleSignIn.signIn();

      if (account != null) {
        final googleUser = await account.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleUser.accessToken,
          idToken: googleUser.idToken,
        );

        UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);

        logger.i(userCredential.user!.email);
      } else {
        logger.e('Google sign-in was aborted.');
      }
    } catch (e) {
      logger.e(e.toString());
      print(e);
    }
  }
}
