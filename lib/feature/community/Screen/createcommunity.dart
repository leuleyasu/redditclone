import 'package:flutter/material.dart';

class CreateCommunity extends StatefulWidget {
  const CreateCommunity({super.key});

  @override
  State<CreateCommunity> createState() => _CreateCommunityState();
}

class _CreateCommunityState extends State<CreateCommunity> {

  final communityNameController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Community Name"),
      ),
      body: Padding(padding: const EdgeInsets.all(10)
      
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
        ElevatedButton(onPressed: (){},
         child:   const Text("Create Community"),
         
         
         
         )
        
        ],
      ),
      
      ),
      
    );
  }
}