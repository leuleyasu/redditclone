import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/core/constants/constants.dart';
// import 'package:reddit_clone/core/failure.dart';
import 'package:reddit_clone/core/providers/storage_repository_provider.dart';
// import 'package:reddit_clone/core/type_defs.dart';
import 'package:reddit_clone/core/utils.dart';
import 'package:reddit_clone/feature/auth/Controller/authController.dart';
import 'package:reddit_clone/feature/community/Repository/communityrepository.dart';
import 'package:reddit_clone/feature/model/comunity_model.dart';
import 'package:reddit_clone/logger.dart';
import 'package:routemaster/routemaster.dart';

final getCommunitieStateProvider = StreamProvider((ref) {
  final comunityController = ref.watch(communityStateProvider.notifier);

  return comunityController.getUserCommunity();
});

final getCommunityByNameProvider = StreamProvider.family((ref, String name) {
  final commnityStateProvider = ref.watch(communityStateProvider.notifier);
  return commnityStateProvider.getCommunityByName(name);
});

final communityStateProvider =
    StateNotifierProvider<CommunityController, bool>((ref) {
  return CommunityController(
      communityrepository: ref.watch(communityRepositoryProvider),
      storageRepository: ref.watch(storageRepositoryProvider),
      ref: ref);
});


final  searchCommunityStateProvider = StreamProvider.family((ref, String query)  {
  return ref.watch(communityStateProvider.notifier).searchCommunity(query);
  
});
class CommunityController extends StateNotifier<bool> {
  final CommunityRepository _communityRepository;

  final StorageRepository _storageRepository;
  Ref _ref;
  CommunityController(
      {required CommunityRepository communityrepository,
      required StorageRepository storageRepository,
      required Ref ref})
      : _communityRepository = communityrepository,
        _storageRepository = storageRepository,
        _ref = ref,
        super(false);

  void createCommunity(String name, BuildContext context) async {
    state = true;
    final user = _ref.watch(userProvider)?.uid ?? "";
    final community = Community(
        id: name,
        name: name,
        banner: Constants.bannerDefault,
        avatar: Constants.avatarDefault,
        members: [user],
        mods: [user]);

    final commntyResult = await _communityRepository.createCommunity(community);
    state = false;
    commntyResult.fold((error) {
      showSnackBar(context, error.message);
      Routemaster.of(context).pop();
    }, (response) => showSnackBar(context, "Community Created Scussfult"));
  }

  Stream<List<Community>> getUserCommunity() {
    final uid = _ref.read(userProvider)!.uid;
    return _communityRepository.getUserCommunities(uid);
  }

  Stream<Community> getCommunityByName(String name) {
    logger.i(name);
    return _communityRepository.getCommunityByName(name);
  }

  void editCommunity({
    required File? profileFile,
    required File? bannerFile,
    // required Uint8List? profileWebFile,
    // required Uint8List? bannerWebFile,
    required BuildContext context,
    required Community community,
  }) async {
    state = true;
    if (profileFile != null ) {
      // communities/profile/memes
      final res = await _storageRepository.storeFile(
        path: 'communities/profile',
        id: community.name,
        file: profileFile,
        // webFile: profileWebFile,
      );
      res.fold(
        (l) => showSnackBar(context, l.message),
        (r) => community = community.copyWith(avatar: r),
      );
    }

    if (bannerFile != null ) {
      // communities/banner/memes
      final res = await _storageRepository.storeFile(
        path: 'communities/banner',
        id: community.name,
        file: bannerFile,
        // webFile: bannerWebFile,
      );
      res.fold(
        (l) => showSnackBar(context, l.message),
        (r) => community = community.copyWith(banner: r),
      );
    }

    final res = await _communityRepository.editCommunity(community);
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) => Routemaster.of(context).pop(),
    );
  }
  Stream<List<Community>>searchCommunity(String query){
    
    return _communityRepository.searchCommunity(query);


  }

}
