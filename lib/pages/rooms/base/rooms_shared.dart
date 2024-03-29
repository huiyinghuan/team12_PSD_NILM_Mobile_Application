// ignore_for_file: camel_case_types
import 'package:flutter/material.dart';
import 'package:l3homeation/models/iot_device.dart';
import 'package:l3homeation/models/room.dart';
import 'package:l3homeation/services/userPreferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Change the baseURL into an await.get from preferences
Future<List<Room>> rooms = Future.value([]);
String? auth;
String baseURL = "http://l3homeation.dyndns.org:2080";

Future<void> loadAuth() async {
  auth = await UserPreferences.getString('auth');
}
