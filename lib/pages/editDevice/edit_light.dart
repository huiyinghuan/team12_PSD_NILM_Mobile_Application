import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:l3homeation/components/custom_button.dart';
import 'package:l3homeation/models/iot_device.dart';
import 'package:l3homeation/widget/navigation_drawer_widget.dart';
import 'package:l3homeation/services/userPreferences.dart';
import 'package:l3homeation/pages/editDevice/edit_light.dart';

class EditLight extends StatefulWidget {
  @override
  _EditLightState createState() => _EditLightState();
}

class _EditLightState extends State<EditLight> {
  late Future<List<dynamic>> devices = Future.value([]);
  String? auth;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
