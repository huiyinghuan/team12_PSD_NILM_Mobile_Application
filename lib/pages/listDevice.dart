import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:l3homeation/components/iot_device_tile.dart';
import 'package:l3homeation/models/iot_device.dart';
import 'package:l3homeation/themes/colors.dart';
import 'package:l3homeation/widget/base_layout.dart';
import 'package:l3homeation/widget/navigation_drawer_widget.dart';

class ListDevice extends StatefulWidget {
  @override
  _ListDeviceState createState() => _ListDeviceState();
}

class _ListDeviceState extends State<ListDevice> {
  late Future<List<dynamic>> devices;

  @override
  void initState() {
    super.initState();

    updateDevices(); // Can be read as initialize devices too --> Naming seems weird only because it usees the exact same function to call for an update
    // updateDevicesTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
    //   updateDevices();
    // });
    // ^ Implement the timer back once we figure out how to make the rebuilding of the device status' more smooth
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'All Devices',
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
          _buildDeviceList(),
        ],
      ),
    );
  }
  
  // Assuming that devices is a List<IoT_Device>
  List<ExpansionTile> buildExpansionTiles(List<dynamic> devices) {
    return devices.map((device) {
      print(device.propertiesMap); 
      String descriptionDevice = device.propertiesMap["userDescription"];
      if (descriptionDevice == "") {
        descriptionDevice = "No description given";
      }
      List<dynamic> categoriesDevice = device.propertiesMap["categories"];
      dynamic valueDevice = device.propertiesMap["value"];
      if (categoriesDevice.contains("blinds")) {
        valueDevice = 'Open ' + valueDevice.toString() + '%';
      } else if (categoriesDevice.contains("security")) {
        if (valueDevice == false) {
          valueDevice = 'Unlocked';
        } else {
          valueDevice = 'Locked';
        }
      }
      else if (valueDevice == 99 || valueDevice == true) {
        valueDevice = 'On';
      } else if (valueDevice == 0 || valueDevice == false){
        valueDevice = 'Off';
      } else {
        valueDevice = valueDevice.toString();
      }
      String categoriesString = categoriesDevice.join(", "); // Convert list to a single string separated by commas
      
      return ExpansionTile(
        title: Text(
          device.name, // Replace with your desired title text
          style: TextStyle(fontSize: 18.0), // Customize title text size
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0), // Adjust padding as needed
            child: Row(
              children: [
                Flexible(
                  child: RichText(
                    text: TextSpan(
                      text: 'Status: ',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                      ),
                      children: [
                        TextSpan(
                          text: valueDevice.toString() + '\n\n',
                          style: TextStyle(
                            color: (valueDevice == 'Off' || valueDevice == 'Unlocked') ? Colors.red : Colors.green,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        TextSpan(
                          text: 'Description Given: \n',
                          // style: TextStyle(
                          //   color: Colors.black,
                          //   fontSize: 14.0,
                          // ),
                        ),
                        TextSpan(
                          text: descriptionDevice + '\n\n',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        TextSpan(
                          text: 'Category Chosen: '
                        ),
                        TextSpan(
                          text: categoriesString,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Switch(
                    // This bool value toggles the switch.
                    value: (valueDevice == 'Off' || valueDevice == 'Unlocked') ? false : true,
                    activeColor: Colors.green,
                    inactiveThumbColor: Colors.red,
                    onChanged: (bool value) {
                      swapper(device);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }).toList();
  }


  // a container that holds the list of devices 
  Container _buildDeviceList() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0),
      child: FutureBuilder<List<dynamic>>(
        future: devices,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 8),
                Column(
                  children: buildExpansionTiles(snapshot.data!),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return Center(
            child: CircularProgressIndicator(
              color: Color(0xFFD36E2F),
            ),
          );
        },
      ),
    );
  }
}