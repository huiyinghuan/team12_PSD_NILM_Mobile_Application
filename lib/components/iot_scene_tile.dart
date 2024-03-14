// ignore_for_file: camel_case_types

import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:l3homeation/models/iot_scene.dart";

class IoT_Scene_Tile extends StatelessWidget {
  final IoT_Scene scene;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final int count;
  const IoT_Scene_Tile({
    Key? key,
    required this.scene,
    required this.onTap,
    required this.count,
    this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        onLongPress: onLongPress != null ? onLongPress : () => {},
        child: buildSceneCard(context));
  }

  Widget buildSceneCard(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final tileWidth =
        (screenWidth - 32.0 - 16.0) / 2; // Adjust padding and spacing as needed

    return SizedBox(
      width:
          tileWidth, // Make the card width half of the screen width minus padding
      child: Card(
        color: Color.fromRGBO(61, 165, 221, 1),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Image(
                image: AssetImage(
                  scene.icon != null
                      ? 'images/icons/${scene.icon}.png'
                      : 'images/icons/scene.png',
                ),
                width: 52.10625,
                height: 53.12625,
              ),
              SizedBox(height: 10),
              RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: '$count',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(255, 255, 255, 1),
                        letterSpacing: 1.0,
                      ),
                    ),
                    const TextSpan(
                      text: ' · ',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Color.fromRGBO(217, 217, 217, 1),
                      ),
                    ),
                    TextSpan(
                      text: '${scene.name}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(255, 255, 255, 1),
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                scene.enable ? "On" : "Off",
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
