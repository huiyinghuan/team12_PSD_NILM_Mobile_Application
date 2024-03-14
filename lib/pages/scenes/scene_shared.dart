// ignore_for_file: unused_import

import 'package:l3homeation/models/iot_device.dart';
import 'package:l3homeation/models/iot_scene.dart';
import 'package:l3homeation/services/userPreferences.dart';
import 'package:l3homeation/services/varHeader.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<List<IoT_Scene>> scenes = Future.value([]);
Future<List<IoT_Device>> devices = Future.value([]);
Future<List<IoT_Device>> devices_in_scene = Future.value([]);
String? auth;

Future<void> loadAuth() async {
  auth = await UserPreferences.getString('auth');
}

Future<void> updateScenes(setState) async {
  if (auth != null) {
    var newScenes = await IoT_Scene.get_scenes(
      auth!,
      VarHeader.BASEURL,
    );
    setState(() {
      scenes = Future.value(newScenes);
    });
  }
}

Future<void> updateDevices(setState) async {
  if (auth != null) {
    var newDevices = await IoT_Device.get_devices(
      auth!,
      VarHeader.BASEURL,
    );
    setState(() {
      devices = Future.value(newDevices);
    });
  }
}

Future<void> updateSceneActionDevices(List<int?> id, setState) async {
  if (auth != null) {
    setState(() {
      devices_in_scene = IoT_Device.get_devices_by_ids(
        auth!,
        VarHeader.BASEURL,
        id,
      );
    });
  }
}

Future<void> removeDeviceFromScene(int index, setState) async {
  if (auth != null) {
    setState(() {
      devices_in_scene = devices_in_scene.then((existingDevices) {
        // Remove the device at index from existingDevices
        return existingDevices..removeAt(index);
      });
    });
  }
}

Future<void> addSceneActionDevices(int? id, setState) async {
  if (auth != null) {
    try {
      // Assuming get_devices_by_ids is an async function that returns List<IoT_Device>
      var moreDevices = await IoT_Device.get_devices_by_ids(
        auth!,
        VarHeader.BASEURL,
        [id],
      );

      setState(() {
        devices_in_scene = devices_in_scene.then((existingDevices) {
          // Combine existing devices with moreDevices
          return [...existingDevices, ...moreDevices];
        });
      });
    } catch (error) {
      // Handle any errors from IoT_Device.get_devices_by_ids
      print("Error fetching devices: $error");
    }
  }
}