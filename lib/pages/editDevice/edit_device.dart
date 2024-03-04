import 'package:flutter/material.dart';
import 'package:l3homeation/models/iot_device.dart';

class EditDevicePage extends StatelessWidget {
  final IoT_Device device;

  const EditDevicePage({required this.device});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${device.name}'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Settings for ${device.name}',
              style: TextStyle(fontSize: 24.0),
            ),
            // Add more settings widgets here
          ],
        ),
      ),
    );
  }
}
