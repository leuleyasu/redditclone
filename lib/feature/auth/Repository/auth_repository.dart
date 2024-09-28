import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:reddit_clone/core/constants/constants.dart';
import 'package:reddit_clone/core/providers/firebase_providers.dart';
import 'package:reddit_clone/feature/model/usermodel.dart';
import 'package:reddit_clone/logger.dart';

final authRepositoryProvider = Provider((ref) => AuthRepository(
    firebaseFirestore: ref.read(firebaseclodFireStore),
    firebaseAuth: ref.read(firebaseAuth),
    googleSignIn: ref.read(googleSignIn)));

class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final FirebaseFirestore _firebaseFirestore;

  AuthRepository(
      {required FirebaseFirestore firebaseFirestore,
      required FirebaseAuth firebaseAuth,
      required GoogleSignIn googleSignIn})
      : _firebaseAuth = firebaseAuth,
        _googleSignIn = googleSignIn,
        _firebaseFirestore = firebaseFirestore;

  Future<void> signInWithGoogle() async {
    try {
      GoogleSignInAccount? account = await _googleSignIn.signIn();

      CollectionReference users() {
        return _firebaseFirestore.collection("users");
      }

      if (account != null) {
        final googleUser = await account.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleUser.accessToken,
          idToken: googleUser.idToken,
        );

        UserCredential userCredential =
            await _firebaseAuth.signInWithCredential(credential);

        UserModel userModel = UserModel(
            name: userCredential.user!.displayName ?? "No Name",
            profilePic: userCredential.user!.photoURL ?? "",
            banner: userCredential.user!.photoURL ?? Constants.bannerDefault,
            uid: userCredential.user!.uid,
            isAuthenticated: true,
            karma: 0,
            awards: []);

        users().doc(userCredential.user!.uid).set(userModel.toMap());
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
