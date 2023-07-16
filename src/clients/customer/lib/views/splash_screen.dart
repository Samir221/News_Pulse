import 'package:flutter/material.dart';
import 'package:newspulse_app/PROJECT_CONSTANTS.dart';
import 'package:newspulse_app/views/login_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Splash extends StatefulWidget {
  final GoogleSignIn googleSignIn; // Add the googleSignIn argument

  const Splash({Key? key, required this.googleSignIn}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navigateToHome();
    });
  }

  _navigateToHome() async {
    await Future.delayed(
      const Duration(milliseconds: 3000),
      () {},
    );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen(googleSignIn: widget.googleSignIn)), // Pass the googleSignIn argument
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(child: LOGO),
      ),
    );
  }
}

