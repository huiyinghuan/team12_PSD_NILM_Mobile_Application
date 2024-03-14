// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:l3homeation/components/custom_button.dart';
import 'package:l3homeation/components/custom_textfield.dart';
import 'package:l3homeation/pages/dashboard/dashboard.dart';
import 'package:l3homeation/pages/login/register_user.dart';
import 'package:l3homeation/services/httphandle.dart';
import 'package:l3homeation/components/error_dialog.dart';
import 'package:l3homeation/pages/login/forget_password.dart';
import 'package:l3homeation/services/userPreferences.dart';

import 'dart:convert';

import 'reuseable.dart';

class Login_Page extends StatefulWidget {
  const Login_Page({super.key});

  @override
  State<Login_Page> createState() => _Login_Page_State();
}

class _Login_Page_State extends State<Login_Page> {
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
    final Auth_Service _authService = Auth_Service(
        email: emailController.text, password: passwordController.text);
    var response = await _authService.checkLoginStatus(context);

    // Close the loading dialog
    Navigator.of(context).pop();

    if (response['status'] == true) {
      // print("Login successful");
      // print(base64Encode(
      // utf8.encode('${emailController.text}:${passwordController.text}')));
      // goToLogin(emailController.text, passwordController.text);
      await User_Preferences.setString('username', response['username']);
      await User_Preferences.setString('userID', response['userID'].toString());
      await User_Preferences.setString(
          'auth',
          base64Encode(utf8
              .encode('${emailController.text}:${passwordController.text}')));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Dashboard()),
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const DialogBox(
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
          addBackgroundImage(),
          safeAreaDisplay(),
        ],
      ),
    );
  }

  SafeArea safeAreaDisplay() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50),

              displayTitle('LOGIN'),

              const SizedBox(height: 50),

              displayLogo(),

              const SizedBox(height: 35),

              // Email field
              displayEmailField(),

              const SizedBox(height: 35),

              // Password field
              displayPasswordField(),

              const SizedBox(height: 10),

              // Forgot password
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: displayForgotPassword(),
              ),

              const SizedBox(height: 25),

              // Sign in button
              displaySignInButton(),

              const SizedBox(height: 50),

              // Registration
              // No API available for registration
              // displayRegistrationButton(),

              const SizedBox(height: 500),
            ],
          ),
        ),
      ), // Add this
    );
  }

  Positioned addBackgroundImage() {
    return Positioned(
      bottom: 0,
      left: -15,
      right: 0,
      child: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/loginBG.png'),
            fit: BoxFit.fitWidth,
            alignment: Alignment.bottomCenter,
          ),
        ),
      ),
    );
  }

  Column displayEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 30),
          child: Text(
            'Email', // Your label text
            style: TextStyle(
              color: Color.fromRGBO(0, 0, 0, 1),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 8),
        displayEmailTextField(),
      ],
    );
  }

  CustomTextField displayEmailTextField() {
    return CustomTextField(
      controller: emailController,
      hintText: 'Email',
      obscureText: false,
      autofillHints: const [AutofillHints.email],
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(20),
        ),
        focusedBorder: OutlineInputBorder(
            borderSide:
                const BorderSide(color: Color.fromARGB(255, 187, 187, 187)),
            borderRadius: BorderRadius.circular(20)),
        fillColor: const Color.fromARGB(255, 236, 236, 236),
        filled: true,
        hintText: 'Email',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Column displayPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 30),
          child: Text(
            'Password', // Your label text
            style: TextStyle(
              color: Color.fromRGBO(0, 0, 0, 1),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        const SizedBox(height: 8),
        // Password Field
        displayPasswordTextField(),
      ],
    );
  }

  CustomTextField displayPasswordTextField() {
    return CustomTextField(
      controller: passwordController,
      hintText: 'Password',
      obscureText: true,
      autofillHints: const [AutofillHints.password],
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(20),
        ),
        focusedBorder: OutlineInputBorder(
            borderSide:
                const BorderSide(color: Color.fromARGB(255, 187, 187, 187)),
            borderRadius: BorderRadius.circular(20)),
        fillColor: const Color.fromARGB(255, 236, 236, 236),
        filled: true,
        hintText: 'Password',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Row displayForgotPassword() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Forget_Password()),
            );
          },
          child: Text('Forgot Password?',
              style: TextStyle(color: Colors.grey[600])),
        ),
      ],
    );
  }

  CustomButton displaySignInButton() {
    return CustomButton(
        name: "Sign in",
        onTap: signInUser,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)));
  }

  Row displayRegistrationButton() {
    return Row(
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
              MaterialPageRoute(builder: (context) => Register_User()),
            );
          },
          child: const Text(
            'Sign up here',
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}
