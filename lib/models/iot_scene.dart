// ignore_for_file: camel_case_types, empty_catches
import 'dart:io';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:l3homeation/models/iot_device.dart';

class IoT_Scene {
  String? name;
  String? description;
  String? type;
  String? mode;
  String? icon;
  bool enable;
  int? created;
  int? updated;
  dynamic content;
  int id;
  int? roomid;
  String wholeJSON;

  // for API Call
  String URL;
  String credentials;

  IoT_Scene({
    required this.name,
    // required this.imagePath,
    required this.id,
    required this.roomid,
    required this.type,
    required this.mode,
    required this.icon,
    required this.enable,
    required this.created,
    required this.updated,
    required this.description,
    required this.content,
    required this.wholeJSON,
    required this.URL,
    required this.credentials,
  });

  Future<void> swapStates() async {
    print("swapping states now\n");
    print("check current state: $enable\n");
    try {
      List<dynamic> jsonResponse = await fetchScenes(credentials, URL, id);

      var onlinevalue = jsonResponse[0]['enabled'];
      if (onlinevalue != enable) {
        enable = onlinevalue;
        return;
      }
    } catch (e) {
      print(e);
    }
    // ignore: unused_local_variable
    late Response? response_put;
    try {
      response_put =
          await putRequest(credentials, URL, id, {'enabled': !enable});
    } catch (e) {
      print("Http put request failed\n");
      print(e);
    }
    print("finished swapping states\n");
  }

  String toString_IOT() {
    return "IoT_Scene: $name, $description, $type, $mode, $icon, $enable, $created, $updated, $content, $id, $roomid";
  }

  Future<Response> activate_scenes() async {
    late Response? response_put;
    response_put = await http.get(
      Uri.parse(URL + '/api/scenes/$id/execute'),
      headers: {
        HttpHeaders.authorizationHeader: 'Basic $credentials',
      },
    );
    return response_put;
  }

  Future<Response> putmethod(String updatedJSON) async {
    late Response response_put;
    response_put = await http.put(
      Uri.parse(URL + '/api/scenes/$id'),
      headers: {
        HttpHeaders.authorizationHeader: 'Basic $credentials',
      },
      body: updatedJSON,
    );
    return response_put;
  }

  Future<Response> change_description(String new_description) async {
    // fetch data and change only description
    Map wholeJSON = (await fetchScenes(credentials, URL, id))[0];
    wholeJSON['description'] = new_description;
    Response response_put = await putmethod(jsonEncode(wholeJSON));
    return response_put;
  }

  Future<Response> change_icon(String newIcon) async {
    // fetch data and change only description
    Map wholeJSON = (await fetchScenes(credentials, URL, id))[0];
    wholeJSON['icon'] = newIcon;
    Response response_put = await putmethod(jsonEncode(wholeJSON));
    return response_put;
  }

  Future<Response> change_action_state(String action_state, int index) async {
    // content updates
    List jsonData = jsonDecode(content);
    Map<String, dynamic> action = jsonData[0]['actions'][index];
    action['action'] = action_state;
    jsonData[0]['actions'][index] = action;
    content = jsonEncode(jsonData);

    // wholeJSON updates
    Map<String, dynamic> jsonData2 = jsonDecode(wholeJSON);
    List<dynamic> content2 = jsonDecode(jsonData2['content']);
    Map<String, dynamic> action2 = content2[0]['actions'][index];
    action2['action'] = action_state;
    content2[0]['actions'][index] = action2;
    jsonData2['content'] = jsonEncode(content2);
    // Convert the modified JSON back to a string
    String updatedJSON = jsonEncode(jsonData2);
    wholeJSON = updatedJSON;

    Response response_put = await putmethod(updatedJSON);
    return response_put;
  }

  Future<Response> add_devices_into_action(IoT_Device new_device) async {// fetch data and change only description
    var dict = {
      "group": "device",
      "type": "single",
      "id": new_device.id,
      "action": (new_device.runtimeType == bool) ? "close" : "turnOff",
      "args": [],
    };
    // content updates
    var jsonData = jsonDecode(content);
    var oldDataAction = (jsonData[0])['actions'];
    oldDataAction ??= []; 
    oldDataAction.add(dict); // entered at the last row of data
    (jsonData[0])['actions'] = oldDataAction;
    content = jsonEncode(jsonData); // put it back

    // wholeJSON updates
    var jsonData2 = jsonDecode(wholeJSON);
    var content2 = jsonDecode(jsonData2['content']);
    var oldDataAction2 = content2[0]['actions'];
    oldDataAction2 ??= []; 
    oldDataAction2.add(dict); // entered at the last row of data

    // put it back
    content2[0]['actions'] = oldDataAction2;
    jsonData2['content'] = jsonEncode(content2);
    // Convert the modified JSON back to a string
    String updatedJSON = jsonEncode(jsonData2);
    wholeJSON = updatedJSON;

    Response response_put = await putmethod(updatedJSON);
    return response_put;
  }

  Future<Response> remove_devices_from_action(int index) async {
    // content updates
    List jsonData = jsonDecode(content);
    List<dynamic> oldDataAction = jsonData[0]['actions'];
    oldDataAction.removeAt(index);
    jsonData[0]['actions'] = oldDataAction;
    content = jsonEncode(jsonData);

    // wholeJSON updates
    Map<String, dynamic> jsonData2 = jsonDecode(wholeJSON);
    List<dynamic> content2 = jsonDecode(jsonData2['content']);
    List<dynamic> oldDataAction2 = content2[0]['actions'];
    oldDataAction2.removeAt(index);
    content2[0]['actions'] = oldDataAction2;
    jsonData2['content'] = jsonEncode(content2);
    // Convert the modified JSON back to a string
    String updatedJSON = jsonEncode(jsonData2);
    wholeJSON = updatedJSON;

    Response response_put = await putmethod(updatedJSON);
    return response_put;
  }

  static Future<Response> post_new_scene(
    String name,
    String description,
    dynamic content,
    String icon,
    String credentials,
    String URL,
  ) {
    var sceneData = {
      "hidden": false, //no need change
      "protectedByPin": false, //no need change
      "sceneView": "sceneView", //not sure yet
      "icon": icon,
      "maxRunningInstances": 2, //no need change
      "stopOnAlarm": false, //no need change
      "restart": true, //no need change
      "type": "json", //no need change
      "content": content,
      "enabled": true, //no need change
      "mode": "automatic", //no need change
      "name": name,
      "description": description,
      "categories": [1], //no need change
      "roomId": 219, //no need change
    };
    final response = http.post(
      Uri.parse('$URL/api/scenes'),
      headers: {
        HttpHeaders.authorizationHeader: 'Basic $credentials',
      },
      body: JsonEncoder().convert(sceneData),
    );
    return response;
  }

  static Future<List<IoT_Scene>> get_scenes(
      String credentials, String URL) async {
    List<IoT_Scene> scenes = [];
    List<dynamic> jsonResponses = await fetchScenes(credentials, URL, null);
    for (Map<String, dynamic> response in jsonResponses) {
      IoT_Scene new_scene;
      if (response['type'] == 'scenario') {
        new_scene = IoT_Scene(
          id: response['id'],
          name: response['name'],
          description: response['description'],
          type: response['type'],
          roomid: response['roomId'],
          mode: response['automatic'],
          icon: response['icon'],
          enable: response['enabled'],
          created: response['created'],
          updated: response['updated'],
          // content: response['content'],
          content: {
            "actions": json.decode(response['content'])['actions'],
            "conditions": json.decode(response['content'])['conditions'],
          },
          URL: URL,
          credentials: credentials,
          wholeJSON: jsonEncode(response),
        );
      } else {
        new_scene = IoT_Scene(
          id: response['id'],
          name: response['name'],
          description: response['description'],
          type: response['type'],
          roomid: response['roomId'],
          mode: response['automatic'],
          icon: response['icon'],
          enable: response['enabled'],
          created: response['created'],
          updated: response['updated'],
          content: response['content'],
          // content: {
          //   "actions": json.decode(response['content'])['actions'],
          //   "conditions": json.decode(response['content'])['conditions'],
          // },
          URL: URL,
          credentials: credentials,
          wholeJSON: jsonEncode(response),
        );
      }
      scenes.add(new_scene);
      // }
    }
    return scenes;
  }

  static Future<List<dynamic>> fetchScenes(
    String credentials,
    String baseURL,
    int? id,
  ) async {
    String url = id == null ? '$baseURL/api/scenes?alexaProhibited=true' : '$baseURL/api/scenes/$id';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        HttpHeaders.authorizationHeader: 'Basic $credentials',
      },
    );

    List<dynamic> jsonResponses = id == null
        ? await jsonDecode(response.body)
        : [jsonDecode(response.body)];
    return jsonResponses;
  }

  static Future<Response> putRequest(
    String credentials,
    String baseURL,
    int id,
    dynamic requestBody,
  ) {
    final response = http.put(
      Uri.parse('$baseURL/api/scenes/$id'),
      headers: {
        HttpHeaders.authorizationHeader: 'Basic $credentials',
      },
      body: jsonEncode(requestBody),
    );

    return response;
  }
}
