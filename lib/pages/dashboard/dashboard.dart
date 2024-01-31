// dashboard_main.dart

import 'package:flutter/material.dart';
import 'package:l3homeation/models/iot_device.dart';
import 'package:l3homeation/pages/dashboard/dashboard_shared.dart';
import 'package:l3homeation/widget/base_layout.dart';

import 'dashboard_lib.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  void initState() {
    super.initState();
    loadAuth().then((_) {
      print("Got auth: $auth\n");
      updateDevices();
    });
  }

  Future<void> updateDevices() async {
    if (auth != null) {
      setState(() {
        devices = IoT_Device.get_devices(
          auth!,
          baseURL,
        );
      });
    }
  }

  void turn_on_off_device_tile(IoT_Device device) async {
    print("Tapping device to toggle state\n");
    await device.swapStates();
    if (auth != null) {
      setState(() {
        devices = IoT_Device.get_devices(
          auth!,
          baseURL,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      title: 'Dashboard',
      child: ListView(
        children: <Widget>[
          buildGreetingSection(context),
          buildDeviceStatusSection(context, turn_on_off_device_tile),
          buildUsageSection(context),
          buildSceneSection(context),
        ],
      ),
    );
  }
}
