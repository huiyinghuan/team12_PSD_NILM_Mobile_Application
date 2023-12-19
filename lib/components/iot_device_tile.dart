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
    return GestureDetector(
      onTap: () {
        // Handle single tap function here
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 180, 176, 176),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            // Device name
            Text(widget.device.name!),
            // Device image
            Image.asset('images/placeholder.png'),
            // Device Status
            SizedBox(
              child: checkType(widget.device.value),
            ),
          ],
        ),
      ),
    );
    // fill in the details needed for the IoT Tile, current state, name, etc...
  }

  Icon checkType(dynamic state) {
    if (state is int) {
      return Icon(
        Icons.circle,
        color: (state != 0) ? Colors.green : Colors.red,
      );
    }
    return Icon(
      Icons.circle,
      color: (state) ? Colors.green : Colors.red,
    );
  }
}
