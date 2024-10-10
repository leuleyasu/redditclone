import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/error_text.dart';
import 'package:reddit_clone/core/common/loader.dart';
import 'package:reddit_clone/core/common/route.dart';
import 'package:reddit_clone/core/providers/firebase_providers.dart';
import 'package:reddit_clone/feature/auth/Controller/authController.dart';
import 'package:reddit_clone/feature/community/Screen/createcommunity.dart';
import 'package:reddit_clone/feature/community/controller/community_controller.dart';
import 'package:reddit_clone/feature/model/comunity_model.dart';
import 'package:reddit_clone/logger.dart';
import 'package:routemaster/routemaster.dart';

class CommunityListDrawer extends ConsumerWidget {
  const CommunityListDrawer({super.key});



  @override
  Widget build(BuildContext context, WidgetRef ref, ) {
    
  void navigateToCommunity(BuildContext context, Community community) {
    Routemaster.of(context).push('/r/${community.name}'.trim());
    print(community.name);
    // logger.i(community.name.trim());
    print(community.name);
  }
    final communityProvider = ref.watch(getCommunitieStateProvider);
    final logoutResult=ref.read(getAuthUser);
    
    return Drawer(
      child: SafeArea(
          child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text("Create Community"),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreateCommunity(),
                  ));
            },
          ),
          communityProvider.when(
            data: (communities) {
              return Expanded(
                child: ListView.builder(
                    itemCount: communities.length,
                    itemBuilder: (context, index) {
                      final community = communities[index];
                      return ListTile(
                        onTap: () => navigateToCommunity(context,community),
                        title: Text(community.name),
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(community.avatar),

                        ),
                      );
                    }
                    
                    
                    ),
              );
            },
            error: (error, stackTrace) => ErrorText(
              error: error.toString(),
            ),
            loading: () => const Loader(),
          ),
        
        ],
      )),
    );
  }
}
