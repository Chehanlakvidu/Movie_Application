// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:movie_application/signup.dart';
import 'package:movie_application/homepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginScreen(),
    );
  }
}
//gggyyy

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
    void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
 

Future<void> _signIn() async {
  try {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    // Check for empty fields and provide immediate feedback.
    if (email.isEmpty || password.isEmpty) {
      _showErrorDialog('Please enter both email and password.');
      return;
    }

    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => MyHomePage(title: 'Home Page')),
    );
  } 
  on FirebaseAuthException catch (e) {
  print('FirebaseAuthException caught: ${e.code} - ${e.message}');
  String errorMessage;
  switch (e.code) {
    case 'user-not-found':
      errorMessage = 'No user found for that email.';
      break;
    case 'wrong-password':
      errorMessage = 'Wrong password provided for that user.';
      break;
    case 'invalid-email':
      errorMessage = 'The email address is badly formatted.';
      break;
    case 'user-disabled':
      errorMessage = 'The user account has been disabled.';
      break;
    case 'operation-not-allowed':
      errorMessage = 'Operation not allowed.';
      break;
    // Add a case for the 'invalid-credential' if you know that is the code
    // case 'invalid-credential':
    //   errorMessage = 'The supplied auth credential is incorrect or has expired.';
    //   break;
    default:
      errorMessage = e.message ?? 'An unknown error occurred. Please try again.';
  }
  _showErrorDialog(errorMessage);
} catch (e) {
  // This is a general catch block for all other exceptions.
  print('General exception caught: $e');
  _showErrorDialog('An unexpected error occurred. Please try again.');
}

  
}


 void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sign In Failed'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }


  
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF00000F), // Deep blue background color
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Add space between the main content and the bottom text
            children: [
              Text(
                'Welcome!',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 60), // Space between 'Welcome!' and input fields
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.white),
                  prefixIcon: Icon(Icons.email, color: Colors.white),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Colors.white),
                  prefixIcon: Icon(Icons.lock, color: Colors.white),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                },
                child: Text(
                  "Forgot password?",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: 32), // More space between 'Forgot password?' and 'Sign In' button
            ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: Color(0xFFFEAC02), // Amber-like color for the button
    padding: EdgeInsets.all(15),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30),
    ),
  ),
  onPressed: _signIn, // Call the _signIn method here
  child: Text('Sign In', style: TextStyle(fontSize: 18)),
),
              SizedBox(height: 16), // Space between 'Sign In' button and 'Sign in with Google' button
              TextButton.icon(
                icon: Image.asset('assets/google_logo.png', height: 24.0), // Google logo
                label: Text('Sign in with Google', style: TextStyle(color: Colors.white)),
                onPressed: () {
                  // Handle sign-in with Google
                },
              ),
              Spacer(), // Pushes the 'Sign up' text to the bottom
             TextButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignUpScreen()),
    );
  },
  child: Text(
    "Don't have an account? Sign up",
    style: TextStyle(color: Colors.white70),
  ),
),
            ],
          ),
        ),
      ),
    );
  }
}
