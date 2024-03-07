import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class NILM_appliance {
  String? name;
  double? power_kW;
  bool? running;
  String? timestamp;
  double? total_consumption;

  NILM_appliance(
      {required this.name,
      required this.power_kW,
      required this.running,
      required this.timestamp,
      required this.total_consumption});

  static Future<List<NILM_appliance>> get_appliances(
      String credentials, String URL) async {
    List<NILM_appliance> appliances = [];

    final response = await http.get(
      Uri.parse('$URL/api'),
      headers: {
        HttpHeaders.authorizationHeader: 'Basic $credentials',
      },
    );
    Map<String, dynamic> jsonResponses = jsonDecode(response.body);

    for (dynamic appliance in jsonResponses['appliances']) {
      NILM_appliance newAppliance = NILM_appliance(
          name: appliance['name'],
          power_kW: appliance['power_kW'],
          running: appliance['running'],
          timestamp: convertToTimestamp(jsonResponses['timestamp']),
          total_consumption: jsonResponses['total_consumption_kW']);
      appliances.add(newAppliance);
    }
    return appliances;
  }

  static String convertToTimestamp(String jsonTimestamp) {
    DateTime dateTime = DateTime.parse(jsonTimestamp).toLocal();

    String formattedTimestamp =
        DateFormat('d MMM yyyy hh:mm a').format(dateTime);

    return formattedTimestamp; // Output: 2 Mar 2024 02:30 PM
  }
}
