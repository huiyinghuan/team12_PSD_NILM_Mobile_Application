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
  const Rooms({Key? key}) : super(key: key);

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
          VarHeader.baseUrl,
        );
      });
    }
  }

  void viewRoom(BuildContext context, Room room) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SpecificRoomPage(specificRoom: room),
      ),
    );
  }

  void adjustRoom(BuildContext context, Room room) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditRoomPage(room: room),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      title: 'Rooms',
      child: ListView(
        children: <Widget>[
          rooms_list_section(context, viewRoom),
          // buildGreetingSection(context),
          // buildDeviceStatusSection(
          //     context, turn_on_off_device_tile, adjustDevice),
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
