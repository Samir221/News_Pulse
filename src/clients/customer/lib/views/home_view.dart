import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:newspulse_app/controllers/logged_in_controller.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loggedInController = context.watch<LoggedInController>();
    
    // Check if user is logged in
    if (loggedInController.userID != null) {
      return LoggedInControllerProvider();  // go directly to LoggedInControllerProvider
    } else {
      return Container();  // return an empty container when user is not logged in
    }
  }
}

