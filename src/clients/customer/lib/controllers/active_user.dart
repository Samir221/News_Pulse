import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ActiveUser with ChangeNotifier {
  String? signInMethod;
  String? userID;
  String? userName;

  static final ActiveUser _singleton = ActiveUser._internal();

  factory ActiveUser() {
    return _singleton;
  }

  ActiveUser._internal();

  void setUser(String loginMethod, String userName, String userID) {
    this.signInMethod = signInMethod;
    this.userName = userName;
    this.userID = userID;
    notifyListeners();
  }

  // userID getter
  String? get userId => userID;
}
