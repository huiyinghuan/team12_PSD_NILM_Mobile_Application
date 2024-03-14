import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class NILM_Appliance {
  String? name;
  double? powerKiloWatt;
  bool? running;
  String? timestamp;
  double? totalConsumption;

  NILM_Appliance(
      {required this.name,
      required this.powerKiloWatt,
      required this.running,
      required this.timestamp,
      required this.totalConsumption});

  static Future<List<NILM_Appliance>> getAppliances(
      String credentials, String URL) async {
    List<NILM_Appliance> appliances = [];

    final response = await http.get(
      Uri.parse(URL),
      headers: {
        HttpHeaders.authorizationHeader: 'Basic $credentials',
      },
    );
    Map<String, dynamic> jsonResponses = jsonDecode(response.body);
    print(jsonResponses);

    for (dynamic appliance in jsonResponses['appliances']) {
      NILM_Appliance newAppliance = NILM_Appliance(
          name: appliance['name'],
          powerKiloWatt: appliance['powerKiloWatt'],
          running: appliance['running'],
          timestamp: convertToTimestamp(jsonResponses['timestamp']),
          totalConsumption: jsonResponses['total_consumption_kW']);
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
