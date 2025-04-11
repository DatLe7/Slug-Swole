import 'dart:ffi';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'weekly_graph.dart';
import 'package:intl/intl.dart';
import 'weekly_bar_graph.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'backend_services.dart';

// Page for graphs and capacity tracking
class DataPage extends StatefulWidget {
  DataPage({super.key});

  @override
  State<DataPage> createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  var facilityData = getFacilityData("east_field_gym");
  bool graphIndex = false;

  @override
  Widget build(BuildContext context) {
    var mostRecent = getMostRecent();
    final theme = Theme.of(context);
    final now = DateTime.now();
    String formattedDate = DateFormat.yMMMEd().format(now);

    // This is for the sizing of the pie chart
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final chartSize = (screenWidth < screenHeight
            ? screenWidth
            : screenHeight) *
        0.6; // Changes pie chart size depending if the device is more wide than

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
                  // Daily Capacity
                  child: Container(
                    padding: EdgeInsets.all(20),
                    width: screenWidth * 0.95,
                    //height: MediaQuery.sizeOf(context).height * 0.3,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: FutureBuilder(
                      future: mostRecent,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        }
                        if (!snapshot.hasData || snapshot.data == null) {
                          return Center(child: Text('No data available'));
                        }
                        bool closed = isClosed();
                        Map<String, dynamic> fullData =
                            snapshot.data as Map<String, dynamic>;
                        String lastUpdated =
                            formatTimestamp(fullData["timestamp"]);
                        int todayData = fullData["capacity"] is int
                            ? fullData["capacity"]
                            : int.tryParse(fullData["capacity"].toString()) ??
                                0;

                        return Row(
                          children: [
                            Container(
                              //padding: EdgeInsets.only(left:10),
                              width: screenWidth * 0.52,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Last updated $lastUpdated",
                                    style: TextStyle(
                                        fontSize: screenWidth * 0.025),
                                  ),
                                  SizedBox(
                                    height: screenHeight * 0.004,
                                  ),
                                  RichText(
                                      text: TextSpan(
                                          text: "Capacity: ",
                                          style: TextStyle(
                                              fontSize: screenWidth * 0.065,
                                              color: Colors.black),
                                          children: [
                                        TextSpan(
                                          text: (closed ? "--" : "$todayData") as String,
                                          style: TextStyle(
                                            fontSize: screenWidth * 0.065,
                                            //fontWeight: FontWeight.bold
                                          ),
                                        )
                                      ])),
                                  Text(
                                    closed ? "Closed":howManyPeople(todayData),
                                    style: TextStyle(
                                        fontSize: screenWidth * 0.07,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: screenHeight * 0.01,
                                  ),
                                  Text(
                                    closed ? "The gym is open from 6AM to 11PM on weekdays and 8AM to 8PM on weekends." : howManyPeopleFlavortext(todayData),
                                    style: TextStyle(
                                        fontSize: screenWidth * 0.04,
                                        color: Colors.black),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(width: screenWidth * 0.13),
                            Container(
                              height: chartSize * 0.15,
                              width: chartSize * 0.15,
                              child: PieChart(
                                PieChartData(
                                  sectionsSpace: chartSize * 0.002,
                                  centerSpaceRadius: chartSize * 0.1,
                                  pieTouchData: PieTouchData(enabled: true),
                                  startDegreeOffset: -90,
                                  sections: [
                                    PieChartSectionData(
                                      value: closed ? 0: todayData.toDouble(),
                                      title: todayData.toString(),
                                      color: pieChartColorPicker(todayData),
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
                                      title: "", //(150 - todayData).toString(),
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
                  // Weekly Graphs
                  width: MediaQuery.sizeOf(context).width * 0.7,
                  height: MediaQuery.sizeOf(context).height * 0.5,
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.only(right: 10, left: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DefaultTabController(
                    initialIndex: DateTime.now().weekday - 1,
                    length: 7,
                    child: Scaffold(
                      appBar: AppBar(
                        title: Builder(builder: (context) {
                          if (graphIndex) {
                            return Text(
                              "Weekly Data - Average ",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          } else {
                            return Text(
                              "Weekly Data - Total",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }
                        }),
                        actions: [
                          Switch(
                              value: graphIndex,
                              onChanged: (bool newValue) {
                                setState(() {
                                  graphIndex = newValue;
                                });
                              }),
                        ],
                        centerTitle: false,
                        bottom: TabBar(
                          tabAlignment: TabAlignment.start,
                          isScrollable: true,
                          labelPadding: EdgeInsets.symmetric(horizontal: 16),
                          labelColor: Colors.black,
                          unselectedLabelColor: Colors.grey,
                          indicatorSize: TabBarIndicatorSize.label,
                          indicator: UnderlineTabIndicator(
                            borderSide: BorderSide(
                                width: 3,
                                color: Colors.black), // Thinner underline
                            insets: EdgeInsets.symmetric(
                                horizontal: 16), // Make it slightly shorter
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
                          Builder(builder: (context) {
                            if (graphIndex) {
                              return WeeklyBarGraph(day: 'monday');
                            } else {
                              return WeekGraph(day: 'monday');
                            }
                          }),
                          Builder(builder: (context) {
                            if (graphIndex) {
                              return WeeklyBarGraph(day: 'tuesday');
                            } else {
                              return WeekGraph(day: 'tuesday');
                            }
                          }),
                          Builder(builder: (context) {
                            if (graphIndex) {
                              return WeeklyBarGraph(day: 'wednesday');
                            } else {
                              return WeekGraph(day: 'wednesday');
                            }
                          }),
                          Builder(builder: (context) {
                            if (graphIndex) {
                              return WeeklyBarGraph(day: 'thursday');
                            } else {
                              return WeekGraph(day: 'thursday');
                            }
                          }),
                          Builder(builder: (context) {
                            if (graphIndex) {
                              return WeeklyBarGraph(day: 'friday');
                            } else {
                              return WeekGraph(day: 'friday');
                            }
                          }),
                          Builder(builder: (context) {
                            if (graphIndex) {
                              return WeeklyBarGraph(day: 'saturday');
                            } else {
                              return WeekGraph(day: 'saturday');
                            }
                          }),
                          Builder(builder: (context) {
                            if (graphIndex) {
                              return WeeklyBarGraph(day: 'sunday');
                            } else {
                              return WeekGraph(day: 'sunday');
                            }
                          }),
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

String formatTimestamp(timestamp) {
  var format = new DateFormat('MMM d @ h:mm a'); // <- use skeleton here
  return format.format(timestamp.toDate());
}

String howManyPeople(int capacity) {
  if (capacity >= 150) {
    return "Full";
  } else if (capacity > 100) {
    return "Very Busy";
  } else if (capacity > 60) {
    return "Busy";
  } else {
    return "Not Busy";
  }
}

String howManyPeopleFlavortext(int capacity) {
  if (capacity >= 150) {
    return "Expect a sizeable line to enter gym, as well as longer wait times for all machines";
  } else if (capacity > 120) {
    return "Expect wait times for more machines like Leg/Bicep/Hamstring curl, as well as Benches and Racks";
  } else if (capacity > 85) {
    return "Expect wait times for some machines like Lat Pulldown and Chest Flys";
  } else {
    return "Expect no/little wait times for most machines and freeweights ";
  }
}

Color pieChartColorPicker(int capacity) {
  if (capacity >= 150) {
    return Colors.redAccent;
  } else if (capacity > 120) {
    return Colors.orange;
  } else if (capacity > 85) {
    return Colors.yellow;
  } else {
    return Colors.lightGreen;
  }
}

bool isClosed() {
  DateTime now = DateTime.now();
  if (now.weekday >= 6 && (now.hour < 8 || now.hour > 20) ||
      (now.hour < 6 || now.hour > 11)) {
    return true;
  }
  return false;
}
