part of '../scene_lib.dart';

ListView buildSecondTab(IoT_Scene scene, setState, List<bool> isallowedSceneActions) {
    List<int> collatedDeviceIds = [];
    List actions = jsonDecode(scene.content)[0]['actions'];
    for (var action in actions) {
      if (action['group'] == 'device') {
        collatedDeviceIds.add(action['id']);
      }
    }
    updateSceneActionDevices(collatedDeviceIds, setState);
    return ListView(
      scrollDirection: Axis.vertical,
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: contentTopHeader(),
        ),
        contentBodyDevices(actions, scene, setState, isallowedSceneActions)
      ],
    );
  }
