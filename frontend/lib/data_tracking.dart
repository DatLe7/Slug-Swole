import 'package:flutter/material.dart';
import 'counter.dart';


//Page for graphs and capacity tracking
class DataPage extends StatelessWidget {
  const DataPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    var capacity = getCounter(); 
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
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
                  Text("$capacity / 120"),
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