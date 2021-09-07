import 'package:flutter/material.dart';
import 'package:kitchen_ware_project/models/meal.dart';
import 'package:kitchen_ware_project/shared/constant.dart';
import 'package:kitchen_ware_project/utli/router.dart';
import 'package:kitchen_ware_project/views/app_screens/meal_detail_screen.dart';

class MealItem extends StatelessWidget {
  Meal? _meal;

  MealItem(Meal _meal){
    this._meal=_meal;
  }



  void selectMeal(BuildContext context) {
    MyRouter.pushPage(context, MealDetail(_meal!));
  }

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.only(
          left: deviceSize.width * 0.02, right: deviceSize.width * 0.02),
      child: Material(
        borderRadius: BorderRadius.circular(7.0),
        elevation: 4.0,
        child: InkWell(
          onTap: () {
            selectMeal(context);
          },
          child: Container(
            width: deviceSize.width * 0.65,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7.0),
              color: Colors.white,
            ),
            child: Column(
              children: <Widget>[
                //SizedBox(width: deviceSize.width * 0.001),
                Container(
                  height: deviceSize.height * 0.17,
                  width: deviceSize.width * 0.65,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(_meal!.imageUrl!), fit: BoxFit.cover),
                      borderRadius: BorderRadius.circular(7.0)),
                ),
                SizedBox(height: deviceSize.height * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: deviceSize.width * 0.02),
                      child: Text(
                        _meal!.title!,
                        style: TextStyle(
                            fontSize: 14.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          _meal!.rate.toString(),
                          style: TextStyle(
                            fontSize: 14.0,
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(right: deviceSize.width * 0.02),
                          child: Icon(
                            Icons.star,
                            color: AmberColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(left: deviceSize.width * 0.02),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.schedule),
                      SizedBox(width: deviceSize.width * 0.02),
                      Text('${_meal!.duration} min',
                          style: TextStyle(
                              fontSize: 14.0, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
