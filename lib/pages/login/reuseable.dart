import 'package:flutter/material.dart';
import 'package:l3homeation/components/square_tile.dart';

Text displayTitle(String title) {
  return Text(
    title,
    style: const TextStyle(
      color: Color.fromRGBO(0, 0, 0, 1),
      fontSize: 30,
      fontWeight: FontWeight.w900,
    ),
  );
}

SquareTile displayLogo() {
  return const SquareTile(imagePath: 'images/l3homeation.png');
}
