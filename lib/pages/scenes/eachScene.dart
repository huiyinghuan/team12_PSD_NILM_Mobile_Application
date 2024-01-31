import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
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
    return DefaultTabController(
      initialIndex: 1,
      length: 3,
      child: 
        Scaffold(
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
              const Column(
                children: [
                    Image(image: AssetImage('images/icons/alarm0.png')),
                  ],
              ),
              ListView.builder(
                itemCount: 25,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    tileColor: index.isOdd ? AppColors.primary1 : AppColors.primary2,
                    title: Text('Edit Devices $index'),
                  );
                },
              ),
              ListView.builder(
                itemCount: 25,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    tileColor: index.isOdd ? AppColors.primary1 : AppColors.primary2,
                    title: Text('Edit Basic Config $index'),
                  );
                },
              ),
            ],
          ),
        )
    );
  }

}
