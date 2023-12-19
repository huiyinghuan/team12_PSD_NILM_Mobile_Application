// ignore_for_file: camel_case_types, empty_catches
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
  dynamic value;

  IoT_Device({
    required this.name,
    // required this.imagePath,
    required this.URL,
    required this.credentials,
    required this.id,
    required this.value,
  });

  Future<void> swapStates() async {
    try {
      final response = await http.get(
        Uri.parse('$URL/api/devices/$id'),
        // Send authorization headers to the backend.
        headers: {
          HttpHeaders.authorizationHeader: 'Basic $credentials',
        },
      );
      var jsonResponse = jsonDecode(response.body);
      value = jsonResponse['properties']['value'];
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
        Uri.parse('$URL/api/devices/$id'),
        headers: {
          HttpHeaders.authorizationHeader: 'Basic $credentials',
        },
        body: jsonEncode(requestBody),
      );
    } catch (e) {}
  }

  static Future<List<IoT_Device>> get_devices(
      String credentials, String URL) async {
    List<IoT_Device> devices = [];
    final response = await http.get(
      Uri.parse('$URL/api/devices/'),
      // Send authorization headers to the backend.
      headers: {
        HttpHeaders.authorizationHeader: 'Basic $credentials',
      },
    );
    List<dynamic> jsonResponses = jsonDecode(response.body);
    for (Map<String, dynamic> response in jsonResponses) {
      if (response['properties'].containsKey('value') &&
          response['visible'] == true) {
        IoT_Device new_device = IoT_Device(
          id: response['id'],
          URL: URL,
          credentials: credentials,
          name: response['name'],
          value: response['properties']['value'],
        );
        devices.add(new_device);
      }
    }
    return devices;
  }

  static Future<List<dynamic>> fetchDevices(
      String credentials, String URL) async {
    final response = await http.get(
      Uri.parse('$URL/api/devices/'),
      // Send authorization headers to the backend.
      headers: {
        HttpHeaders.authorizationHeader: 'Basic $credentials',
      },
    );
    List<dynamic> jsonResponses = jsonDecode(response.body);
    return jsonResponses;
  }
}
