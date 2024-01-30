// ignore_for_file: camel_case_types, empty_catches
import 'dart:io';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

    required this.URL,
    required this.credentials,
  });

  Future<void> swapStates() async {
    print("swapping states now\n");
    print("check current state: $enable\n");
    try {
      List<dynamic> jsonResponse = await fetchScenes(credentials, URL, id);
      
      // check if online value is same as local value, if not, update local value
      var onlinevalue = jsonResponse[0]['enabled'];
      if (onlinevalue != enable) {
        print("online enable is not same as local enable\n");
        print("online enable: $onlinevalue\n");
        print("do not swap state, but update the interface enable and local enable");
        enable = onlinevalue;
        return;
      }
    } catch (e) {
      print(e);
    }
    // ignore: unused_local_variable
    late Response? response_put;
    try {
      print("${enable.runtimeType}");

      // swap the state. send request to backend
      response_put = await putRequest(
                            credentials, URL, id, 
                            {'enabled': !enable}
                          );
    } catch (e) {
      print("Http put request failed\n");
      print(e);
    }
    print("finished swapping states\n");
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
          type:response['type'],
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
        );
      } else {
        new_scene = IoT_Scene(
          id: response['id'],
          name: response['name'],
          description: response['description'],
          type:response['type'],
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
        );
      }
      scenes.add(new_scene);
      // }
    }
    return scenes;
  }

  static Future<List<dynamic>> fetchScenes(
    String credentials, String baseURL, int? id,
  ) async {
    String url = id == null ? '$baseURL/api/scenes' : '$baseURL/api/scenes/$id';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        HttpHeaders.authorizationHeader: 'Basic $credentials',
      },
    );

    List<dynamic> jsonResponses = jsonDecode(response.body);
    return jsonResponses;
  }

  static Future<Response> putRequest(
    String credentials, String baseURL, int id, dynamic requestBody,
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
