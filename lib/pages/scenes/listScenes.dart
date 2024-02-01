import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:l3homeation/models/IoT_Scene.dart';
import 'package:l3homeation/pages/scenes/eachScene.dart';
import 'package:l3homeation/themes/colors.dart';
import 'package:l3homeation/widget/navigation_drawer_widget.dart';
import 'package:l3homeation/services/userPreferences.dart';

class listScenes extends StatefulWidget {
  @override
  _listScenesState createState() => _listScenesState();
}

class _listScenesState extends State<listScenes> {
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
  }

  void swapper(IoT_Scene scene) async {
    print("Tapping scene to toggle state\n");
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
    final navigateTo =
        (Widget page) => Navigator.of(context).push(MaterialPageRoute(
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
          _buildSceneList(navigateTo), //passing the navigateTo function to buildExpansionTiles
        ],
      ),
    );
  }

  // Assuming that scenes is a List<IoT_Scene>
  List<ExpansionTile> buildExpansionTiles(List<dynamic> scenes, navigateTo) {
    return scenes.map((scene) {
      print(scene.toString_IOT());
      dynamic enableScene = scene.enable;
      
      return ExpansionTile(
        title: Text(
          scene.name, // Replace with your desired title text
          style: const TextStyle(fontSize: 18.0), // Customize title text size
        ),
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(18.0), // Adjust padding as needed
                child: Row(
                  children: [
                    Flexible(
                      child: RichText(
                        text: const TextSpan(
                          text: 'Status: ',
                          style: TextStyle(
                            color: AppColors.secondary1,
                            fontSize: 18.0,
                          ),
                          children: [
                            TextSpan(
                              text: 'hhello \n\n',
                              style: TextStyle(
                                color: AppColors.secondary1,
                                fontSize: 18.0,
                                fontWeight: (FontWeight.bold),
                              ),
                            ),
                            TextSpan(
                              text: 'Enable Trigger Scene: \n',
                              // style: TextStyle(
                              //   color: Colors.black,
                              //   fontSize: 14.0,
                              // ),
                            ),
                          ],
                        ),
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
                    IconButton(
                      // This bool value toggles the switch.
                      icon: const Icon(Icons.edit),
                      onPressed: (enableScene)
                          ? () {
                              print('directing to next page');
                              navigateTo(eachScene(scene: scene));
                            }
                          : null,
                      color: (enableScene) ? AppColors.secondary1 : Colors.grey,
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: ButtonBar(
                  children: [
                    TextButton(
                      onPressed: (enableScene)
                          ? () => {
                                scene.activate_scenes(),
                              }
                          : null,
                      child: Text(
                        'Activate Scene Now',
                        style: TextStyle(
                          color: (enableScene)
                              ? AppColors.secondary1
                              : Colors.grey,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      );
    }).toList();
  }

  // a container that holds the list of scenes
  Container _buildSceneList(navigateTo) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0),
      child: FutureBuilder<List<dynamic>>(
        future: scenes,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                  children: buildExpansionTiles(snapshot.data!, navigateTo),
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
}
