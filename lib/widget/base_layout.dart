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
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF00456B), Color(0x00BBD6CD)],
            ),
          ),
        ),
        title: Text(
          title,
          style: TextStyle(fontSize: 22),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        automaticallyImplyLeading:
            false, // removes the hamburger icon on the nav bar
      ),
      drawer: NavigationDrawerWidget(),
      body: child,
    );
  }
}
