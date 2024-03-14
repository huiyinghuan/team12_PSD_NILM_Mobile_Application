part of '../scene_lib.dart';

Row buildImageAndTitle(IoT_Scene scene) {
  return Row(
    children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(0, 5, 20, 5),
        child: Image(
          image: AssetImage(
            scene.icon != null
                ? 'images/icons/${scene.icon}.png'
                : 'images/icons/scene.png',
          ),
          width: 52.10625,
          height: 53.12625,
        ),
      ),
      Text(
        scene.name!, // Replace with your desired title text
        style: const TextStyle(
            fontSize: 15.0), // Customize title text size
      ),
    ],
  );
}
