import 'package:flutter/material.dart';
import 'package:l3homeation/models/iot_device.dart';
import 'package:l3homeation/models/room.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:l3homeation/components/iot_device_tile.dart';
import 'package:l3homeation/pages/editDevice/edit_device.dart';
import 'rooms_shared.dart';

class SpecificRoomPage extends StatefulWidget {
  final Room specificRoom;

  const SpecificRoomPage({required this.specificRoom});

  @override
  State<SpecificRoomPage> createState() => _SpecificRoomPageState();
}

class _SpecificRoomPageState extends State<SpecificRoomPage> {
  Future<List<IoT_Device>> devices = Future.value([]);
  @override
  void initState() {
    super.initState();
    devices = widget.specificRoom.getThisRoomsDevices();
  }

  void turn_on_off_device_tile(IoT_Device device) async {
    await device.swapStates();
    if (auth != null) {
      setState(() {
        devices = IoT_Device.get_devices(
          auth!,
          baseURL,
        );
      });
    }
  }

  void adjustDevice(BuildContext context, IoT_Device device) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditDevicePage(device: device),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.specificRoom.name}'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Looking at ${widget.specificRoom.name}',
              style: TextStyle(fontSize: 24.0),
            ),
            const SizedBox(height: 25),
            displayDevicesInRoom(context, turn_on_off_device_tile),
            // Add more settings widgets here
          ],
        ),
      ),
    );
  }

  Widget displayDevicesInRoom(BuildContext context, Function onTap) {
    return Container(
      child: deviceTiedDevices(context, onTap),
    );
  }

  Widget deviceTiedDevices(BuildContext context, Function onTap) {
    return FutureBuilder<List<IoT_Device>>(
      future: devices,
      builder:
          (BuildContext context, AsyncSnapshot<List<IoT_Device>> snapshot) {
        if (snapshot.hasData) {
          // Filter devices based on the room's ID
          List<IoT_Device> roomDevices = snapshot.data!.toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 8),
              // displayNumberOfDevicesOn(roomDevices),
              displayDeviceTiles(roomDevices, onTap),
            ],
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else {
          return failedToLoadError();
        }
      },
    );
  }

  Row displayNumberOfDevicesOn(List<IoT_Device> roomDevices) {
    return Row(
      children: [
        Text(
          '${roomDevices.length} DEVICES ON',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(width: 4), // Add spacing between text and icon
      ],
    );
  }

  Wrap displayDeviceTiles(List<IoT_Device> roomDevices, Function onTap) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: roomDevices
          .map((device) => IoT_Device_Tile(
                device: device,
                onTap: () => onTap(device),
              ))
          .toList(),
    );
  }

  Text failedToLoadError() {
    return Text(
      'Failed to load devices',
      style: GoogleFonts.poppins(fontSize: 18, color: Colors.grey[600]),
    );
  }

  bool checkDeviceValue(IoT_Device device) {
    if (device.value is int) {
      if (device.value > 0) {
        return true;
      }
    }
    return false;
  }
}
