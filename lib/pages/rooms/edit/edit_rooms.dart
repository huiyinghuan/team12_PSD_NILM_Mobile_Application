import 'package:flutter/material.dart';
import 'package:l3homeation/models/room.dart';

class EditRoomPage extends StatefulWidget {
  final Room room;

  const EditRoomPage({required this.room});

  @override
  State<EditRoomPage> createState() => _EditRoomPageState();
}

class _EditRoomPageState extends State<EditRoomPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.room.name}'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Editing for ${widget.room.name}',
              style: const TextStyle(fontSize: 24.0),
            ),
            // Add more settings widgets here
          ],
        ),
      ),
    );
  }
}
