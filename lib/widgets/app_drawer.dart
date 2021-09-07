import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:kitchen_ware_project/APIs/googleMap/map_app.dart';
import 'package:kitchen_ware_project/providers/user_provider.dart';
import 'package:kitchen_ware_project/services/authentication/auth.dart';
import 'package:kitchen_ware_project/services/authentication/authinticate.dart';
import 'package:kitchen_ware_project/shared/constant.dart';
import 'package:kitchen_ware_project/utli/router.dart';
import 'package:kitchen_ware_project/views/app_screens/basket_screen.dart';
import 'package:kitchen_ware_project/views/app_screens/chef_orders_screen.dart';
import 'package:kitchen_ware_project/views/app_screens/chef_profile_screen.dart';
import 'package:kitchen_ware_project/views/app_screens/meals_screen.dart';
import 'package:kitchen_ware_project/views/app_screens/orders_screen.dart';
import 'package:kitchen_ware_project/views/app_screens/settings.dart';
import 'package:kitchen_ware_project/views/app_screens/user_profile_screen.dart';
import 'package:kitchen_ware_project/views/chat_screens/chats_screen.dart';
import 'package:kitchen_ware_project/widgets/meals_list.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProv = Provider.of<UserProvider>(context, listen: false);
    var Height = MediaQuery.of(context).size.height * 0.03;
    return Drawer(
      //elevation: 20.0,
      child: Column(
        children: <Widget>[
          // AppBar(
          //   title: Text('Hello Friend!'),
          //   automaticallyImplyLeading: false,
          // ),
          SizedBox(
            height: Height,
          ),
          Container(
              padding: EdgeInsets.all(15),
              alignment: Alignment.centerLeft,
              child: Text(
                "Hello Friend!",
                style: TextStyle(color: OrangeColor),
              )),
          Divider(),
          ListTile(
            leading: Icon(Icons.face, color: LightOrangeColor),
            title: Text('Profile'),
            onTap: () {
              if (userProv.logedUser != null) {
                if (userProv.logedUser!.isChief == false) {
                  MyRouter.pushPage(
                      context, ProfilePage(logedUser: userProv.logedUser!));
                } else if (userProv.logedUser!.isChief == true) {
                  MyRouter.pushPage(
                      context, ChefProfileScreen(userProv.logedUser!.userID!));
                }
              } else {
                MyRouter.pushPage(context, Authinticate());
              }
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment, color: LightOrangeColor),
            title: Text('Your Orders'),
            onTap: () {
              if (userProv.logedUser != null) {
                MyRouter.pushPage(context, OrdersScreen());
              } else {
                MyRouter.pushPage(context, Authinticate());
              }
            },
          ),
          _showRequestedOrders(context),
          Divider(),
          ListTile(
            leading: Icon(Icons.shopping_basket, color: LightOrangeColor),
            title: Text('Basket'),
            onTap: () {
              if (userProv.logedUser != null) {
                MyRouter.pushPage(context, Basket());
              } else {
                MyRouter.pushPage(context, Authinticate());
              }
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.restaurant_rounded, color: LightOrangeColor),
            title: Text('Near Resturants'),
            onTap: () {
              if (userProv.logedUser != null) {
                MyRouter.pushPage(context, MapApp());
              } else {
                MyRouter.pushPage(context, Authinticate());
              }
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.favorite_border, color: LightOrangeColor),
            title: Text('Favorites'),
            onTap: () {
              if (userProv.logedUser != null) {
                MyRouter.pushPage(context, MealsScreen(query: 2,));
              } else {
                MyRouter.pushPage(context, Authinticate());
              }
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.settings, color: LightOrangeColor),
            title: Text('Settings'),
            onTap: () {
              if (userProv.logedUser != null) {
                MyRouter.pushPage(context, Profile());
              } else {
                MyRouter.pushPage(context, Authinticate());
              }
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.message, color: LightOrangeColor),
            title: Text('Messages'),
            onTap: () {
              if (userProv.logedUser != null) {
                MyRouter.pushPage(context, ChatsScreen());
              } else {
                MyRouter.pushPage(context, Authinticate());
              }
            },
          ),
          Divider(),
          _showLogOut(context),
        ],
      ),
    );
  }
}

_showLogOut(context) {
  return ListTile(
    leading: Icon(Icons.logout, color: LightOrangeColor),
    title: Text('Log Out'),
    onTap: () async {
        await AuthService().signOut().then((_) => Phoenix.rebirth(context));
    },
  );
}

_showRequestedOrders(context) {
  if (Provider.of<UserProvider>(context, listen: false).logedUser != null) {
    if (Provider.of<UserProvider>(context, listen: false).logedUser!.isChief!) {
      return Column(
        children: [
          Divider(),
          ListTile(
            leading: Icon(Icons.payments_outlined, color: LightOrangeColor),
            title: Text('Requested Orders'),
            onTap: () {
              MyRouter.pushPage(context, ChefOrdersScreen());
            },
          ),
        ],
      );
    } else {
      return Container();
    }
  } else {
    return Container();
  }
}
