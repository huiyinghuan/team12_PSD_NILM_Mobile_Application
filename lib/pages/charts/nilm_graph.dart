import 'dart:async';
import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:l3homeation/components/graphs/chart_sample.dart';
import 'package:l3homeation/models/nilm_appliance.dart';
import 'package:l3homeation/pages/dashboard/dashboard_shared.dart';

class NILM_graph extends StatefulWidget {
  NILM_graph({super.key});
  final Color leftBarColor = AppColors_Graph.contentColorYellow;
  final Color rightBarColor = AppColors_Graph.contentColorRed;
  final Color avgColor = Color.fromARGB(255, 255, 115, 0);
  @override
  State<StatefulWidget> createState() => NILM_graph_state();
}

class NILM_graph_state extends State<NILM_graph> {
  final double width = 4;

  late List<BarChartGroupData> rawBarGroups;
  late List<BarChartGroupData> showingBarGroups;
  late Future<List<NILM_appliance>> appliances;
  int touchedGroupIndex = -1;
  String credentials = auth!;
  // change to deployment url when done
  String baseURL = "http://dereknan.click:27558";
  List<String> x_axis_titles = [];
  List<double> y_axis_titles = [];
  String? timestamp;
  double? total_power_consumption;
  @override
  void initState() {
    super.initState();

    appliances = fetch_appliances(credentials, baseURL);

    final barGroup1 = makeGroupData(0, 5, 12);
    final barGroup2 = makeGroupData(1, 16, 12);
    final barGroup3 = makeGroupData(2, 18, 5);
    final barGroup4 = makeGroupData(3, 20, 16);

    final items = [
      barGroup1,
      barGroup2,
      barGroup3,
      barGroup4,
    ];

    rawBarGroups = items;

    showingBarGroups = rawBarGroups;
  }

  Future<List<NILM_appliance>> fetch_appliances(
      String credentials, String URL) async {
    List<NILM_appliance> appliances = [];
    appliances = await NILM_appliance.get_appliances(credentials, URL);
    return appliances;
  }

  Widget getGraph() {
    return FutureBuilder<List<NILM_appliance>>(
      future: appliances,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<NILM_appliance> appliances = snapshot.data!;
          process_NILM_appliances(snapshot, appliances);
          return Placeholder(); // Return your widget here
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Or any other loading indicator
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return Text('No data'); // Handle other states as needed
        }
      },
    );
  }

  void process_NILM_appliances(
      AsyncSnapshot snapshot, List<NILM_appliance> appliances) {
    timestamp = appliances[0].timestamp;
    total_power_consumption = appliances[0].total_consumption;
    for (NILM_appliance appliance in appliances) {
      x_axis_titles.add(appliance.name!);
      y_axis_titles.add(appliance.power_kW!);
      // print(appliance.running);

      print(appliance.total_consumption);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Padding(
          padding: const EdgeInsets.all(16), child: getGraph() //Column(
          //   crossAxisAlignment: CrossAxisAlignment.stretch,
          //   children: <Widget>[
          //     Row(
          //       mainAxisSize: MainAxisSize.min,
          //       children: <Widget>[
          //         makeTransactionsIcon(),
          //         const SizedBox(
          //           width: 10,
          //         ),
          //         const Text(
          //           'Transactions',
          //           style: TextStyle(color: Colors.white, fontSize: 10),
          //         ),
          //         const SizedBox(
          //           width: 4,
          //         ),
          //         const Text(
          //           'state',
          //           style: TextStyle(color: Color(0xff77839a), fontSize: 16),
          //         ),
          //       ],
          //     ),
          //     const SizedBox(
          //       height: 38,
          //     ),
          //     Expanded(
          //       child: BarChart(
          //         BarChartData(
          //           maxY: 20,
          //           barTouchData: BarTouchData(
          //             touchTooltipData: BarTouchTooltipData(
          //               tooltipBgColor: Colors.grey,
          //               getTooltipItem: (a, b, c, d) => null,
          //             ),
          //             touchCallback: (FlTouchEvent event, response) {
          //               if (response == null || response.spot == null) {
          //                 setState(() {
          //                   touchedGroupIndex = -1;
          //                   showingBarGroups = List.of(rawBarGroups);
          //                 });
          //                 return;
          //               }

          //               touchedGroupIndex = response.spot!.touchedBarGroupIndex;

          //               setState(() {
          //                 if (!event.isInterestedForInteractions) {
          //                   touchedGroupIndex = -1;
          //                   showingBarGroups = List.of(rawBarGroups);
          //                   return;
          //                 }
          //                 showingBarGroups = List.of(rawBarGroups);
          //                 if (touchedGroupIndex != -1) {
          //                   var sum = 0.0;
          //                   for (final rod
          //                       in showingBarGroups[touchedGroupIndex].barRods) {
          //                     sum += rod.toY;
          //                   }
          //                   final avg = sum /
          //                       showingBarGroups[touchedGroupIndex]
          //                           .barRods
          //                           .length;

          //                   showingBarGroups[touchedGroupIndex] =
          //                       showingBarGroups[touchedGroupIndex].copyWith(
          //                     barRods: showingBarGroups[touchedGroupIndex]
          //                         .barRods
          //                         .map((rod) {
          //                       return rod.copyWith(
          //                           toY: avg, color: widget.avgColor);
          //                     }).toList(),
          //                   );
          //                 }
          //               });
          //             },
          //           ),
          //           titlesData: FlTitlesData(
          //             show: true,
          //             rightTitles: const AxisTitles(
          //               sideTitles: SideTitles(showTitles: false),
          //             ),
          //             topTitles: const AxisTitles(
          //               sideTitles: SideTitles(showTitles: false),
          //             ),
          //             bottomTitles: AxisTitles(
          //               sideTitles: SideTitles(
          //                 showTitles: true,
          //                 getTitlesWidget: bottomTitles,
          //                 reservedSize: 42,
          //               ),
          //             ),
          //             leftTitles: AxisTitles(
          //               sideTitles: SideTitles(
          //                 showTitles: true,
          //                 reservedSize: 28,
          //                 interval: 1,
          //                 getTitlesWidget: leftTitles,
          //               ),
          //             ),
          //           ),
          //           borderData: FlBorderData(
          //             show: false,
          //           ),
          //           barGroups: showingBarGroups,
          //           gridData: const FlGridData(show: false),
          //         ),
          //       ),
          //     ),
          //     const SizedBox(
          //       height: 12,
          //     ),
          //   ],
          // ),
          ),
    );
  }

  Widget leftTitles(
    double value,
    TitleMeta meta,
    /*List<int> maxMinAvg*/
  ) {
    const style = TextStyle(
      color: Color(0xff7589a2),
      fontWeight: FontWeight.bold,
      fontSize: 10,
    );
    String text;
    if (value == 0) {
      text = '1K';
    } else if (value == 10) {
      text = '5K';
    } else if (value == 19) {
      text = '10K';
    } else {
      return Container();
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 0,
      child: Text(text, style: style),
    );
  }

  Widget bottomTitles(
    double value,
    TitleMeta meta,
    /*List<String> titles*/
  ) {
    final titles = <String>['Mn', 'Te', 'Wd', 'Tu'];

    final Widget text = Text(
      titles[value.toInt()],
      style: const TextStyle(
        color: Color(0xff7589a2),
        fontWeight: FontWeight.bold,
        fontSize: 7,
      ),
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16, //margin top
      child: text,
    );
  }

  BarChartGroupData makeGroupData(int x, double y1, double y2) {
    return BarChartGroupData(
      barsSpace: 4,
      x: x,
      barRods: [
        BarChartRodData(
          toY: y1,
          color: widget.leftBarColor,
          width: width,
        ),
        BarChartRodData(
          toY: y2,
          color: widget.rightBarColor,
          width: width,
        ),
      ],
    );
  }

  Widget makeTransactionsIcon() {
    const width = 3.5;
    const space = 3.5;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: width,
          height: 10,
          color: Colors.white.withOpacity(0.4),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          color: Colors.white.withOpacity(0.8),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 42,
          color: Colors.white.withOpacity(1),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          color: Colors.white.withOpacity(0.8),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 10,
          color: Colors.white.withOpacity(0.4),
        ),
      ],
    );
  }
}
