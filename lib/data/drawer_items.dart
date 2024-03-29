import 'package:flutter/material.dart';
import 'package:l3homeation/models/drawer_item.dart';

class MyFlutterApp {
  MyFlutterApp._();

  static const String _kFontFam = 'MyFlutterApp';

  static const IconData dashboard = IconData(0xe800, fontFamily: _kFontFam);

  // please help to edit the .ttf file to include the custom images for this ( not sure about this )
  static const IconData list_devices = IconData(0xe805, fontFamily: _kFontFam);

  static const IconData scenes = IconData(0xe802, fontFamily: _kFontFam);

  // and this (maybe a sofa looking picture)
  static const IconData rooms_list = IconData(0xe805, fontFamily: _kFontFam);

  static const IconData power_consumption =
      IconData(0xe801, fontFamily: _kFontFam);
  static const IconData profile_setting =
      IconData(0xe803, fontFamily: _kFontFam);
  static const IconData router = IconData(0xe804, fontFamily: _kFontFam);
}

const itemsFirst = [
  DrawerItem(title: 'Dashboard', icon: MyFlutterApp.dashboard),
  DrawerItem(title: 'All Devices', icon: MyFlutterApp.list_devices),
  DrawerItem(title: 'Scenes', icon: MyFlutterApp.scenes),
  DrawerItem(title: 'Rooms', icon: MyFlutterApp.rooms_list),
  DrawerItem(title: 'Power', icon: MyFlutterApp.power_consumption),
  DrawerItem(title: 'Profile', icon: MyFlutterApp.profile_setting),
];

const itemsSecond = [
  DrawerItem(title: 'Searching...', icon: MyFlutterApp.router),
];
