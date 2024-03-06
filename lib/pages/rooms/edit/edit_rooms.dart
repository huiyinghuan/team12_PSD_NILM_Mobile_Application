import 'package:flutter/material.dart';
import 'package:l3homeation/models/room.dart';

class EditRoomPage extends StatelessWidget {
  final Room room;

  const EditRoomPage({required this.room});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${room.name}'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Editing for ${room.name}',
              style: TextStyle(fontSize: 24.0),
            ),
            // Add more settings widgets here
          ],
        ),
      ),
    );
  }
}
