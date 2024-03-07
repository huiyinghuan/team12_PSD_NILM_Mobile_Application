// ignore_for_file: camel_case_types

import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "../models/iot_device.dart";

class IoT_Device_Tile extends StatelessWidget {
  final IoT_Device device;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final double textSize; // Add a parameter for text size

  const IoT_Device_Tile({
    Key? key,
    required this.device,
    required this.onTap,
    this.onLongPress,
    this.textSize = 12,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // To determine the background color based on the device's active state
    final Color indicatorColor = (device.value != 0 && device.value != false)
        ? Colors.green
        : Colors.red;

    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 2.0),
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        decoration: BoxDecoration(
          color: Colors.white, // Background color for the whole tile
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min, // To fit the content inside the row
          children: [
            // Change the background color of this container
            activityStatus(indicatorColor),
            SizedBox(width: 8), // Spacing between the indicator and the text
            Text(
              '${device.name} ${device.value != 0 ? "Active" : "Inactive"}',
              style: GoogleFonts.poppins(
                fontSize: textSize, // Use the text size parameter
                color: Colors.black, // Text color
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container activityStatus(Color indicatorColor) {
    return Container(
      height: 12.0, // Size of the circle
      width: 12.0, // Size of the circle
      decoration: BoxDecoration(
        color: indicatorColor, // Use the indicator color
        shape: BoxShape.circle,
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
