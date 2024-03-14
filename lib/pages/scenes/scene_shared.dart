// ignore_for_file: unused_import

import 'package:l3homeation/models/iot_device.dart';
import 'package:l3homeation/models/iot_scene.dart';
import 'package:l3homeation/services/userPreferences.dart';
import 'package:l3homeation/services/varHeader.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<List<IoT_Scene>> scenes = Future.value([]);
Future<List<IoT_Device>> devices = Future.value([]);
Future<List<IoT_Device>> devicesInScene = Future.value([]);
String? auth;

Future<void> loadAuth() async {
  auth = await User_Preferences.getString('auth');
}

Future<void> updateScenes(setState) async {
  if (auth != null) {
    var newScenes = await IoT_Scene.getScenes(
      auth!,
      Var_Header.BASEURL,
    );
    setState(() {
      scenes = Future.value(newScenes);
    });
  }
}

Future<void> updateDevices(setState) async {
  if (auth != null) {
    var newDevices = await IoT_Device.getDevices(
      auth!,
      Var_Header.BASEURL,
    );
    setState(() {
      devices = Future.value(newDevices);
    });
  }
}

Future<void> updateSceneActionDevices(List<int?> id, setState) async {
  if (auth != null) {
    setState(() {
      devicesInScene = IoT_Device.getDevicesByIds(
        auth!,
        Var_Header.BASEURL,
        id,
      );
    });
  }
}

Future<void> removeDeviceFromScene(int index, setState) async {
  if (auth != null) {
    setState(() {
      devicesInScene = devicesInScene.then((existingDevices) {
        // Remove the device at index from existingDevices
        return existingDevices..removeAt(index);
      });
    });
  }
}

Future<void> addSceneActionDevices(int? id, setState) async {
  if (auth != null) {
    try {
      // Assuming getDevicesByIds is an async function that returns List<IoT_Device>
      var moreDevices = await IoT_Device.getDevicesByIds(
        auth!,
        Var_Header.BASEURL,
        [id],
      );

      setState(() {
        devicesInScene = devicesInScene.then((existingDevices) {
          // Combine existing devices with moreDevices
          return [...existingDevices, ...moreDevices];
        });
      });
    } catch (error) {
      // Handle any errors from IoT_Device.getDevicesByIds
      print("Error fetching devices: $error");
    }
  }
}