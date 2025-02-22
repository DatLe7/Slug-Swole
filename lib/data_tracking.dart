import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'weekly_graph.dart';
import 'counter.dart';
import 'package:intl/intl.dart';
import 'dart:math';

import 'backend_services.dart';

// Page for graphs and capacity tracking
class DataPage extends StatelessWidget {
  var facilityData = getFacilityData("east_field_gym");
  var todayData = getTodaysData();
  List<FlSpot> dummyData = List.generate(8, (index) {
    return FlSpot(((Random().nextDouble() * 18) + 6), (Random().nextDouble() * 120));
  });
  List<FlSpot> dummyData1 = List.generate(8, (index) {
    return FlSpot(((Random().nextDouble() * 18) + 6), (Random().nextDouble() * 120));
  });
  List<FlSpot> dummyData2 = List.generate(8, (index) {
    return FlSpot(((Random().nextDouble() * 18) + 6), (Random().nextDouble() * 120));
  });
  List<FlSpot> dummyData3 = List.generate(8, (index) {
    return FlSpot(((Random().nextDouble() * 18) + 6), (Random().nextDouble() * 120));
  });
  List<FlSpot> dummyData4 = List.generate(8, (index) {
    return FlSpot(((Random().nextDouble() * 18) + 6), (Random().nextDouble() * 120));
  });
  List<FlSpot> dummyData5 = List.generate(8, (index) {
    return FlSpot(((Random().nextDouble() * 18) + 6), (Random().nextDouble() * 120));
  });
  List<FlSpot> dummyData6 = List.generate(8, (index) {
    return FlSpot(((Random().nextDouble() * 18) + 6), (Random().nextDouble() * 120));
  });

  DataPage({super.key});

  String howManyPeople(capacity) {
    if (capacity == 120) {
      return "Full";
    } else if (capacity > 100) {
      return "Very Busy";
    } else if (capacity > 60) {
      return "Busy";
    } else {
      return "Not Busy";
    }
  }

  @override
  Widget build(BuildContext context) {
    var capacity = (Random().nextDouble() * 120).roundToDouble().toInt(); // getCounter();
    final theme = Theme.of(context);
    final now = DateTime.now();
    String formattedDate = DateFormat.yMMMEd().format(now);

    return FutureBuilder(
      future: todayData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        var todayData = snapshot.data;
        print(todayData);
        print("data fetched!");
        
        return LayoutBuilder(
          builder: (context, constraints) {
            return Scaffold(
              backgroundColor: theme.colorScheme.primary,
              body: ListView(
                children: [
                  SizedBox(height: 20),
                  Center(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      width: MediaQuery.sizeOf(context).width * 0.7,
                      height: MediaQuery.sizeOf(context).height * 0.2,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Center(
                                child: Column(
                                  children: [
                                    Text(formattedDate),
                                    Text("Capacity: ${howManyPeople(capacity)}"),
                                    Text("$todayData / 140"),
                                  ],
                                ),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: PieChart(
                                  PieChartData(
                                    sections: [
                                      PieChartSectionData(
                                        value: capacity.toDouble(),
                                        title: capacity.toString(),
                                        color: Colors.red,
                                        titleStyle: TextStyle(
                                          fontSize: 15,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          shadows: [Shadow(color: Colors.black, blurRadius: 2)],
                                        ),
                                      ),
                                      PieChartSectionData(
                                        value: (120 - capacity.toDouble()),
                                        title: (120 - capacity).toString(),
                                        color: Colors.grey,
                                        titleStyle: TextStyle(
                                          fontSize: 15,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          shadows: [Shadow(color: Colors.black, blurRadius: 2)],
                                        ),
                                      ),
                                    ],
                                    sectionsSpace: 3,
                                    centerSpaceRadius: 5.0,
                                    pieTouchData: PieTouchData(enabled: true),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: MediaQuery.sizeOf(context).width * 0.7,
                    height: MediaQuery.sizeOf(context).height * 0.5,
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: DefaultTabController(
                      initialIndex: 0,
                      length: 7,
                      child: Scaffold(
                        appBar: AppBar(
                          title: Text("Weekly Data"),
                          centerTitle: true,
                          bottom: TabBar(
                            tabs: [
                              Tab(text: "Mon"),
                              Tab(text: "Tue"),
                              Tab(text: "Wed"),
                              Tab(text: "Thu"),
                              Tab(text: "Fri"),
                              Tab(text: "Sat"),
                              Tab(text: "Sun"),
                            ],
                          ),
                        ),
                        body: TabBarView(
                          children: [
                            WeekGraph(capData: dummyData),
                            WeekGraph(capData: dummyData1),
                            WeekGraph(capData: dummyData2),
                            WeekGraph(capData: dummyData3),
                            WeekGraph(capData: dummyData4),
                            WeekGraph(capData: dummyData5),
                            WeekGraph(capData: dummyData6),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30,), 
                ],
              ),
            );
          },
        );
      },
    );
  }
}