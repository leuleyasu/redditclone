import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/loader.dart';
import 'package:reddit_clone/core/common/route.dart';
import 'package:reddit_clone/feature/auth/Controller/authController.dart';
import 'package:reddit_clone/feature/model/usermodel.dart';
import 'package:reddit_clone/logger.dart';
import 'package:routemaster/routemaster.dart';

import 'core/common/error_text.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Check if Firebase has already been initialized
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp();
  }

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  UserModel? userModel;

  void getUserData(User userData) async {
    userModel = await ref
        .watch(authControllerProvider.notifier)
        .getUserData(userData.uid)
        .first;

    ref.watch(userProvider.notifier).update((state) => userModel);
    setState(() {});
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return ref.watch(authStateChangeProvider).when(
          data: (data) {
            return MaterialApp.router(
              routerDelegate: RoutemasterDelegate(routesBuilder: (_) {
                logger.i(data);
                if (data != null) {
                  if (userModel != null) {
                    return loggedInRoute;
                  }

                  getUserData(data);
                  return loggedInRoute;
                } else {
                  return loggedOutRoute;
                }
              }),
              routeInformationParser: const RoutemasterParser(),
            );
          },
          error: (error, stackTrace) => ErrorText(
            error: error.toString(),
          ),
          loading: () => const Loader(),
        );
  }
}
