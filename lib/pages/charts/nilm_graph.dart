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
  final double width = 15;

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

  double? min;
  double? avg;
  double? max;

  late Timer updateNILMTimer;
  @override
  void initState() {
    super.initState();

    appliances = fetch_appliances(credentials, baseURL);
    updateNILMTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      updateNilmGraph();
    });
  }

  Future<void> updateNilmGraph() async {
    if (auth != null) {
      setState(() {
        appliances = NILM_appliance.get_appliances(
          auth!,
          baseURL,
        );
      });
    }
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
          return displayScrollable(); // Return your widget here
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
    List<BarChartGroupData> localBarGroup = [];
    List<String> local_x_titles = [];
    List<double> local_y_titles = [];
    int i = 0;
    timestamp = appliances[0].timestamp;
    total_power_consumption = appliances[0].total_consumption;
    for (NILM_appliance appliance in appliances) {
      local_x_titles.add(appliance.name!);
      local_y_titles.add(appliance.power_kW!);
      if (min == null) min = appliance.power_kW!;
      if (max == null) max = appliance.power_kW!;
      if (appliance.power_kW! < min!) min = appliance.power_kW!;
      if (appliance.power_kW! > max!) max = appliance.power_kW!;
      localBarGroup.add(makeGroupData(i, appliance.power_kW!));
      i++;
    }
    double number = max! + min!;
    avg = (i != 0) ? double.parse((number / i).toStringAsFixed(2)) : null;
    x_axis_titles = local_x_titles;
    y_axis_titles = local_y_titles;
    rawBarGroups = localBarGroup;
    showingBarGroups = rawBarGroups;
    print("length is: ${rawBarGroups.length}");
  }

  @override
  void dispose() {
    updateNILMTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: getGraph(),
      ),
    );
  }

  Column displayScrollable() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Total Energy Consumed: $total_power_consumption kW',
                  style: TextStyle(
                      color: Color.fromARGB(255, 236, 201, 42),
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(width: 70),
                Text(
                  '$timestamp',
                  style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255), fontSize: 16),
                ),
                SizedBox(width: 20),
                makeIcon()
              ],
            ),
          ],
        ),
        const SizedBox(
          height: 38,
        ),
        Expanded(
          child: BarChart(
            BarChartData(
              maxY: max,
              barTouchData: BarTouchData(
                touchTooltipData: BarTouchTooltipData(
                  tooltipBgColor: Color.fromARGB(255, 240, 148, 105),
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    final yValue = rod.toY.toString();
                    return BarTooltipItem(
                      yValue,
                      TextStyle(color: Colors.white),
                    );
                  },
                ),
                touchCallback: (FlTouchEvent event, response) {
                  if (response == null || response.spot == null) {
                    setState(() {
                      touchedGroupIndex = -1;
                      showingBarGroups = List.of(rawBarGroups);
                    });
                    return;
                  }

                  touchedGroupIndex = response.spot!.touchedBarGroupIndex;

                  setState(() {
                    if (!event.isInterestedForInteractions) {
                      touchedGroupIndex = -1;
                      showingBarGroups = List.of(rawBarGroups);
                      return;
                    }
                    showingBarGroups = List.of(rawBarGroups);
                    if (touchedGroupIndex != -1) {
                      var sum = 0.0;
                      for (final rod
                          in showingBarGroups[touchedGroupIndex].barRods) {
                        sum += rod.toY;
                      }
                      final avg = sum /
                          showingBarGroups[touchedGroupIndex].barRods.length;

                      showingBarGroups[touchedGroupIndex] =
                          showingBarGroups[touchedGroupIndex].copyWith(
                        barRods: showingBarGroups[touchedGroupIndex]
                            .barRods
                            .map((rod) {
                          return rod.copyWith(toY: avg, color: widget.avgColor);
                        }).toList(),
                      );
                    }
                  });
                },
              ),
              titlesData: FlTitlesData(
                show: true,
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: bottomTitles,
                    reservedSize: 42,
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 28,
                    interval: 1,
                    getTitlesWidget: leftTitles,
                  ),
                ),
              ),
              borderData: FlBorderData(
                show: false,
              ),
              barGroups: showingBarGroups,
              gridData: const FlGridData(show: false),
            ),
          ),
        ),
        const SizedBox(
          height: 12,
        ),
      ],
    );
  }

  Widget leftTitles(
    double value,
    TitleMeta meta,
    /*List<double> maxMinAvg*/
  ) {
    const style = TextStyle(
      color: Color.fromARGB(255, 255, 255, 255),
      fontWeight: FontWeight.bold,
      fontSize: 10,
    );
    String text;
    if (value == 0) {
      text = '$min';
    } else if (value >= avg! && value < max!) {
      text = '$avg';
    } else if (value >= max!) {
      text = '$max';
    } else {
      return Container();
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 0,
      child: Text(text, style: style),
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    // final titles = <String>['Mn', 'Te', 'Wd', 'Tu'];

    final Widget text = Text(
      x_axis_titles[value.toInt()],
      style: const TextStyle(
        color: Color.fromARGB(255, 255, 255, 255),
        fontWeight: FontWeight.bold,
        fontSize: 8,
      ),
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10, //margin top
      child: Transform.rotate(
          angle: -math.pi /
              10.0, // Rotate the text by 45 degrees (pi/4 radians) counter-clockwise
          child: text),
    );
  }

  BarChartGroupData makeGroupData(int x, double y1) {
    return BarChartGroupData(
      barsSpace: 10,
      x: x,
      barRods: [
        BarChartRodData(
          toY: y1,
          color: widget.leftBarColor,
          width: width,
        ),
      ],
    );
  }

  Widget makeIcon() {
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
