import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/error_text.dart';
import 'package:reddit_clone/core/common/loader.dart';
import 'package:reddit_clone/feature/auth/Controller/authController.dart';
import 'package:reddit_clone/feature/community/controller/community_controller.dart';
import 'package:reddit_clone/feature/model/comunity_model.dart';
import 'package:routemaster/routemaster.dart';

class CommunityScreen extends ConsumerWidget {
  final String name;

  const CommunityScreen({super.key, required this.name});
  @override
  Widget build(BuildContext context, WidgetRef ref) {

    void joinCommunity(Community community, BuildContext context){
      ref.read(communityStateProvider.notifier).joinCommunity(community, context);
    }
    void navigaToModTools() {
      Routemaster.of(context).push("/mod-tools/$name");
    }

    final getCommunityProvider = ref.watch(getCommunityByNameProvider(name));
    final user = ref.watch(userProvider)!;
    return Scaffold(
//     appBar: AppBar(
//     automaticallyImplyLeading: false,
//   title:     Center(child: Text(name, style: const TextStyle(color: Colors.red),))

// ),

        body: getCommunityProvider.when(
      data: (data) => NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                floating: true,
                expandedHeight: 150,
                iconTheme: const IconThemeData(color: Colors.white),
                flexibleSpace: Stack(
                  children: [
                    Positioned.fill(
                        child: Image.network(
                      data.banner,
                      fit: BoxFit.cover,
                    )),
                  ],
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(15),
                sliver: SliverList(
                    delegate: SliverChildListDelegate([
                  Align(
                    alignment: Alignment.topLeft,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(data.avatar),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        data.name,
                        style: const TextStyle(
                            fontSize: 19, fontWeight: FontWeight.bold),
                      ),
                      data.mods.contains(user.uid)
                          ? OutlinedButton(
                              onPressed: () =>navigaToModTools(),
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              )),
                              child: const Text("Mod Tools"))
                          : OutlinedButton(
                              onPressed: () =>joinCommunity(data, context),
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              )),
                              child: data.members.contains(user.uid)
                                  ? const Text("Joined")
                                  : const Text("Join"))
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      "${data.members.length} Members",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ])),
              )
            ];
          },
          body: const Text("Displaying POsts")),
      error: (error, stackTrace) => ErrorText(error: error.toString()),
      loading: () => const Loader(),
    ));
  }
}
