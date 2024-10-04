import 'package:flutter/material.dart';
import 'package:reddit_clone/feature/community/Screen/createcommunity.dart';
import 'package:routemaster/routemaster.dart';

class CommunityListDrawer extends StatelessWidget {
  const CommunityListDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(child: Column(
        children: [

          ListTile(
            
            leading: const  Icon(Icons.add),
            title: const Text("Create Community"),
            onTap: () {
             Navigator.push(context, MaterialPageRoute(builder: (context) => CreateCommunity(),));
            },
            
            )

        ],
      )),
    );
  }
}