import 'package:flutter/material.dart';
import 'package:l3homeation/models/drawer_item.dart';

class MyFlutterApp {
  MyFlutterApp._();

  static const String _kFontFam = 'MyFlutterApp';

  static const IconData dashboard = IconData(0xe800, fontFamily: _kFontFam);
  static const IconData power_consumption = IconData(0xe801, fontFamily: _kFontFam);
  static const IconData scene = IconData(0xe802, fontFamily: _kFontFam);
  static const IconData profile_setting = IconData(0xe803, fontFamily: _kFontFam);
  static const IconData router = IconData(0xe804, fontFamily: _kFontFam);
}

final itemsFirst = const [
  DrawerItem(title: 'Dashboard', icon: MyFlutterApp.dashboard),
  DrawerItem(title: 'Power', icon: MyFlutterApp.power_consumption),
  DrawerItem(title: 'Scenes', icon: MyFlutterApp.scene),
  DrawerItem(title: 'Profile', icon: MyFlutterApp.profile_setting),
];

final itemsSecond = const [
  DrawerItem(title: 'Searching...', icon: MyFlutterApp.router),
];
