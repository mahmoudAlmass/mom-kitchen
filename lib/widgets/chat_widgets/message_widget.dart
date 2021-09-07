import 'package:flutter/material.dart';
import 'package:kitchen_ware_project/models/message.dart';
import 'package:kitchen_ware_project/models/user.dart';
import 'package:kitchen_ware_project/providers/report_provider.dart';
import 'package:kitchen_ware_project/providers/user_provider.dart';
import 'package:provider/provider.dart';

class MessageWidget extends StatelessWidget {
  final Message message;
  final bool isMe;
  final User other;

  const MessageWidget({
    required this.message,
    required this.isMe,
    required this.other
    
  });

  @override
  Widget build(BuildContext context) {
    final radius = Radius.circular(12);
    final borderRadius = BorderRadius.all(radius);

    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        if (!isMe)
          CircleAvatar(
            radius: 16,
              backgroundImage: NetworkImage(other.imageUrl!),
          ),
        Container(
          padding: EdgeInsets.all(14),
          margin: EdgeInsets.symmetric(horizontal: 16,vertical: 1),
          constraints: BoxConstraints(maxWidth: 180),
          decoration: BoxDecoration(
            color: isMe ? Colors.black26 : Colors.black54,
            borderRadius: isMe
                ? borderRadius.subtract(BorderRadius.only(bottomRight: radius))
                : borderRadius.subtract(BorderRadius.only(bottomLeft: radius)),
          ),
          child: buildMessage(context),
        ),
      ],
    );
  }

  Widget buildMessage(BuildContext context) => Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          InkWell(
            onLongPress: () { 
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text('Are you sure?'),
                  content: Text('are you sure you want to report this message'),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('No'),
                      onPressed: () {
                        print(message.createdAt);
                        Navigator.of(ctx).pop(false);
                      },
                    ),
                    FlatButton(
                      child: Text('Yes'),
                      onPressed: () async {
                        String reporterId =
                            Provider.of<UserProvider>(context, listen: false)
                                .logedUser!
                                .userID!;
                        await Provider.of<ReportsProvider>(context,
                                listen: false)
                            .reportOnMessage(message, reporterId)
                            .then((_) {
                          Navigator.of(ctx).pop(true);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content:
                                const Text('you\'ve reported on this meal'),
                            duration: const Duration(seconds: 1),
                          ));
                        });
                      },
                    ),
                  ],
                ),
              );
            },
            child: Text(
              message.message!,
              style: TextStyle(color: isMe ? Colors.black : Colors.white),
              textAlign: isMe ? TextAlign.end : TextAlign.start,
            ),
          ),
        ],
      );
}
