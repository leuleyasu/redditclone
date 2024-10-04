import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/theme/pallete.dart';

import 'package:routemaster/routemaster.dart';

class ProfileDrawer extends ConsumerWidget {
  const ProfileDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
         const    CircleAvatar(
              backgroundImage: NetworkImage(""),
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
              onTap: () => {}
            ),
            ListTile(
              title: const Text('Log Out'),
              leading: Icon(
                Icons.logout,
                color: Pallete.redColor,
              ),
              onTap: () => {}
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