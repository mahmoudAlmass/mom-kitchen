import 'package:flutter/material.dart';
import 'package:kitchen_ware_project/views/auth_screens/log_in_Screen.dart';
import 'package:kitchen_ware_project/views/auth_screens/login.dart';
import 'package:kitchen_ware_project/views/auth_screens/signup.dart';

class Authinticate extends StatefulWidget {
  @override
  _AuthinticateState createState() => _AuthinticateState();
}

class _AuthinticateState extends State<Authinticate> {
  bool showSignIn=true;

  void toggleView(){
    setState(() => showSignIn=!showSignIn);
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: showSignIn? LoginScreen(toggleView: toggleView) :SignUp(toggleView: toggleView),
    );
  }
}