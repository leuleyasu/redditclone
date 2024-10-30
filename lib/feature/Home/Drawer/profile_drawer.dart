import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/feature/auth/Repository/auth_repository.dart';
import 'package:reddit_clone/theme/pallete.dart';

import 'package:routemaster/routemaster.dart';

class ProfileDrawer extends ConsumerWidget {
  String uid;
   ProfileDrawer({super.key ,required this.uid});

  void logout(WidgetRef ref) async{
    await ref.read(authRepositoryProvider).logoutUser();
  }
 void navigateUserProfile(BuildContext context) {
    Routemaster.of(context).push('/u/$uid');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
         const    CircleAvatar(
              // backgroundImage: cir
              radius: 70,
            ),
            const SizedBox(height: 10),
        const     Text(
              '"u name"',
              style:  TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            const Divider(),
            ListTile(
              title: const Text('My Profile'),
              leading: const Icon(Icons.person),
              onTap: () => navigateUserProfile(context)
            ),
            ListTile(
              title: const Text('Log Out'),
              leading: Icon(
                Icons.logout,
                color: Pallete.redColor,
              ),
              onTap: () => logout(ref)
            ),
            Switch.adaptive(
              value: false,
              onChanged: (val) => {}
            ),
          ],
        ),
      ),
    );
  }
}