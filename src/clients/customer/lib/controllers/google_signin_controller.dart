import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:newspulse_app/controllers/logged_in_controller.dart';
import 'package:newspulse_app/PROJECT_CONSTANTS.dart';
import 'package:newspulse_app/controllers/active_user.dart';
import 'package:newspulse_app/views/home_view.dart';
import 'package:provider/provider.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

class GoogleSignInMethod extends StatefulWidget {
  final GoogleSignIn googleSignIn;

  const GoogleSignInMethod({Key? key, required this.googleSignIn}) : super(key: key);

  @override
  _GoogleState createState() => _GoogleState();
}

class _GoogleState extends State<GoogleSignInMethod> {
  GoogleSignInAccount? _currentUser;

/*
  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((account) {
      setState(() {
        _currentUser = account;
      });
    });
    _googleSignIn.signInSilently();
  }*/

    @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((account) {
      setState(() {
        _currentUser = account;
      });
      if (account != null) {
        final loggedInController = Provider.of<LoggedInController>(context, listen: false);
        loggedInController.handleUserAuthentication();
        if (loggedInController.userID.isNotEmpty) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeView()),
          );
        } else {
          print('Error: Invalid user information');
        }
      }
    });
    _googleSignIn.signInSilently();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('$PROJECT_NAME Google Sign in'),
      ),
      body: Container(
        alignment: Alignment.center,
        child: _buildWidget(),
      ),
    );
  }

  Widget _buildWidget() {
    GoogleSignInAccount? user = _currentUser;
    if (user != null) {
      ActiveUser activeUser = Provider.of<ActiveUser>(context);
      LoggedInController loggedInController = Provider.of<LoggedInController>(context);

      // Set the user information in the LoggedInController
      //loggedInController.initializeUserEmail(user.email ?? '');
      loggedInController.setUserID(user.email);

      activeUser.setUser(
        'Google',
        user.displayName ?? ''.toString(),
        user.id,
      );

      return Padding(
        padding: const EdgeInsets.fromLTRB(2, 12, 2, 12),
        child: Column(
          children: [
            ListTile(
              leading: GoogleUserCircleAvatar(identity: user),
              title: Text(
                user.displayName ?? '',
                style: TextStyle(fontSize: 22),
              ),
              subtitle: Text(user.email, style: TextStyle(fontSize: 22)),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Signed in successfully',
              style: H2_FONT_STYLE,
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {
                if (loggedInController.userID.isNotEmpty) {
                  print('User ID: ${loggedInController.userID}');
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomeView()),
                  );
                } else {
                  print('Error: Invalid user information');
                }
              },
              child: const Text('Enter Application'),
            ),
            SizedBox(
              height: 35,
            ),
            ElevatedButton(
              onPressed: signOut,
              child: const Text('Sign out'),
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            const Text(
              'You are not signed in',
              style: H2_FONT_STYLE,
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: signIn,
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Sign in', style: TextStyle(fontSize: 30)),
              ),
            ),
          ],
        ),
      );
    }
  }
  void signOut() {
    _googleSignIn.disconnect();
  }


/*
  Future<void> signIn() async {
    try {
      await _googleSignIn.signIn();
      print('Signing in 1...');
      final loggedInController = Provider.of<LoggedInController>(context, listen: false);
      await loggedInController.handleUserAuthentication();
      print('Google UserID: ${loggedInController.userID}');
    } catch (e) {
      print('Error signing in $e');
    }
  }
}
*/

Future<void> signIn() async {
    try {
      await _googleSignIn.signIn();
      print('Signing in 1...');
      final loggedInController = Provider.of<LoggedInController>(context, listen: false);
      await loggedInController.handleUserAuthentication();
      print('Google UserID: ${loggedInController.userID}');

      // Check if user ID is not empty, then navigate
      if (loggedInController.userID.isNotEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeView()),
        );
      } else {
        print('Error: Invalid user information');
      }
    } catch (e) {
      print('Error signing in $e');
    }
}



}