// ignore_for_file: non_constant_identifier_names

part of '../../scene_lib.dart';

ListTile bodyAllDeviceRow(List actions, int index, AsyncSnapshot<List<IoT_Device>> snapshot, BuildContext context, IoT_Scene scene, setState, List<bool> isallowedSceneActions) {
  Map stateToChangeTo = {
    'turnOff': 'turnOn',
    'TurnOff': 'TurnOn',
    'close': 'open',
    'unsecure': 'secure',
    'turnOn': 'turnOff',
    'TurnOn': 'TurnOff',
    'open': 'close',
    'secure': 'unsecure',
    null: 'turnOff'
  };
  bool Offoron = (actions[index]['action']) == 'turnOff' ||
          (actions[index]['action']) == 'TurnOff' ||
          (actions[index]['action']) == 'close' ||
          (actions[index]['action']) == 'unsecure'
      ? false
      : true;
  isallowedSceneActions.add(Offoron);

  return ListTile(
    tileColor: (index % 2 == 1) ? AppColors.primary1 : AppColors.primary2,
    title: Text(snapshot.data![index].name!),
    onLongPress: () => {
      if (snapshot.data!.length > 1 && index != 0)
        {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Remove Device'),
                content: Text(
                    'Are you sure you want to remove ${snapshot.data![index].name}?'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      setState(() {
                        Future<Response> changeResponse =
                            scene.removeDevicesFromAction(index);
                        changeResponse.then((value) {
                          if (value.statusCode == 204) {
                            updateScenes(setState);
                            isallowedSceneActions.removeAt(index);
                            removeDeviceFromScene(index, setState);
                            Navigator.pop(context);
                          }
                        });
                      });
                    },
                    child: const Text('Yes'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('No'),
                  ),
                ],
              );
            },
          ),
        }
      else
        {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              if (index == 0) {
                return customInfoDialog(
                    "First Main device is not able to remove from the scene.", context);
              } else {
                return customInfoDialog(
                    "Cannot remove the last device from the scene.", context);
              }
            },
          ),
        }
    },
    trailing: Switch(
      value: isallowedSceneActions[index],
      onChanged: (value) {
        setState(() {
          Future<Response> changeResponse = scene.changeActionState(
            stateToChangeTo[actions[index]['action']],
            index,
          );
          changeResponse.then((value) {
            if (value.statusCode == 204) {
              isallowedSceneActions[index] =
                  !isallowedSceneActions[index];
              updateScenes(setState);
            }
          });
        });
      },
    ),
  );
}

AlertDialog customInfoDialog(String customText, BuildContext context) {
  return AlertDialog(
    title: const Text('Device not Removed'),
    content: Text(customText),
    actions: <Widget>[
      TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text('OK'),
      ),
    ],
  );
}
