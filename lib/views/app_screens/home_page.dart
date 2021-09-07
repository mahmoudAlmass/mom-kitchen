import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kitchen_ware_project/APIs/notifications/notification_handler.dart';
import 'package:kitchen_ware_project/components/loading_widget.dart';
import 'package:kitchen_ware_project/components/shimmer_loading.dart';
import 'package:kitchen_ware_project/models/meal.dart';
import 'package:kitchen_ware_project/models/notifications.dart';
import 'package:kitchen_ware_project/modules/custom_search/custom_search_delegate.dart';
import 'package:kitchen_ware_project/modules/firestore_upload_images.dart';
import 'package:kitchen_ware_project/providers/app_provider.dart';
import 'package:kitchen_ware_project/providers/meal_provider.dart';
import 'package:kitchen_ware_project/providers/order_provider.dart';
import 'package:kitchen_ware_project/providers/user_provider.dart';
import 'package:kitchen_ware_project/services/authentication/authinticate.dart';
import 'package:kitchen_ware_project/utli/dialogs/dialogs.dart';
import 'package:kitchen_ware_project/utli/router.dart';
import 'package:kitchen_ware_project/views/app_screens/categories_screen.dart';
import 'package:kitchen_ware_project/views/app_screens/chef_profile_screen.dart';
import 'package:kitchen_ware_project/views/app_screens/cheifs_list_screen.dart';
import 'package:kitchen_ware_project/views/app_screens/meals_screen.dart';
import 'package:kitchen_ware_project/views/app_screens/notifications_screen.dart';
import 'package:kitchen_ware_project/views/app_screens/user_profile_screen.dart';
import 'package:kitchen_ware_project/widgets/app_drawer.dart';
import 'package:kitchen_ware_project/widgets/category_item.dart';
import 'package:kitchen_ware_project/widgets/chefs_list.dart';
import 'package:kitchen_ware_project/widgets/meals_list.dart';
import 'package:provider/provider.dart';
import 'package:kitchen_ware_project/shared/constant.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  Future<void> onRefresh() async {
    MyRouter.pushPageReplacement(context, HomePage());
  }

  @override
  Widget build(BuildContext context) {
    final userProv = Provider.of<UserProvider>(context, listen: false);

    return WillPopScope(
      onWillPop: () => Dialogs().showExitDialog(context),
      child: Scaffold(
        // appBar: AppBar(
        //   title: Text("Home Page"),
        //   actions: [
        //     IconButton(
        //         icon: Icon(Icons.person),
        //         onPressed: () async {
        //             print(Provider.of<UserProvider>(context,listen: false).logedUser!.userID);
        //         }),
        //   ],
        // ),
        body: _buildBody(context),
        drawer: AppDrawer(),
      ),
    );
  }

  _buildBody(context) {
    var Height1 = MediaQuery.of(context).size.height * 0.03;
    var Height2 = MediaQuery.of(context).size.height * 0.005;
    return RefreshIndicator(
      color: OrangeColor,
      onRefresh: () async {
        onRefresh();
      },
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              _buildTitleSection(context),
              SizedBox(height: Height1),
              _buildTextTitleSection(context, 'Categories', CategoriesScreen()),
              SizedBox(height: Height2),
              _buildCategoriesSection(context),
              SizedBox(height: Height1),
              _buildTextTitleSection(
                  context, 'Delicious Meals For You', MealsScreen()),
              SizedBox(height: Height2),
              _buildMealsSection(context, 0),
              SizedBox(height: Height1),
              _buildTextTitleSection(
                  context,
                  'Most Rated Meals',
                  MealsScreen(
                    query: 1,
                  )),
              SizedBox(height: Height2),
              _buildMealsSection(context, 1),
              SizedBox(height: Height1),
              _buildTextTitleSection(
                  context, 'Our Best Weekly Chiefs', CheifsListScreen()),
              SizedBox(height: Height2),
              _buildCheifsSection(context),
              SizedBox(height: Height1),
            ],
          ),
        ),
      ),
    );
  }

  _buildTitleSection(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.menu,
                color: BlackColor,
                size: 25,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNotificationWidget(context),
            InkWell(
              onTap: () {
                var logedUser =
                    Provider.of<UserProvider>(context, listen: false).logedUser;
                if (logedUser == null) {
                  MyRouter.pushPage(context, Authinticate());
                } else {
                  if (logedUser.isChief == true) {
                    MyRouter.pushPage(
                        context, ChefProfileScreen(logedUser.userID!));
                  } else if (logedUser.isChief == false) {
                    MyRouter.pushPage(
                        context, ProfilePage(logedUser: logedUser));
                  }
                }
              },
              child:
                  Provider.of<UserProvider>(context, listen: false).logedUser ==
                          null
                      ? CircleAvatar(
                          child: Container(
                            child: CircleAvatar(
                              radius: 20,
                              backgroundImage:
                                  AssetImage('assets/images/person-icon.png'),
                            ),
                          ),
                        )
                      : CachedNetworkImage(
                          imageUrl:
                              Provider.of<UserProvider>(context, listen: false)
                                  .logedUser!
                                  .imageUrl
                                  .toString(),
                          imageBuilder: (context, _) => Container(
                            width: 40.0,
                            height: 40.0,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                      Provider.of<UserProvider>(context,
                                              listen: false)
                                          .logedUser!
                                          .imageUrl
                                          .toString(),
                                    ))),
                          ),
                          placeholder: (context, url) => Container(
                            height: 50.0,
                            width: 50.0,
                            child: ShimmerLoading(),
                          ),
                          errorWidget: (context, url, error) => CircleAvatar(
                            child: Image.asset('assets/images/person-icon.png'),
                            radius: 20,
                          ),
                          fit: BoxFit.cover,
                        ),
            ),
          ],
        ),
      ],
    );
  }

  _buildNotificationWidget(context) {
    final notificationProv = Provider.of<NotificationHandler>(context);
    return Stack(
      children: <Widget>[
        new IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              showDialog(
                  context: context, builder: (_) => AnimatedNotifications());
              //todo fill this part with some actions
              notificationProv.clearCounter();
            }),
        notificationProv.counter != 0
            ? new Positioned(
                right: 11,
                top: 11,
                child: new Container(
                  padding: EdgeInsets.all(2),
                  decoration: new BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  constraints: BoxConstraints(
                    minWidth: 14,
                    minHeight: 14,
                  ),
                  child: Text(
                    '${notificationProv.counter}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            : new Container()
      ],
    );
  }

  _buildTextTitleSection(context, String title, Widget page) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          alignment: Alignment.topLeft,
          child: Text(
            title,
            style: TextStyle(color: BlackColor, fontSize: 18),
          ),
        ),
        TextButton(
          style: TextButton.styleFrom(
            textStyle: const TextStyle(fontSize: 20),
          ),
          onPressed: () {
            MyRouter.pushPage(context, page);
          },
          child: _seeAllButton(),
        ),
      ],
    );
  }

  _buildCategoriesSection(context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.08,
      child: CategoryItem(),
    );
  }

  _buildMealsSection(context, int query) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.28,
      child: MealsList(query: query),
    );
  }

  _buildCheifsSection(context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.32,
      child: ChefsList(),
    );
  }

  _seeAllButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10)),
      ),
      child: Text(
        'see all',
        style: TextStyle(fontSize: 13, color: Colors.grey),
      ),
    );
  }
}
