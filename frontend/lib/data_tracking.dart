import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';

//Page for graphs and capacity tracking
class DataPage extends StatelessWidget {
  const DataPage({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    String formattedDate = DateFormat.yMMMEd().format(now);
    final List<FlSpot> dummyData = List.generate(8, (index) { return FlSpot(index.toDouble(), (Random().nextDouble()*120)); });
    double current = dummyData[dummyData.length - 1].y;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
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
              child: Column(
                children: [
                  Text(formattedDate),
                  Text("Capacity: "),
                  Text("${current.toInt()} / 120"),
                ],
              ),
            ),
          ),
          SizedBox(height: 20,),
          Container(
            width: MediaQuery.sizeOf(context).width * 0.4,
            height: MediaQuery.sizeOf(context).height * 0.6,
            padding: EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.white, 
              borderRadius: BorderRadius.circular(10),
            ),
            child: LineChart(
              LineChartData(
                maxY: 120,
                minY: 0,
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
                  bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 35,
                      interval: 20,
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
        ],
      ),
    );
  }
}