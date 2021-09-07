import 'package:flutter/material.dart';
import 'package:kitchen_ware_project/models/chat.dart';
import 'package:kitchen_ware_project/models/user.dart';
import 'package:kitchen_ware_project/providers/chat_provider.dart';
import 'package:kitchen_ware_project/shared/constant.dart';
import 'package:kitchen_ware_project/widgets/chat_widgets/messages_widget.dart';
import 'package:kitchen_ware_project/widgets/chat_widgets/new_message_widget.dart';
import 'package:kitchen_ware_project/widgets/chat_widgets/profile_header_widget.dart';
import 'package:provider/provider.dart';
class ChatScreen extends StatefulWidget {

  final User other;
  final Chat chat;

  const ChatScreen({
    required this.other,
    required this.chat,

    Key? key,
  }) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<ChatScreen> {

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
        backgroundColor: OrangeColor,
        body: SafeArea(
          child: Column(
            children: [
              ProfileHeaderWidget(other: widget.other),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                  ),
                  child: MessagesWidget( chat: widget.chat, other: widget.other,),
                ),
              ),
              NewMessageWidget(chatId: widget.chat.chatId!, otherId: widget.other.userID!)
            ],
          ),
        ),
    );
  }
}