import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'backend_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

String numToTime(int num){
  if (num < 12){
    return "$num AM";
  } else if (num == 12){
    return "$num PM";
  } else {
    return "${num - 12} PM";
  }
}
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


List<int> createIntList(int start, int end) {
  return List.generate(end - start + 1, (index) => start + index);
}


List<int> subtractLists(List<int> list1, List<int> list2) {
  return list1.where((element) => !list2.contains(element)).toList();
}


class WeeklyBarGraph extends StatefulWidget {
  final String day;
  const WeeklyBarGraph({super.key, required this.day});

  @override
  State<WeeklyBarGraph> createState() => _WeeklyBarGraphState();
}

class _WeeklyBarGraphState extends State<WeeklyBarGraph> {
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
          List<BarChartGroupData> barData = [];
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
          List<int> hours_with_data = [];
          hourData.forEach((key, value) {
            hours_with_data.add(key);
            double y = calculateAverage(value);
            BarChartGroupData dataPoint = BarChartGroupData(x: key, barRods: [BarChartRodData(toY: y)] );
            barData.add(dataPoint);
          });
          List<int> operationalHours = getHours(widget.day); // first index is opening, second index is closing
          List<int> allHours = createIntList(operationalHours[0], operationalHours[1]);
          List<int> missingHours = subtractLists(allHours, hours_with_data);
          for (int i in missingHours){
            BarChartGroupData dataPoint = BarChartGroupData(x: i, barRods: [BarChartRodData(toY: 0)] );
            barData.add(dataPoint);
          }
          barData.sort((a, b) => a.x.compareTo(b.x));
          return BarChart(
            BarChartData(
              maxY: 150,
              alignment: BarChartAlignment.center,
              barGroups: barData,
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                        showTitles: false,
                    )
                ),
                rightTitles: AxisTitles(
                    sideTitles: SideTitles(
                        showTitles: false,
                    )
                ),
                topTitles: AxisTitles(
                    sideTitles: SideTitles(
                        showTitles: false,
                    )
                ),
                bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 35,
                        getTitlesWidget: (double value, TitleMeta meta) {
                            if (value.toInt() % 2 == 0) {
                                return Text(value.toInt().toString());
                            } else {
                                return SizedBox(); // Hide label
                            }
                        }
                    ),
                )
              ),
              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  fitInsideHorizontally: true,
                  fitInsideVertically: true,
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    return BarTooltipItem(
                      '${numToTime(group.x)}: ${rod.toY}',
                      TextStyle(color: const Color.fromARGB(255, 17, 14, 14), fontWeight: FontWeight.bold),
                    );
                  },
                ),
              )
            ),
            duration: Duration(milliseconds: 150),
            curve: Curves.linear,
          );
        }
    ),
    );  
  }
}
