// File: lib/widgets/base_layout.dart
import 'package:flutter/material.dart';
import 'navigation_drawer_widget.dart'; 

class BaseLayout extends StatelessWidget {
  final Widget child;
  final String title;

  BaseLayout({required this.child, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: TextStyle(fontSize: 22),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      drawer: NavigationDrawerWidget(), 
      body: child,
    );
  }
}
