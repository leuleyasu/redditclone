import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/loader.dart';
import 'package:reddit_clone/feature/community/controller/community_controller.dart';


class CreateCommunity extends ConsumerStatefulWidget {
  const CreateCommunity({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreateCommunityState();
}
class _CreateCommunityState extends ConsumerState<CreateCommunity> {
final communityNameController= TextEditingController();

void createCommunity() {
  ref.read(communityStateProvider.notifier).createCommunity(communityNameController.text, context);
}
@override
  void dispose() {
    communityNameController.dispose();
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final isLoading= ref.watch(communityStateProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Community Name"),
      ),
      body: isLoading? const Loader(): Padding(padding: const EdgeInsets.all(10)
      
    ,  child: Column(
        children: [
const Align(
  alignment: Alignment.topLeft,
  child: Text("Community name"),
),
TextField(
  controller: communityNameController,
  decoration: const InputDecoration(
    
    hintText: "",
    filled: true,
    border: InputBorder.none,
    contentPadding: EdgeInsets.all(10)
  ),

),
  const SizedBox(height: 30,)

        ,
        ElevatedButton(onPressed: createCommunity,
         child:   const Text("Create Community"),
         
         
         
         )
        
        ],
      ),
      
      ),
      
    );
  }
}