import 'package:flutter/material.dart';
import '../../constants.dart';

class CustomButton extends StatelessWidget {
  final double width, height;
  final void Function() onPressed;
  final String title;
  final LinearGradient gradient;
  final TextStyle titleStyle;

  final double _radius = 100.0;

  CustomButton({
    required this.onPressed,
    required this.title,
    this.width = 213.0,
    this.height = 53.0,
    this.gradient = CustomGradients.OrangeGradient,
    this.titleStyle = CustomTextStyles.ButtonText,
  });

  @override
  Widget build(BuildContext context) {
    return new Container(
      height: height,
      //margin: EdgeInsets.symmetric(horizontal: 90.0),
      width: width,
      decoration: BoxDecoration(
        gradient: gradient,
        boxShadow: [
          BoxShadow(
            offset: Offset(0.00, 10.00),
            color: CustomColors.LightBlue.withOpacity(0.20),
            blurRadius: 10,
          ),
        ],
        borderRadius: BorderRadius.circular(_radius),
      ),
      child: FlatButton(
        onPressed: onPressed,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_radius),
        ),
        child: Center(
          child: Text(
            title,
            style: titleStyle,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
