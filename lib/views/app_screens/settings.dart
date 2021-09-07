import 'package:flutter/material.dart';
import 'package:kitchen_ware_project/models/user.dart';
import 'package:kitchen_ware_project/providers/app_provider.dart';
import 'package:kitchen_ware_project/providers/meal_provider.dart';
import 'package:kitchen_ware_project/providers/user_provider.dart';
import 'package:kitchen_ware_project/shared/theme/theme_config.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late List items;


  @override
  void initState() {
    super.initState();
    items = [
      {'icon': Icons.brightness_2,
        'title': 'Dark Mode',
        'function': () => {}},
      {
        'icon': Icons.language_outlined,
        'title': 'Switch Your Language',
        'function':  (){},
      },
            {
        'icon': Icons.dinner_dining_outlined,
        'title': 'Change unsing Mode',
        'function':  ()=> changeUsingMode(),
      },
    ];
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: Text(
          'Settings',
        ),
      ),
      body: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 10),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          if (items[index]['title'] == 'Dark Mode') {
            return _buildThemeSwitch(items[index]);
          }
          if (items[index]['title'] == 'Switch Your Language') {
            return _buildLanguageSwitch(items[index]);
          }
          

          return ListTile(
            onTap: items[index]['function'],
            leading: Icon(
              items[index]['icon'],
            ),
            title: Text(
              items[index]['title'],
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return Divider();
        },
      ),
    );
  }

  Widget _buildThemeSwitch(Map item) {
    return SwitchListTile(
      secondary: Icon(
        item['icon'],
      ),
      title: Text(
        item['title'],
      ),
      value: Provider.of<AppProvider>(context).theme == ThemeConfig.lightTheme
          ? false
          : true,
      onChanged: (v) {
        if (v) {
          Provider.of<AppProvider>(context, listen: false)
              .setTheme(ThemeConfig.darkTheme, 'dark');
        } else {
          Provider.of<AppProvider>(context, listen: false)
              .setTheme(ThemeConfig.lightTheme, 'light');
        }
      },
    );
  }
  
  Widget _buildLanguageSwitch(Map item) {
    return SwitchListTile(
      secondary: Icon(
        item['icon'],
      ),
      title: Text(
        item['title'],
      ),
      value: false,
      onChanged: (v) {

      },
    );
  }
  changeUsingMode() {
  final userProv=Provider.of<UserProvider>(context,listen:false);
  final user=userProv.logedUser!;
  
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
          title: Text('Are you sure?'),
          content: Text(
            user.isChief ==true ?
            'you are currently in chef mode, do you want to change your status to customer?\nthis may delete all your posts':
            "you are currently in customer mode, do you want to change your status to chef?",
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(ctx).pop(false);
              },
            ),
            FlatButton(
                child: Text('Yes'),
                onPressed: () async {
                  if(user.isChief==true){
                    await userProv.changeChiefStatus(false).then((_) async{
                      Provider.of<MealProvider>(context,listen:false)
                      .clearAllMealToSingleCheif(userProv.logedUser!.userID!);
                    });
                  }else if(user.isChief==false){
                    await userProv.changeChiefStatus(true);
                  }
                  Navigator.of(ctx).pop();
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'your mode had updated',
                      ),
                      duration: Duration(seconds: 1),
                    ),
                  );
                }),
          ]),
    );
  }

}
