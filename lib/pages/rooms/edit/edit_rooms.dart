import 'package:flutter/material.dart';
import 'package:l3homeation/models/room.dart';

class Edit_Room_Page extends StatefulWidget {
  final Room room;

  const Edit_Room_Page({required this.room});

  @override
  State<Edit_Room_Page> createState() => _Edit_Room_Page_State();
}

class _Edit_Room_Page_State extends State<Edit_Room_Page> {
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
