part of '../scene_lib.dart';

ButtonBar buildButtonAndSwitch(BuildContext context, IoT_Scene scene, bool enableScene, navigateTo, sceneOnOff){
  return ButtonBar(
    children: [
      AnimatedOpacity(
        opacity: enableScene ? 1 : 0.5,
        duration: const Duration(
            seconds: 1), // Customize the duration as needed
        child: Row(
          children: [
            TextButton(
              onPressed: enableScene
                  ? () => navigateTo(eachScene(scene: scene))
                  : null,
              onLongPress: enableScene
                  ? () {
                      customDialog("Click to Edit Scene", context);
                    }
                  : null,
              style: ButtonStyle(
                foregroundColor: enableScene
                    ? MaterialStateProperty.all<Color>(
                        AppColors.secondary1)
                    : MaterialStateProperty.all<Color>(
                        Colors.grey),
              ),
              child: const Icon(Icons.edit),
            ),
            TextButton(
              onPressed: enableScene
                  ? () => scene.activate_scenes()
                  : null,
              onLongPress: enableScene
                  ? () {
                      customDialog("Click to Activate Scene Once", context);
                    }
                  : null,
              child: const Icon(Icons.touch_app)
            ),
          ],
        ),
      ),
      Switch(
        // This bool value toggles the switch.
        value: enableScene,
        activeColor: Colors.green,
        inactiveThumbColor: Colors.red,
        onChanged: (bool value) {
          sceneOnOff(scene);
        },
      ),
    ],
  );
}

void customDialog(String text, BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Padding(
          padding: const EdgeInsets.fromLTRB(
              0, 20, 0, 20), // Add your desired padding values
          child: Center(
            heightFactor: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.info),
                const SizedBox(width: 10),
                Flexible(
                  child: Text(
                    text,
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                    overflow: TextOverflow.visible,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
