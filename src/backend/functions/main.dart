import 'package:flutter/material.dart';
import 'package:newspulse_app/views/splash_screen.dart';
import 'package:newspulse_app/formatting_constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:newspulse_app/controllers/active_user.dart';
import 'package:newspulse_app/controllers/logged_in_controller.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() async {
  // Initialize Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ActiveUser()),
        ChangeNotifierProxyProvider<ActiveUser, LoggedInController>(
          create: (context) {
            final activeUser = Provider.of<ActiveUser>(context, listen: false);
            return LoggedInController(
              loginType: activeUser.signInMethod ?? '',
              userName: activeUser.userName ?? '',
              userID: activeUser.userID ?? '',
            );
          },
          update: (context, activeUser, loggedInController) => LoggedInController(
            loginType: activeUser.signInMethod ?? '',
            userName: activeUser.userName ?? '',
            userID: activeUser.userID ?? '',
          ),
        ),
      ],
      child: MyApp(googleSignIn: _googleSignIn),
    ),
  );
}

class MyApp extends StatelessWidget {
  final GoogleSignIn _googleSignIn;

  MyApp({Key? key, required GoogleSignIn googleSignIn})
      : _googleSignIn = googleSignIn,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '$PROJECT_NAME App',
      color: DARK_COLOR,
      home: Splash(googleSignIn: _googleSignIn),
    );
  }
}
