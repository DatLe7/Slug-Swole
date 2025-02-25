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
  var mostRecent = getMostRecent();
  
  DataPage({super.key});

  String howManyPeople(int capacity) {
    if (capacity > 120) {
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
    final theme = Theme.of(context);
    final now = DateTime.now();
    String formattedDate = DateFormat.yMMMEd().format(now);
    
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade900, Colors.blue.shade500],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: ListView(
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
                    child: FutureBuilder(
                      future: mostRecent,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        }
                        if (!snapshot.hasData || snapshot.data == null) {
                          return Center(child: Text('No data available'));
                        }
                        Map<String, dynamic> fullData =
                            snapshot.data as Map<String, dynamic>;
                        int todayData = fullData["capacity"] is int
                            ? fullData["capacity"]
                            : int.tryParse(fullData["capacity"].toString()) ?? 0;
                        return Row(
                          children: [
                            Expanded(
                              child: Center(
                                child: Column(
                                  children: [
                                    Text(formattedDate),
                                    Text("Capacity: ${howManyPeople(todayData)}"),
                                    Text("$todayData / 150"),
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
                                          value: todayData.toDouble(),
                                          title: todayData.toString(),
                                          color: Colors.red,
                                          titleStyle: TextStyle(
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            shadows: [
                                              Shadow(
                                                  color: Colors.black,
                                                  blurRadius: 2)
                                            ],
                                          ),
                                        ),
                                        PieChartSectionData(
                                          value: (150 - todayData.toDouble()),
                                          title: (150 - todayData).toString(),
                                          color: Colors.grey,
                                          titleStyle: TextStyle(
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            shadows: [
                                              Shadow(
                                                  color: Colors.black,
                                                  blurRadius: 2)
                                            ],
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
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  width: MediaQuery.sizeOf(context).width * 0.7,
                  height: MediaQuery.sizeOf(context).height * 0.6,
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.only(right: 10, left: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DefaultTabController(
                    initialIndex: 0,
                    length: 7,
                    child: Scaffold(
                      appBar: AppBar(
                        title: Text(
                          "Weekly Data",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        centerTitle: true,
                        bottom: TabBar(
                          tabAlignment: TabAlignment.start,
                          isScrollable: true,
                          labelPadding: EdgeInsets.symmetric(horizontal: 16),
                          labelColor: Colors.black,
                          unselectedLabelColor: Colors.grey,
                          indicatorSize: TabBarIndicatorSize.label,
                          indicator: UnderlineTabIndicator(
                            borderSide: BorderSide(width: 3, color: Colors.black), // Thinner underline
                            insets: EdgeInsets.symmetric(horizontal: 16), // Make it slightly shorter
                          ),
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
                          WeekGraph(day: 'monday'), 
                          WeekGraph(day: 'tuesday'),
                          WeekGraph(day: 'wednesday'),
                          WeekGraph(day: 'thursday'),
                          WeekGraph(day: 'friday'),
                          WeekGraph(day: 'saturday'),
                          WeekGraph(day: 'sunday'),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
        );
      },
    );
  }
}
