import 'package:flutter/material.dart';
import 'package:slug_swole/backend_services.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'data_tracking.dart';


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
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

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
                      fontSize: 25,
                      fontWeight: FontWeight.bold, color: Colors.yellow),
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
          body: page,
          bottomNavigationBar: FutureBuilder(
              future: data,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SizedBox.shrink();
                }
                if (snapshot.hasError) {
                  return SizedBox.shrink();
                }
                if (!snapshot.hasData || snapshot.data == null) {
                  return SizedBox.shrink();
                }
                if(snapshot.data){
                return BottomNavigationBar(
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
                );
                }
               else {return SizedBox.shrink();} 
              }),
        );
      },
    );
  }
}
