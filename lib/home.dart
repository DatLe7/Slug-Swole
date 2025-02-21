import 'package:flutter/material.dart';
import 'package:slug_swole/backend_services.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'data_tracking.dart';
import 'splits.dart';
import 'counter.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  var selectedIndex = 0;
  //calls from backend_services.dart to check if user is an admin
  Future data = adminAuth();

  @override
  Widget build(BuildContext context) {
    void newState(int index) {
      setState(() {
        selectedIndex = index;
      });
    }

    Widget page;
    switch (selectedIndex) {
      case 0:
        page = DataPage();
        break;
      /*
      case 1:
        page = SplitsPage();
        break;
      */
      case 1:
        page = Counter();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return FutureBuilder(
      future: data,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        //If user is an admin, return the admin home page
        if (snapshot.data) {
          return LayoutBuilder(
            builder: (context, constraints) {
              return Scaffold(
                appBar: AppBar(
                  leading: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Image.asset("assets/fitSlug.png"),
                  ),
                  toolbarHeight: MediaQuery.sizeOf(context).height * 0.075,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  title: FittedBox(
                    child: RichText(
                      text: TextSpan(
                        text: "SLUG",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.yellow),
                        children: [
                          TextSpan(
                              text: "SWOLE",
                              style: TextStyle(color: Colors.blue)),
                        ],
                      ),
                    ),
                  ),
                  actions: [
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
                body: page,
                bottomNavigationBar: BottomNavigationBar(
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.bar_chart_outlined),
                      label: 'Home',
                    ),
                    /*BottomNavigationBarItem(
                      icon: Icon(Icons.fitness_center),
                      label: "Splits",
                    ),*/
                    BottomNavigationBarItem(
                      icon: Icon(Icons.shield_outlined),
                      label: "counter",
                    ),
                  ],
                  currentIndex: selectedIndex,
                  onTap: newState,
                ),
              );
            },
          );
        }
        //otherwise, return the public facing home page
        else {
          return LayoutBuilder(builder: (context, constraints) {
            return Scaffold(
              appBar: AppBar(
                leading: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image.asset("assets/fitSlug.png"),
                ),
                toolbarHeight: MediaQuery.sizeOf(context).height * 0.075,
                backgroundColor: Theme.of(context).colorScheme.primary,
                title: RichText(
                    text: TextSpan(
                        text: "SLUG",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.yellow),
                        children: [
                      TextSpan(
                          text: "SWOLE", style: TextStyle(color: Colors.blue)),
                    ])),
                centerTitle: true,
              ),
              body: page,
              bottomNavigationBar: BottomNavigationBar(
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.bar_chart_outlined),
                    label: 'Home',
                  ),
                  /*BottomNavigationBarItem(
                    icon: Icon(Icons.fitness_center),
                    label: "Splits",
                  ),*/
                ],
                currentIndex: selectedIndex,
                onTap: newState,
              ),
            );
          });
        }
      },
    );
  }
}
