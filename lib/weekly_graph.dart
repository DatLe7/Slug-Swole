import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class WeekGraph extends StatefulWidget {
    final List<FlSpot> capData;

    const WeekGraph({super.key, required this.capData});

    @override
    State<WeekGraph> createState() => _WeekGraphState();
}

class _WeekGraphState extends State<WeekGraph> {
    @override
    Widget build(BuildContext context) {
        return Container(
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
                    spots: widget.capData,
                    isCurved: true,
                    barWidth: 3,
                    color: Colors.black,
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
            ),
        );
    }
}