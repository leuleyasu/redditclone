import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/core/constants/firebase_constants.dart';
import 'package:reddit_clone/core/failure.dart';
import 'package:reddit_clone/core/providers/firebase_providers.dart';
import 'package:reddit_clone/core/type_defs.dart';
import 'package:reddit_clone/feature/model/comunity_model.dart';

final communityRepositoryProvider = Provider<CommunityRepository>((ref) {
  return CommunityRepository(firebasefirestore: ref.watch(firebaseclodFireStore)) ;
});

class CommunityRepository {
  final FirebaseFirestore _firebaseFirestore;
  CommunityRepository({required FirebaseFirestore firebasefirestore}):
  _firebaseFirestore=firebasefirestore;


  FutureVoid createCommunity(Community community) async {
    try {
      final communities= await  _communities.doc(community.name).get();
if (communities.exists) {
  throw "Communities name already Exists";
  
}

else{
 return right(_communities.doc(community.name).set(community.toMap()));
} 
    } on FirebaseException catch(e){
      return left(Failure(e.toString()));
    } catch (e) {
     return left(Failure(e.toString()));
    }
  }
 
Stream<List<Community>> getUserCommunities(String uid) {
  return _communities
      .where('members', arrayContains: uid)
      .snapshots()
      .map((snapshot) {
        // Safely handle empty or null snapshots
        if (snapshot.docs.isEmpty) return [];

        // Map each document to a Community object
        return snapshot.docs.map((doc) {
          return Community.fromMap(doc.data() as Map<String, dynamic>);
        }).toList();
      });
}

Stream<Community>getComunityByName(String name){

  return _communities.doc(name).snapshots().map((event)=>
  Community.fromMap(event.data() as Map<String,dynamic>));
}

 CollectionReference get _communities=> FirebaseFirestore.instance.collection(FirebaseConstants.communitiesCollection);
  
}