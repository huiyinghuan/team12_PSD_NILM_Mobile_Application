// ignore_for_file: unused_import

import 'package:l3homeation/models/iot_device.dart';
import 'package:l3homeation/models/iot_scene.dart';
import 'package:l3homeation/services/userPreferences.dart';
import 'package:l3homeation/services/varHeader.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<List<IoT_Scene>> scenes = Future.value([]);
Future<List<IoT_Device>> devices = Future.value([]);
String? auth;

Future<void> loadAuth() async {
  auth = await UserPreferences.getString('auth');
}

