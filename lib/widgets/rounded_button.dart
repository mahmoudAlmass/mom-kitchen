import 'package:flutter/material.dart';
import 'package:kitchen_ware_project/shared/constant.dart';

class RoundedButton extends StatelessWidget {
  final String? text;
  final Function()? press;
  final double? width;
  final Color? color, textColor;

  const RoundedButton({
    Key? key,
    this.text,
    this.width,
    this.press,
    this.color = OrangeColor,
    this.textColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      width: width??size.width * 0.6,
      height: size.height * 0.06,
      child: FlatButton(
        color: color,
        shape: RoundedRectangleBorder(
            side: BorderSide(
              color: OrangeColor,
              width: 1,
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.circular(30)),
        onPressed: press,
        child: Text(
          text!,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
