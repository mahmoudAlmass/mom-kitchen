import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class InternetConnection extends ChangeNotifier{
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  InternetConnection(){
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
      return;
    }
    notifyListeners();
    return _updateConnectionStatus(result);
  }

  void _updateConnectionStatus(ConnectivityResult result)  {
    _connectionStatus = result;
    print(_connectionStatus);
    notifyListeners();
  }

  bool get connected{
    return _connectionStatus.toString().contains("none")? false : true;
    
  }

}
