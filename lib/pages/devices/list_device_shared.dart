// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:l3homeation/models/iot_device.dart';
import 'package:l3homeation/services/userPreferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<List<dynamic>> devices = Future.value([]);
String? auth;

Future<void> loadAuth() async {
  auth = await User_Preferences.getString('auth');
}
