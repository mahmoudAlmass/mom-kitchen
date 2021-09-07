import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kitchen_ware_project/APIs/notifications/notification_handler.dart';
import 'package:kitchen_ware_project/services/authentication/wrapper.dart';
import 'package:kitchen_ware_project/shared/constant.dart';
import 'package:kitchen_ware_project/utli/router.dart';
import 'package:provider/provider.dart';


class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  
  startTimeout() {
    return new Timer(Duration(seconds: 2), handleTimeout);
  }
  
  void handleTimeout() {
    changeScreen();
  }

  changeScreen() async {
    MyRouter.pushPageReplacement(
      context,
      Wrapper(),
    );
  }

  @override
  void initState() {
    Provider.of<NotificationHandler>(context,listen: false).initToken();
    Provider.of<NotificationHandler>(context,listen: false).litenToMessages();

    super.initState();
    startTimeout();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Color.fromRGBO(255, 194, 41, 150),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                "assets/images/app-icon.jpg",
                height: 100.0,
                width: 100.0,
              ),
              SizedBox(height: 40,),
              Text(
              'Welcome To Mom\'s Kitchen',
              style: TextStyle(fontSize: 20, color: Color.fromRGBO(254, 115, 76, 1)),
        ),

            ],
          ),
        ),
      ),
    );
  }
}
