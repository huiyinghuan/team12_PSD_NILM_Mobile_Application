// import 'dart:io';
// import 'package:http/http.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class User {
//   int? id;
//   String? email;
//   String? password;
//   String? passwordConfirm;
//   String? name;
//   String? type;
//   String wholeJSON;

//   // for API Call
//   late String URL;
//   late String credentials;

//   User(
//       {required this.id,
//       required this.email,
//       required this.password,
//       required this.passwordConfirm,
//       required this.wholeJSON,
//       required this.URL,
//       required this.credentials,
//       required this.name,
//       required this.type});

// // Future<List<dynamic>> fetchData() async {
// //   final response =
// //       await http.get(Uri.parse('http://l3homeation.dyndns.org:2080'));
// //   if (response.statusCode == 200) {
// //     // Data fetched successfully
// //     print(response.body);
// //   } else {
// //     // Handle errors
// //     print('Failed to load data: ${response.statusCode}');
// //   }
// // }

//   Future<List<dynamic>> fetchAvailableUsers(
//     String credentials,
//     String baseURL,
//     int? id,
//   ) async {
//     String url = '$baseURL/api/users';
//     final response = await http.get(
//       Uri.parse(url),
//       headers: {
//         HttpHeaders.authorizationHeader: 'Basic $credentials',
//       },
//     );

//     List<dynamic> jsonResponses = id == null
//         ? await jsonDecode(response.body)
//         : [jsonDecode(response.body)];
//     return jsonResponses;
//   }


//   Future<List<User>> fetchUsersFromJsonResponses(
//     List<dynamic> jsonResponses,
//   ) async {
//     List<User> userList = [];

//     // Iterate through the JSON responses
//     for (var jsonResponse in jsonResponses) {
//       // Extract required fields for each user
//       int? id = jsonResponse['id'];
//       String? name = jsonResponse['name'];
//       String? type = jsonResponse['type'];
//       String? email = jsonResponse['email'];
//       String? password = jsonResponse['password'];
//       String? passwordConfirm = jsonResponse['passwordConfirm'];

//       // Create a User object and add it to the list
//       User user = User(
//         id: id,
//         name: name,
//         type: type,
//         email: email,
//         password: password,
//         passwordConfirm: passwordConfirm
//         // Initialize other fields as required
//       );

//       userList.add(user);
//     }

//     return userList;
//   }
// }


//   // Future<List<dynamic>> fetchUserObject(
//   //   String credentials,
//   //   String baseURL,
//   //   int? id,
//   // ) async {
//   //   String url = '$baseURL/api/user/$id';
//   //   final response = await http.get(
//   //     Uri.parse(url),
//   //     headers: {
//   //       HttpHeaders.authorizationHeader: 'Basic $credentials',
//   //     },
//   //   );

//   //   List<dynamic> jsonResponses = id == null
//   //       ? await jsonDecode(response.body)
//   //       : [jsonDecode(response.body)];
//   //   return jsonResponses;
//   // }

//   Future<Response> putRequest(
//     String credentials,
//     String baseURL,
//     int id,
//     dynamic requestBody,
//   ) {
//     final response = http.put(
//       Uri.parse('$baseURL/api/users/$id'),
//       headers: {
//         HttpHeaders.authorizationHeader: 'Basic $credentials',
//       },
//       body: jsonEncode(requestBody),
//     );

//     return response;
//   }

//   Future<Response> putmethod(String updatedJSON) async {
//     late Response response_put;
//     response_put = await http.put(
//       Uri.parse(URL + '/api/users/$id'),
//       headers: {
//         HttpHeaders.authorizationHeader: 'Basic $credentials',
//       },
//       body: updatedJSON,
//     );
//     return response_put;
//   }

//   Future<Response> changePassword(String newPassword) async {
//     Map wholeJSON = (await fetchUserObject(credentials, URL, id))[0];
//     wholeJSON['password'] = newPassword;
//     wholeJSON['passwordConfirm'] = newPassword;
//     Response response_put = await putmethod(jsonEncode(wholeJSON));
//     return response_put;
//   }

// // void updateUserProfile(String credentials, String baseURL, Map<String, dynamic> updatedData) async {
// //   int userId = updatedData['id']; // Assuming the user ID is required for updating the profile

// //   // Construct the URL for updating the user profile
// //   String url = '$baseURL/api/users/$userId';

// //   // Make the PUT request to update the user profile
// //   Response response = await IoT_Scene.putRequest(
// //     credentials,
// //     url,
// //     updatedData,
// //   );

// //   // Check the response status to handle success or failure
// //   if (response.statusCode == 200) {
// //     // Profile updated successfully
// //     print('User profile updated successfully');
// //   } else {
// //     // Handle error
// //     print('Failed to update user profile: ${response.body}');
// //   }
// // }
// // Future<void> changePassword(String new_password) async {
// //   final response = await http.put(Uri.parse(URL + '/api/users/$id'));
// // }
// }
