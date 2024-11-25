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
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent)
        ),
        home: HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget{
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage>{
  var selectedIndex = 0;
  Widget build(BuildContext context){
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
            title: const Text('SlugSwole'),
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
    return const Placeholder();
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
    return const Placeholder();
  }
}
