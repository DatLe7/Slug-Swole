import 'package:flutter/material.dart';
//import 'package:slug_swole/backend_services.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'data_tracking.dart';
import 'chatbot.dart'; // Import the ChatScreen


class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  var selectedIndex = 0;
  //calls from backend_services.dart to check if user is an admin

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          appBar: AppBar(
            leading: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Image.asset("assets/slugswoleLogoNoBackground.png"),
            ),
            toolbarHeight: MediaQuery.sizeOf(context).height * 0.075,
            backgroundColor: Theme.of(context).colorScheme.primary,
            title: FittedBox(
              child: RichText(
                text: TextSpan(
                  text: "SLUG",
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold, color: Colors.white),
                  children: [
                    TextSpan(
                      
                        text: "SWOLE", style: TextStyle(color: Colors.blue)),
                  ],
                ),
              ),
            ),
            actions: [
              IconButton(onPressed: () {setState(() {});}, icon: Icon(Icons.refresh, color: Colors.white,)),
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProfileScreen(
                                  appBar: AppBar(
                                    title: const Text('User Profile'),
                                  ),
                                  actions: [
                                    SignedOutAction((context) {
                                      Navigator.of(context).pop();
                                    })
                                  ],
                                )));
                  },
                  icon: Icon(
                    Icons.settings,
                    color: Colors.white,
                  ))
            ],
            centerTitle: true,
          ),
          body: DataPage(),
          /*
          floatingActionButton: FloatingActionButton(//button to direct to the chatbot screen. can adjust loco and icon.
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ChatScreen()),
              );
            },
            backgroundColor: Colors.blue, // Set the button color to red
            child: const Icon(Icons.chat, color: Colors.white), // Add a chat icon
          ), //floatingaction button end here
          */
        );
      },
    );
  }
}
