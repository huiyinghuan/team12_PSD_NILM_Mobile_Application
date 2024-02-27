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
  late Future<List<IoT_Device>> devices_in_scene = Future.value([]);
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
        devices_in_scene = IoT_Device.get_devices_by_ids(
          auth!,
          "http://l3homeation.dyndns.org:2080",
          id,
        );
      });
    }
    print(devices_in_scene);
  }

  void swapper(IoT_Scene scene) async {
    print("Tapping scene to toggle state\n");
    print("Hello world");
    await scene.swapStates();
    print("${scene.icon}");
    updateScenes();
  }
  @override
  Widget build(BuildContext context) {
    
    navigateTo(Widget page) => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => page,
            ));
    
    TabBar tabNames(){
      return const TabBar (
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
          icon: Icon(Icons.edit_note),
          text: 'Edit Basic Config',
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
              scene.name,
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
              buildFirstTab(),
              //---------------------------------FIRST TAB---------------------------------
              //---------------------------------SECOND TAB---------------------------------
              buildSecondTab(navigateTo),
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
  SingleChildScrollView buildFirstTab(){
    return SingleChildScrollView(
      child: Padding(
        // make scrollable below.
        padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
        child: Column(
          // column got 2 children. 1 top row and 1 bottom datatable
          children: [
            contentTopRow(),
            Center(
              child: contentBody()
            ),
          ],
        ),
      ),
    );
  }

  Row contentTopRow(){
            // top row. icon and name
    return Row(
        children: [
          SizedBox(
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
      );
  }

  SingleChildScrollView contentBody(){
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
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
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
            changeDescriptionPromptBox('Edit ' + tableAttributes[i], data_cell, i);
          },
        )
      ]));
    }

    return dataRows;
  }

  String Body_buildDataCellContent(int columnIndex) {
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

  // for data table edit data custom popup box
  Future<void> changeDescriptionPromptBox(String title, String content, int i) async {
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
              child: (new_desc == '') ? const Text('OK') : const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  //---------------------------------FIRST TAB FUNCTION---------------------------------
  //####################################################################################
  //---------------------------------SECOND TAB FUNCTION---------------------------------

  ListView buildSecondTab(navigateTo) {
    List<int> collatedDeviceIds = [];
    List actions = jsonDecode(scene.content)[0]['actions'];
    for (var action in actions) {
      if (action['group'] == 'device') {
        collatedDeviceIds.add(action['id']);
      }
    }
    updateDevices(collatedDeviceIds);
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

  Text contentTopHeader(){
    return Text(
      'Scene will do the following:',
      style: GoogleFonts.poppins(
        fontSize: 18,
        color: Colors.grey[600],
      ),
    );
  }

  FutureBuilder<List<IoT_Device>> contentBodyDevices(List actions){
    return FutureBuilder<List<IoT_Device>>(
      future: devices_in_scene, // listing of all devices_in_scene for that scene 
      builder: (BuildContext context, AsyncSnapshot<List<IoT_Device>> snapshot) {
        if (snapshot.hasData) {
          // If the Future has completed successfully, build the ListView.
          // List<IoT_Device> deviceList = snapshot.data!;
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: snapshot.data!.length + 1, // Add 1 for the additional row
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
    return ListTile(
      tileColor: (index % 2 == 1)
          ? AppColors.primary1
          : AppColors.primary2,
      title: const Text('Add New Device'), // Customize the text as needed
      onTap: () {
        // Show the prompt dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Add New Device'), // Customize the dialog title
              content: const Text('Prompt content'), // Customize the dialog content
              actions: [
                TextButton(
                  onPressed: () {
                    // Handle the button click
                    // Perform the necessary actions
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'), // Customize the button text
                ),
              ],
            );
          },
        );
      },
    );
  }

  ListTile Body_allDeviceRow(List actions, int index, AsyncSnapshot<List<IoT_Device>> snapshot) {
    Map stateToChangeTo = {
      'turnOff': 'turnOn',
      'close': 'open',
      'unsecure': 'secure',
      'turnOn': 'turnOff',
      'open': 'close',
      'secure': 'unsecure'
    };
    bool Offoron = (actions[index]['action']) == 'turnOff' ||
        (actions[index]['action']) == 'close' ||
        (actions[index]['action']) == 'unsecure'
        ? false
        : true;
    isAllowed_Scene_Actions.add(Offoron);

    return ListTile(
      tileColor: (index % 2 == 1)
          ? AppColors.primary1
          : AppColors.primary2,
      title: Text(snapshot.data![index].name!),
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
                isAllowed_Scene_Actions[index] = !isAllowed_Scene_Actions[index];
                updateScenes();
              }
            });
          });
        },
      ),
    );
  }

  //---------------------------------SECOND TAB FUNCTION---------------------------------
  //####################################################################################
  //---------------------------------THIRD TAB FUNCTION---------------------------------
  //---------------------------------THIRD TAB FUNCTION---------------------------------
}
