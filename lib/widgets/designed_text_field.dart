import 'package:flutter/material.dart';
import 'package:kitchen_ware_project/shared/constant.dart';

class DesignedTextField extends StatelessWidget {
  final String? Function(String?)? textFieldValidator;
  final String? text;
  final Color? fieldColor;
  final double? textFieldWidth;
  final String? initialValue;
  final TextInputType? keyboardType;
  final void Function(String)? submitField;
  final void Function(String?)? save;
  final String? hintText;
  final Widget? suffixIcon;
  final bool? readOnly;

  DesignedTextField({
    Key? key,
    this.text,
    this.hintText,
    this.suffixIcon,
    this.fieldColor,
    this.initialValue,
    this.textFieldValidator,
    this.textFieldWidth,
    this.keyboardType,
    this.submitField,
    this.save,
    this.readOnly,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;

    return Container(
      width: textFieldWidth,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
              alignment: Alignment.topLeft,
              child: Text(" " + text!,
                  style: TextStyle(fontSize: 16, color: LightBlackColor))),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            keyboardType: keyboardType,
            cursorColor: LightBlackColor,
            initialValue: initialValue,
            decoration: InputDecoration(
              suffixIcon: suffixIcon,
              hintText: hintText,
              hintStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w100),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                  color: fieldColor!,
                  width: 2.0,
                ),
              ),
              filled: true,
              fillColor: fieldColor,
              focusColor: Colors.amber,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: fieldColor!,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            validator: textFieldValidator,
            onFieldSubmitted: submitField,
            onSaved: save,
            readOnly: readOnly == null ? false : readOnly!,
          ),
        ],
      ),
    );
  }
}
