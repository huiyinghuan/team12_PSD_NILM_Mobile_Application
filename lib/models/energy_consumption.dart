// ignore_for_file: camel_case_types, non_constant_identifier_names

import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Energy_Consumption {
  String? consumptionKwh;
  String? consumptionCost;
  String? credentials;

  Energy_Consumption({
    required this.consumptionKwh,
    required this.consumptionCost,
    required this.credentials,
  });

  static Future<List<Energy_Consumption>> getEnergyConsumptionSummary(
      String credentials, String URL) async {
    // final year = 2023; for testing
    final year = DateTime.now().year;
    final response = await http.get(
      Uri.parse('$URL/energy/consumption/summary?period=$year'),
      // Send authorization headers to the backend.
      headers: {
        HttpHeaders.authorizationHeader: 'Basic $credentials',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final consumption = data['consumption'].toString();
      final consumptionCost = data['consumptionCost'].toString();
      return [
        Energy_Consumption(
            consumptionKwh: consumption,
            consumptionCost: consumptionCost,
            credentials: credentials)
      ];
    } else {
      throw Exception('Failed to fetch energy consumption data');
    }
  }
}
