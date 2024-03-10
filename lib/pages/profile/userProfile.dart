import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:l3homeation/services/userPreferences.dart';
import 'package:l3homeation/themes/colors.dart';
import 'package:l3homeation/widget/base_layout.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  String? auth;
  // Initialize futureProfiles immediately with a safe placeholder
  Future<List<Map<String, dynamic>>> futureProfiles = Future.value([]);
  Future<void> loadAuth() async {
    auth = await UserPreferences.getString('auth');
    // Now that auth is loaded, update futureProfiles with the actual future
    setState(() {
      futureProfiles = getAllProfile();
    });
  }

  @override
  void initState() {
    super.initState();
    loadAuth().then((_) {
      print("Got auth: $auth\n");
    });
  }

  //add member
  Future<void> createProfile(_userNameController) async {
    if (auth != null) {
      final url = Uri.parse('http://l3homeation.dyndns.org:2080/api/profiles');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          HttpHeaders.authorizationHeader: 'Basic $auth',
        },
        body: jsonEncode(<String, dynamic>{
          'name': _userNameController,
          'iconId': 6,
          'sourceId': 3
          // Name of the profile
        }),
      );

      if (response.statusCode == 200) {
        // Profile created successfully

        print('Profile created successfully');
      } else {
        // Failed to create profile
        print('Failed to create profile: ${response.statusCode}');
        // Print the response body for more details about the error
        print('Response body: ${response.body}');
        // You can handle errors appropriately
      }
    }
  }

  // get all profiles
  Future<List<Map<String, dynamic>>> getAllProfile() async {
    List<Map<String, dynamic>> profilesList = [];
    if (auth != null) {
      final url = Uri.parse('http://l3homeation.dyndns.org:2080/api/profiles');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          HttpHeaders.authorizationHeader: 'Basic $auth',
        },
      );

      if (response.statusCode == 200) {
        // Profile created successfully
        print('Profile retrieved successfully');

        var jsonResponse = jsonDecode(response.body);
        print(jsonResponse);

        // Extract the profiles list
        List<dynamic> profiles = jsonResponse['profiles'];

        //extract information from profiles json
        // Check if the profiles list is not empty
        if (profiles.isNotEmpty) {
          // Iterate through each profile in the list
          for (var profile in profiles) {
            // Extract the name of the profile
            String name = profile['name'];
            print('Name: $name');

            profilesList.add({
              'name': profile['name'],
              'imageUrl':
                  'https://picsum.photos/id/237/200/300', // hardcoded image link
            });
          }

          // Get the last profile in the list
          Map<String, dynamic> lastProfile = profiles.last;

          // Extract the ID of the last profile
          int lastProfileId = lastProfile['id'];
          print('ID of the last profile: $lastProfileId');
        }
      } else {
        // Failed to create profile
        print('Failed to get all profile: ${response.statusCode}');
        // Print the response body for more details about the error
        print('Response body: ${response.body}');
        // You can handle errors appropriately
      }
    }
    return profilesList;
  }

  @override
  Widget build(BuildContext context) {
    // Wrap your content with BaseLayout instead of Scaffold
    return BaseLayout(
      title: 'Profile', // Pass the title to the BaseLayout
      child: DefaultTabController(
        length: 2, // 2 tabs
        child: Column(
          children: <Widget>[
            _buildProfileHeader(context),
            SizedBox(height: 8),
            _buildTabBar(context),
            Expanded(child: _buildTabBarView(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          // CircleAvatar(
          //   radius: 50,
          //   backgroundImage: NetworkImage(
          //       'https://picsum.photos/id/91/200/300'), // Replace with actual image
          // ),
          // SizedBox(height: 8),
          FutureBuilder<String?>(
            future: UserPreferences.getString('username'),
            builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(
                            'https://picsum.photos/id/91/200/300'), // Replace with actual image
                      ),
                      SizedBox(height: 8),
                      Text(
                        snapshot.data ??
                            '', // Display the username from the snapshot
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),

                      // )
                      // Text(
                      //   'John Abraham',
                      //   style: TextStyle(
                      //     fontWeight: FontWeight.bold,
                      //     fontSize: 24,
                      //   ),
                      // ),
                      SizedBox(height: 16), // Add spacing before the button
                      SizedBox(
                        width: 100, // Set the width of the button
                        child: TextButton(
                          onPressed: () {
                            // To handle logout logic
                          },
                          child: Text('Logout'),
                          style: TextButton.styleFrom(
                            // primary: Colors.white,
                            backgroundColor: AppColors.secondary2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  18), // Set the circular radius to 18
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 16), // Add padding inside the button
                          ),
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
    return TabBar(
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
    TextEditingController _nameController = TextEditingController();
    TextEditingController _currentPasswordController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();
    TextEditingController _confirmPasswordController = TextEditingController();
    String? _errorMessage;

    // check if the password entered is the same
    bool passwordsMatch() {
      return _passwordController.text == _confirmPasswordController.text;
    }

    //check if current password entered matches the passowrd in the server
    Future<bool> checkCurrentPassword(String _currentPasswordController) async {
      String? storedAuth = await UserPreferences.getString('auth');
      if (storedAuth != null) {
        List<int> decodedBytes = base64Decode(storedAuth);
        String decodedString = utf8.decode(decodedBytes);

        List<String> emailPassword = decodedString.split(':');
        String password = emailPassword[1];

        if (password == _currentPasswordController) {
          // Password entered matches the password in the user preference string
          return true;
        } else {
          return false;
        }
      } else {
        print("auth string not found");
        return false;
      }
    }

    // final AuthService _authService = AuthService(password: _currentPasswordController.text);
    // var response = await _authService.checkLoginStatus(context);
    // print("Response: ${_currentPasswordController.text}");

    // if (response['status'] == true) {
    //   return true;
    //   else{
    //     return false;
    //   }
//    }

    return FutureBuilder<String?>(
      future: UserPreferences.getString('username'),
      builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            _nameController.text = snapshot.data ?? '';

            return ListView(
              padding: EdgeInsets.all(16.0),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 32.0),
                  child: !_isEditingData
                      ? Column(
                          children: [
                            TextFormField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                labelText: 'Name',
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppColors.primary2, width: 2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                            // TextFormField(
                            //   initialValue: 'test123',
                            //   // controller: _passwordController,
                            //   obscureText: !_isPasswordVisible,
                            //   decoration: InputDecoration(
                            //     labelText: 'Password',
                            //     hintText:
                            //         'Leave blank to keep current password',
                            //     enabledBorder: OutlineInputBorder(
                            //       borderSide:
                            //           BorderSide(color: Colors.grey.shade300),
                            //       borderRadius: BorderRadius.circular(12),
                            //     ),
                            //     focusedBorder: OutlineInputBorder(
                            //       borderSide: BorderSide(
                            //           color: AppColors.primary2, width: 2),
                            //       borderRadius: BorderRadius.circular(12),
                            //     ),
                            //     suffixIcon: IconButton(
                            //       icon: Icon(
                            //         _isPasswordVisible
                            //             ? Icons.visibility
                            //             : Icons.visibility_off,
                            //       ),
                            //       onPressed: () {
                            //         setState(() {
                            //           _isPasswordVisible = !_isPasswordVisible;
                            //         });
                            //       },
                            //     ),
                            //   ),
                            // ),
                            SizedBox(height: 24),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _isEditingData = true;
                                });
                              },
                              child: Text('Edit Data'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.secondary3,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 16),
                                minimumSize: Size(200, 48),
                              ),
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            TextFormField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                labelText: 'Name',
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppColors.primary2, width: 2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                            //current password field
                            TextFormField(
                              controller: _currentPasswordController,
                              decoration: InputDecoration(
                                labelText: 'Current Password',
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppColors.primary2, width: 2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                            TextFormField(
                              controller:
                                  _passwordController, // stores the password text
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
                                  borderSide: BorderSide(
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
                            SizedBox(height: 16),
                            TextFormField(
                              controller:
                                  _confirmPasswordController, //store the confirm passowrd text
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
                                  borderSide: BorderSide(
                                      color: AppColors.primary2, width: 2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                            if (_errorMessage != null)
                              Text(
                                _errorMessage!,
                                style: TextStyle(
                                    color: Colors
                                        .red), // Customize error text style
                              ),
                            SizedBox(height: 24),
                            ElevatedButton(
                              onPressed: () async {
                                // Check if passwords match
                                // if (passwordsMatch()) {
                                //   // Passwords match, implement your logic for password change confirmation here
                                //   Future<bool> passwordCheck = checkCurrentPassword(_currentPasswordController.text);
                                //   if (passwordCheck == true) {

                                //   }

                                //   // After performing the logic, reset the editing state and clear the controllers
                                //   setState(() {
                                //     _isEditingData = false;
                                //     _passwordController.clear();
                                //     _confirmPasswordController.clear();
                                //     // Reset error message when passwords match
                                //     _errorMessage = null;
                                //   });
                                // } else {
                                //   // Passwords do not match, show an error message or take appropriate action
                                //   setState(() {
                                //     _errorMessage = 'Passwords do not match';
                                //   });
                                // }
                              },
                              child: Text('Confirm Change'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.secondary3,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 16),
                                minimumSize: Size(200, 48),
                              ),
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
          return Center(child: CircularProgressIndicator());
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
            physics: ScrollPhysics(), // Make it scrollable
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
                    side: BorderSide(color: AppColors.primary2, width: 2),
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
                        SizedBox(height: 8),
                        Text(
                          familyMembers[index]['name'],
                          style: TextStyle(
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
                    side: BorderSide(color: AppColors.primary2, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: InkWell(
                    onTap: () {
                      _showAddMemberDialog(context);
                    },
                    child: Center(
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
          return Center(child: Text("No profiles available"));
        }
      },
    );
  }

  void _showAddMemberDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController _usernameController = TextEditingController();

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
                Text(
                  'Send New Invitation',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color:
                        AppColors.secondary2, // Consistent color for the title
                  ),
                ),
                SizedBox(height: 15),
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Enter Username',
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: AppColors.primary2, width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Logic to send invite
                    createProfile(_usernameController.text);
                    Navigator.of(context).pop(); // Close the dialog after
                    setState(() {
                      // This will re-fetch the profiles
                      futureProfiles = getAllProfile();
                    });
                  },
                  child: Text('Send Invite', style: TextStyle(fontSize: 16)),
                  style: ElevatedButton.styleFrom(
                    // primary: AppColors.secondary2,
                    // onPrimary: Colors.white, // Text color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Cancel',
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
