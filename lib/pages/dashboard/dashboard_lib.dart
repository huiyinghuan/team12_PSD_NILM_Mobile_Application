// dashboard_lib.dart

library dashboard_lib;

import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

import 'package:l3homeation/components/iot_device_tile.dart';
import 'package:l3homeation/models/energy_consumption.dart';
import 'package:l3homeation/pages/charts/power_graph.dart';
import 'package:l3homeation/pages/devices/listDevice.dart';
import 'package:l3homeation/models/iot_device.dart';
import 'package:l3homeation/pages/editDevice/edit_device.dart';
import 'package:l3homeation/services/userPreferences.dart';
import 'package:l3homeation/pages/login/login_page.dart';
import 'dashboard_shared.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:l3homeation/models/energy_consumption.dart';
import 'package:intl/intl.dart';

part 'greeting_section.dart';
part 'device_status_section.dart';
part 'usage_section.dart';
part 'scene_section.dart';
