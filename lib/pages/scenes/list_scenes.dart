// dashboard_main.dart

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:l3homeation/models/iot_scene.dart';
import 'package:l3homeation/services/varHeader.dart';
import "package:google_fonts/google_fonts.dart";
import 'package:l3homeation/pages/scenes/scene_shared.dart';
import 'package:l3homeation/widget/navigation_drawer_widget.dart';

import 'scene_lib.dart';

class List_Scenes extends StatefulWidget {
  @override
  _List_Scenes_State createState() => _List_Scenes_State();
}

class _List_Scenes_State extends State<List_Scenes> {
  late Timer dashboardUpdateTimer;

  @override
  void initState() {
    super.initState();
    loadAuth().then((_) {
      updateScenes(setState);
      updateDevices(setState);

      dashboardUpdateTimer =
          Timer.periodic(const Duration(seconds: 5), (timer) {
        updateScenes(setState);
      });
    });
  }

  @override
  void dispose() {
    dashboardUpdateTimer.cancel();
    super.dispose();
  }

  void sceneOnOff(IoT_Scene scene) async {
    await scene.swapStates();
    if (auth != null) {
      setState(() {
        scenes = IoT_Scene.getScenes(
          auth!,
          Var_Header.BASEURL,
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
      drawer: Navigation_Drawer_Widget(),
      body: buildFutureSceneList(navigateTo, sceneOnOff), //passing the navigateTo function to buildEachRow
      floatingActionButton: buildAddSceneFloatingButton(context, updateScenes(setState)),
    );
  }
}
