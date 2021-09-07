import 'package:flutter/material.dart';
import 'package:kitchen_ware_project/components/loading_widget.dart';
import 'package:kitchen_ware_project/models/chat.dart';
import 'package:kitchen_ware_project/models/user.dart';
import 'package:kitchen_ware_project/modules/custom_search/custom_search_delegate.dart';
import 'package:kitchen_ware_project/modules/custom_search/custom_user_search.dart';
import 'package:kitchen_ware_project/providers/app_provider.dart';
import 'package:kitchen_ware_project/providers/chat_provider.dart';
import 'package:kitchen_ware_project/providers/user_provider.dart';
import 'package:kitchen_ware_project/shared/constant.dart';
import 'package:kitchen_ware_project/utli/router.dart';
import 'package:kitchen_ware_project/views/chat_screens/chat_screen.dart';
import 'package:provider/provider.dart';

import 'chef_profile_screen.dart';

class CheifsListScreen extends StatefulWidget {
  @override
  State<CheifsListScreen> createState() => _CheifsListScreenState();
}

class _CheifsListScreenState extends State<CheifsListScreen> {
  List<User> cheifs = [];
  bool _isLoading = true;
  bool _isInit = true;
  @override
  void didChangeDependencies() async {
    if (_isInit) {
      await Provider.of<UserProvider>(context, listen: false)
          .fetchAllChiefs()
          .then((value) {
        setState(() {
          cheifs = value;
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.arrow_back_ios,
                                  color: LightBlackColor),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            // SizedBox(width: deviceSize.width * 0.03),
                            Text("Chefs",
                                style: TextStyle(
                                    color: LightBlackColor, fontSize: 22)),
                          ],
                        ),
                        IconButton(
                          icon: Icon(Icons.search),
                          onPressed: () async {
                            final data =
                                Provider.of<UserProvider>(context, listen: false)
                                    .getUserStream(cheifs);
                            var searchQueries =
                                Provider.of<AppProvider>(context, listen: false)
                                    .getUserQueriesStream();
                            // should be id
                            dynamic result = await showSearch(
                              context: context,
                              delegate: CustomUserSearch(
                                  data: data, searchQueries: searchQueries),
                            );
                            if (result != null)
                              MyRouter.pushPage(
                                  context, ChefProfileScreen(result));
                          },
                        ),
                      ],
                    ),
                  ),
                  ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: cheifs.length,
                    itemBuilder: (context, index) {
                      return ChiefItemBuilder(
                        cheif: cheifs[index],
                      );
                    },
                  ),
                ],
              ),
            ),
          );
  }
}

// ignore: must_be_immutable
class ChiefItemBuilder extends StatelessWidget {
  User cheif;

  ChiefItemBuilder({required this.cheif});

  void selectChef(BuildContext context) {
    MyRouter.pushPage(context, ChefProfileScreen(cheif.userID!));
  }

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;

    return InkWell(
      onTap: () {
        selectChef(context);
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        child: Container(
          padding: EdgeInsets.all(15),
          child: Row(
            children: [
              SizedBox(width: deviceSize.width * 0.03),
              CircleAvatar(
                backgroundImage: NetworkImage(cheif.imageUrl!),
                maxRadius: 40,
              ),
              SizedBox(width: deviceSize.width * 0.025),

              Flexible(
                child: Container(
                  padding: EdgeInsets.only(left: 10),
                  //  width : double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        // mainAxisSize: MainAxisSize.values[20],
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cheif.userName!,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                          Text(cheif.location??""),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          
                          Icon(
                            Icons.favorite_sharp,
                            color: Colors.red,
                          ),
                          SizedBox(width: 10,),
                          Text(
                            cheif.numberOfLoves!.toString() ,
                          ),
                          SizedBox(
                            width: deviceSize.width * 0.05,
                          ),
                          IconButton(onPressed: ()async{
                            final userProv=Provider.of<UserProvider>(context,listen:false).logedUser!;
                            Chat chat=await Provider.of<ChatProvider>(context,listen:false).initChat(cheif.userID!, userProv.userID!);
                            MyRouter.pushPage(context, ChatScreen(other: cheif, chat: chat));
                          }, 
                          icon: Icon(Icons.message_rounded)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // IconButton(
              //   onPressed: ()async{
              //     final chatsProv=Provider.of<ChatProvider>(context,listen:false);
              //     final userProv=Provider.of<UserProvider>(context,listen:false);
              //     await chatsProv.initChat(cheif.userID!,userProv.logedUser!.userID!).then((value) {
              //       MyRouter.pushPage(context, ChatScreen(other: cheif, chat: value));
              //     });
              //   },
              //   icon: Icon(Icons.message))
            ],
          ),
        ),
      ),
    );
  }
}
