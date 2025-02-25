import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'backend_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


double calculateAverage(List<int> numbers){
  if (numbers.isEmpty){
    return 0.0;
  }
  double sum = 0;
  for (int number in numbers){
    sum += number;
  }
  return (sum / numbers.length).roundToDouble();
}

List<int> getHours(String day){
  switch (day){
    case ('monday'):
      return [6, 24];
    case ('tuesday'):
      return [6, 24];
    case ('wednesday'):
      return [6, 24];
    case ('thursday'):
      return [6, 24];
    case ('friday'):
      return [6, 24];
    case ('saturday'):
      return [8, 20];
    case ('sunday'):
      return [8, 20];
    default:
      throw ArgumentError("$day is not one of the days of the week");
  }
}


class WeekGraph extends StatefulWidget {
  final String day;

  const WeekGraph({super.key, required this.day});

  @override
  State<WeekGraph> createState() => _WeekGraphState();
}

class _WeekGraphState extends State<WeekGraph> {
  @override
  Widget build(BuildContext context) {
    var getDateData = getDayOfWeek(widget.day);
    return Container(
      padding: EdgeInsets.only(left: 10, right: 20, top: 20, bottom: 20),
      child: FutureBuilder(
        future: getDateData,
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
          var data = snapshot.data as List<dynamic>;
          List<FlSpot> chartData = [];
          Map<int,List<int>> hourData = {};
          for (var item in data) {
            var cap = item['capacity'];  // Get the capacity
            if (cap is String) {
              cap = int.parse(cap);  // Convert it to int if it's a string
            } else if (cap is! int) {
              print("Warning: Invalid data type for capacity");
              continue;  // Skip this iteration if the capacity is neither int nor string
            }
            var timestamp = item['timestamp'];
            if (timestamp != null && timestamp is Timestamp) {
              DateTime dateValues = timestamp.toDate();
              hourData.putIfAbsent(dateValues.hour, () => []).add(cap); // creates new key in hourData hashmap if it doesn't exist. appends new value to current list if key does exist
            } else {
              // Handle the case when timestamp is missing or invalid
              print("Warning: Invalid timestamp or missing timestamp in data");
            }
          }
          hourData.forEach((key, value) {
            FlSpot dataPoint = FlSpot(key.toDouble(), calculateAverage(value));
            chartData.add(dataPoint);
          });
          List<int> operationalHours = getHours(widget.day); // first index is opening, second index is closing
          return LineChart(
            LineChartData(
              maxY: 150,
              minY: 0,
              maxX: operationalHours[1].toDouble(),
              minX: operationalHours[0].toDouble(),
              lineTouchData: LineTouchData(enabled: false),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  dotData: FlDotData(show: false),
                  spots: chartData,
                  isCurved: true,
                  barWidth: 4,
                  color: Colors.black,
                  isStrokeCapRound: true,
                ),
              ],
              titlesData: FlTitlesData(
                topTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 25,
                    interval: 2,
                    maxIncluded: true,
                    minIncluded: true,
                  ),
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
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
