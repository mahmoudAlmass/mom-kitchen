import 'package:flutter/material.dart';
import 'package:kitchen_ware_project/models/notifications.dart';


class NotificationItem extends StatelessWidget {
  final Notifications? notification;

  const NotificationItem({
    this.notification,
    Key? key,
  });

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;

    return Card(
      child: Row(
        children: [
          SizedBox(width: deviceSize.width * 0.01),
          Container(
            width: deviceSize.width * 0.2,
            height: deviceSize.height * 0.1,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                    image: AssetImage(notification!.imageUrl!))),
          ),
          SizedBox(width: deviceSize.width * 0.02),
          Container(
            width: deviceSize.width * 0.44,
            child: Text(
              notification!.notificationContent!,
              style: TextStyle(
                fontSize: 13,
              ),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}
