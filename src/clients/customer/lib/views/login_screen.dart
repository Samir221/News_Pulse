import 'package:flutter/material.dart';
import 'package:newspulse_app/PROJECT_CONSTANTS.dart';
import 'package:newspulse_ui/newspulse_ui.dart';
import 'package:newspulse_app/controllers/google_signin_controller.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen extends StatefulWidget {
  final GoogleSignIn googleSignIn;

  const LoginScreen({Key? key, required this.googleSignIn}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: LOGO // Add this line
              ),

              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  width: LOGIN_BUTTON_WIDTH,
                  child: BuildLoginButton('Google',
                      GoogleSignInMethod(googleSignIn: widget.googleSignIn)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  width: LOGIN_BUTTON_WIDTH,
                  child: BuildLoginButton('Facebook',
                      GoogleSignInMethod(googleSignIn: widget.googleSignIn)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  width: LOGIN_BUTTON_WIDTH,
                  child: BuildLoginButton("Twitter",
                      GoogleSignInMethod(googleSignIn: widget.googleSignIn)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }



InkWell BuildLoginButton(String signInType, Widget loginMethod) {
  return InkWell(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => loginMethod),
      );
    },
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0), // Increased horizontal padding
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0), // Decreased borderRadius for sharper corners
        boxShadow: [
          BoxShadow(
            color: kcDarkBlueColor,
            spreadRadius: 0,
            blurRadius: 7,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Sign in with $signInType',
            style: TextStyle(color: kcDarkBlueColor),
            textAlign: TextAlign.left,
          ),
          SvgPicture.asset(
            'assets/images/${signInType}_logo.svg',
            height: 32,
            width: 32,
            color: kcDarkBlueColor,
          ),
        ],
      ),
    ),
  );
}


}