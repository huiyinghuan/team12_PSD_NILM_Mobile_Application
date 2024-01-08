import 'package:flutter/material.dart';
import 'package:l3homeation/themes/colors.dart';
import 'package:l3homeation/widget/base_layout.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
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
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(
                'https://via.placeholder.com/150'), // Replace with actual image
          ),
          SizedBox(height: 8),
          Text(
            'John Abraham',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          SizedBox(height: 16), // Add spacing before the button
          SizedBox(
            width: 100, // Set the width of the button
            child: TextButton(
              onPressed: () {
                // To handle logout logic
              },
              child: Text('Logout'),
              style: TextButton.styleFrom(
                primary: Colors.white,
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
    TextEditingController _nameController =
        TextEditingController(text: 'John Abraham');
    TextEditingController _passwordController = TextEditingController();
    TextEditingController _confirmPasswordController = TextEditingController();

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
                          borderSide: BorderSide(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: AppColors.primary2, width: 2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      initialValue: 'test123',
                      // controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: 'Leave blank to keep current password',
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: AppColors.primary2, width: 2),
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
                          borderSide: BorderSide(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: AppColors.primary2, width: 2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        labelText: 'New Password',
                        hintText: 'Enter new password',
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: AppColors.primary2, width: 2),
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
                      controller: _confirmPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Retype Password',
                        hintText: 'Retype password to confirm change',
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: AppColors.primary2, width: 2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        // Implement your logic for password change confirmation here

                        // After performing the logic, reset the editing state and clear the controllers
                        setState(() {
                          _isEditingData = false;
                          _passwordController.clear();
                          _confirmPasswordController.clear();
                        });
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

  Widget _buildFamilySection(BuildContext context) {
    // Dummy data for family members
    List<Map<String, dynamic>> familyMembers = [
      {
        'name': 'Linda Abraham',
        'imageUrl':
            'https://via.placeholder.com/150/0000FF/808080?text=Linda+Abraham', // Replace with actual image URL
      },
      {
        'name': 'Lyra Abraham',
        'imageUrl':
            'https://via.placeholder.com/150/FF0000/FFFFFF?text=Lyra+Abraham', // Replace with actual image URL
      },
      {
        'name': 'Ben Abraham',
        'imageUrl':
            'https://via.placeholder.com/150/FFFF00/000000?text=Ben+Abraham', // Replace with actual image URL
      },
      {
        'icon': Icons.add,
      },
    ];
    // Calculate the space available after accounting for padding and spacing
    double gridSpacing = 20;
    double gridPadding = 20;
    double cardWidth =
        (MediaQuery.of(context).size.width / 2) - gridPadding - gridSpacing;

    return GridView.builder(
      padding: EdgeInsets.all(gridPadding),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: gridSpacing,
        mainAxisSpacing: gridSpacing,
        childAspectRatio: (cardWidth /
            (cardWidth *
                1.0)), // Assuming you want the card height to be 80% of its width
      ),
      itemCount: familyMembers.length,
      itemBuilder: (context, index) {
        final member = familyMembers[index];

        return Card(
          // Keep the border radius and outline as is, or adjust as needed
          shape: RoundedRectangleBorder(
            side: BorderSide(color: AppColors.primary2, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: InkWell(
            onTap: () {
              if (member.containsKey('icon')) {
                _showAddMemberDialog(context);
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (member.containsKey('imageUrl')) ...[
                  CircleAvatar(
                    radius: 30, // Adjust as needed
                    backgroundImage: NetworkImage(member['imageUrl']),
                  ),
                  SizedBox(height: 8),
                  Text(
                    member['name'],
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ] else ...[
                  Icon(
                    member['icon'],
                    size: 100,
                    color: AppColors.secondary3,
                  ),
                ],
              ],
            ),
          ),
        );
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
          elevation: 5, // Adds a subtle shadow for depth
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
                    labelStyle: TextStyle(color: AppColors.primary2),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.primary2),
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
                    Navigator.of(context).pop(); // Close the dialog after
                  },
                  child: Text('Send Invite', style: TextStyle(fontSize: 16)),
                  style: ElevatedButton.styleFrom(
                    primary: AppColors.secondary2,
                    onPrimary: Colors.white, // Text color
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