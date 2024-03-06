// ignore_for_file: camel_case_types
import 'package:flutter/material.dart';
import 'package:l3homeation/models/energy_consumption.dart';
import 'package:l3homeation/models/iot_device.dart';
import 'package:l3homeation/services/userPreferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

// Change the baseURL into an await.get from preferences
Future<List<IoT_Device>> devices = Future.value([]);
Future<List<Energy_Consumption>> energies = Future.value([]);
String? auth;
String baseURL = "http://l3homeation.dyndns.org:2080";

// Dummy data for devices and usage. Fetch this from backend or service.
const String username = "John Doe";
const int devicesOn = 9;
final Map<String, int> deviceStatus = {
  'Smart Fan': 2,
  'Lights': 2,
};

// Get current date
String currentDate = DateFormat('dd MMMM yyyy').format(DateTime.now());

// Sign out
Future<void> signUserOut(BuildContext context) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.clear();
}

bool checkDeviceValue(IoT_Device device) {
  if (device.value is int) {
    if (device.value > 0) {
      return true;
    }
  }
  return false;
}

Future<void> loadAuth() async {
  auth = await UserPreferences.getString('auth');
}
