import 'package:flutter/material.dart';

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
              
            },
            
            )

        ],
      )),
    );
  }
}