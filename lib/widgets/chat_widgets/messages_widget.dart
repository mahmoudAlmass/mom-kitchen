import 'package:flutter/material.dart';
import 'package:kitchen_ware_project/models/chat.dart';
import 'package:kitchen_ware_project/models/message.dart';
import 'package:kitchen_ware_project/models/user.dart';
import 'package:kitchen_ware_project/providers/chat_provider.dart';
import 'package:kitchen_ware_project/providers/user_provider.dart';
import 'package:kitchen_ware_project/widgets/chat_widgets/message_widget.dart';
import 'package:provider/provider.dart';

class MessagesWidget extends StatefulWidget {
  final User other;
  final Chat chat;

  const MessagesWidget({
    required this.other,
    required this.chat,
    Key? key,
  }) : super(key: key);

  @override
  State<MessagesWidget> createState() => _MessagesWidgetState();
}

class _MessagesWidgetState extends State<MessagesWidget> {

  @override

  Widget build(BuildContext context)=> StreamBuilder<List<Message>>(
        stream: ChatProvider().messages(widget.chat.chatId),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            default:
              if (snapshot.hasError) {
                return buildText('Something Went Wrong Try later');
              } else {
                final messages = snapshot.data;
                final logedUser =Provider.of<UserProvider>(context,listen: false).logedUser!;
                return messages!.isEmpty
                    ? buildText('Say Hi..')
                    : ListView.builder(
                        physics: BouncingScrollPhysics(),
                        reverse: true,
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[index];
                          return MessageWidget(
                            message: message,
                            other:widget.other,
                            isMe: message.userId == logedUser.userID ,
                          );
                        },
                      );
              }
          }
        },
      );


  // @override
  // Widget build(BuildContext context) {
  //   final userProv = Provider.of<UserProvider>(context, listen: false);
  //   return ListView.builder(
  //     physics: BouncingScrollPhysics(),
  //     reverse: true,
  //     itemCount: messages.length,
  //     itemBuilder: (context, index) {
  //       final message = messages[index];
  //       return MessageWidget(
  //         message: message,
  //         isMe: message.userId != userProv.logedUser!.userID,
  //       );
  //     },
  //   );
  // }

  Widget buildText(String text) => Center(
        child: Text(
          text,
          style: TextStyle(fontSize: 24),
        ),
      );
}
