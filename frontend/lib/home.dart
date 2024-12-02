import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:frontend/main.dart';
import 'package:frontend/data_tracking.dart';
import 'package:frontend/splits.dart';
import 'package:frontend/counter.dart';

class HomePage extends StatefulWidget{
  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage>{
  var selectedIndex = 0; 

  @override
  Widget build(BuildContext context){
      final theme = Theme.of(context);
      void newState(int index){
        setState((){
          selectedIndex = index;
        });
      }
      Widget page;
      switch (selectedIndex){
        case 0:
          page = DataPage();
        case 1:
          page = SplitsPage();
        case 2:
          page = Counter();
        default:
          throw UnimplementedError('no widget for $selectedIndex');
          
      }
      return LayoutBuilder(builder: (context,constraints){
        return Scaffold(
          
          appBar: AppBar(
            
            leading: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Image.asset("assets/fitSlug.png"),
            ),
            toolbarHeight: 75,
            backgroundColor: theme.primaryColorDark,
            title: RichText(text: TextSpan(
              text:"SLUG", style: TextStyle(fontWeight:FontWeight.bold,fontSize: 50,color: Colors.yellow),
              children:[
                 TextSpan(text: "SWOLE", style: TextStyle(color: Colors.blue)),

              ]

            )),
            centerTitle: true,
            
          ),
          
          body:page,
          
          bottomNavigationBar: BottomNavigationBar(
            items: const[
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_outlined),
              label: 'Home',
              ),
            BottomNavigationBarItem(
              icon: Icon(Icons.fitness_center),
              label: "Splits",
              ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shield_outlined),
              label: "counter",
              ),
            ],
            currentIndex: selectedIndex,
            onTap: newState,
          ),
        );
      }
      );
    
  } 
}

