// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:reddit_clone/core/common/error_text.dart';
import 'package:reddit_clone/core/common/loader.dart';
import 'package:reddit_clone/core/constants/constants.dart';
import 'package:reddit_clone/core/utils.dart';
import 'package:reddit_clone/feature/community/controller/community_controller.dart';
import 'package:reddit_clone/feature/model/comunity_model.dart';
import 'package:reddit_clone/theme/pallete.dart';

class EditCommunityScreen extends ConsumerStatefulWidget {
 final String name;
 const  EditCommunityScreen({
    required this.name,
  });
 
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditCommunityScreenState();
}

class _EditCommunityScreenState extends ConsumerState<EditCommunityScreen> {
  File? bannerFile;
  File? profileFile;

  void selectBannerImage() async {
    final res = await pickImage();
    if (res != null) {
      setState(() {
        bannerFile = File(res.files.first.path!);
      });
    }
  }

  void selectProfileImage() async {
    final res = await pickImage();
    if (res != null) {
      setState(() {
        profileFile = File(res.files.first.path!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoding = ref.watch(communityStateProvider);
    void save(Community community) {
      ref.watch(communityStateProvider.notifier).editCommunity(
          profileFile: profileFile,
          bannerFile: bannerFile,
          context: context,
          community: community);
    }

    final getcommunityProvider =
        ref.watch(getCommunityByNameProvider(widget.name));
    return getcommunityProvider.when(
      data: (community) => Scaffold(
        backgroundColor: Pallete.darkModeAppTheme.scaffoldBackgroundColor,
        appBar: AppBar(
          title: const Text("Edit Community"),
          centerTitle: false,
          actions: [
            TextButton(
                onPressed: () => save(community), child: const Text("save"))
          ],
        ),
        body:  isLoding ?
       const   Center(
child: Loader(),
        ):
        Column(
          children: [
            SizedBox(
              height: 200,
              child: Stack(children: [
                GestureDetector(
                  onTap: () => selectBannerImage(),
                  child: DottedBorder(
                      radius: const Radius.circular(10),
                      color:
                          Pallete.darkModeAppTheme.textTheme.bodyMedium!.color!,
                      strokeCap: StrokeCap.round,
                      dashPattern: const [10, 4],
                      child: Container(
                        width: double.infinity,
                        height: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: bannerFile != null
                            ? Image.file(bannerFile!)
                            : community.banner.isEmpty ||
                                    community.banner == Constants.bannerDefault
                                ? const Center(
                                    child: Icon(
                                    Icons.camera_outlined,
                                    color: Colors.white,
                                  ))
                                : Image.network(community.banner),
                      )),
                ),
                Positioned(
                    left: 12,
                    top: 120,
                    child: GestureDetector(
                        onTap: selectProfileImage,
                        child: profileFile != null
                            ? CircleAvatar(
                                backgroundImage: FileImage(profileFile!))
                            : CircleAvatar(
                                backgroundImage:
                                    NetworkImage(community.avatar))))
              ]),
            )
          ],
        ),
      ),
      error: (error, stackTrace) => ErrorText(error: error.toString()),
      loading: () => const Loader(),
    );
  }
}
