import 'package:flutter/material.dart';

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
