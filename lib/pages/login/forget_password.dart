import 'package:flutter/material.dart';
import 'package:l3homeation/components/custom_textfield.dart';
import 'package:l3homeation/components/custom_button.dart';
import 'package:l3homeation/components/error_dialog.dart';
import 'package:l3homeation/pages/login/login_page.dart';
import 'package:l3homeation/services/varHeader.dart';
import 'package:http/http.dart' as http;

import 'reuseable.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final emailController = TextEditingController();

  // Sign up user method
  void resetPassword() async {
    // Loading circle
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });

    // Make the REST API call
    final response = await http.post(Uri.parse(
        '${VarHeader.BASEURL}/passwordForgotten/${emailController.text}'));

    // Check the response status code
    if (response.statusCode == 200) {
      // Password reset successful
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const DialogBox(
            title: "Success",
            errorText: "Password Reset. Please check your email",
          );
        },
      );
    } else {
      // Password reset failed
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const DialogBox(
            title: "Error",
            errorText: "Failed to reset password, try another user",
          );
        },
      );
    }

    // Close the loading dialog
    Navigator.of(context).pop();

    // Handle login failure
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const DialogBox(
            title: "Success",
            errorText: "Password Reset. Please check your email");
      },
    );
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
                displayLogo(),
                const SizedBox(height: 50),

                // Title
                displayTitle('Forget Password'),

                const SizedBox(height: 25),

                // Email field
                CustomTextField(
                    controller: emailController,
                    hintText: 'Email',
                    obscureText: false,
                    autofillHints: const [AutofillHints.email]),

                const SizedBox(height: 25),

                // Sign in button
                CustomButton(
                  name: "Reset Password",
                  onTap: resetPassword,
                ),

                const SizedBox(height: 50),

                // Sign in page
                redirectToSignIn()
              ],
            ),
          ),
        ), // Add this
      ),
    );
  }

  Row redirectToSignIn() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Remembered your password? Go to '),
        const SizedBox(
          width: 4,
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          },
          child: const Text(
            'Sign in',
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}
