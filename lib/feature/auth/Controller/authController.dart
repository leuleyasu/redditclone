import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/feature/auth/Repository/auth_repository.dart';
import 'package:reddit_clone/core/utils.dart';
import 'package:reddit_clone/feature/model/usermodel.dart';

final userProvider= StateProvider<UserModel?>((ref) => null);

final authControllerProvider = StateNotifierProvider<AuthController, bool>(
  (ref) => AuthController(
    authRepository: ref.watch(authRepositoryProvider),
    ref: ref,
  ),
);
final  authStateChangeProvider=StreamProvider((ref)=>ref.watch(authRepositoryProvider).authStateChange);

final getUserDataProvider = StreamProvider.family((ref, String uid) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getUserData(uid);
});


final getAuthUser=FutureProvider((ref){
  
  final userSignoutState =ref.read(authControllerProvider.notifier);
return userSignoutState.logoutUser();
});
// final userStateChangeProvider=
class AuthController extends StateNotifier<bool> {
  final Ref _ref;
  final AuthRepository _authRepository;
  AuthController({required Ref ref, required AuthRepository authRepository})
      : _authRepository = authRepository,
        _ref = ref,
        super(false);

  void signInWithGoogleSignIn(BuildContext context) async {
    state=true;

    final userData = await _authRepository.signInWithGoogle();
state=false;
    userData.fold((onLeft) => showSnackBar(context, onLeft.message),
        (userData) => _ref.read(userProvider.notifier).update((state)=>userData));
  }

  Stream<UserModel> getUserData(String uuid)  {
    return _authRepository.getUserData(uuid);
  }

  Future<void> logoutUser() async{
    await _authRepository.logoutUser();
  }
  
}



