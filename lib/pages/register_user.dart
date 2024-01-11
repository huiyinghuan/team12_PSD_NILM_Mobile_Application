import 'package:flutter/material.dart';
import 'package:l3homeation/components/custom_textfield.dart';
import 'package:l3homeation/components/square_tile.dart';
import 'package:l3homeation/components/custom_button.dart';
import 'package:l3homeation/components/error_dialog.dart';
import 'package:l3homeation/pages/login_page.dart';

class RegisterUser extends StatefulWidget {
  const RegisterUser({super.key});

  @override
  State<RegisterUser> createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Sign up user method
  void signUpUser() async {
    // Loading circle
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });

    // Close the loading dialog
    Navigator.of(context).pop();

    print("Sign up test successful");

    // Handle login failure
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const DialogBox(
            title: "Success",
            errorText: "Registration Successful. Please login again");
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
                const SquareTile(imagePath: 'images/l3homeation.png'),
                const SizedBox(height: 50),

                // Welcome back text
                const Text(
                  'Registration',
                  style: TextStyle(
                      color: Color.fromARGB(255, 97, 97, 97), fontSize: 16),
                ),

                const SizedBox(height: 25),

                // Email field
                CustomTextField(
                    controller: emailController,
                    hintText: 'Email',
                    obscureText: false,
                    autofillHints: [AutofillHints.email]),

                const SizedBox(height: 15),

                // Password Field
                CustomTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: true,
                    autofillHints: [AutofillHints.password]),

                const SizedBox(height: 15),

                // Confirm Password Field
                CustomTextField(
                    controller: confirmPasswordController,
                    hintText: 'Confirm Password',
                    obscureText: true,
                    autofillHints: [AutofillHints.password]),

                const SizedBox(height: 25),

                // Sign in button
                CustomButton(
                  name: "Sign In",
                  onTap: signUpUser,
                ),

                const SizedBox(height: 50),

                // Sign in page
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account? '),
                    const SizedBox(
                      width: 4,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      child: const Text(
                        'Sign in',
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ), // Add this
      ),
    );
  }
}
