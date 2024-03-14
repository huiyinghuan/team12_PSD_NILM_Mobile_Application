// ignore_for_file: use_build_context_synchronously, file_names, camel_case_types, library_private_types_in_public_api

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:l3homeation/services/userPreferences.dart';
import 'package:l3homeation/themes/colors.dart';
import 'package:l3homeation/widget/base_layout.dart';
import 'package:l3homeation/pages/dashboard/dashboard_shared.dart';
import 'package:l3homeation/pages/login/login_page.dart';
import 'package:l3homeation/components/error_dialog.dart';
import 'package:l3homeation/services/varHeader.dart';

class User_Profile extends StatefulWidget {
  const User_Profile({super.key});

  @override
  _User_Profile_State createState() => _User_Profile_State();
}

class _User_Profile_State extends State<User_Profile> {
  String? auth;
  // Initialize futureProfiles immediately with a safe placeholder
  Future<List<Map<String, dynamic>>> futureProfiles = Future.value([]);
  Future<void> loadAuth() async {
    auth = await User_Preferences.getString('auth');
    // Now that auth is loaded, update futureProfiles with the actual future
    setState(() {
      futureProfiles = getAllProfile();
    });
  }

  final snackBar = const SnackBar(
    content: Text("Password Change Successful!"),
    duration: Duration(seconds: 2),
  );

  @override
  void initState() {
    super.initState();
    loadAuth().then((_) {});
  }

  //add member
  Future<void> createProfile(userNameController) async {
    if (auth != null) {
      final url = Uri.parse('${Var_Header.BASEURL}/profiles');
      await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          HttpHeaders.authorizationHeader: 'Basic $auth',
        },
        body: jsonEncode(<String, dynamic>{
          'name': userNameController,
          'iconId': 6,
          'sourceId': 3
          // Name of the profile
        }),
      );
    }
  }

  Future<Map<String, dynamic>> changePassword(
      BuildContext context,
      String currentPassword,
      String newPassword,
      String newConfirmPassword) async {
    String? userName = await User_Preferences.getString('username');
    String? userID = await User_Preferences.getString('userID');
    var url = Uri.parse('${Var_Header.BASEURL}/users/$userID');
    var response = await http.put(
      url,
      headers: {
        'accept': 'application/json',
        'X-Fibaro-Version': '2',
        'Accept-language': 'en',
        'Authorization':
            'Basic ${base64Encode(utf8.encode('$userName:$currentPassword'))}',
      },
      body: const JsonEncoder().convert({
        'password': newPassword,
        'passwordConfirm': newConfirmPassword,
      }),
    );

    if (response.statusCode == 200) {
      // var jsonResponse = jsonDecode(response.body);
      return {'status': true};
    } else {
      // var jsonResponse = jsonDecode(response.body);
      return {'status': false};
    }
  }

  // get all profiles
  Future<List<Map<String, dynamic>>> getAllProfile() async {
    List<Map<String, dynamic>> profilesList = [];
    if (auth != null) {
      final url = Uri.parse('${Var_Header.BASEURL}/profiles');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          HttpHeaders.authorizationHeader: 'Basic $auth',
        },
      );

      if (response.statusCode == 200) {
        // Profile created successfully
        var jsonResponse = jsonDecode(response.body);

        // Extract the profiles list
        List<dynamic> profiles = jsonResponse['profiles'];

        //extract information from profiles json
        // Check if the profiles list is not empty
        if (profiles.isNotEmpty) {
          // Iterate through each profile in the list
          for (var profile in profiles) {
            // Extract the name of the profile
            profilesList.add({
              'name': profile['name'],
              'imageUrl':
                  'https://picsum.photos/id/237/200/300', // hardcoded image link
            });
          }
        }
      }
    }
    return profilesList;
  }

  @override
  Widget build(BuildContext context) {
    // Wrap your content with Base_Layout instead of Scaffold
    return Base_Layout(
      title: 'Profile', // Pass the title to the Base_Layout
      child: DefaultTabController(
        length: 2, // 2 tabs
        child: Column(
          children: <Widget>[
            _buildProfileHeader(context),
            const SizedBox(height: 8),
            _buildTabBar(context),
            Expanded(child: _buildTabBarView(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          // CircleAvatar(
          //   radius: 50,
          //   backgroundImage: NetworkImage(
          //       'https://picsum.photos/id/91/200/300'), // Replace with actual image
          // ),
          // SizedBox(height: 8),
          FutureBuilder<String?>(
            future: User_Preferences.getString('username'),
            builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Column(
                    children: [
                      const CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(
                            'https://picsum.photos/id/91/200/300'), // Replace with actual image
                      ),
                      const SizedBox(height: 8),
                      Text(
                        snapshot.data ??
                            '', // Display the username from the snapshot
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(
                          height: 16), // Add spacing before the button
                      SizedBox(
                        width: 100, // Set the width of the button
                        child: TextButton(
                          onPressed: () async {
                            await signUserOut(context);
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => const Login_Page()));
                          },
                          style: TextButton.styleFrom(
                            // primary: Colors.white,
                            backgroundColor: AppColors.secondary2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  18), // Set the circular radius to 18
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 16), // Add padding inside the button
                          ),
                          child: const Text('Logout'),
                        ),
                      ),
                    ],
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(BuildContext context) {
    return const TabBar(
      labelStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 17,
      ),
      tabs: [
        Tab(text: 'Personal Data'),
        Tab(text: 'Family'),
      ],
      indicatorColor: AppColors.primary2,
      indicatorWeight: 6.0,
    );
  }

  Widget _buildTabBarView(BuildContext context) {
    return TabBarView(
      children: [
        _buildPersonalDataSection(context),
        _buildFamilySection(context),
      ],
    );
  }

  bool _isEditingData = false;
  bool _isPasswordVisible = false; // State variable for password visibility

  Widget _buildPersonalDataSection(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController currentPasswordController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController confirmPasswordController = TextEditingController();

    return FutureBuilder<String?>(
      future: User_Preferences.getString('username'),
      builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            nameController.text = snapshot.data ?? '';

            return ListView(
              padding: const EdgeInsets.all(16.0),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 32.0),
                  child: !_isEditingData
                      ? Column(
                          children: [
                            TextFormField(
                              controller: nameController,
                              decoration: InputDecoration(
                                labelText: 'Name',
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: AppColors.primary2, width: 2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            const SizedBox(height: 24),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _isEditingData = true;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.secondary3,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                minimumSize: const Size(200, 48),
                              ),
                              child: const Text('Edit Data'),
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            TextFormField(
                              controller: nameController,
                              decoration: InputDecoration(
                                labelText: 'Name',
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: AppColors.primary2, width: 2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            //current password field
                            TextFormField(
                              controller: currentPasswordController,
                              decoration: InputDecoration(
                                labelText: 'Current Password',
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: AppColors.primary2, width: 2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller:
                                  passwordController, // stores the password text
                              obscureText: !_isPasswordVisible,
                              decoration: InputDecoration(
                                labelText: 'New Password',
                                hintText: 'Enter new password',
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: AppColors.primary2, width: 2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isPasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isPasswordVisible = !_isPasswordVisible;
                                    });
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller:
                                  confirmPasswordController, //store the confirm passowrd text
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: 'Retype Password',
                                hintText: 'Retype password to confirm change',
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: AppColors.primary2, width: 2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            const SizedBox(height: 24),
                            ElevatedButton(
                              onPressed: () async {
                                var response = await changePassword(
                                    context,
                                    currentPasswordController.text,
                                    passwordController.text,
                                    confirmPasswordController.text);

                                if (response['status'] == true) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                  setState(() {
                                    _isEditingData = false;
                                  });
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return const DialogBox(
                                          title: "Success!",
                                          errorText:
                                              "Password Change Successfully!");
                                    },
                                  );
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return const DialogBox(
                                          title: "Error",
                                          errorText:
                                              "Password Change Error. Please try again");
                                    },
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.secondary3,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                minimumSize: const Size(200, 48),
                              ),
                              child: const Text('Confirm Change'),
                            ),
                          ],
                        ),
                ),
              ],
            );
          }
        }
      },
    );
  }

  Widget _buildFamilySection(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: futureProfiles, // Use the future initialized in initState
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (snapshot.hasData) {
          List<Map<String, dynamic>> familyMembers = snapshot.data!;
          // Adding +1 for the "add new member" card
          double gridSpacing = 20;
          double gridPadding = 20;
          double cardWidth = (MediaQuery.of(context).size.width / 2) -
              gridPadding -
              gridSpacing;
          double cardHeight = cardWidth * 1.0; // Adjust based on your design

          return GridView.builder(
            shrinkWrap: true,
            physics: const ScrollPhysics(), // Make it scrollable
            padding: EdgeInsets.all(gridPadding),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: gridSpacing,
              mainAxisSpacing: gridSpacing,
              childAspectRatio: (cardWidth / cardHeight),
            ),
            itemCount: familyMembers.length +
                1, // Account for the "add new member" card
            itemBuilder: (context, index) {
              if (index < familyMembers.length) {
                return Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(color: AppColors.primary2, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: InkWell(
                    onTap: () {
                      // Future functionality or details
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage:
                              NetworkImage(familyMembers[index]['imageUrl']),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          familyMembers[index]['name'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                // "Add new member" card
                return Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(color: AppColors.primary2, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: InkWell(
                    onTap: () {
                      _showAddMemberDialog(context);
                    },
                    child: const Center(
                      child: Icon(
                        Icons.add_circle,
                        size: 50,
                        color: AppColors.secondary2,
                      ),
                    ),
                  ),
                );
              }
            },
          );
        } else {
          return const Center(child: Text("No profiles available"));
        }
      },
    );
  }

  void _showAddMemberDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController usernameController = TextEditingController();

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(20), // Softer curve for the dialog
          ),
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Use minimum space vertically
              children: <Widget>[
                const Text(
                  'Send New Invitation',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color:
                        AppColors.secondary2, // Consistent color for the title
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    labelText: 'Enter Username',
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: AppColors.primary2, width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Logic to send invite
                    createProfile(usernameController.text);
                    Navigator.of(context).pop(); // Close the dialog after
                    setState(() {
                      // This will re-fetch the profiles
                      futureProfiles = getAllProfile();
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    // primary: AppColors.secondary2,
                    // onPrimary: Colors.white, // Text color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                  ),
                  child:
                      const Text('Send Invite', style: TextStyle(fontSize: 16)),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel',
                      style: TextStyle(color: AppColors.secondary2)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
