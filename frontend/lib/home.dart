import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:frontend/main.dart';
import 'package:provider/provider.dart';

class home extends StatelessWidget {
  const home({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => MyAppState(),
      child: MaterialApp(
        title: 'homepage',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
          
        ),
        home: HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget{
  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage>{
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context){
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
            backgroundColor: Colors.black87, 
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
              icon: Icon(Icons.line_weight),
              label: "Splits"

              )
            ],
            currentIndex: selectedIndex,
            onTap: newState,
          ),
        );
      }
      );
    
  } 
}
//Page for graphs and capacity tracking
class DataPage extends StatelessWidget {
  const DataPage({super.key});

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: Colors.black54,
      body:Column(
        children: [
          SizedBox(height: 20,),
          Center(
            child: Container(
              padding: EdgeInsets.all(10),
              width: 1000,
              decoration: BoxDecoration(
              color: Colors.white, 
              borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Text("Placeholder Date"),
                  Text("Capacity: "),
                  Text("xxx / 120"),
                  
                ],
              ),
            ),
          ),
          SizedBox(height: 20,)
        ],
      ),
      

    );
  }
}
//Page for recording splits
class SplitsPage extends StatefulWidget {
  const SplitsPage({super.key});

  @override
  State<SplitsPage> createState() => _SplitsPageState();
}

class _SplitsPageState extends State<SplitsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body:Center(
        child: Column(
          children: [
            Text("Page 2"),
            
          ],
        ),
      ),

    );
  }
}
