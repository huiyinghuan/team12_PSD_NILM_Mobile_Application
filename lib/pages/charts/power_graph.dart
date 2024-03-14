// ignore_for_file: camel_case_types, library_private_types_in_public_api

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:l3homeation/components/graphs/chart_sample.dart';
import 'package:l3homeation/pages/charts/nilm_graph.dart';
import 'package:l3homeation/widget/base_layout.dart';
import 'package:l3homeation/services/userPreferences.dart';
import 'package:l3homeation/components/graphs/bar_chart_sample2.dart';
import 'package:l3homeation/components/graphs/bar_chart_sample6.dart';
import 'package:l3homeation/components/graphs/bar_chart_sample7.dart';
import 'package:l3homeation/components/graphs/line_chart_sample10.dart';
import 'package:l3homeation/components/graphs/line_chart_sample2.dart';
import 'package:l3homeation/components/graphs/pie_chart_sample2.dart';
import 'package:l3homeation/components/graphs/radar_chart_sample1.dart';

class ChartSamples {
  static final Map<ChartType, List<ChartSample>> samples = {
    ChartType.line: [
      LineChartSample(10, (context) => const LineChartSample10()),
    ],
  };
}

class Power_Graph extends StatefulWidget {
  const Power_Graph({super.key});

  @override
  _Power_Graph_State createState() => _Power_Graph_State();
}

class _Power_Graph_State extends State<Power_Graph>
    with SingleTickerProviderStateMixin {
  String? auth;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    loadAuth().then((_) {});
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> loadAuth() async {
    auth = await User_Preferences.getString('auth');
  }

  Widget buildEnergyTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          GridView.count(
            crossAxisCount: 1,
            childAspectRatio: 1,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: <Widget>[
              Container(
                color: Colors.black,
                child: const LineChartSample10(),
              ),
              Container(
                color: const Color.fromARGB(255, 189, 223, 109),
                alignment: Alignment.center,
                child: const BarChartSample6(),
              ),
            ],
          ),
          Container(
            color: const Color.fromARGB(255, 63, 128, 118),
            child: BarChartSample7(),
          ),
          Container(
            color: const Color.fromARGB(255, 206, 107, 140),
            child: const PieChartSample2(),
          ),
          Container(
            color: const Color.fromARGB(255, 129, 134, 177),
            child: const RadarChartSample1(),
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
            physics: const NeverScrollableScrollPhysics(),
            children: <Widget>[
              Container(
                color: const Color.fromARGB(255, 49, 83, 194),
                child: const NILM_Graph(),
              ),
            ],
          ),
          Container(
            color: const Color.fromARGB(255, 160, 113, 160),
            alignment: Alignment.center,
            child: const LineChartSample2(),
          ),
          Container(
            color: const Color.fromARGB(255, 74, 90, 231),
            child: const BarChartSample2(),
          ),
        ],
      ),
    );
  }

  TabBarView buildTabularViews() {
    return TabBarView(
      controller: _tabController,
      children: [
        buildNILMTab(),
        buildEnergyTab(),
      ],
    );
  }

  TabBar buildTabSelect() {
    return TabBar(
      controller: _tabController,
      tabs: const [
        Tab(text: 'NILM Data'),
        Tab(text: 'Energy Data'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Base_Layout(
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
