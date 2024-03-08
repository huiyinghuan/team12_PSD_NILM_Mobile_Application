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
    final Color indicatorColor = (device.value != 0 && device.value != false)
        ? Colors.green
        : Colors.red;
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          children: [
            SizedBox(
              width: ((MediaQuery.of(context).size.width) / 2 - 30),
              child: Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color:
                      getBackGroundColor(), // Background color for the whole tile
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    activityStatus(indicatorColor),
                    SizedBox(width: 5.0),
                    Expanded(child: displayDeviceName()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Text displayDeviceName() {
    return Text(
      textAlign: TextAlign.start,
      '${truncateString(device.name!, 11)} ${determineActivity(device)}',
      style: GoogleFonts.poppins(
        fontSize: textSize, // Use the text size parameter
        color: Colors.black, // Text color
      ),
    );
  }

  Color getBackGroundColor() {
    if (device.value != 0 && device.value != false) {
      return const Color.fromARGB(255, 241, 177, 81);
    }
    return Color.fromARGB(255, 240, 230, 188);
  }

  String determineActivity(device) {
    if (device.value is int) {
      if (device.value != 0) {
        return "Active";
      } else {
        return "Inactive";
      }
    } else if (device.value is bool) {
      if (device.value) return "Active";
    }
    return "Inactive";
  }

  String truncateString(String input, int toLength) {
    if (input.length > toLength) {
      // If the string is longer than 15 characters
      return input.substring(0, toLength - 2) +
          ".."; // Extract first 13 characters and append ".."
    } else {
      // If the string is 15 characters or less
      return input; // Return the original string
    }
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
