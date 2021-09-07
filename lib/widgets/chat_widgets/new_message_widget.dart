
import 'package:flutter/material.dart';
import 'package:kitchen_ware_project/models/message.dart';
import 'package:kitchen_ware_project/providers/chat_provider.dart';
import 'package:kitchen_ware_project/providers/user_provider.dart';
import 'package:kitchen_ware_project/shared/constant.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
class NewMessageWidget extends StatefulWidget {
  final String otherId;
  final String chatId;

  const NewMessageWidget({
    required this.otherId,
    required this.chatId,

    Key? key,
  }) : super(key: key);

  @override
  _NewMessageWidgetState createState() => _NewMessageWidgetState();
}

class _NewMessageWidgetState extends State<NewMessageWidget> {
  final _controller = TextEditingController();
  String message = '';


  void sendMessage(String userid) async {
    FocusScope.of(context).unfocus();
    _controller.clear();
    String id =Uuid().v4();
    Message _message=Message(messageId: id,message: message,userId: userid,createdAt: DateTime.now());
    await Provider.of<ChatProvider>(context,listen: false).uploadMessage(widget.chatId, _message);
  }

  @override
  Widget build(BuildContext context) {
    String id = Provider.of<UserProvider>(context,listen: false).logedUser!.userID!;
    return Container(
        color: Colors.white,
        padding: EdgeInsets.all(8),
        child: Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                controller: _controller,
                textCapitalization: TextCapitalization.sentences,
                autocorrect: true,
                enableSuggestions: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[100],
                  hintText: 'Type your message',
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 0,color: OrangeColor),
                    gapPadding: 10,
                    borderRadius: BorderRadius.circular(25),
                    
                  ),
                ),
                onChanged: (value) => setState(() {
                  message = value;
                }),
              ),
            ),
            SizedBox(width: 20),
            GestureDetector(
              onTap: message.trim().isEmpty ? null : ()=>sendMessage(id),
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: OrangeColor,
                ),
                child: Icon(Icons.send, color: Colors.white),
              ),
            ),
          ],
        ),
      );
  } 
}
