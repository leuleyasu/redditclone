import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/core/common/error_text.dart';
import 'package:reddit_clone/core/constants/firebase_constants.dart';
import 'package:reddit_clone/core/failure.dart';
import 'package:reddit_clone/core/providers/firebase_providers.dart';
import 'package:reddit_clone/core/type_defs.dart';
import 'package:reddit_clone/feature/model/comunity_model.dart';
import 'package:reddit_clone/logger.dart';

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
  Stream<Community> getCommunityByName(String name) {
    return _communities.doc(name).snapshots().map((event) {
      print("Community data:${event.data()}");
      logger.i(event.data());
      return Community.fromMap(event.data() as Map<String, dynamic>);});
  }


  FutureVoid editCommunity(Community community) async {
    try {
      return right(_communities.doc(community.name).update(community.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

Stream<List<Community>>searchCommunity( String query ){
  return _communities.where('name', isGreaterThan: query.isEmpty?null:query, 
  isLessThan: query.isEmpty?null : query.substring(0, query.length - 1) +
                  String.fromCharCode(
                    query.codeUnitAt(query.length - 1) + 1,
  
  )).snapshots(

  ).map((event){
    List<Community> communities = [];
    for (var community in event.docs) {
      communities.add(Community.fromMap(community.data() as Map<String ,dynamic>));

    }
    return communities;
  });
}

 CollectionReference get _communities=> FirebaseFirestore.instance.collection(FirebaseConstants.communitiesCollection);
  
}