import 'package:flutter/material.dart';
import 'package:reddit_clone/feature/Home/Screen/HomeScree.dart';
import 'package:reddit_clone/feature/auth/screen/Login_page.dart';
import 'package:reddit_clone/feature/community/Screen/add_moderator.dart';
import 'package:reddit_clone/feature/community/Screen/communityScreen.dart';
import 'package:reddit_clone/feature/community/Screen/createcommunity.dart';
import 'package:reddit_clone/feature/community/Screen/editcommunity_ecreen.dart';
import 'package:reddit_clone/feature/community/Screen/mod_tools_screen.dart';
import 'package:reddit_clone/feature/community/Screen/user_profile/screen/user_profile_screen.dart';
import 'package:routemaster/routemaster.dart';

final loggedOutRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: LoginScreen()),
});
final loggedInRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: HomeScreen()),
  '/create-community': (_) => const MaterialPage(child: CreateCommunity()),
  '/r/:name': (route) => MaterialPage(
        child: CommunityScreen(
          name: route.pathParameters['name']!,
        ),
      ),
  "/mod-tools/:name": (routeData) => MaterialPage( 
          child: ModToolsScreen(
        name: routeData.pathParameters['name']!,
      )),
  "/edit-community/:name": (routeData) => MaterialPage(
          child: EditCommunityScreen(
        name: routeData.pathParameters['name']!,
      )),
  "/add-mods/:name": (routeData) => MaterialPage(
          child: AddModsScreen(
        name: routeData.pathParameters['name']!,
      )),

          '/u/:uid': (routeData) => MaterialPage(
          child: UserProfileScreen(
            uid: routeData.pathParameters['uid']!,
          ),
        ),
        
});
