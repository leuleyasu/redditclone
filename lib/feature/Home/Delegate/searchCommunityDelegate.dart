import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/error_text.dart';
import 'package:reddit_clone/core/common/loader.dart';
import 'package:reddit_clone/feature/community/controller/community_controller.dart';
import 'package:routemaster/routemaster.dart';

class SearchCommunityDelegate extends SearchDelegate {
final  WidgetRef ref;
SearchCommunityDelegate(this.ref);
  @override
  List<Widget>? buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context, ) {
return ref.watch(searchCommunityStateProvider(query)).when(data: (communities)=>
ListView.builder(
  itemCount: communities.length,
  itemBuilder: (context, index) {
    final community=communities[index];
    ListTile(
    leading: CircleAvatar(
      backgroundImage:NetworkImage(community.avatar),
      // child: 
    ),
    title: Text(community.name),
    onTap: () => navigateToCommunity(context, community.name) ,
  );
  
   } )
, 
error: (error, stackTrace) => ErrorText(error: error.toString()),
 loading: ()=> const Loader());
  }


}
    
  void navigateToCommunity(BuildContext context, String communityName) {
    Routemaster.of(context).push('/r/$communityName'.trim());
 
  }