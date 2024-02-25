import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:l3homeation/models/IoT_Scene.dart';
import 'package:l3homeation/models/iot_device.dart';
import 'package:l3homeation/themes/colors.dart';
import 'package:l3homeation/widget/navigation_drawer_widget.dart';
import 'package:l3homeation/services/userPreferences.dart';

class eachScene extends StatefulWidget {
  final dynamic scene;

  eachScene({required this.scene});

  @override
  _eachSceneState createState() => _eachSceneState(scene: scene);
}

class _eachSceneState extends State<eachScene> {
  final dynamic scene;
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
  late Future<List<IoT_Device>> devices = Future.value([]);
  bool isDataLoaded = false;
  String? auth;

  @override
  void initState() {
    super.initState();
    loadAuth().then((_) {
      print("Got auth: $auth\n");
      updateScenes();
      // updateDevices();
    });
    // updateScenes(); // Can be read as initialize scenes too --> Naming seems weird only because it usees the exact same function to call for an update
    // updateScenesTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
    //   updateScenes();
    // });
    // ^ Implement the timer back once we figure out how to make the rebuilding of the scene status' more smooth
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
    print("${scene.icon}");
  }

  Future<void> updateDevices(List<int?> id) async {
    if (auth != null) {
      setState(() {
        devices = IoT_Device.get_devices_by_ids(
          auth!,
          "http://l3homeation.dyndns.org:2080",
          id,
        );
      });
    }
    print(devices);
  }

  void swapper(IoT_Scene scene) async {
    print("Tapping scene to toggle state\n");
    print("Hello world");
    await scene.swapStates();
    print("${scene.icon}");
    updateScenes();
  }

  // Function to forcefully refresh the screen
  void refreshScreen() {
    setState(() {
      // Set some state that might have changed
      isDataLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    
    final navigateTo =
        (Widget page) => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => page,
            ));
    return DefaultTabController(
        initialIndex: 1,
        length: 3,
        child: Scaffold(
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
            bottom: const TabBar(
              tabs: <Widget>[
                Tab(
                  icon: Icon(Icons.cloud_outlined),
                  text: 'Information',
                ),
                Tab(
                  icon: Icon(Icons.edit_attributes),
                  text: 'Edit Devices',
                ),
                Tab(
                  icon: Icon(Icons.edit_note),
                  text: 'Edit Basic Config',
                ),
              ],
            ),
            scrolledUnderElevation: 4.0,
            shadowColor: Theme.of(context).shadowColor,
          ),
          drawer: NavigationDrawerWidget(),
          body: TabBarView(
            children: <Widget>[
              //---------------------------------FIRST TAB---------------------------------
              SingleChildScrollView(
                child: Padding(
                  // make scrollable below.
                  padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
                  child: Column(
                    // column got 2 children. 1 top row and 1 bottom datatable
                    children: [
                      Row(
                        // top row. icon and name
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            child: Image(
                              image: AssetImage(
                                scene.icon != null
                                    ? 'images/icons/${scene.icon}.png'
                                    : 'images/kitchen.png',
                              ),
                              fit: BoxFit
                                  .cover, // to prevent overflow from too large image and also fix the image size to 100 by 100 px
                              color: scene.icon != null
                                  ? null
                                  : AppColors.primary3,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20.0), // Add desired padding here
                            child: Text(
                              scene.name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Center(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Padding(
                            // padding for the datatable
                            padding: const EdgeInsets.only(top: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FutureBuilder<List<DataRow>>(
                                  future: buildDataRows(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<List<DataRow>> snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return CircularProgressIndicator();
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
                                                  padding: EdgeInsets.only(
                                                      left: 10.0),
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
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              //---------------------------------FIRST TAB---------------------------------
              //---------------------------------SECOND TAB---------------------------------
              buildListView(navigateTo),
              // ListView.builder(
              //   itemCount: 25,
              //   itemBuilder: (BuildContext context, int index) {
              //     return ListTile(
              //       tileColor:
              //           index.isOdd ? AppColors.primary1 : AppColors.primary2,
              //       title: Text('Edit Basic Config $index'),
              //     );
              //   },
              // ),
              //---------------------------------SECOND TAB---------------------------------
              //---------------------------------THIRD TAB---------------------------------
              ListView.builder(
                itemCount: 25,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    tileColor:
                        index.isOdd ? AppColors.primary1 : AppColors.primary2,
                    title: Text('Edit Basic Config $index'),
                  );
                },
              ),
              //---------------------------------THIRD TAB---------------------------------
            ],
          ),
        ));
  }

  //---------------------------------FIRST TAB FUNCTION---------------------------------
  // for data table edit data custom popup box
  Future<void> showCustomDialog(String title, String content, int i) async {
    // print(content);
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
                      // print('changed description to $new_desc');
                    }
                  });
                }
                Navigator.of(context).pop();
              },
              child: (new_desc == '') ? Text('OK') : Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  // for data table
  Future<List<DataRow>> buildDataRows() async {
    List<DataRow> dataRows = [];

    for (int i = 0; i < tableAttributes.length; i++) {
      String data_cell = buildDataCellContent(i);
      dataRows.add(DataRow(cells: [
        DataCell(Text(tableAttributes[i])),
        DataCell(
          Text(
            data_cell,
            maxLines: 1,
          ),
          onTap: () async {
            showCustomDialog('Edit ' + tableAttributes[i], data_cell, i);
          },
        )
      ]));
    }

    return dataRows;
  }

  String buildDataCellContent(int columnIndex) {
    switch (columnIndex) {
      case 0:
        return scene.description;
      case 1:
        return scene.type;
      case 2:
        return scene.icon;
      case 3:
        return scene.mode.toString();
      case 4:
        return scene.enable.toString();
      case 5:
        return DateFormat('HH:mm | dd/MM/yyyy').format(
          DateTime.fromMillisecondsSinceEpoch(scene.created * 1000),
        );
      case 6:
        return DateFormat('HH:mm | dd/MM/yyyy').format(
          DateTime.fromMillisecondsSinceEpoch(scene.updated * 1000),
        );
      case 7:
        return scene.content.toString();
      case 8:
        return scene.id.toString();
      default:
        return 'Unknown Column';
    }
  }

  //---------------------------------FIRST TAB FUNCTION---------------------------------
  //####################################################################################
  //---------------------------------SECOND TAB FUNCTION---------------------------------

  ListView buildListView(navigateTo) {
    List<int> collatedDeviceIds = [];
    List actions = jsonDecode(scene.content)[0]['actions'];
    for (var action in actions) {
      if (action['group'] == 'device') {
        collatedDeviceIds.add(action['id']);
      }
    }
    updateDevices(collatedDeviceIds);
    return ListView(
      children: [
        Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
            'Do the following:',
            style: GoogleFonts.poppins(
              fontSize: 18,
              color: Colors.grey[600],
            ),
            )
        ),
        FutureBuilder<List<IoT_Device>>(
          future: devices, // listing of all devices for that scene 
          builder:
              (BuildContext context, AsyncSnapshot<List<IoT_Device>> snapshot) {
            if (snapshot.hasData) {
              // If the Future has completed successfully, build the ListView.
              // List<IoT_Device> deviceList = snapshot.data!;
              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  // dict to change state. turnOff : turnOn, close : open, unsecure : secure
                  Map changestate = {
                    'turnOff': 'turnOn',
                    'close': 'open',
                    'unsecure': 'secure',
                    'turnOn': 'turnOff',
                    'open': 'close',
                    'secure': 'unsecure'
                  };
                  late bool Offoron = 
                    (actions[index]['action']) == 'turnOff' || 
                    (actions[index]['action']) == 'close' || 
                    (actions[index]['action']) == 'unsecure' ? false : true;
                  return ListTile(
                    tileColor: (index % 2 == 1)
                        ? AppColors.primary1
                        : AppColors.primary2,
                    title: Text(snapshot.data![index].name!),
                    trailing: Switch(
                      value: Offoron,
                      onChanged: (Offoron) {
                        setState(() {
                          Future<Response> changeResponse =
                            scene.change_action_state(
                              changestate[actions[index]['action']],
                              index,
                            );
                            changeResponse.then((value) {
                            if (value.statusCode == 204) {
                              Offoron = !Offoron;
                              actions[index]['action'] = changestate[actions[index]['action']];
                              updateScenes();
                              updateDevices(collatedDeviceIds);
                              // navigateTo(eachScene(scene: scene));
                              // print('changed description to $new_desc');
                            }
                          });
                        });
                        // updateDevices(collatedDeviceIds);
                      },
                    ),
                  );
                },
              );
              // return Text("hello world");
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              return Text(
                'Failed to load devices',
                style:
                    GoogleFonts.poppins(fontSize: 18, color: Colors.grey[600]),
              );
            }
          },
        ),
      ],
    );
  }

  bool assignValue(IoT_Device device) {
    if (device.value is int) {
      return device.value != 0 ? true : false;
    }
    return device.value ? true : false;
  }

  //---------------------------------SECOND TAB FUNCTION---------------------------------
  //####################################################################################
  //---------------------------------THIRD TAB FUNCTION---------------------------------
  //---------------------------------THIRD TAB FUNCTION---------------------------------
}
