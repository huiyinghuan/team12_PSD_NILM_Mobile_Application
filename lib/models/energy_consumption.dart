
import 'dart:io';
import 'package:http/http.dart';
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

  static Future<List<Energy_Consumption>> get_energy_consumption_summary(
      String credentials, String URL) async {
    List<Energy_Consumption> consumption_summary = [];
    // final year = 2023; for testing
    final year = DateTime.now().year;
    final response = await http.get(
      Uri.parse('$URL/api/energy/consumption/summary?period=$year'),
      // Send authorization headers to the backend.
      headers: {
        HttpHeaders.authorizationHeader: 'Basic $credentials',
      },
    );

    // Print the raw JSON response to the console
    // print('Response status: ${response.statusCode}');
    // print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final consumption = data['consumption'].toString();
      final consumptionCost = data['consumptionCost'].toString();
      return [
        Energy_Consumption(consumptionKwh: consumption,
            consumptionCost: consumptionCost,
            credentials: credentials)
      ];
    } else {
      throw Exception('Failed to fetch energy consumption data');
    }
  }
}