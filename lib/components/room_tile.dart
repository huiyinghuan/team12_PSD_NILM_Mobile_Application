// ignore_for_file: camel_case_types

import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:l3homeation/models/room.dart";
import "package:l3homeation/themes/colors.dart";

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
      width: screenWidth / 2 + 100, // Half the screen width with padding
      height: 100,
      child: InkWell(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.all(6.0),
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          decoration: BoxDecoration(
            color: AppColors.primary2, // Background color for the whole tile
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max, // To fit the content inside the row
            children: [
              // Change the background color of this container
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 5, 20, 5),
                child: Image(
                  image: AssetImage(
                    room.icon == 'room_baby' ||
                            room.icon == 'room_child2' ||
                            room.icon == 'room_office4' ||
                            room.icon == 'room_toilet'
                        ? 'images/icons/${room.icon}.png'
                        : 'images/icons/room_child2.png',
                  ),
                  width: 52.10625,
                  height: 53.12625,
                ),
              ),
              const SizedBox(
                  width: 8), // Spacing between the indicator and the text
              Text(
                '${room.name}',
                style: GoogleFonts.poppins(
                  fontSize: 16, // You can adjust this value as needed
                  color: Colors.black, // Text color
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
