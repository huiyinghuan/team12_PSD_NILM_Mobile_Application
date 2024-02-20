import 'package:flutter/material.dart';
import 'package:l3homeation/components/custom_button.dart';
import 'package:l3homeation/components/custom_textfield.dart';
import 'package:l3homeation/components/square_tile.dart';
import 'package:l3homeation/pages/dashboard/dashboard.dart';
import 'package:l3homeation/pages/login/register_user.dart';
import 'package:l3homeation/services/httphandle.dart';
import 'package:l3homeation/services/userpreferences.dart';
import 'package:l3homeation/components/error_dialog.dart';
import 'package:l3homeation/pages/login/forget_password.dart';
import 'dart:convert';

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
    print("Response: ${passwordController.text}");

    // Close the loading dialog
    Navigator.of(context).pop();

    if (response['status'] == true) {
      await UserPreferences.setString('username', response['username']);
      await UserPreferences.setString(
          'auth',
          base64Encode(utf8
              .encode('${emailController.text}:${passwordController.text}')));
      print("Login successful");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Dashboard()),
      );
    } else {
      print("Error logging in");
      // Handle login failure
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return DialogBox(
              title: "Error", errorText: "Login Error. Please try again");
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // Background image
          Positioned(
            bottom: 0,
            left: -15,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/loginBG.png'),
                  fit: BoxFit.fitWidth,
                  alignment: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50),
                    const Text(
                      'LOGIN',
                      style: TextStyle(
                        color: Color.fromRGBO(0, 0, 0, 1),
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 50),
                    const SquareTile(imagePath: 'images/l3homeation.png'),
                    const SizedBox(height: 35),

                    // Email field
                    CustomTextField(
                        controller: emailController,
                        hintText: 'Email',
                        obscureText: false,
                        autofillHints: [AutofillHints.email]),

                    const SizedBox(height: 55),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 30),
                          child: Text(
                            'Password', // Your label text
                            style: TextStyle(
                              color: Color.fromRGBO(0, 0, 0, 1),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        SizedBox(height: 8),
                        // Password Field
                        CustomTextField(
                          controller: passwordController,
                          hintText: 'Password',
                          obscureText: true,
                          autofillHints: [AutofillHints.password],
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 187, 187, 187)),
                                borderRadius: BorderRadius.circular(20)),
                            fillColor: Color.fromARGB(255, 236, 236, 236),
                            filled: true,
                            hintText: 'Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // Forgot password
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ForgetPassword()),
                              );
                            },
                            child: Text('Forgot Password?',
                                style: TextStyle(color: Colors.grey[600])),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),

                    // Sign in button
                    CustomButton(
                        name: "Sign in",
                        onTap: signInUser,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20))),

                    const SizedBox(height: 50),

                    // Registration
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Not a member? '),
                        const SizedBox(
                          width: 4,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegisterUser()),
                            );
                          },
                          child: const Text(
                            'Sign up here',
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 500),
                  ],
                ),
              ),
            ), // Add this
          ),
        ],
      ),
    );
  }
}
