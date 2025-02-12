import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'counter.dart';
import 'package:intl/intl.dart';
import 'dart:math';

import 'backend_services.dart';



//Page for graphs and capacity tracking
class DataPage extends StatelessWidget {
  List<FlSpot> dummyData = List.generate(8, (index) { return FlSpot(((Random().nextDouble()*18)+6), (Random().nextDouble()*120)); });
  List<FlSpot> dummyData1 = List.generate(8, (index) { return FlSpot(((Random().nextDouble()*18)+6), (Random().nextDouble()*120)); });
  List<FlSpot> dummyData2 = List.generate(8, (index) { return FlSpot(((Random().nextDouble()*18)+6), (Random().nextDouble()*120)); });
  List<FlSpot> dummyData3 = List.generate(8, (index) { return FlSpot(((Random().nextDouble()*18)+6), (Random().nextDouble()*120)); });
  List<FlSpot> dummyData4 = List.generate(8, (index) { return FlSpot(((Random().nextDouble()*18)+6), (Random().nextDouble()*120)); });
  List<FlSpot> dummyData5 = List.generate(8, (index) { return FlSpot(((Random().nextDouble()*18)+6), (Random().nextDouble()*120)); });
  List<FlSpot> dummyData6 = List.generate(8, (index) { return FlSpot(((Random().nextDouble()*18)+6), (Random().nextDouble()*120)); });
  DataPage({super.key});
  String howManyPeople(capacity){
    if(capacity == 120){
      return "Full";
    }
    else if(capacity > 100){
      return "Very Busy";
    }
    else if(capacity > 60){
      return "Busy";
    }
    else{
      return "Not Busy";
    } 
  }
  

  @override
  Widget build(BuildContext context) {
    var capacity = (Random().nextDouble()*120).roundToDouble().toInt(); // getCounter(); 
    final theme = Theme.of(context);
    final now = DateTime.now();
    String formattedDate = DateFormat.yMMMEd().format(now);

    

    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
      body:Column(
        children: [
          SizedBox(height: 20,),
          Center(
            child: Container(
              padding: EdgeInsets.all(10),
              width: MediaQuery.sizeOf(context).width * 0.4,
              height: MediaQuery.sizeOf(context).height * 0.12,
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
                          Text("$capacity / 120"),
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
                                  shadows: [Shadow(color: Colors.black, blurRadius: 2)]
                                )
                              ),
                              PieChartSectionData(
                                value: (120 - capacity.toDouble()),
                                title: (120 - capacity).toString(),
                                color: Colors.grey,
                                titleStyle: TextStyle(
                                  fontSize: 15 ,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  shadows: [Shadow(color: Colors.black, blurRadius: 2)]
                                )
                              )
                            ],
                            sectionsSpace: 3,
                            centerSpaceRadius: 5.0,
                            pieTouchData: PieTouchData(enabled: true)
                          )
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: 20,),
          Container(
            width: MediaQuery.sizeOf(context).width * 0.4,
            height: MediaQuery.sizeOf(context).height * 0.6,
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
                    Container(
                      padding: EdgeInsets.all(20),
                      child: LineChart(
                        LineChartData(
                          maxY: 120,
                          minY: 0,
                          maxX: 24,
                          minX: 6,
                          lineTouchData: LineTouchData(enabled: false),
                          borderData: FlBorderData(show: false),
                          lineBarsData: [
                            LineChartBarData(
                              spots: dummyData,
                              isCurved: true,
                              barWidth: 3,
                              color: Colors.black
                            ),
                          ],
                          titlesData: FlTitlesData(
                            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 25,
                                interval: 3,
                                maxIncluded: true,
                                minIncluded: true,
                                )
                              ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 35,
                                interval: 30,
                                maxIncluded: true,
                                minIncluded: true,
                              ),
                            ),
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: false,
                                reservedSize: 35,
                              )
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(20),
                      child: LineChart(
                        LineChartData(
                          maxY: 120,
                          minY: 0,
                          lineTouchData: LineTouchData(enabled: false),
                          borderData: FlBorderData(show: false),
                          lineBarsData: [
                            LineChartBarData(
                              spots: dummyData1,
                              isCurved: true,
                              barWidth: 3,
                              color: Colors.black
                            ),
                          ],
                          titlesData: FlTitlesData(
                            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 35,
                                interval: 30,
                                maxIncluded: true,
                                minIncluded: true,
                              ),
                            ),
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: false,
                                reservedSize: 35,
                              )
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(20),
                      child: LineChart(
                        LineChartData(
                          maxY: 120,
                          minY: 0,
                          lineTouchData: LineTouchData(enabled: false),
                          borderData: FlBorderData(show: false),
                          lineBarsData: [
                            LineChartBarData(
                              spots: dummyData2,
                              isCurved: true,
                              barWidth: 3,
                              color: Colors.black
                            ),
                          ],
                          titlesData: FlTitlesData(
                            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 35,
                                interval: 30,
                                maxIncluded: true,
                                minIncluded: true,
                              ),
                            ),
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: false,
                                reservedSize: 35,
                              )
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(20),
                      child: LineChart(
                        LineChartData(
                          maxY: 120,
                          minY: 0,
                          lineTouchData: LineTouchData(enabled: false),
                          borderData: FlBorderData(show: false),
                          lineBarsData: [
                            LineChartBarData(
                              spots: dummyData3,
                              isCurved: true,
                              barWidth: 3,
                              color: Colors.black
                            ),
                          ],
                          titlesData: FlTitlesData(
                            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 35,
                                interval: 30,
                                maxIncluded: true,
                                minIncluded: true,
                              ),
                            ),
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: false,
                                reservedSize: 35,
                              )
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(20),
                      child: LineChart(
                        LineChartData(
                          maxY: 120,
                          minY: 0,
                          lineTouchData: LineTouchData(enabled: false),
                          borderData: FlBorderData(show: false),
                          lineBarsData: [
                            LineChartBarData(
                              spots: dummyData4,
                              isCurved: true,
                              barWidth: 3,
                              color: Colors.black
                            ),
                          ],
                          titlesData: FlTitlesData(
                            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 35,
                                interval: 30,
                                maxIncluded: true,
                                minIncluded: true,
                              ),
                            ),
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: false,
                                reservedSize: 35,
                              )
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(20),
                      child: LineChart(
                        LineChartData(
                          maxY: 120,
                          minY: 0,
                          lineTouchData: LineTouchData(enabled: false),
                          borderData: FlBorderData(show: false),
                          lineBarsData: [
                            LineChartBarData(
                              spots: dummyData5,
                              isCurved: true,
                              barWidth: 3,
                              color: Colors.black
                            ),
                          ],
                          titlesData: FlTitlesData(
                            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 35,
                                interval: 30,
                                maxIncluded: true,
                                minIncluded: true,
                              ),
                            ),
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: false,
                                reservedSize: 35,
                              )
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(20),
                      child: LineChart(
                        LineChartData(
                          maxY: 120,
                          minY: 0,
                          lineTouchData: LineTouchData(enabled: false),
                          borderData: FlBorderData(show: false),
                          lineBarsData: [
                            LineChartBarData(
                              spots: dummyData6,
                              isCurved: true,
                              barWidth: 3,
                              color: Colors.black
                            ),
                          ],
                          titlesData: FlTitlesData(
                            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 35,
                                interval: 30,
                                maxIncluded: true,
                                minIncluded: true,
                              ),
                            ),
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: false,
                                reservedSize: 35,
                              )
                            ),
                          ),
                        ),
                      ),
                    ),
                  ]
                ),
              )
            )
          ),
        ],
      ),
    );
  }
}