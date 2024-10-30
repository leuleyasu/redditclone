import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:reddit_clone/core/constants/constants.dart';
import 'package:reddit_clone/core/failure.dart';
import 'package:reddit_clone/core/providers/firebase_providers.dart';
import 'package:reddit_clone/core/type_defs.dart';
import 'package:reddit_clone/feature/model/usermodel.dart';
import 'package:reddit_clone/logger.dart';
import 'package:fpdart/fpdart.dart';

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
  CollectionReference _users() {
    return _firebaseFirestore.collection("users");
  }

   Stream<User?> get authStateChange=> _firebaseAuth.authStateChanges();

  FutureEither<UserModel> signInWithGoogle() async {
    try {
      GoogleSignInAccount? account = await _googleSignIn.signIn();

      if (account != null) {
        final googleUser = await account.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleUser.accessToken,
          idToken: googleUser.idToken,
        );

        UserCredential userCredential =
            await _firebaseAuth.signInWithCredential(credential);

        late UserModel userModel;
        if (userCredential.additionalUserInfo!.isNewUser) {
          userModel = UserModel(
              name: userCredential.user!.displayName ?? "No Name",
              profilePic: userCredential.user!.photoURL ?? "",
              banner: userCredential.user!.photoURL ?? Constants.bannerDefault,
              uid: userCredential.user!.uid,
              isAuthenticated: true,
              karma: 0,
              awards: []);
          _users().doc(userCredential.user!.uid).set(userModel.toMap());
        } else {
          await getUserData(userCredential.user!.uid);
        }
        logger.i(userCredential.user!.email);
        return right(userModel);
      } else {
        logger.e('Google sign-in was aborted.');
        return left(Failure("Google sign-in was aborted."));
      }
    } catch (e) {
      // logger.e('Google sign-in was aborted.');
      return left(Failure(e.toString()));
    }
  }

  Stream<UserModel> getUserData(String uuid)  {
    return _users().doc(uuid).snapshots().map(
        (event) => UserModel.fromMap(event.data() as Map<String, dynamic>));
  }


Future<void> logoutUser() async {
  try {
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
    print("User successfully logged out");
  } catch (e) {
    print("Error logging out: $e");
  }
}
}
