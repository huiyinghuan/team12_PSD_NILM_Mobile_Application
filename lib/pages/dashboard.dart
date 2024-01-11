// ignore_for_file: camel_case_types

import "dart:async";

import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import 'package:l3homeation/services/userPreferences.dart';
import "../components/iot_device_tile.dart";
import "package:l3homeation/pages/listDevice.dart";
import "../models/iot_device.dart";
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';
import 'package:l3homeation/widget/base_layout.dart';

class dashboard extends StatefulWidget {
  const dashboard({Key? key}) : super(key: key);

  @override
  State<dashboard> createState() => _dashboardState();
}

// Sign out
Future<void> signUserOut(BuildContext context) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.clear();
}

class _dashboardState extends State<dashboard> {
  late Future<List<IoT_Device>> devices = Future.value([]);
  late Timer updateDevicesTimer;
  String? auth;

  @override
  void initState() {
    super.initState();
    loadAuth().then((_) {
      print("Got auth: $auth\n");
      updateDevices();
    });
    // Can be read as initialize devices too --> Naming seems weird only because it usees the exact same function to call for an update
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

  void swapper(IoT_Device device) async {
    print("Tapping device to toggle state\n");
    await device.swapStates();
    if (auth != null) {
      setState(() {
        devices = IoT_Device.get_devices(
          auth!,
          "http://l3homeation.dyndns.org:2080",
        );
      });
    }
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
    return BaseLayout(
      title: 'Dashboard',
      child: ListView(
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
        title: Row(
          children: [
            Expanded(
              child: FutureBuilder<String?>(
                future: UserPreferences.getString('username'),
                builder:
                    (BuildContext context, AsyncSnapshot<String?> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Hi, ',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                color: Colors.deepOrange[800],
                              ),
                            ),
                            TextSpan(
                              text: '${snapshot.data} 👋',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                color: Colors.deepOrange[800],
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  }
                },
              ),
            ),
            IconButton(
              onPressed: () async {
                await signUserOut(context);
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => LoginPage()));
              },
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDeviceStatusSection() {
    final navigateTo =
        (Widget page) => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => page,
            ));

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
                      '${snapshot.data!.where((device) => (device.value == 99 || device.value == true)).length} DEVICES ON',
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 4), // Add spacing between text and icon
                    Container(
                      child: IconButton(
                        icon: const Icon(Icons.add_circle_outline_outlined),
                        onPressed: () => {navigateTo(ListDevice())},
                      ),
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
        ),
      ),
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
          Stack(
            alignment: Alignment.centerRight,
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
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
                      Text(date,
                          style: GoogleFonts.poppins(
                              fontSize: 16, fontWeight: FontWeight.w400)),
                      SizedBox(height: 10),
                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                                text: '$usageKWh',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFFD36E2F),
                                )),
                            TextSpan(
                                text: ' KWh',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                  letterSpacing: 1.0,
                                )),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Text('Cost : \$$cost',
                          style:
                              GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              Positioned(
                right: 25,
                child: Image.asset(
                  'images/lightning.png',
                  width: 100,
                ),
              ),
            ],
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
              Column(
                children: [
                  buildSceneCard(
                      'Kitchen', 'Lights; Fan', '3', 'images/kitchen.png'),
                ],
              ),
              Column(
                children: [
                  buildSceneCard('Bedroom', 'ALL', '4', 'images/bedroom.png'),
                ],
              ),
              // Add more columns as needed
            ],
          ),
        ],
      ),
    );
  }

  Widget buildSceneCard(
      String title, String devices, String count, String imagePath) {
    return Card(
      color: Color.fromRGBO(0, 69, 107, 1),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            //Icon(Icons.kitchen, size: 40), // Change to appropriate icon
            Image(
              image: AssetImage(imagePath),
              width: 52.10625,
              height: 53.12625,
            ),

            SizedBox(height: 10),
            RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                      text: '$count',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(255, 255, 255, 1),
                        letterSpacing: 1.0,
                      )),
                  TextSpan(
                      text: ' · ',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Color.fromRGBO(217, 217, 217, 1),
                      )),
                  TextSpan(
                      text: '$title',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(255, 255, 255, 1),
                        letterSpacing: 1.0,
                      )),
                ],
              ),
            ),
            Text(
              devices,
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
