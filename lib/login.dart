// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_constructors, use_build_context_synchronously, avoid_print, annotate_overrides

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
    // Add a case for the 'invalid-credential'
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
      backgroundColor: Color(0xFF00000F), 
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, 
            children: [
              Text(
                'Welcome!',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 60), 
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
            
              SizedBox(height: 32), 
            ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: Color(0xFFFEAC02),
    padding: EdgeInsets.all(15),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30),
    ),
  ),
  onPressed: _signIn, 
  child: Text('Sign In', style: TextStyle(fontSize: 18)),
),
              SizedBox(height: 16), 
              
              Spacer(), 
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
