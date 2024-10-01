import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/feature/auth/Controller/authController.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user= ref.watch(userProvider)!;
    return Scaffold(
      body: Center(
        child: Text(user.name),
      ),
    );
  }
}