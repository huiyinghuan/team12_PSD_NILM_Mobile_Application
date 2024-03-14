// dashboard_main.dart

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:l3homeation/models/iot_scene.dart';
import 'package:l3homeation/models/energy_consumption.dart';
import 'package:l3homeation/models/iot_device.dart';
import 'package:l3homeation/pages/dashboard/dashboard_shared.dart';
import 'package:l3homeation/pages/editDevice/edit_device.dart';
import 'package:l3homeation/widget/base_layout.dart';
import 'package:l3homeation/services/varHeader.dart';

import 'dashboard_lib.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

late Timer dashboardUpdateTimer;
late ScrollController scrollController;

class _DashboardState extends State<Dashboard> {
  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    loadAuth().then((_) async {
      updateDevices();
      fetchEnergy();
      fetchScenes();
      dashboardUpdateTimer =
          Timer.periodic(const Duration(seconds: 5), (timer) {
        updateDevices();
      });
    });
  }

  Future<void> updateDevices() async {
    if (auth != null) {
      setState(() {
        devices = IoT_Device.getDevices(
          auth!,
          Var_Header.BASEURL,
        );
      });
    }
  }

  Future<void> fetchScenes() async {
    if (auth != null) {
      setState(() {
        allScenes = IoT_Scene.getScenes(
          auth!,
          Var_Header.BASEURL,
        );
      });
    }
  }

  Future<void> fetchEnergy() async {
    if (auth != null) {
      setState(() {
        energies = Energy_Consumption.getEnergyConsumptionSummary(
            auth!, Var_Header.BASEURL);
      });
    }
  }

  void turnOnOffDeviceTile(IoT_Device device) async {
    await device.swapStates();
    if (auth != null) {
      setState(() {
        devices = IoT_Device.getDevices(
          auth!,
          Var_Header.BASEURL,
        );
      });
    }
  }

  void adjustDevice(
      BuildContext context, IoT_Device device, Function toggleDeviceState) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Edit_Device_Page(
          device: device,
          onTap: toggleDeviceState,
        ),
      ),
    );
  }

  void sceneSwap(IoT_Scene scene) async {
    await scene.swapStates();
    if (auth != null) {
      setState(() {
        allScenes = IoT_Scene.getScenes(auth!, Var_Header.BASEURL);
      });

      // Scroll to the previous position after updating the UI
      scrollController.animateTo(
        scrollController.position.pixels,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Base_Layout(
      title: 'Dashboard',
      child: ListView(
        controller: scrollController,
        children: <Widget>[
          buildGreetingSection(context),
          buildDeviceStatusSection(
              context, turnOnOffDeviceTile, adjustDevice),
          buildUsageSection(context),
          buildSceneSection(context, sceneSwap),
        ],
      ),
    );
  }

  // remove the timer to stop the crashes
  @override
  void dispose() {
    dashboardUpdateTimer.cancel();
    scrollController.dispose(); // Dispose the ScrollController
    super.dispose();
  }
}
