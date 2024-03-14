import 'package:flutter/material.dart';
import 'package:l3homeation/models/iot_scene.dart';
import "package:google_fonts/google_fonts.dart";
import 'package:l3homeation/pages/scenes/scene_shared.dart';
import 'package:l3homeation/themes/colors.dart';
import 'package:l3homeation/widget/navigation_drawer_widget.dart';

import 'scene_lib.dart';

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

  @override
  void initState() {
    super.initState();
    loadAuth().then((_) {
      updateScenes(setState);
      updateDevices(setState);
    });
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
              buildFirstTab(context, scene, setState, tableAttributes),
              //---------------------------------FIRST TAB---------------------------------
              //---------------------------------SECOND TAB---------------------------------
              buildSecondTab(scene, setState, isAllowed_Scene_Actions),
              //---------------------------------SECOND TAB---------------------------------
              //---------------------------------THIRD TAB---------------------------------
              buildThirdTab(),
              //---------------------------------THIRD TAB---------------------------------
            ],
          ),
        ));
  }
}

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
