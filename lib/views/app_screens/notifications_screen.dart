import 'package:flutter/material.dart';
import 'package:kitchen_ware_project/APIs/notifications/notification_handler.dart';
import 'package:kitchen_ware_project/models/notifications.dart';
import 'package:kitchen_ware_project/shared/constant.dart';
import 'package:kitchen_ware_project/widgets/notification_item.dart';
import 'package:provider/provider.dart';

class AnimatedNotifications extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AnimatedNotificationsState();
}

class AnimatedNotificationsState extends State<AnimatedNotifications>
    with SingleTickerProviderStateMixin {
  AnimationController? controller;
  Animation<double>? scaleAnimation;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    scaleAnimation =
        CurvedAnimation(parent: controller!, curve: Curves.easeOut);

    controller!.addListener(() {
      setState(() {});
    });

    controller!.forward();
  }

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;

    return Stack(children: [
      Positioned(
        top: 50,
        right: 70,
        child: Align(
          alignment: Alignment.topRight,
          child: ScaleTransition(
            alignment: Alignment.topRight,
            scale: scaleAnimation!,
            child: Container(
              width: deviceSize.width * 0.78,
              height: deviceSize.height * 0.6,
              child: NotificationScreen(),
            ),
          ),
        ),
      ),
    ]);
  }
}

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    List<Notifications> notifications =
        Provider.of<NotificationHandler>(context).notifications;
    return Material(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: deviceSize.height * 0.05,
                left: deviceSize.width * 0.03,
                right: deviceSize.width * 0.01,
                bottom: deviceSize.height * 0.01,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon:
                            Icon(Icons.arrow_back_ios, color: LightBlackColor),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      Text("Notifications",
                          style:
                              TextStyle(color: LightBlackColor, fontSize: 22)),
                    ],
                  ),
                ],
              ),
            ),
            notifications.length == 0
                ? Text("no items yet ... ")
                : ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      return NotificationItem(
                          notification: notifications[index]);
                    },
                  ),
          ],
        ),
      ),

      // child: ListView(
      //   children: [
      //     Padding(
      //       padding: EdgeInsets.only(
      //         top: deviceSize.height * 0.03,
      //         left: deviceSize.width * 0.03,
      //         right: deviceSize.width * 0.01,
      //         bottom: deviceSize.height * 0.01,
      //       ),
      //       child: Row(
      //         mainAxisAlignment: MainAxisAlignment.start,
      //         children: [
      //           IconButton(
      //             icon: Icon(Icons.arrow_back_ios, color: LightBlackColor),
      //             onPressed: () {
      //               Navigator.pop(context);
      //             },
      //           ),
      //           SizedBox(width: deviceSize.width * 0.1),
      //           Text("Notifications",
      //               style: TextStyle(color: LightBlackColor, fontSize: 18)),
      //         ],
      //       ),
      //     ),
      //     SizedBox(height: deviceSize.height * 0.01),
      //     Padding(
      //       padding: EdgeInsets.only(
      //         left: deviceSize.width * 0.03,
      //         right: deviceSize.width * 0.01,
      //         bottom: deviceSize.height * 0.01,
      //       ),

      //     ),
      //   ],
      // ),
    );
  }
}
