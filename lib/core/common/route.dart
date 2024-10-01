import 'package:flutter/material.dart';
import 'package:reddit_clone/feature/Home/Screen/HomeScree.dart';
import 'package:reddit_clone/feature/auth/screen/Login_page.dart';
import 'package:routemaster/routemaster.dart';

final loggedOutRoute=RouteMap(routes: {
  '/': (_) => const  MaterialPage(child: LoginScreen()),
});
final loggedInRoute=RouteMap(routes: {
  '/': (_) => const  MaterialPage(child: HomeScreen()),
});