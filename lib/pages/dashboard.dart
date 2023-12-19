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

  // void navigateToPlaceholder(){
  //   Navigator.push(context, MaterialPageRoute(builder: (context) => ))
  // }
  void swapper(IoT_Device device) async {
    print("Tapped\n");
    await device.swapStates(); // Wait for the swapStates operation to complete
    updateDevices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(widget.name),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment
            .start, // Override this to shift everything else elsewhere
        children: [
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.only(
                left: 16), // Adjust the left padding as needed
            child: Text(
              'Paired Devices',
              style: GoogleFonts.abel(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 10),
          FutureBuilder<List<IoT_Device>>(
              future: devices, builder: futureBuilding),
          const SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget futureBuilding(
      BuildContext context, AsyncSnapshot<List<IoT_Device>> snapshot) {
    if (snapshot.hasData) {
      return Container(
        height: 150, // Set the desired height for each tile
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) => Container(
            margin: EdgeInsets.symmetric(
                horizontal: 8), // Add some margin for spacing between tiles
            child: IoT_Device_Tile(
              device: snapshot.data![index],
              onTap: () => swapper(snapshot.data![index]),
            ),
          ),
        ),
      );
    } else {
      return const Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 100),
          ),
          SizedBox(
            width: 60,
            height: 60,
            child: CircularProgressIndicator(),
          ),
          Padding(
            padding: EdgeInsets.only(top: 100),
            child: Text('Awaiting result...'),
          ),
        ],
      );
    }
  }
}
