import 'package:flutter/material.dart';
import 'package:kitchen_ware_project/providers/app_provider.dart';
import 'package:kitchen_ware_project/utli/router.dart';
import 'package:kitchen_ware_project/views/app_screens/get_started_screen.dart';
import 'package:kitchen_ware_project/views/app_screens/home_page.dart';
import 'package:kitchen_ware_project/widgets/rounded_button.dart';
import 'package:provider/provider.dart';
class WelcomPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppProvider>(context,listen: false);
      Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        SizedBox(height: size.height * 0.03),
        Container(
          alignment: Alignment.center,
          width: 240,
          height: 240,
          decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/signInBackground.jpg'),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(7.0)),
        ),
        SizedBox(height: size.height * 0.06),
        Container(
            width: size.width * 0.7,
            child: Text(
              "Let's Eat Quality Food!",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            )),
        SizedBox(height: size.height * 0.02),
        Container(
            width: size.width * 0.7,
            child: Text(
              "discover near home made delicious meals near to you",
              style: TextStyle(fontSize: 17, color: Colors.black45),
              textAlign: TextAlign.center,
            )),
        SizedBox(height: size.height * 0.05),
        Container(
          alignment: Alignment.center,
          child: RoundedButton(
            text: "Get Started",
            press: () {
              MyRouter.pushPageReplacement(context, GetStartedScreen());
            },
          ),
        ),
        SizedBox(height: size.height * 0.01),
        // Container(
        //   alignment: Alignment.center,
        //   child: RoundedButton(
        //     text: "Log In",
        //     color: Colors.white,
        //     textColor: OrangeColor,
        //     press: () {
        //       Navigator.of(context).pushNamed(LoginScreen.routeName);
        //     },
        //   ),
        // ),
      ]),
    );
  }
}