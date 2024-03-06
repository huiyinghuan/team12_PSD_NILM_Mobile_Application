// dashboard_main.dart

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:l3homeation/models/iot_device.dart';
import 'package:l3homeation/models/room.dart';
import 'package:l3homeation/pages/devices/listDevice.dart';
import 'package:l3homeation/pages/editDevice/edit_device.dart';
import 'package:l3homeation/pages/rooms/base/specific_room.dart';
import 'package:l3homeation/widget/base_layout.dart';

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
          baseURL,
        );
      });
    }
  }

  void viewRoom(BuildContext context, Room room) {
    print("attempting to nav to view");
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SpecificRoomPage(specificRoom: room),
      ),
    );
  }

  void adjustRoom(BuildContext context, IoT_Device device) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditDevicePage(device: device),
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
