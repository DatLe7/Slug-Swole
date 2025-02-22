import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'backend_services.dart'; 
import 'dart:async';


DatabaseReference ref = FirebaseDatabase.instance.ref("weekly_capacity_data");
int _counter = 0;
int getCounter(){
  return _counter;
}


void scheduleTask() {
  DateTime now = DateTime.now();
  int minutesUntilNextExecution = 10 - (now.minute % 10);
  Duration initialDelay = Duration(minutes: minutesUntilNextExecution, seconds: -now.second);

  Future.delayed(initialDelay, () {
    Timer.periodic(Duration(minutes: 10), (timer) {
      uploadData(_counter);
    });
  });
}


class Counter extends StatefulWidget {
  
  const Counter({super.key});

  @override
  State<Counter> createState() => _CounterState();
}


class _CounterState extends State<Counter> {
  @override
  final mostRecent = getMostRecent();
  void initState() {
    super.initState();
    scheduleTask();  // Start the task only once when the widget is first initialized
  }

  void _incrementCounter() {
    if(_counter < 120){
      setState(() {
        _counter++;
    });}
      
  }
  void _decrementCounter() {
    if(_counter > 0){
      setState(() {
        _counter--;
    });}
  }
  void _setCounter(int x){
    setState((){
      _counter = x;
    });

  }
  @override
  Widget build(BuildContext context) {
    
    return FutureBuilder(
      future: mostRecent,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
    Map<String, dynamic> data = snapshot.data as Map<String, dynamic>;
    var capacity = data["capacity"];
    _counter = capacity;
   
    return Scaffold( 
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                "Staff only feature!"),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(onPressed: _decrementCounter, child: Text("-"),),
                  Text(
                    '$_counter',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  ElevatedButton(onPressed: _incrementCounter, child: Text("+")),
              
                ],
              
              ),
              
            ],
          ),
        ),
        // This trailing comma makes auto-formatting nicer for build methods.
      );
  });
  }
}