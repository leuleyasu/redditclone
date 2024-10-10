import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/constants/constants.dart';
import 'package:reddit_clone/core/type_defs.dart';
import 'package:reddit_clone/core/utils.dart';
import 'package:reddit_clone/feature/auth/Controller/authController.dart';
import 'package:reddit_clone/feature/community/Repository/communityrepository.dart';
import 'package:reddit_clone/feature/model/comunity_model.dart';
import 'package:reddit_clone/logger.dart';
import 'package:routemaster/routemaster.dart';


final getCommunitieStateProvider= StreamProvider((ref)  {

  final comunityController=ref.watch(communityStateProvider.notifier);

  return comunityController.getUserCommunity();
});

final getCommunityByNameProvider=StreamProvider.family((ref,String name){
  final commnityStateProvider=ref.watch(communityStateProvider.notifier);
  return commnityStateProvider.getCommunityByName(name);
});

final communityStateProvider = StateNotifierProvider<CommunityController,bool>((ref) {
  return CommunityController(communityrepository: ref.watch(communityRepositoryProvider), ref: ref);
});

class CommunityController extends StateNotifier<bool> {
CommunityRepository _communityRepository;
Ref _ref;
CommunityController({required CommunityRepository communityrepository, required Ref ref }):
_communityRepository=communityrepository, _ref=ref, super(false);


  void createCommunity(String name, BuildContext context ) async {
state=true;
final user = _ref.watch(userProvider)?.uid??"";
 final community= Community(id: name, name: name, banner: Constants.bannerDefault,
  avatar: Constants.avatarDefault, members: [user], mods: [user]);


  final commntyResult= await _communityRepository.createCommunity(community);
state=false;
commntyResult.fold((error){
  showSnackBar(context, error.message);
Routemaster.of(context).pop();
  
  }, (response)=> showSnackBar(context, "Community Created Scussfult") );
  }
  


Stream<List<Community>> getUserCommunity()  {

  final uid=_ref.read(userProvider)!.uid;
return _communityRepository.getUserCommunities(uid);


}


Stream<Community>getCommunityByName(String name){
  logger.i(name);
return _communityRepository.getCommunityByName(name);
}

}