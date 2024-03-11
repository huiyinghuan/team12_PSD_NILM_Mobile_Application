import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:l3homeation/models/IoT_Scene.dart';
import 'package:l3homeation/models/iot_device.dart';
import 'package:l3homeation/pages/scenes/eachScene.dart';
import 'package:l3homeation/themes/colors.dart';
import 'package:l3homeation/widget/navigation_drawer_widget.dart';
import 'package:l3homeation/services/userPreferences.dart';

class listScenes extends StatefulWidget {
  @override
  _listScenesState createState() => _listScenesState();
}

class _listScenesState extends State<listScenes> {
  late Future<List<IoT_Scene>> scenes = Future.value([]);
  late Future<List<IoT_Device>> devices = Future.value([]);
  String? auth;
  late Timer dashboardUpdateTimer;

  @override
  void initState() {
    super.initState();
    loadAuth().then((_) {
      updateScenes();
      updateDevices();

      dashboardUpdateTimer =
          Timer.periodic(const Duration(seconds: 5), (timer) {
        updateScenes();
      });
    });
  }

  @override
  void dispose() {
    dashboardUpdateTimer.cancel();
    super.dispose();
  }

  Future<void> loadAuth() async {
    auth = await UserPreferences.getString('auth');
  }

  Future<void> updateScenes() async {
    if (auth != null) {
      setState(() {
        scenes = IoT_Scene.get_scenes(
          auth!,
          "http://l3homeation.dyndns.org:2080",
        );
      });
    }
  }

  Future<void> updateDevices() async {
    if (auth != null) {
      setState(() {
        devices = IoT_Device.get_devices(
          auth!,
          "http://l3homeation.dyndns.org:2080",
        );
      });
    }
  }

  void swapper(IoT_Scene scene) async {
    await scene.swapStates();
    if (auth != null) {
      setState(() {
        scenes = IoT_Scene.get_scenes(
          auth!,
          "http://l3homeation.dyndns.org:2080",
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    navigateTo(Widget page) => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => page,
        ));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'All scenes',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 22,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      drawer: NavigationDrawerWidget(),
      body: ListView(
        children: <Widget>[
          _buildSceneList(
              navigateTo), //passing the navigateTo function to buildExpansionTiles
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              String name = '';
              String description = '';

              IoT_Device selectedDevice = IoT_Device(
                name: '',
                URL: '',
                credentials: '',
                id: 0,
                needSlider: false,
                value: 0,
                propertiesMap: {},
                roomId: 0,
              );
              late var buttonpressed = (selectedDevice.id == null ||
                  name == '' ||
                  description == '');
              return AlertDialog(
                title: const Text('New Scene'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      onChanged: (value) {
                        name = value;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Name',
                      ),
                    ),
                    TextField(
                      onChanged: (value) {
                        description = value;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Description',
                      ),
                    ),
                    FutureBuilder<List<IoT_Device>>(
                      future: devices,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<IoT_Device> devices = snapshot.data!;
                          return DropdownButtonFormField<IoT_Device>(
                            decoration: const InputDecoration(
                              labelText: 'Select a device',
                              hintText: 'Choose a device',
                            ),
                            items: [
                              const DropdownMenuItem<IoT_Device>(
                                value: null,
                                child: Text('Choose a Main device'),
                              ),
                              ...devices.map((IoT_Device device) {
                                return DropdownMenuItem<IoT_Device>(
                                  value: device,
                                  child: Text(device.name!),
                                );
                              }),
                            ],
                            onChanged: (IoT_Device? select) {
                              // Handle selected device
                              if (select != null) {
                                selectedDevice = select;
                              }
                            },
                          );
                        } else if (snapshot.hasError) {
                          return const Text('Error loading devices');
                        } else {
                          return const CircularProgressIndicator();
                        }
                      },
                    ),
                  ],
                ),
                actions: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (buttonpressed) {
                        Navigator.of(context).pop();
                        return;
                      }
                      var action = (selectedDevice.value.runtimeType == bool)
                          ? "close"
                          : "turnOff";
                      // Add logic to save the new scene with the provided name and description
                      IoT_Scene.post_new_scene(
                        name,
                        description,
                        "[{\"conditions\":{\"operator\":\"all\",\"conditions\":[]},\"actions\":[{\"group\":\"device\",\"type\":\"single\",\"id\":${selectedDevice.id},\"action\":\"$action\",\"args\":[]}]}]",
                        'scene',
                        auth!,
                        "http://l3homeation.dyndns.org:2080",
                      ).then((response) {
                        updateScenes();
                        setState(() {});
                      });
                      Navigator.of(context).pop();
                    },
                    child: const Text('Save'),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  // a container that holds the list of scenes
  Container _buildSceneList(navigateTo) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0),
      child: FutureBuilder<List<IoT_Scene>>(
        future: scenes,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                  children: [
                    ...buildExpansionTiles(snapshot.data!, navigateTo),
                    const SizedBox(height: 100), // Add a margin spacer
                  ],
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFFD36E2F),
            ),
          );
        },
      ),
    );
  }

  // Assuming that scenes is a List<IoT_Scene>
  Iterable<Card> buildExpansionTiles(List<IoT_Scene> scenes, navigateTo) {
    return scenes.map((scene) {
      dynamic enableScene = scene.enable;

      return Card(
        elevation: 0,
        margin: const EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: const BorderSide(
              color: AppColors.primary2, width: 2), // Add orange outline
        ),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: ExpansionTile(
              title: Row(
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
                        fontSize: 18.0), // Customize title text size
                  ),
                ],
              ),
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                          18, 10, 0, 0), // Adjust padding as needed
                      child: eachSceneRow(scene, enableScene,
                          navigateTo), // Replace with your desired row widget
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: ButtonBar(
                        children: [
                          AnimatedOpacity(
                            opacity: enableScene ? 1 : 0.5,
                            duration: const Duration(
                                seconds: 1), // Customize the duration as needed
                            child: Row(
                              children: [
                                TextButton(
                                  onPressed: enableScene
                                      ? () {
                                          navigateTo(eachScene(scene: scene));
                                        }
                                      : null,
                                  onLongPress: enableScene
                                      ? () {
                                          CustomDialog("Click to Edit Scene");
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
                                          CustomDialog(
                                              "Click to Activate Scene Once");
                                        }
                                      : null,
                                  child: IconButton(
                                    icon: const Icon(Icons.touch_app),
                                    onPressed: enableScene
                                        ? () {
                                            navigateTo(eachScene(scene: scene));
                                          }
                                        : null,
                                    color: enableScene
                                        ? AppColors.secondary1
                                        : Colors.grey,
                                  ),
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
                              swapper(scene);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            )),
      );
    }).toList();
  }

  void CustomDialog(String text) {
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

  Row eachSceneRow(IoT_Scene scene, enableScene, navigateTo) {
    String? description;
    if (scene.description == "" || scene.description == null) {
      description = "No description";
    }
    int countOfDevices = jsonDecode(scene.content)[0]['actions'].length;
    return Row(
      children: [
        // child: buildRichText(description, scene.description!, countOfDevices)
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildRichText(description, scene.description!, countOfDevices),
            ],
          ),
        ),
      ],
    );
  }
}

RichText buildRichText(
    String? description, String sceneDescription, int countOfDevices) {
  return RichText(
    text: TextSpan(
      style: GoogleFonts.poppins(fontSize: 16.0, color: Colors.black),
      children: [
        TextSpan(
          text: 'Description: ',
          style: GoogleFonts.poppins(color: AppColors.primary2),
        ),
        TextSpan(
          text: '${description ?? sceneDescription}\n\n',
          style: GoogleFonts.poppins(),
        ),
        TextSpan(
          text: 'Number of Devices: ',
          style: GoogleFonts.poppins(color: AppColors.primary2),
        ),
        TextSpan(
          text: '${countOfDevices}',
          style: GoogleFonts.poppins(),
        ),
      ],
    ),
  );
}
