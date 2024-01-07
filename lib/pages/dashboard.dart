// ignore_for_file: camel_case_types

import "dart:convert";
import "dart:io";

import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:l3homeation/components/iot_device_tile.dart";
import "package:l3homeation/pages/placeholder.dart";
import "../models/iot_device.dart";
import "../themes/colors.dart";
import "package:http/http.dart" as http;
import 'package:l3homeation/provider/navigation_provider.dart';
import 'package:l3homeation/widget/navigation_drawer_widget.dart';
import 'package:provider/provider.dart';
import 'package:l3homeation/models/iot_device.dart';
import 'dart:convert';

class dashboard extends StatefulWidget {
  const dashboard({Key? key}) : super(key: key);

  @override
  State<dashboard> createState() => _dashboardState();
}

class _dashboardState extends State<dashboard> {
  late Future<List<IoT_Device>> devices;

  @override
  void initState() {
    super.initState();

    updateDevices();
  }

  Future<void> updateDevices() async {
    setState(() {
      devices = IoT_Device.get_devices(
        base64.encode("admin:Project2023!".codeUnits),
        "http://l3homeation.dyndns.org:2080",
      );
    });
  }

  void swapper(IoT_Device device) async {
    print("Tapping device to toggle state\n");
    await device.swapStates();
    // After swapping state, fetch devices again and rebuild UI.
    setState(() {
      devices = IoT_Device.get_devices(
        base64.encode(utf8.encode("admin:Project2023!")),
        "http://l3homeation.dyndns.org:2080",
      );
    });
  }

  // Dummy data for devices and usage. Fetch this from backend or service.
  final String username = "John Doe";
  final int devicesOn = 9;
  final Map<String, int> deviceStatus = {
    'Smart Fan': 2,
    'Lights': 2,
  };
  final String date = '17 Dec 2022';
  final int usageKWh = 450;
  final int cost = 100;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Dashboard',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 22,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      drawer: NavigationDrawerWidget(),
      body: ListView(
        children: <Widget>[
          buildGreetingSection(),
          buildDeviceStatusSection(),
          buildUsageSection(),
          buildSceneSection(),
        ],
      ),
    );
  }

  Widget buildGreetingSection() {
    return Container(
      color: Colors.grey[200],
      child: ListTile(
        leading: CircleAvatar(child: Icon(Icons.person)),
        title: Text('Hi, $username 👋',
            style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange[800])),
        subtitle: Text('Welcome Back'),
      ),
    );
  }

  Widget buildDeviceStatusSection() {
    return Container(
      color: Colors.grey[200],
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: FutureBuilder<List<IoT_Device>>(
        future: devices,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: [
                    Text(
                      '${snapshot.data!.where((device) => device.value != 0).length} DEVICES ON',
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 4), // Add spacing between text and icon
                    Icon(
                      Icons.add_circle_outline_sharp,
                      color: Colors.black,
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: snapshot.data!
                      .map((device) => IoT_Device_Tile(
                            device: device,
                            onTap: () => swapper(device),
                          ))
                      .toList(),
                ),
              ],
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            return Text(
              'Failed to load devices',
              style: GoogleFonts.poppins(fontSize: 18, color: Colors.grey[600]),
            );
          }
        },
      ),
    );
  }

  Widget buildUsageSection() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(40),
            bottomRight: Radius.circular(40),
          )),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text('Usage',
                style: GoogleFonts.poppins(
                    fontSize: 12, fontWeight: FontWeight.bold)),
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFB1F4CF), // Start color of the gradient
                  Color(0xFF9890E3), // End color of the gradient
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 4,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(date, style: GoogleFonts.poppins(fontSize: 16)),
                  SizedBox(height: 10),
                  RichText(
                    text: TextSpan(
                      style: GoogleFonts.poppins(fontSize: 24),
                      children: <TextSpan>[
                        TextSpan(
                            text: '$usageKWh',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFD36E2F))),
                        TextSpan(
                            text: ' KWh',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Text('Cost : \$$cost',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSceneSection() {
    // For now, using static data and cards
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Scene',
            style:
                GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Wrap(
            spacing: 10,
            children: <Widget>[
              buildSceneCard('Kitchen', 'Lights; Fan', '3'),
              buildSceneCard('Bedroom', 'ALL', '4'),
              // Add more cards here
            ],
          ),
        ],
      ),
    );
  }

  Widget buildSceneCard(String title, String devices, String count) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Icon(Icons.kitchen, size: 40), // Change to appropriate icon
            Text(
              '$count · $title',
              style: GoogleFonts.poppins(),
            ),
            Text(
              devices,
              style: GoogleFonts.poppins(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}
