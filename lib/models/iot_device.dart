// ignore_for_file: camel_case_types, empty_catches, non_constant_identifier_names, avoid_print
import 'dart:io';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class IoT_Device {
  String? name;
  String? imagePath;
  String? URL;
  String? credentials;
  int? id;
  bool? needSlider;
  dynamic value;
  int? roomId;
  Map<String, dynamic>? propertiesMap;

  IoT_Device({
    required this.name,
    // required this.imagePath,
    required this.URL,
    required this.credentials,
    required this.id,
    required this.needSlider,
    required this.value,
    required this.roomId,
    required this.propertiesMap,
  });
  Future<void> setToTrue() async {
    try {
      Map<String, dynamic>? requestBody = {
        'properties': {
          'value': true,
        },
      };
      await http.put(
        Uri.parse('$URL/devices/$id'),
        headers: {
          HttpHeaders.authorizationHeader: 'Basic $credentials',
        },
        body: jsonEncode(requestBody),
      );
    } catch (e) {
      print("Http put request failed\n");
    }
  }

  Future<void> setToFalse() async {
    try {
      Map<String, dynamic>? requestBody = {
        'properties': {
          'value': false,
        },
      };
      await http.put(
        Uri.parse('$URL/devices/$id'),
        headers: {
          HttpHeaders.authorizationHeader: 'Basic $credentials',
        },
        body: jsonEncode(requestBody),
      );
    } catch (e) {
      print("Http put request failed\n");
    }
  }

  Future<void> setToZero() async {
    try {
      Map<String, dynamic>? requestBody = {
        'properties': {'value': 0},
      };
      await http.put(
        Uri.parse('$URL/devices/$id'),
        headers: {
          HttpHeaders.authorizationHeader: 'Basic $credentials',
        },
        body: jsonEncode(requestBody),
      );
    } catch (e) {
      print("Http put request failed\n");
    }
  }

  Future<void> sendCurrentValue() async {
    try {
      Map<String, dynamic>? requestBody = {
        'properties': {
          'value': value,
        },
      };
      await http.put(
        Uri.parse('$URL/devices/$id'),
        headers: {
          HttpHeaders.authorizationHeader: 'Basic $credentials',
        },
        body: jsonEncode(requestBody),
      );
    } catch (e) {
      print("Http put request failed\n");
    }
  }

  Future<void> swapStates() async {
    try {
      final response = await http.get(
        Uri.parse('$URL/devices/$id'),
        // Send authorization headers to the backend.
        headers: {
          HttpHeaders.authorizationHeader: 'Basic $credentials',
        },
      );
      var jsonResponse = jsonDecode(response.body);
      var onlinevalue = jsonResponse['properties']['value'];
      if (onlinevalue != value) {
        value = onlinevalue;
        return;
      }
    } catch (e) {}
    // ignore: unused_local_variable
    late Response? putRequest;
    try {
      Map<String, dynamic>? requestBody;
      if (value is int) {
        if (value != 0) {
          value = 0;
        } else {
          value = 99;
        }
        requestBody = {
          'properties': {
            'value': value,
          },
        };
      } else if (value is bool) {
        requestBody = {
          'properties': {
            'value': !value,
          },
        };
      } else {
        return;
      }
      putRequest = await http.put(
        Uri.parse('$URL/devices/$id'),
        headers: {
          HttpHeaders.authorizationHeader: 'Basic $credentials',
        },
        body: jsonEncode(requestBody),
      );
    } catch (e) {
      print("Http put request failed\n");
    }
  }

  static Future<List<IoT_Device>> getDevices(
      String credentials, String URL) async {
    List<IoT_Device> devices = [];
    final response = await http.get(
      Uri.parse('$URL/devices/'),
      // Send authorization headers to the backend.
      headers: {
        HttpHeaders.authorizationHeader: 'Basic $credentials',
      },
    );
    List<dynamic> jsonResponses = jsonDecode(response.body);

    for (Map<String, dynamic> response in jsonResponses) {
      if (response['properties'].containsKey('value') &&
          response['visible'] == true) {
        IoT_Device newDevice = IoT_Device(
          id: response['id'],
          URL: URL,
          credentials: credentials,
          name: response['name'],
          value: response['properties']['value'],
          needSlider: response['properties']['value'] is int ? true : false,
          roomId: response['roomID'],
          propertiesMap: response['properties'],
        );

        devices.add(newDevice);
      }
    }
    return devices;
  }

  static Future<List<IoT_Device>> getDevicesByIds(
      String credentials, String URL, List<int?> ids) async {
    List<IoT_Device> devices = [];
    if (ids.isEmpty) {
      return devices;
    } else {
      for (int? id in ids) {
        if (id != null) {
          final response = await http.get(
            Uri.parse('$URL/devices/$id'),
            // Send authorization headers to the backend.
            headers: {
              HttpHeaders.authorizationHeader: 'Basic $credentials',
            },
          );
          dynamic jsonResponses = jsonDecode(response.body);
          if (jsonResponses['properties'].containsKey('value') &&
              jsonResponses['visible'] == true) {
            IoT_Device newDevice = IoT_Device(
              id: jsonResponses['id'],
              URL: URL,
              credentials: credentials,
              name: jsonResponses['name'],
              value: jsonResponses['properties']['value'],
              needSlider:
                  jsonResponses['properties']['value'] is bool ? true : false,
              roomId: jsonResponses['roomID'],
              propertiesMap: jsonResponses['properties'],
            );
            devices.add(newDevice);
          }
        }
      }
      return devices;
    }
  }

  static Future<List<dynamic>> fetchDevices(
      String credentials, String URL) async {
    final response = await http.get(
      Uri.parse('$URL/devices/'),
      // Send authorization headers to the backend.
      headers: {
        HttpHeaders.authorizationHeader: 'Basic $credentials',
      },
    );
    List<dynamic> jsonResponses = jsonDecode(response.body);
    return jsonResponses;
  }
}
