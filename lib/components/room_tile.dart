// ignore_for_file: camel_case_types

import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:l3homeation/models/room.dart";
import "../models/iot_device.dart";

class Room_Tile extends StatelessWidget {
  final Room room;
  final VoidCallback onTap;
  final double textSize; // Add a parameter for text size

  const Room_Tile({
    Key? key,
    required this.room,
    required this.onTap,
    this.textSize = 12,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      width: screenWidth / 2 - 12, // Half the screen width with padding
      height: 100,
      child: InkWell(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.all(6.0),
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          decoration: BoxDecoration(
            color: Colors.white, // Background color for the whole tile
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min, // To fit the content inside the row
            children: [
              // Change the background color of this container

              SizedBox(width: 8), // Spacing between the indicator and the text
              Text(
                '${room.name}',
                style: GoogleFonts.poppins(
                  fontSize: 16, // You can adjust this value as needed
                  color: Colors.black, // Text color
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
