import 'package:flutter/material.dart';
import 'dart:math';
import 'package:like_button/like_button.dart';

//Page for recording splits
class SplitsPage extends StatefulWidget {
  const SplitsPage({super.key});

  @override
  State<SplitsPage> createState() => _SplitsPageState();
}

class _SplitsPageState extends State<SplitsPage> {
  List dummySplits = List.generate(20, (index) => {"name":"Split $index","author":"TEMP", "target":"TEMP","exercises":[],"likes":Random().nextInt(1500),});
  @override

  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.primaryColor,
      body: ListView.builder(
        itemCount: dummySplits.length,
        itemBuilder: (BuildContext context,int index){ 
          return GestureDetector(
            onTap: (){
              print('Tapped on item $index');
            },
            child:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height:20),
                Container(
                  padding: EdgeInsets.all(10),
                  width: MediaQuery.sizeOf(context).width * 0.4,
                  decoration: BoxDecoration(
                  color: Colors.white, 
                  borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                        Text("Name: ${dummySplits[index]["name"]}"),
                        Spacer(),
                        Text("Author: ${dummySplits[index]["author"]}"),
                        Spacer(),
                        Text("Target: ${dummySplits[index]["target"]}"),
                        ],
                      ),
                      Row(children: [
                        Text("Likes: ${dummySplits[index]["likes"].toString()}"),
                        LikeButton(
                          onTap: (bool isLiked) async{
                          return !isLiked;
                          },
                        )
                      ])
                    ],
                  )
                            
                ),
          
              ],
            )
          );
      }),

    );
  }
}
