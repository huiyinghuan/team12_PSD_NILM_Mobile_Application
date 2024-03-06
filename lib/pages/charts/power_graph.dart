import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:l3homeation/components/graphs/bar_chart_sample2.dart';
import 'package:l3homeation/components/graphs/bar_chart_sample6.dart';
import 'package:l3homeation/components/graphs/bar_chart_sample7.dart';
import 'package:l3homeation/components/graphs/chart_sample.dart';
import 'package:l3homeation/components/graphs/line_chart_sample10.dart';
import 'package:l3homeation/components/graphs/line_chart_sample2.dart';
import 'package:l3homeation/components/graphs/pie_chart_sample2.dart';
import 'package:l3homeation/components/graphs/radar_chart_sample1.dart';
import 'package:l3homeation/models/iot_device.dart';
import 'package:l3homeation/widget/navigation_drawer_widget.dart';
import 'package:l3homeation/services/userPreferences.dart';

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

class _PowerGraphState extends State<PowerGraph> {
  late Future<List<dynamic>> devices = Future.value([]);
  String? auth;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this as TickerProvider);
    loadAuth().then((_) {
      print("Got auth: $auth\n");
      updateDevices();
    });
    // updateDevices(); // Can be read as initialize devices too --> Naming seems weird only because it usees the exact same function to call for an update
    // updateDevicesTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
    //   updateDevices();
    // });
    // ^ Implement the timer back once we figure out how to make the rebuilding of the device status' more smooth
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
  Widget build(BuildContext context) {
    
    TabBar tabNames(){
      return const TabBar (
        tabs: [
        Tab(
          icon: Icon(Icons.cloud_outlined),
          text: 'Graph 1',
        ),
        Tab(
          icon: Icon(Icons.edit_attributes),
          text: 'Graph 2',
        ),
        ],
      );
    }

    return DefaultTabController(
        initialIndex: 1,
        length: 3,
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Graph Displaying',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 22,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        bottom: tabNames(),
        scrolledUnderElevation: 4.0,
        shadowColor: Theme.of(context).shadowColor,
      ),
      drawer: NavigationDrawerWidget(),
      backgroundColor: Color.fromARGB(230, 145, 145, 145),
      body: TabBarView(
        children: <Widget>[
            SingleChildScrollView(
              child: Padding(
                // make scrollable below.
                padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
                child: Column(
                  children: [
                    content1(),
                  ],
                ),
              ),
            ),
            SingleChildScrollView(
              child: Padding(
                // make scrollable below.
                padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
                child: Column(
                  children: [
                    content2()
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

SingleChildScrollView content1() {
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
              child: PieChartSample2(),
              color: Color.fromARGB(255, 255, 255, 255),
            ),
            Container(
              child: BarChartSample6(),
              color: Color.fromARGB(255, 189, 223, 109),
              alignment: Alignment.center,
            ),
            Container(
              child: BarChartSample7(),
              color: Color.fromARGB(255, 63, 128, 118),
            ),
          ],
        ),
      ],
    ),
  );
}
SingleChildScrollView content2() {
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
            Container(
              child: BarChartSample7(),
              color: Color.fromARGB(255, 63, 128, 118),
            ),
          ],
        ),
        Container(
          child: RadarChartSample1(),
          color: Color.fromARGB(255, 129, 134, 177),
        ),
        Container(
          child: BarChartSample2(),
          color: Color.fromARGB(255, 79, 27, 109),
        ),
      ],
    ),
  );
}
