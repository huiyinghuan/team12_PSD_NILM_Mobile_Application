import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:l3homeation/models/iot_device.dart';
import 'package:l3homeation/widget/navigation_drawer_widget.dart';
import 'package:l3homeation/services/varHeader.dart';

import 'list_device_lib.dart';
import 'list_device_shared.dart';

class ListDevice extends StatefulWidget {
  @override
  _ListDeviceState createState() => _ListDeviceState();
}

class _ListDeviceState extends State<ListDevice> {
  @override
  void initState() {
    super.initState();
    loadAuth().then((_) {
      updateDevices();
    });
  }

  Future<void> updateDevices() async {
    if (auth != null) {
      setState(() {
        devices = IoT_Device.get_devices(
          auth!,
          VarHeader.BASEURL,
        );
      });
    }
  }

  void swapper(IoT_Device device, VoidCallback callback) async {
    await device.swapStates();
    if (auth != null) {
      setState(() {
        devices = IoT_Device.get_devices(
          auth!,
          VarHeader.BASEURL,
        );
      });
      callback();
    }
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
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      drawer: NavigationDrawerWidget(),
      body: ListView(
        children: <Widget>[
          buildDeviceList(swapper),
        ],
      ),
    );
  }
}
