import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/core/constants/constants.dart';
import 'package:reddit_clone/core/failure.dart';
import 'package:reddit_clone/core/providers/storage_repository_provider.dart';
import 'package:reddit_clone/core/type_defs.dart';
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

class CommunityController extends StateNotifier<bool> {
  CommunityRepository _communityRepository;

  StorageRepository _storageRepository;
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

  void editCommunity(
      {required File? profileFile,
      required File? bannerFile,
      required BuildContext context,
      required Community community}) async {
    try {
      if (bannerFile != null) {
        final res = await _storageRepository.storeFile(
          path: "communities/banner",
          id: community.name,
          file: bannerFile, 
        );

        res.fold((error) => showSnackBar(context, error.toString()),
            (data) => community.copyWith(banner: data));
      }
      if (profileFile != null) {
        final res = await _storageRepository.storeFile(
          path: "communities/profile",
          id: community.name,
          file: profileFile,
        );

        res.fold((error) => showSnackBar(context, error.toString()),
            (data) => community.copyWith(avatar: data));
      }
      final res = await _communityRepository.editCommunity(community);
      res.fold((onLeft) => showSnackBar(context, onLeft.message),
          (data) => showSnackBar(context, "Succesfully Updated"));


  
    } catch (e) {
      print(e.toString());
      // return left(Failure("message")); 


    }
  }
}
