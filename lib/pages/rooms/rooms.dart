// dashboard_main.dart

import 'package:flutter/material.dart';
import 'package:l3homeation/models/iot_device.dart';
import 'package:l3homeation/models/room.dart';
import 'package:l3homeation/pages/devices/listDevice.dart';
import 'package:l3homeation/pages/editDevice/edit_device.dart';
import 'package:l3homeation/widget/base_layout.dart';

import 'package:l3homeation/pages/rooms/rooms_shared.dart';
import 'rooms_lib.dart';

class Rooms extends StatefulWidget {
  const Rooms({Key? key}) : super(key: key);

  @override
  State<Rooms> createState() => _RoomsState();
}

class _RoomsState extends State<Rooms> {
  @override
  void initState() {
    super.initState();
    loadAuth().then((_) {
      updateRooms();
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

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      title: 'Rooms',
      child: ListView(
        children: <Widget>[
          Placeholder()
          // buildGreetingSection(context),
          // buildDeviceStatusSection(
          //     context, turn_on_off_device_tile, adjustDevice),
          // buildUsageSection(context),
          // buildSceneSection(context),
        ],
      ),
    );
  }
}
