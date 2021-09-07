import 'package:flutter/cupertino.dart';
import 'package:kitchen_ware_project/shared/constant.dart';
import 'package:kitchen_ware_project/shared/constants.dart';
import 'package:kitchen_ware_project/models/slider.dart';
import 'package:kitchen_ware_project/utli/router.dart';
import 'package:kitchen_ware_project/views/app_screens/home_page.dart';
import 'package:kitchen_ware_project/widgets/rounded_button.dart';


class SlideItem extends StatelessWidget {
  final int? index;
  final bool? lastSlide;
  SlideItem({required this.index,required this.lastSlide});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width * 0.85,
          height: MediaQuery.of(context).size.height * 0.4,
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage(sliderArrayList[index!].sliderImageUrl!))),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.05,
        ),
        Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.0),
            child: Text(
              sliderArrayList[index!].sliderHeading!,
              style: TextStyle(
                fontFamily: Constants.OPEN_SANS,
                color: OrangeColor,
                letterSpacing: 1.0,
                height: 1.1,
                fontSize: 18.0,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.02,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.0),
          child: Text(
            sliderArrayList[index!].sliderSubHeading!,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: BlackColor,
              letterSpacing: 1.3,
              fontSize: 14.0,
            ),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.02,
        ),
          lastSlide!? Container(
          alignment: Alignment.center,
          child: RoundedButton(
            text: "Get Started",
            press: () {
              MyRouter.pushPageReplacement(context, HomePage());
            },
          ),
        ):Container(),
      ],
    );
  }
}
