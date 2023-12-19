// ignore_for_file: camel_case_types

import "dart:convert";
import "dart:io";

import "package:flutter/material.dart";
import "../models/iot_device.dart";
import "../themes/colors.dart";
import "package:http/http.dart" as http;

class dashboard extends StatefulWidget {
  const dashboard({super.key});
  final String name = "Welcome back {Username}";

  @override
  State<dashboard> createState() => _dashboardState();
}

class _dashboardState extends State<dashboard> {
  late Future<List<IoT_Device>> devices;
  @override
  void initState() {
    super.initState();

    setState(() {
      devices = IoT_Device.get_devices(
          base64.encode("admin:Project2023!".codeUnits),
          "http://l3homeation.dyndns.org:2080");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(widget.name),
      ),
      body: Center(
        child: FutureBuilder<List<IoT_Device>>(
            future: devices, builder: futureBuilding),
      ),
    );
  }

  Widget futureBuilding(
      BuildContext context, AsyncSnapshot<List<IoT_Device>> snapshot) {
    if (snapshot.hasData) {
      return Column(
        children: <Widget>[
          for (IoT_Device device in snapshot.data!)
            Text("Device name: ${device.name}"),
          // Text("hello world"),
          // Text("hello 2nd world"),
        ],
      );
    } else {
      return Column(children: <Widget>[
        Text("No Data yet"),
      ]);
    }
  }
}
