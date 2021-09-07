import 'package:flutter/material.dart';
import 'package:kitchen_ware_project/APIs/notifications/notification_handler.dart';
import 'package:kitchen_ware_project/components/error_widget.dart';
import 'package:kitchen_ware_project/components/loading_widget.dart';
import 'package:kitchen_ware_project/models/user.dart';
import 'package:kitchen_ware_project/providers/app_provider.dart';
import 'package:kitchen_ware_project/providers/report_provider.dart';
import 'package:kitchen_ware_project/providers/user_provider.dart';
import 'package:kitchen_ware_project/services/authentication/authinticate.dart';
import 'package:kitchen_ware_project/views/app_screens/home_page.dart';
import 'package:kitchen_ware_project/views/app_screens/welcom_page.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  bool _isInit = true;
  bool _isLoading = true;
  bool isBlocked = false;

  @override
  @override
  void didChangeDependencies() async {
    dynamic user = Provider.of<User?>(context);
    final userProv = Provider.of<UserProvider>(context, listen: false);
    // here for register user
    if (_isInit && user != null) {
      await Provider.of<ReportsProvider>(context, listen: false)
          .isBlockedUser(user.userID)
          .then((value) {
        setState(() {
          print(value);
          isBlocked = value;
        });
      });
      String deviceToken =
          Provider.of<NotificationHandler>(context, listen: false).deviceToken;
      await userProv.fetchAndSetUser(user).then((_) async {
        if (userProv.logedUser != null) {
          await Provider.of<UserProvider>(context, listen: false)
              .updateDeviceToken(deviceToken)
              .then((_) {
            setState(() {
              _isLoading = false;
              _isInit = false;
            });
          });
        } else {
          setState(() {
            _isLoading = false;
            _isInit = false;
          });
        }
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    dynamic user = Provider.of<User?>(context);
    final app = Provider.of<AppProvider>(context, listen: false);

    // return either authinticated or home widget
    if (!isBlocked) {
      if (user == null) {
        return Authinticate();
      } else {
        return app.firstUse == true
            ? WelcomPage()
            : _isLoading
                ? LoadingWidget()
                : HomePage();
      }
    } else {
      return MyErrorWidget();
    }
  }
}
