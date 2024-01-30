import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:l3homeation/models/IoT_Scene.dart';
import 'package:l3homeation/themes/colors.dart';
import 'package:l3homeation/widget/navigation_drawer_widget.dart';
import 'package:l3homeation/services/userPreferences.dart';

class Scenes extends StatefulWidget {
  @override
  _ScenesState createState() => _ScenesState();
}

class _ScenesState extends State<Scenes> {
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
          _buildSceneList(),
        ],
      ),
    );
  }

  // Assuming that scenes is a List<IoT_Scene>
  List<ExpansionTile> buildExpansionTiles(List<dynamic> scenes) {
    return scenes.map((scene) {
      print(scene);
      dynamic enableScene = scene.enable;

      return ExpansionTile(
        title: Text(
          scene.name, // Replace with your desired title text
          style: const TextStyle(fontSize: 18.0), // Customize title text size
        ),
        children: [
          Column(children: [
            
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
                ],
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: ButtonBar(
                children: [
                  TextButton(
                    onPressed: () {
                      print("Activate Scene Now");
                    },
                    child: const Text(
                      'Activate Scene Now',
                      style: TextStyle(
                        color: AppColors.secondary1,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],)
        ],
      );
    }).toList();
  }

  // a container that holds the list of scenes
  Container _buildSceneList() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0),
      child: FutureBuilder<List<dynamic>>(
        future: scenes,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 8),
                Column(
                  children: buildExpansionTiles(snapshot.data!),
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
