// ignore_for_file: camel_case_types

import "package:flutter/material.dart";
import "../models/iot_device.dart";

class IoT_Device_Tile extends StatefulWidget {
  final IoT_Device device;
  const IoT_Device_Tile({super.key, required this.device});
  @override
  State<StatefulWidget> createState() => _IoT_Device_Tile_State();
}

class _IoT_Device_Tile_State extends State<IoT_Device_Tile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
    // fill in the details needed for the IoT Tile, current state, name, etc...
  }
}
