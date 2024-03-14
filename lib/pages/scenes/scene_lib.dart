// ignore_for_file: unused_import

library scene_lib;

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:l3homeation/models/iot_device.dart';
import 'package:l3homeation/models/iot_scene.dart';
import 'package:l3homeation/pages/scenes/each_scene.dart';
import 'package:l3homeation/services/varHeader.dart';
import 'package:l3homeation/themes/colors.dart';

import 'scene_shared.dart';

// for List_Scenes.dart 
part './scene_list/add_floating_button.dart';
part './scene_list/build_image_title.dart';
part './scene_list/build_scene_info.dart';
part './scene_list/build_button_switch.dart';
part './scene_list/future_scene_list.dart';

// for Each_Scene.dart

// first tab
part 'scene_each_individual/icon_scene_name.dart';
part 'scene_each_individual/build_firsttab.dart';
part 'scene_each_individual/first_tab/build_firsttab_content_top.dart';
part 'scene_each_individual/first_tab/build_firsttab_content_body.dart';
part 'scene_each_individual/first_tab/build_firsttab_body_datatable.dart';

// second tab
part 'scene_each_individual/build_secondtab.dart';
part 'scene_each_individual/second_tab/build_secondtab_content_top.dart';
part 'scene_each_individual/second_tab/build_secondtab_content_body.dart';
part 'scene_each_individual/second_tab/build_secondtab_body_all_devices.dart';
part 'scene_each_individual/second_tab/build_secondtab_body_add_devices.dart';
