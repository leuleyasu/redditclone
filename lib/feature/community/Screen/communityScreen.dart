import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/error_text.dart';
import 'package:reddit_clone/core/common/loader.dart';
import 'package:reddit_clone/feature/community/controller/community_controller.dart';

class CommunityScreen extends ConsumerWidget {
  String name;

   CommunityScreen({super.key, required this.name});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final getCommunityProvider=ref.watch(getCommunityByNameProvider(name));
    return Scaffold(
      body: getCommunityProvider.when(data: (data)=>
      NestedScrollView(headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverAppBar(
            expandedHeight: 150,
flexibleSpace: Stack(
  children: [
    Positioned.fill(child: 
    Image.network(data.banner))
  ],
),
          )
        ];
      },
      
       body: const Text("Displaying POsts")),
      
       error: (error, stackTrace) => ErrorText(error: error.toString()),
        loading: () => const Loader(),
    ));
  }
}