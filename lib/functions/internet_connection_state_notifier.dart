import 'package:flutter/material.dart';

class InternetConnectionNotifier with ChangeNotifier {
  static final InternetConnectionNotifier _instance =
      InternetConnectionNotifier._internal();
  factory InternetConnectionNotifier() => _instance;
  InternetConnectionNotifier._internal();

  bool _internetConnectionState = false;
  bool _mongoDBConnectionState = false;

  bool get internetConnectionState => _internetConnectionState;
  bool get mongoDBConnectionState => _mongoDBConnectionState;

  void updateInternetConnectionState(bool status) {
    _internetConnectionState = status;
    notifyListeners();
  }

  void updateMongoDBConnectionState(bool status) {
    _mongoDBConnectionState = status;
    notifyListeners();
  }
}
