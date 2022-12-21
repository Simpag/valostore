import 'package:flutter/material.dart';
import '../../constants.dart';

class CustomButton extends StatelessWidget {
  final void Function() onPressed;
  final String title;
  final TextStyle titleStyle;

  final double _radius = 100.0;

  CustomButton({
    required this.onPressed,
    required this.title,
    this.titleStyle = CustomTextStyles.ButtonText,
  });

  @override
  Widget build(BuildContext context) {
    return new Container(
      height: 80,
      //margin: EdgeInsets.symmetric(horizontal: 90.0),
      width: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28.0),
        color: const Color(0xffFE424F),
        //color: CustomColors.ErrorRed,
        boxShadow: [
          BoxShadow(
            offset: Offset(0.00, 10.00),
            color: CustomColors.LightBlue.withOpacity(0.20),
            blurRadius: 10,
          ),
        ],
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          Icons.arrow_forward,
          color: CustomColors.BackgroundGrey.withOpacity(0.95),
          size: 40.0,
        ),
      ),
    );
  }
}

/*
child: FlatButton(
        onPressed: onPressed,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_radius),
        ),
        child: Center(
          child: Icon(
            Icons.arrow_forward,
            color: CustomColors.BackgroundGrey.withOpacity(0.95),
            size: 40.0,
          ),
        ),
      ),
*/