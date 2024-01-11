import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:l3homeation/components/bar_chart_sample2.dart';
import 'package:l3homeation/components/bar_chart_sample6.dart';
import 'package:l3homeation/components/bar_chart_sample7.dart';
import 'package:l3homeation/components/chart_sample.dart';
import 'package:l3homeation/components/line_chart_sample10.dart';
import 'package:l3homeation/components/line_chart_sample2.dart';
import 'package:l3homeation/components/pie_chart_sample2.dart';
import 'package:l3homeation/components/radar_chart_sample1.dart';
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

  @override
  void initState() {
    super.initState();
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
    return Scaffold(
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
      ),
      drawer: NavigationDrawerWidget(),
      backgroundColor: Color.fromARGB(230, 145, 145, 145),
      body:ListView(
        children: [
          // GridView.count
          GridView.count(
            crossAxisCount: 1,
            childAspectRatio: 1,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(), // Disable scrolling for the inner GridView
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
              Container(
                child: BarChartSample2(),
                color: Color.fromARGB(255, 79, 27, 109),
              ),
              Container(
                child: PieChartSample2(),
                color: Color.fromARGB(255, 206, 107, 140),
              ),
            ],
          ),
          // Container outside of GridView
          Container(
            child: RadarChartSample1(),
            color: Color.fromARGB(255, 129, 134, 177),
          ),
        ],
      ),
    );
  }
}
