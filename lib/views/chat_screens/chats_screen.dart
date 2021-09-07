import 'package:flutter/material.dart';
import 'package:kitchen_ware_project/components/loading_widget.dart';
import 'package:kitchen_ware_project/components/shimmer_loading.dart';
import 'package:kitchen_ware_project/models/chat.dart';
import 'package:kitchen_ware_project/models/user.dart';
import 'package:kitchen_ware_project/providers/chat_provider.dart';
import 'package:kitchen_ware_project/providers/user_provider.dart';
import 'package:kitchen_ware_project/shared/constant.dart';
import 'package:kitchen_ware_project/utli/router.dart';
import 'package:kitchen_ware_project/views/chat_screens/chat_screen.dart';
import 'package:provider/provider.dart';

class ChatsScreen extends StatefulWidget {
  @override
  State<ChatsScreen> createState() => _ChatsState();
}

class _ChatsState extends State<ChatsScreen> {
  List<Chat> chats = [];
  bool _isLoading = true;
  bool _isInit = true;
  @override
  void didChangeDependencies() async {
    if (_isInit) {
      String userID =
          Provider.of<UserProvider>(context, listen: false).logedUser!.userID!;
          print("user iddd"+userID);
      await Provider.of<ChatProvider>(context, listen: false)
          .getAllChats(userID)
          .then((value) {
        setState(() {
          chats = value;
          _isLoading = false;
          _isInit = false;
        });
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;

    return _isLoading
        ? LoadingWidget()
        : Scaffold(
            body: SingleChildScrollView(
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back_ios,
                              color: LightBlackColor),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        SizedBox(width: deviceSize.width * 0.03),
                        Text("chats",
                            style: TextStyle(
                                color: LightBlackColor, fontSize: 22)),
                      ],
                    ),
                  ),
                  chats.length != 0
                      ? ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: chats.length,
                          itemBuilder: (context, index) {
                            return ChatItemBuilder(
                              chat: chats[index],
                            );
                          },
                        )
                      : Text("no messages yet"),
                ],
              ),
            ),
          );
  }

  Widget buildText(String text) => Center(
        child: Text(
          text,
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
      );
}

// ignore: must_be_immutable
class ChatItemBuilder extends StatefulWidget {
  Chat chat;
  ChatItemBuilder({required this.chat});

  @override
  State<ChatItemBuilder> createState() => _ChatItemBuilderState();
}

class _ChatItemBuilderState extends State<ChatItemBuilder> {
  void selectChat(BuildContext context) {
    MyRouter.pushPage(
        context,
        ChatScreen(
          other: other,
          chat: widget.chat,
        ));
  }

  bool _isLoading = true;
  bool _isInit = true;
  late User other;
  @override
  void didChangeDependencies() async {
    if (_isInit) {
      // the idea to solve this is save two id's and set the other to whatever is the other
      final logedUserId =
          Provider.of<UserProvider>(context, listen: false).logedUser!.userID!;
      String otherId;
      otherId = widget.chat.otherId == logedUserId
          ? widget.chat.userId!
          : widget.chat.otherId!;

      await Provider.of<UserProvider>(context, listen: false)
          .fetchChiefByid(otherId)
          .then((value) {
        setState(() {
          other = value;
          _isLoading = false;
          _isInit = false;
        });
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    return _isLoading
        ? ShimmerLoading()
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                selectChat(context);
              },
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
                child: Container(
        
                  padding: EdgeInsets.all(15),
                  child: Row(
                    children: [
                      SizedBox(width: deviceSize.width * 0.03),
                      CircleAvatar(
                        backgroundImage: NetworkImage(other.imageUrl!),
                        maxRadius: 40,
                      ),
                      SizedBox(width: deviceSize.width * 0.025),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: deviceSize.width * 0.025),
                            child: Text(
                              other.userName!,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                            
                          ),
                          SizedBox(height: 10,),
                          Padding(
                            padding: EdgeInsets.only(
                            
                            left: deviceSize.width * 0.025),
                          
                            child: Container(
                              width: deviceSize.width*0.5,

                              child: Text(widget.chat.messages!.first.message!,style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                  )
                                  ,overflow: TextOverflow.fade,
                                  ),
                            ),
                          ),
                              SizedBox(width: 20,height: 10,),
                                Padding(
                                  padding: EdgeInsets.only(
                                left: deviceSize.width * 0.025),
                                  child: Text('${widget.chat.messages!.first.createdAt!.hour}:${widget.chat.messages!.first.createdAt!.minute}',style: TextStyle(
                                  fontSize: 12,                                  
                                  color: Colors.black54,
                              ),),
                                ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
