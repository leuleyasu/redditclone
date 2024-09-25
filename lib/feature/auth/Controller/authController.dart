

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/feature/auth/Repository/auth_repository.dart';

final authControllerProvider= Provider((ref)=>AuthController(authRepository: ref.read(authRepositoryProvider)));
class AuthController {
  AuthRepository _authRepository;
  AuthController({required AuthRepository authRepository }):_authRepository=authRepository;
  void signInWithGoogleSignIn() async{

    _authRepository.signInWithGoogle();
    
  }
  
}