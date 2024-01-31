import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:l3homeation/models/IoT_Scene.dart';
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
  String? auth;

  @override
  void initState() {
    super.initState();
    loadAuth().then((_) {
      print("Got auth: $auth\n");
      updateScenes();
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

  void swapper(IoT_Scene scene) async {
    print("Tapping scene to toggle state\n");
    print("Hello world");
    await scene.swapStates();
    print("${scene.icon}");
    updateScenes();
  }

  @override
  Widget build(BuildContext context) {
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
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
                child: SingleChildScrollView(
                  // make scrollable below.
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
                      Padding(
                        // padding for the datatable
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Center(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
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
              ListView.builder(
                itemCount: 25,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    tileColor:
                        index.isOdd ? AppColors.primary1 : AppColors.primary2,
                    title: Text('Edit Devices $index'),
                  );
                },
              ),
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
            ],
          ),
        ));
  }

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
                        child: Text('Original: \n$content'),
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
          Text(data_cell),
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
}
