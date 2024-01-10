import 'package:flutter/material.dart';
import 'package:l3homeation/components/custom_button.dart';
import 'package:l3homeation/components/custom_textfield.dart';
import 'package:l3homeation/components/square_tile.dart';
import 'package:l3homeation/pages/dashboard.dart';
import 'package:l3homeation/services/httphandle.dart';
import 'package:l3homeation/services/userpreferences.dart';
import 'package:l3homeation/components/error_dialog.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Sign in user method
  void signInUser() async {
    // Loading circle
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });

    // Login function
    final AuthService _authService = AuthService(
        email: emailController.text, password: passwordController.text);
    var response = await _authService.checkLoginStatus(context);

    // Close the loading dialog
    Navigator.of(context).pop();

    if (response['status'] == true) {
      await UserPreferences.setUsername(response['username']);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => dashboard()),
      );
    } else {
      // Handle login failure
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return ErrorDialog(errorText: "Login Error. Please try again");
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: SingleChildScrollView(
          // Add this
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                const SquareTile(imagePath: 'images/l3homeation.png'),
                const SizedBox(height: 50),

                // Welcome back text
                const Text(
                  'Welcome to L3 Homeation',
                  style: TextStyle(
                      color: Color.fromARGB(255, 97, 97, 97), fontSize: 16),
                ),

                const SizedBox(height: 25),

                // Email field
                CustomTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),

                const SizedBox(height: 25),

                // Password Field
                CustomTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),

                const SizedBox(height: 10),

                // Forgot password
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('Forgot Password?',
                          style: TextStyle(color: Colors.grey[600]))
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // Sign in button
                CustomButton(
                  onTap: signInUser,
                ),

                const SizedBox(height: 50),

                // Registration
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Not a member? '),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      'Sign up here',
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold),
                    )
                  ],
                )
              ],
            ),
          ),
        ), // Add this
      ),
    );
  }
}
