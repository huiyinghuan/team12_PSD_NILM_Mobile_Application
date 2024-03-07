// dashboard_main.dart

import 'dart:async';

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:l3homeation/models/energy_consumption.dart';
import 'package:l3homeation/models/iot_device.dart';
import 'package:l3homeation/pages/charts/power_graph.dart';
import 'package:l3homeation/pages/dashboard/dashboard_shared.dart';
import 'package:l3homeation/pages/devices/listDevice.dart';
import 'package:l3homeation/pages/editDevice/edit_device.dart';
import 'package:l3homeation/widget/base_layout.dart';
import 'package:l3homeation/pages/editDevice/edit_device.dart';

import 'dashboard_lib.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

late Timer dashboardUpdateTimer;

// updateDevicesTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
//   updateDevices();
// });
// ^ Implement the timer back once we figure out how to make the rebuilding of the device status' more smooth
class _DashboardState extends State<Dashboard> {
  late Timer updateDevicesTimer;

  @override
  void initState() {
    super.initState();
    loadAuth().then((_) {
      print("Got auth: $auth\n");
      updateDevices();
      fetchEnergy();
      dashboardUpdateTimer =
          Timer.periodic(const Duration(seconds: 5), (timer) {
        updateDevices();
      });
      updateDevicesTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
        updateDevices();
      });
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

  Future<void> fetchEnergy() async {
    if (auth != null) {
      setState(() {
        energies =
            Energy_Consumption.get_energy_consumption_summary(auth!, baseURL);
      });
    }
  }

  void turn_on_off_device_tile(IoT_Device device, Function callback) async {
    print("Tapping device to toggle state\n");
    await device.swapStates();
    if (auth != null) {
      setState(() {
        devices = IoT_Device.get_devices(
          auth!,
          baseURL,
        );
      });
      callback();
    }
  }

  void adjustDevice(
      BuildContext context, IoT_Device device, Function toggleDeviceState) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditDevicePage(
          device: device,
          onTap: toggleDeviceState,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      title: 'Dashboard',
      child: ListView(
        children: <Widget>[
          buildGreetingSection(context),
          buildDeviceStatusSection(
              context, turn_on_off_device_tile, adjustDevice),
          buildUsageSection(context),
          buildSceneSection(context),
        ],
      ),
    );
  }

  // remove the timer to stop the crashes
  @override
  void dispose() {
    dashboardUpdateTimer.cancel();
    super.dispose();
  }
}
