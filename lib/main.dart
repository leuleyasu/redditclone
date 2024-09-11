import 'package:flutter/material.dart';
import 'package:reddit_clone/feature/auth/screen/Login_page.dart';

void main() {
  runApp(const MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      
      home: const  LoginScreen());
  }
}

