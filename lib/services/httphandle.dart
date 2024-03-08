import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  final String baseUrl = 'http://l3homeation.dyndns.org:2080/api';
  final String email;
  final String password;

  AuthService({required this.email, required this.password});

  Future<Map<String, dynamic>> checkLoginStatus(BuildContext context) async {
    var url = Uri.parse('$baseUrl/loginStatus?action=login&tosAccepted=true');
    var response = await http.post(
      url,
      headers: {
        'accept': 'application/json',
        'X-Fibaro-Version': '2',
        'Accept-language': 'en',
        'Authorization':
            'Basic ${base64Encode(utf8.encode('$email:$password'))}',
      },
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      return jsonResponse;
    } else {
      return {'status': false};
    }
  }
}
