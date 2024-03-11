import 'package:flutter/material.dart';

import 'package:l3homeation/components/custom_button.dart';
import 'package:l3homeation/components/custom_textfield.dart';
import 'package:l3homeation/pages/login/login_page.dart';

import 'reuseable.dart';

class RegisterUser extends StatefulWidget {
  const RegisterUser({super.key});

  @override
  State<RegisterUser> createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final snackBar = const SnackBar(
    content: Text("Registration Successful! Please login again"),
    duration: Duration(seconds: 2),
  );

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

    // TODO handle the registration logic here

    // Close the loading dialog
    Navigator.of(context).pop();

    // print("Sign up test successful");

    // Handle login failure
    // showDialog(
    //   context: context,
    //   builder: (BuildContext context) {
    //     return const DialogBox(
    //         title: "Success",
    //         errorText: "Registration Successful. Please login again");
    //   },
    // );

    // Changed message to a snackbar so it looks cleaner and can bring user to the login_page()

    // if(successfulRegistration){ScaffoldMessenger....}

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
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
                // Homeation logo
                displayLogo(),

                const SizedBox(height: 50),

                // Welcome back text
                displayTitle("Registration"),
                const SizedBox(height: 25),

                // Email field
                displayEmailField(),

                const SizedBox(height: 15),

                // Password Field
                displayPasswordField(),

                const SizedBox(height: 15),

                // Confirm Password Field
                displayConfirmPasswordField(),

                const SizedBox(height: 25),

                // Sign in button
                CustomButton(
                  name: "Sign In",
                  onTap: signUpUser,
                ),

                const SizedBox(height: 50),

                // Sign in page
                redirectToSignIn(),
              ],
            ),
          ),
        ), // Add this
      ),
    );
  }

  CustomTextField displayEmailField() {
    return CustomTextField(
        controller: emailController,
        hintText: 'Email',
        obscureText: false,
        autofillHints: const [AutofillHints.email]);
  }

  CustomTextField displayPasswordField() {
    return CustomTextField(
        controller: passwordController,
        hintText: 'Password',
        obscureText: true,
        autofillHints: const [AutofillHints.password]);
  }

  CustomTextField displayConfirmPasswordField() {
    return CustomTextField(
        controller: confirmPasswordController,
        hintText: 'Confirm Password',
        obscureText: true,
        autofillHints: const [AutofillHints.password]);
  }

  Row redirectToSignIn() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Already have an account? '),
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
