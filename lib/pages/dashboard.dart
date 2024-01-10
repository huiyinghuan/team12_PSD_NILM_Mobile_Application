import "dart:convert";

import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "../components/iot_device_tile.dart";
import "../models/iot_device.dart";
import "../themes/colors.dart";
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';

class dashboard extends StatefulWidget {
  const dashboard({super.key});

  @override
  State<dashboard> createState() => _dashboardState();
}

// Sign out
Future<void> signUserOut(BuildContext context) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.clear();
}

// Load data
Future<String?> loadData(String key) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(key);
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
        actions: [
          IconButton(
            onPressed: () async {
              await signUserOut(context);
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginPage()));
            },
            icon: const Icon(Icons.logout),
          )
        ],
        backgroundColor: primaryColor,
        title: FutureBuilder<String?>(
          future: loadData('username'),
          builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return Text('Welcome ${snapshot.data}',
                    style: const TextStyle(fontSize: 20));
              }
            }
          },
        ),
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
