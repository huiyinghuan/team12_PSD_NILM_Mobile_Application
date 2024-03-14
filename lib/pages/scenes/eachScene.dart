import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:l3homeation/models/iot_scene.dart';
import 'package:l3homeation/models/iot_device.dart';
import 'package:l3homeation/themes/colors.dart';
import 'package:l3homeation/widget/navigation_drawer_widget.dart';
import 'package:l3homeation/services/userPreferences.dart';
import 'package:l3homeation/services/varHeader.dart';

class eachScene extends StatefulWidget {
  final IoT_Scene scene;

  eachScene({required this.scene});

  @override
  _eachSceneState createState() => _eachSceneState(scene: scene);
}

class _eachSceneState extends State<eachScene> {
  final IoT_Scene scene;
  List<bool> isAllowed_Scene_Actions = [];

  List<String> tableAttributes = [
    'Description',
    'Type',
    'Icon',
    'Mode',
    'Enable',
    'Created',
    'Updated',
    'Content',
    'Id',
  ];

  _eachSceneState({required this.scene});

  late Future<List<dynamic>> scenes = Future.value([]);
  Future<List<IoT_Device>> devices = Future.value([]);
  late Future<List<IoT_Device>> devices_in_scene = Future.value([]);
  String? auth;

  @override
  void initState() {
    super.initState();
    loadAuth().then((_) {
      updateScenes();
      updateDevices();
    });
  }

  Future<void> loadAuth() async {
    auth = await UserPreferences.getString('auth');
  }

  Future<void> updateScenes() async {
    if (auth != null) {
      setState(() {
        scenes = IoT_Scene.get_scenes(
          auth!,
          VarHeader.BASEURL,
        );
      });
    }
  }

  Future<void> updateDevices() async {
    if (auth != null) {
      setState(() {
        devices = IoT_Device.get_devices(
          auth!,
          VarHeader.BASEURL,
        );
      });
    }
  }

  Future<void> updateSceneActionDevices(List<int?> id) async {
    if (auth != null) {
      setState(() {
        devices_in_scene = IoT_Device.get_devices_by_ids(
          auth!,
          VarHeader.BASEURL,
          id,
        );
      });
    }
  }

  Future<void> removeDeviceFromScene(int index) async {
    if (auth != null) {
      setState(() {
        devices_in_scene = devices_in_scene.then((existingDevices) {
          // Remove the device at index from existingDevices
          return existingDevices..removeAt(index);
        });
      });
    }
  }

  Future<void> addSceneActionDevices(int? id) async {
    if (auth != null) {
      try {
        // Assuming get_devices_by_ids is an async function that returns List<IoT_Device>
        var moreDevices = await IoT_Device.get_devices_by_ids(
          auth!,
          VarHeader.BASEURL,
          [id],
        );

        setState(() {
          devices_in_scene = devices_in_scene.then((existingDevices) {
            // Combine existing devices with moreDevices
            return [...existingDevices, ...moreDevices];
          });
        });
      } catch (error) {
        // Handle any errors from IoT_Device.get_devices_by_ids
        print("Error fetching devices: $error");
      }
    }
  }

  void swapper(IoT_Scene scene) async {
    await scene.swapStates();
    updateScenes();
  }

  @override
  Widget build(BuildContext context) {
    navigateTo(Widget page) => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => page,
        ));

    TabBar tabNames() {
      return const TabBar(
        tabs: [
          Tab(
            icon: Icon(Icons.cloud_outlined),
            text: 'Information',
          ),
          Tab(
            icon: Icon(Icons.edit_attributes),
            text: 'Edit Devices',
          ),
          Tab(
            icon: Icon(Icons.timer),
            text: 'Time Config',
          )
        ],
      );
    }

    return DefaultTabController(
        initialIndex: 1,
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text(
              scene.name!,
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontSize: 22,
              ),
            ),
            iconTheme: const IconThemeData(color: Colors.black),
            bottom: tabNames(),
            scrolledUnderElevation: 4.0,
            shadowColor: Theme.of(context).shadowColor,
          ),
          drawer: NavigationDrawerWidget(),
          body: TabBarView(
            children: <Widget>[
              //---------------------------------FIRST TAB---------------------------------
              buildFirstTab(scene),
              //---------------------------------FIRST TAB---------------------------------
              //---------------------------------SECOND TAB---------------------------------
              buildSecondTab(),
              //---------------------------------SECOND TAB---------------------------------
              //---------------------------------THIRD TAB---------------------------------
              buildThirdTab(),
              //---------------------------------THIRD TAB---------------------------------
            ],
          ),
        ));
  }

  //---------------------------------FIRST TAB FUNCTION---------------------------------
  SingleChildScrollView buildFirstTab(IoT_Scene scene_carriedover) {
    return SingleChildScrollView(
      child: Padding(
        // make scrollable below.
        padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
        child: Column(
          // column got 2 children. 1 top row and 1 bottom datatable
          children: [
            contentTopRow(scene_carriedover),
            Center(child: contentBody()),
          ],
        ),
      ),
    );
  }

  Row contentTopRow(dynamic scene_carriedover) {
    // top row. icon and name
    return Row(
      children: [
        SizedBox(
          width: 100,
          height: 100,
          child: InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    scrollable: true,
                    title: Text('Change Icon'),
                    content: SizedBox(
                      height: 300, // Set a fixed height for the AlertDialog
                      child: SingleChildScrollView(
                        child: Column(
                          children: List.generate(
                            (iconList.length / 5)
                                .ceil(), // Calculate number of rows
                            (rowIndex) {
                              int startIndex = rowIndex * 5;
                              int endIndex = (rowIndex + 1) * 5;
                              if (endIndex > iconList.length) {
                                endIndex = iconList.length;
                              }
                              return Row(
                                children: List.generate(
                                  endIndex - startIndex,
                                  (index) => Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        Future<Response> changeResponse =
                                            scene_carriedover.change_icon(
                                                iconList[startIndex + index]);
                                        changeResponse.then((value) {
                                          if (value.statusCode == 204) {
                                            scene.icon =
                                                iconList[startIndex + index];
                                            updateScenes();
                                          }
                                        });
                                        // Add your onTap logic here
                                        Navigator.of(context).pop();
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image(
                                          image: AssetImage(
                                              'images/icons/${iconList[startIndex + index]}.png'),
                                          width: 40,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
            child: Image(
              image: AssetImage(
                scene.icon != null
                    ? 'images/icons/${scene.icon}.png'
                    : 'images/kitchen.png',
              ),
              fit: BoxFit.cover,
              color: scene.icon != null ? null : AppColors.primary3,
            ),
          ),
        ),
        Padding(
          padding:
              const EdgeInsets.only(left: 20.0), // Add desired padding here
          child: Text(
            scene.name!,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  SingleChildScrollView contentBody() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        // padding for the datatable
        padding: const EdgeInsets.only(top: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder<List<DataRow>>(
              future: Body_buildDataRows(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<DataRow>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return DataTable(
                    horizontalMargin: 20,
                    columns: const [
                      DataColumn(label: Text('')),
                      DataColumn(
                        label: Row(
                          children: [
                            Text('Data Information'),
                            Padding(
                              padding: EdgeInsets.only(left: 10.0),
                              child: Icon(Icons.edit),
                            )
                          ],
                        ),
                      )
                    ],
                    rows: snapshot.data!,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  // for data table
  Future<List<DataRow>> Body_buildDataRows() async {
    List<DataRow> dataRows = [];

    for (int i = 0; i < tableAttributes.length; i++) {
      String data_cell = Body_buildDataCellContent(i);
      dataRows.add(DataRow(cells: [
        DataCell(Text(tableAttributes[i])),
        DataCell(
          Text(
            data_cell,
            maxLines: 1,
          ),
          onTap: () async {
            changeDescriptionPromptBox(
                'Edit ' + tableAttributes[i], data_cell, i);
          },
        )
      ]));
    }

    return dataRows;
  }

  String Body_buildDataCellContent(int columnIndex) {
    switch (columnIndex) {
      case 0:
        return scene.description!;
      case 1:
        return scene.type!;
      case 2:
        return scene.icon!;
      case 3:
        return scene.mode.toString();
      case 4:
        return scene.enable.toString();
      case 5:
        return DateFormat('HH:mm | dd/MM/yyyy').format(
          DateTime.fromMillisecondsSinceEpoch(scene.created! * 1000),
        );
      case 6:
        return DateFormat('HH:mm | dd/MM/yyyy').format(
          DateTime.fromMillisecondsSinceEpoch(scene.updated! * 1000),
        );
      case 7:
        return scene.content.toString();
      case 8:
        return scene.id.toString();
      default:
        return 'Unknown Column';
    }
  }

  // create an icon list that exist in the images/icons
  List<String> iconList = [
    'airpurifer0',
    'airpurifer100',
    'alarm_partial',
    'alarm_red',
    'alarm_siren_gray0',
    'alarm_siren_gray100',
    'alarm_siren_red0',
    'alarm_siren_red100',
    'alarm0',
    'audio0',
    'audio100',
    'barrierClosing',
    'barrierOpening',
    'brama_2-50',
    'brama50',
    'com.fibaro.rainSensor',
    'com.fibaro.rainSensor0',
    'com.fibaro.windSensor',
    'czajnik0',
    'czajnik100',
    'czujnik_ruchu0',
    'czujnik_ruchu100',
    'czujnik_zalania0',
    'czujnik_zalania100',
    'dehumidifier0',
    'dehumidifier100',
    'door_lock100',
    'doorbell_dark0',
    'doorbell_dark100',
    'drzwi0',
    'drzwi100',
    'energy_meter',
    'evening',
    'garageDoor_sectionalClosing',
    'garageDoor_sectionalOpening',
    'gate_doubleLeafClosing',
    'gate_doubleLeafOpening',
    'humidifier0',
    'humidifier100',
    'klimatyzator0',
    'klimatyzator100',
    // 'lampaogrodowa0',
    // 'lampaogrodowa100',
    'light0',
    'light100',
    'morning',
    'onoff0',
    // 'onoff100',
    'preasure_sensor',
    // 'roleta_wewo',
    'roleta_wew100',
    'scene_auto',
    'scene_block',
    'scene_dinner',
    'scene_dinner2',
    'scene_entrance',
    'scene_entrance2',
    'scene_exit',
    'scene_exit2',
    'scene_lua',
    'scene_magic',
    'scene_movie',
    'scene',
    'smoke_sensor0',
    'smoke_sensor100',
    'wiatrak0',
    'wiatrak100',
  ];

  // for data table edit data custom popup box
  Future<void> changeDescriptionPromptBox(
      String title, String content, int i) async {
    String new_desc = '';
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: (i == 0)
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SingleChildScrollView(
                          child: Text('Original: \n$content'),
                        ),
                      ),
                    ),
                    const Card(
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text('To change:'),
                      ),
                    ),
                    TextField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'New Description',
                      ),
                      onChanged: (value) {
                        new_desc = value;
                      },
                    ),
                  ],
                )
              : Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text('Original: $content'),
                  ),
                ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                if (i == 0) {
                  Future<Response> changeResponse =
                      scene.change_description(new_desc);
                  changeResponse.then((value) {
                    if (value.statusCode == 204) {
                      scene.description = new_desc;
                      updateScenes();
                    }
                  });
                }
                Navigator.of(context).pop();
              },
              child:
                  (new_desc == '') ? const Text('OK') : const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  //---------------------------------FIRST TAB FUNCTION---------------------------------
  //####################################################################################
  //---------------------------------SECOND TAB FUNCTION---------------------------------

  ListView buildSecondTab() {
    List<int> collatedDeviceIds = [];
    List actions = jsonDecode(scene.content)[0]['actions'];
    for (var action in actions) {
      if (action['group'] == 'device') {
        collatedDeviceIds.add(action['id']);
      }
    }
    updateSceneActionDevices(collatedDeviceIds);
    return ListView(
      scrollDirection: Axis.vertical,
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: contentTopHeader(),
        ),
        contentBodyDevices(actions)
      ],
    );
  }

  Text contentTopHeader() {
    return Text(
      'Scene will do the following:',
      style: GoogleFonts.poppins(
        fontSize: 18,
        color: Colors.grey[600],
      ),
    );
  }

  FutureBuilder<List<IoT_Device>> contentBodyDevices(List actions) {
    return FutureBuilder<List<IoT_Device>>(
      future:
          devices_in_scene, // listing of all devices_in_scene for that scene
      builder:
          (BuildContext context, AsyncSnapshot<List<IoT_Device>> snapshot) {
        if (snapshot.hasData) {
          // If the Future has completed successfully, build the ListView.
          // List<IoT_Device> deviceList = snapshot.data!;
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount:
                snapshot.data!.length + 1, // Add 1 for the additional row
            itemBuilder: (BuildContext context, int index) {
              if (index != snapshot.data!.length) {
                return Body_allDeviceRow(actions, index, snapshot);
              } else {
                // Render the additional row
                return Body_addDeviceRow(index);
              }
            },
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return Text(
            'Failed to load devices_in_scene',
            style: GoogleFonts.poppins(fontSize: 18, color: Colors.grey[600]),
          );
        }
      },
    );
  }

  ListTile Body_addDeviceRow(int index) {
    var selectedDeviceInDropdown;
    late var isEmpty = false;
    return ListTile(
      tileColor: AppColors.primary5,
      title: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Add New Device',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 8), // Add some spacing between the text and icon
          Icon(Icons.add_circle_rounded, color: AppColors.secondary5),
        ],
      ),
      onTap: () {
        // Show the prompt dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Add New Device'),
              content: FutureBuilder<List<IoT_Device>>(
                future: devices,
                builder: (context, devicesSnapshot) {
                  if (devicesSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (devicesSnapshot.hasError) {
                    return const Text('Error loading devices');
                  } else {
                    return FutureBuilder<List<IoT_Device>>(
                      future: devices_in_scene,
                      builder: (context, sceneSnapshot) {
                        if (sceneSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (sceneSnapshot.hasError) {
                          return const Text('Error loading scene devices');
                        } else {
                          // Filter out devices that are already in scene
                          final List<IoT_Device> filteredDevices =
                              devicesSnapshot.data!
                                  .where((device) => !sceneSnapshot.data!.any(
                                      (sceneDevice) =>
                                          sceneDevice.id == device.id))
                                  .toList();

                          if (filteredDevices.isEmpty) {
                            isEmpty = true;
                            return const Center(
                              heightFactor: 3,
                              child: Text(
                                'No devices left to add',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            );
                          }

                          return DropdownButtonFormField<IoT_Device>(
                            hint: const Text('Select a device'),
                            items: filteredDevices.map((device) {
                              return DropdownMenuItem<IoT_Device>(
                                value: device,
                                child: Text(device.name!),
                              );
                            }).toList(),
                            onChanged: (IoT_Device? selectedDevice) {
                              // Handle selected device
                              selectedDeviceInDropdown = selectedDevice;
                            },
                          );
                        }
                      },
                    );
                  }
                },
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      setState(() {
                        if (selectedDeviceInDropdown != null) {
                          // Add the selected device to the scene
                          Future<Response> changeResponse =
                              scene.add_devices_into_action(
                                  selectedDeviceInDropdown);
                          changeResponse.then((value) {
                            if (value.statusCode == 204) {
                              updateScenes();
                              Navigator.pop(context); // Close the dialog
                              isAllowed_Scene_Actions.add(false);
                              addSceneActionDevices(
                                  selectedDeviceInDropdown.id);
                            }
                          });
                        } else {
                          Navigator.pop(context); // Close the dialog
                        }
                      });
                    },
                    child:
                        (isEmpty) ? const Text('Dismiss') : const Text('Add')),
              ],
            );
          },
        );
      },
    );
  }

  ListTile Body_allDeviceRow(
      List actions, int index, AsyncSnapshot<List<IoT_Device>> snapshot) {
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
    isAllowed_Scene_Actions.add(Offoron);

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
                              scene.remove_devices_from_action(index);
                          changeResponse.then((value) {
                            if (value.statusCode == 204) {
                              updateScenes();
                              isAllowed_Scene_Actions.removeAt(index);
                              removeDeviceFromScene(index);
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
                  return customDialog(
                      "First Main device is not able to remove from the scene.");
                } else {
                  return customDialog(
                      "Cannot remove the last device from the scene.");
                }
              },
            ),
          }
      },
      trailing: Switch(
        value: isAllowed_Scene_Actions[index],
        onChanged: (value) {
          setState(() {
            Future<Response> changeResponse = scene.change_action_state(
              stateToChangeTo[actions[index]['action']],
              index,
            );
            changeResponse.then((value) {
              if (value.statusCode == 204) {
                isAllowed_Scene_Actions[index] =
                    !isAllowed_Scene_Actions[index];
                updateScenes();
              }
            });
          });
        },
      ),
    );
  }

  AlertDialog customDialog(String customText) {
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
  //---------------------------------SECOND TAB FUNCTION---------------------------------
  //####################################################################################
  //---------------------------------THIRD TAB FUNCTION---------------------------------

  ListView buildThirdTab() {
    return ListView.builder(
      itemCount: 25,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          tileColor: index.isOdd ? AppColors.primary1 : AppColors.primary2,
          title: Text('Edit Basic Config $index'),
        );
      },
    );
  }

  //---------------------------------THIRD TAB FUNCTION---------------------------------
}
