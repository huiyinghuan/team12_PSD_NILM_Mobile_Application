// ignore_for_file: camel_case_types

import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "../models/iot_device.dart";

class IoT_Device_Tile extends StatefulWidget {
  final IoT_Device device;
  final void Function()? onTap;
  const IoT_Device_Tile({
    super.key,
    required this.device,
    required this.onTap,
  });
  @override
  State<StatefulWidget> createState() => _IoT_Device_Tile_State();
}

class _IoT_Device_Tile_State extends State<IoT_Device_Tile> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onTap?.call();
      },
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 198, 186, 255),
          borderRadius: BorderRadius.circular(20),
        ),
        // Set constraints to control the size of the tile
        constraints: const BoxConstraints(
          maxHeight: 100, // Adjust the maximum height as needed
          maxWidth: 200, // Adjust the maximum width as needed
          minWidth: 200,
          minHeight: 50,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Device name
            Text(widget.device.name!, style: GoogleFonts.abel(fontSize: 20)),
            // Device image
            // Image.asset('images/placeholder.png', height: 20),
            // Device Status
            SizedBox(
              height: 50, // Adjust the height of the status as needed
              width: 50,
              child: checkType(widget
                  .device.value), // Adjust the width of the status as needed
            ),
          ],
        ),
      ),
    );
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
