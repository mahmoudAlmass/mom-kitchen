import 'package:flutter/material.dart';
import 'package:kitchen_ware_project/models/user.dart';
import 'package:kitchen_ware_project/shared/constant.dart';
import 'package:kitchen_ware_project/utli/router.dart';
import 'package:kitchen_ware_project/views/app_screens/chef_profile_screen.dart';

// ignore: must_be_immutable
class ChefItem extends StatelessWidget {
  User? _cheif;


  ChefItem(User _cheif){
    this._cheif=_cheif;
  }

  void selectChef(BuildContext context) {
    MyRouter.pushPage(context, ChefProfileScreen(_cheif!.userID!));
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

          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: deviceSize.height * 0.01),
              CircleAvatar(
                backgroundImage: NetworkImage(_cheif!.imageUrl!),
                maxRadius: 40,
              ),
              SizedBox(
                height: deviceSize.height * 0.04,
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      _cheif!.userName??"cheif",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(
                      height: deviceSize.height * 0.02,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: OrangeColor,
                        ),
                        Text(
                          _cheif!.location??"place",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
