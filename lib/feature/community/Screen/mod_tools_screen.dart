import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

class ModToolsScreen extends StatelessWidget {
 final String name;
 const  ModToolsScreen({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    void navigateToEditModTools() {
      Routemaster.of(context).push("/edit-community/$name");
    }


    return Scaffold(
      // backgroundColor: Pallete.darkModeAppTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Mod Tools"),
      ),
      body: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text("Add Moderator"),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text("Edit Moderator"),
            onTap: navigateToEditModTools,
          ),
        ],
      ),
    );
  }
}
