import 'package:flutter/material.dart';
import 'package:newspulse_app/views/watchlist_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class LoggedInController extends ChangeNotifier {
  String loginType;
  String userName;
  String userID;

  LoggedInController({
    required this.loginType,
    required this.userName,
    required this.userID,
  });


  void setUserID(String id) {
    this.userID = id;
    notifyListeners();
  }

  Future<void> handleUserAuthentication() async {
    try {
      // Perform the necessary authentication steps
      // ...

      // Set the user email once authentication is successful
      //initializeUserEmail(userEmail);

      // Notify listeners that the authentication is complete
      notifyListeners();
    } catch (error) {
      // Handle any errors that occur during authentication
      // ...
    }
  }
}

class LoggedInControllerProvider extends StatefulWidget {
  @override
  _LoggedInControllerProviderState createState() =>
      _LoggedInControllerProviderState();
}

class _LoggedInControllerProviderState
    extends State<LoggedInControllerProvider> {
  late String defaultWatchlist;

  @override
  Widget build(BuildContext context) {
    final loggedInController = Provider.of<LoggedInController>(context);
    final firestore = FirebaseFirestore.instance;
    final userCollection = firestore.collection('users');

    return FutureBuilder<DocumentSnapshot>(
      future: userCollection.doc(loggedInController.userID).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        if (snapshot.hasData) {
          final data = snapshot.data!.data() as Map<String, dynamic>?;

          if (data != null) {
            defaultWatchlist = data['DefaultWatchlist'] ?? 'Default Watchlist';

            return WatchlistView(
              userID: loggedInController.userID,
              userName: loggedInController.userName,
              defaultWatchlist: defaultWatchlist,
            );
          } else {
            return FutureBuilder<void>(
              future: createNewUserAndWatchlist(userCollection),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                return WatchlistView(
                  userID: loggedInController.userID,
                  userName: loggedInController.userName,
                  defaultWatchlist: 'Default Watchlist',
                );
              },
            );
          }
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        return Text('No data available');
      },
    );
  }

  Future<void> createNewUserAndWatchlist(
      CollectionReference<Map<String, dynamic>> userCollection) async {
    final loggedInController = Provider.of<LoggedInController>(context, listen: false);
    
    await userCollection.doc(loggedInController.userID).set({
      'signInMethod': loggedInController.loginType,
      'DefaultWatchlist': 'Default Watchlist',
    });

    await userCollection
        .doc(loggedInController.userID)
        .collection('watchlists')
        .doc('Default Watchlist')
        .set({
      'symbols': [],
    });
  }
}

