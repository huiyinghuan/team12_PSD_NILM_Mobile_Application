// ignore_for_file: camel_case_types, empty_catches
import 'dart:io';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:l3homeation/models/iot_device.dart';

class Room {
  String? name;
  String URL;
  String credentials;
  int? sectionId;
  int? id;
  bool? isDefault;
  String? icon;
  Map<String, dynamic>? defaultSensors;
  int? defaultThermostat;
  Map<String, dynamic>? meters;
  late List<IoT_Device> devices;
  Map<String, dynamic>? propertiesMap;
  Room(
      {required this.name,
      required this.URL,
      required this.credentials,
      required this.id,
      this.sectionId,
      this.isDefault,
      this.icon,
      this.defaultSensors,
      this.defaultThermostat,
      this.propertiesMap});

  static Future<List<Room>> fetchRooms(String credentials, String URL) async {
    List<Room> rooms = [];
    final response = await http.get(
      Uri.parse('$URL/api/rooms'),
      // Send authorization headers to the backend.
      headers: {
        HttpHeaders.authorizationHeader: 'Basic $credentials',
      },
    );
    List<dynamic> jsonResponses = jsonDecode(response.body);
    for (Map<String, dynamic> responses in jsonResponses) {
      Room newRoom = Room(
          credentials: credentials,
          URL: URL,
          id: responses['id'],
          name: responses['name'],
          sectionId: responses['sectionId'],
          defaultSensors: responses['defaultSensors'],
          defaultThermostat: responses['defaultThermostat'],
          propertiesMap: responses);
      rooms.add(newRoom);
    }
    // print(jsonResponses);
    print(rooms.length);
    return rooms;
  }
}
