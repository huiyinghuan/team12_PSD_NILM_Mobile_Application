// dashboard_main.dart

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:l3homeation/models/room.dart';
import 'package:l3homeation/pages/rooms/base/specific_room.dart';
import 'package:l3homeation/pages/rooms/edit/edit_rooms.dart';
import 'package:l3homeation/widget/base_layout.dart';
import 'package:l3homeation/services/varHeader.dart';
import 'package:l3homeation/pages/rooms/base/rooms_shared.dart';
import 'rooms_lib.dart';

class Rooms extends StatefulWidget {
  const Rooms({super.key});

  @override
  State<Rooms> createState() => _RoomsState();
}

class _RoomsState extends State<Rooms> {
  late Timer updateRoomsTimer;

  @override
  void initState() {
    super.initState();
    loadAuth().then((_) {
      updateRooms();
      updateRoomsTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
        updateRooms();
      });
    });
  }
  // Implement rebuilding of the screen here

  Future<void> updateRooms() async {
    if (auth != null) {
      setState(() {
        rooms = Room.fetchRooms(
          auth!,
          Var_Header.BASEURL,
        );
      });
    }
  }

  void viewRoom(BuildContext context, Room room) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Specific_Room_Page(specificRoom: room),
      ),
    );
  }

  void adjustRoom(BuildContext context, Room room) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Edit_Room_Page(room: room),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Base_Layout(
      title: 'Rooms',
      child: ListView(
        children: <Widget>[
          roomsListSection(context, viewRoom),
          // buildGreetingSection(context),
          // buildDeviceStatusSection(
          //     context, turnOnOffDeviceTile, adjustDevice),
          // buildUsageSection(context),
          // buildSceneSection(context),
        ],
      ),
    );
  }

  @override
  void dispose() {
    updateRoomsTimer.cancel();
    super.dispose();
  }
}
