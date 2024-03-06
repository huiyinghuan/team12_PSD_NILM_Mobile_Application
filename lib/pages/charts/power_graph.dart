import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:l3homeation/components/graphs/chart_sample.dart';
import 'package:l3homeation/pages/charts/nilm_graph.dart';
import 'package:l3homeation/widget/base_layout.dart';
import 'package:l3homeation/widget/navigation_drawer_widget.dart';
import 'package:l3homeation/services/userPreferences.dart';
import 'package:l3homeation/components/graphs/bar_chart_sample2.dart';
import 'package:l3homeation/components/graphs/bar_chart_sample6.dart';
import 'package:l3homeation/components/graphs/bar_chart_sample7.dart';
import 'package:l3homeation/components/graphs/line_chart_sample10.dart';
import 'package:l3homeation/components/graphs/line_chart_sample2.dart';
import 'package:l3homeation/components/graphs/pie_chart_sample2.dart';
import 'package:l3homeation/components/graphs/radar_chart_sample1.dart';
import 'package:l3homeation/models/iot_device.dart';

class ChartSamples {
  static final Map<ChartType, List<ChartSample>> samples = {
    ChartType.line: [
      LineChartSample(10, (context) => LineChartSample10()),
    ],
  };
}

class PowerGraph extends StatefulWidget {
  @override
  _PowerGraphState createState() => _PowerGraphState();
}

class _PowerGraphState extends State<PowerGraph>
    with SingleTickerProviderStateMixin {
  late Future<List<dynamic>> devices = Future.value([]);
  String? auth;
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    loadAuth().then((_) {
      print("Got auth: $auth\n");
      updateDevices();
    });
  }

  Future<void> loadAuth() async {
    auth = await UserPreferences.getString('auth');
  }

  Future<void> updateDevices() async {
    if (auth != null) {
      setState(() {
        devices = IoT_Device.get_devices(
          auth!,
          "http://l3homeation.dyndns.org:2080",
        );
      });
    }
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  Widget buildEnergyTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          GridView.count(
            crossAxisCount: 1,
            childAspectRatio: 1,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: <Widget>[
              Container(
                child: LineChartSample10(),
                color: Colors.black,
              ),
              Container(
                child: LineChartSample2(),
                color: Color.fromARGB(255, 160, 113, 160),
                alignment: Alignment.center,
              ),
              Container(
                child: BarChartSample6(),
                color: Color.fromARGB(255, 189, 223, 109),
                alignment: Alignment.center,
              ),
            ],
          ),
          Container(
            child: BarChartSample7(),
            color: Color.fromARGB(255, 63, 128, 118),
          ),
          Container(
            child: PieChartSample2(),
            color: Color.fromARGB(255, 206, 107, 140),
          ),
        ],
      ),
    );
  }

  Widget buildNILMTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          GridView.count(
            crossAxisCount: 1,
            childAspectRatio: 1,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: <Widget>[
              Container(
                child: NILM_graph(),
                color: Color.fromARGB(255, 79, 27, 109),
              ),
            ],
          ),
          Container(
            child: RadarChartSample1(),
            color: Color.fromARGB(255, 129, 134, 177),
          ),
        ],
      ),
    );
  }

  TabBarView buildTabularViews() {
    return TabBarView(
      controller: _tabController,
      children: [
        buildEnergyTab(),
        buildNILMTab(),
      ],
    );
  }

  TabBar buildTabSelect() {
    return TabBar(
      controller: _tabController,
      tabs: [
        Tab(text: 'Energy'),
        Tab(text: 'NILM'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      title: 'Graph Displaying',
      child: Column(
        children: <Widget>[
          buildTabSelect(),
          Expanded(
            child: buildTabularViews(),
          ),
        ],
      ),
    );
  }
}
