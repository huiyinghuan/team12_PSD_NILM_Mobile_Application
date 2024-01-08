import 'dart:async';

import 'package:flutter/material.dart';
import 'package:l3homeation/themes/colors.dart';
import 'package:l3homeation/widget/base_layout.dart';

class ListDevice extends StatefulWidget {
  @override
  _ListDeviceState createState() => _ListDeviceState();
}

class _ListDeviceState extends State<ListDevice> {
  final List<String> devices = [
    'Device 1',
    'Device 2',
    'Device 3',
    'Device 4',
    'Device 5',
    'Device 6',
    // Add more devices as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          _buildGridSliver(),
          _buildLargeGridSliver(),
        ],
      ),
    );
  }

  SliverAppBar _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 200.0,
      pinned: true,
      floating: true, // Set to true for the app bar to become visible as soon as the user scrolls
      snap: true, // App bar snaps into view when scrolled up
      flexibleSpace: FlexibleSpaceBar(
        title: Text('List of Devices'),
        background: Image.network(
          'https://example.com/your_image.jpg',
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  SliverGrid _buildGridSliver() {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Number of columns
        crossAxisSpacing: 8.0, // Spacing between columns
        mainAxisSpacing: 8.0, // Spacing between rows
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return _buildDeviceCard(devices[index]);
        },
        childCount: devices.length,
      ),
    );
  }

  SliverList _buildLargeGridSliver() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          // Replace this with your large grid widget
          return _buildDeviceCard(devices[index], isLarge: true);
        },
        childCount: 1, // Only one item in the SliverList
      ),
    );
  }

  Widget _buildDeviceCard(String deviceName, {bool isLarge = false}) {
    // Customize the appearance of each device card
    return Card(
      elevation: 2.0,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              deviceName,
              style: TextStyle(
                fontSize: isLarge ? 24 : 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            // Add more details or widgets related to the device
          ],
        ),
      ),
    );
  }
}
