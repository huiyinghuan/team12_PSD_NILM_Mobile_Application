// ignore_for_file: camel_case_types

import "package:flutter/material.dart";
import "../themes/colors.dart";

class dashboard extends StatefulWidget {
  const dashboard({super.key});
  final String name = "Welcome back {Username}";
  @override
  State<dashboard> createState() => _dashboardState();
}

class _dashboardState extends State<dashboard> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(widget.name),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        foregroundColor: Colors.black,
        backgroundColor: primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }
}
