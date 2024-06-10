import 'package:bloodbankmanager/dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bloodbankmanager/authentication/signup.dart';
import 'package:flutter/material.dart';
import 'package:bloodbankmanager/homePage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> logIn(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Navigate to home page if sign-in is successful
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              Dashboard(), // Replace HomePage with your actual home page widget
        ),
      );
    } catch (e) {
      // Handle sign-in errors here
      print("Sign-in error: $e");
      // You can show an error message or take other actions as needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            // Make the content scrollable
            child: Container(
              margin: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _header(),
                  SizedBox(
                      height:
                          20), // Add some space between header and input fields
                  _inputField(
                      context, emailController, passwordController, logIn),
                  _forgotPassword(),
                  _signup(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget _header() {
  return Column(
    children: [
      SizedBox(height: 30.0),
      Container(
        height: 100,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/logo.png'),
            fit: BoxFit.fitHeight,
          ),
        ),
      ),
      SizedBox(height: 10),
      Text(
        "Blood Link",
        style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
      ),
      Text("Enter your credentials to login"),
    ],
  );
}

Widget _inputField(
    BuildContext context,
    TextEditingController emailController,
    TextEditingController passwordController,
    Future<void> Function(BuildContext) logIn) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      SizedBox(height: 200.0),
      TextField(
        controller: emailController,
        decoration: InputDecoration(
          hintText: "Email",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),
          fillColor: Colors.redAccent.withOpacity(0.1),
          filled: true,
          prefixIcon: const Icon(Icons.person),
        ),
      ),
      const SizedBox(height: 10),
      TextField(
        controller: passwordController,
        decoration: InputDecoration(
          hintText: "Password",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),
          fillColor: Colors.redAccent.withOpacity(0.1),
          filled: true,
          prefixIcon: const Icon(Icons.password),
        ),
        obscureText: true,
      ),
      const SizedBox(height: 10),
      ElevatedButton(
        onPressed: () {
          logIn(context); // Pass the context when calling logIn
        },
        style: ElevatedButton.styleFrom(
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: Colors.redAccent,
        ),
        child: const Text(
          "Login",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      )
    ],
  );
}

Widget _forgotPassword() {
  return TextButton(
    onPressed: () {},
    child: const Text(
      "Forgot password?",
      style: TextStyle(color: Colors.black),
    ),
  );
}

Widget _signup(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Text("Don't have an account? "),
      TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SignupPage()),
          );
        },
        child: const Text(
          "Sign Up",
          style: TextStyle(color: Colors.redAccent),
        ),
      ),
    ],
  );
}
