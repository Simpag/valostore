import 'package:flutter/material.dart';
import '../../constants.dart';
import 'dart:math' as math;

class StoreItem extends StatelessWidget {
  final String image_link, name;

  final double _radius = 10.0;

  StoreItem({
    required this.name,
    required this.image_link,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.longestSide * 0.15,
      width: MediaQuery.of(context).size.shortestSide * 0.9,
      margin: EdgeInsets.symmetric(vertical: 10.0),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.black54,
        boxShadow: [
          BoxShadow(
            offset: Offset(0.00, 10.00),
            color: CustomColors.Blue,
            blurRadius: 10,
          ),
        ],
        borderRadius: BorderRadius.circular(_radius),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 10,
            child: Container(
              //padding: EdgeInsets.only(left: 15.0),
              width: MediaQuery.of(context).size.shortestSide * 0.3,
              alignment: Alignment.centerLeft,
              child: Text(
                name,
                style: TextStyle(fontSize: 18, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Positioned(
            right: 25,
            child: Container(
              width: MediaQuery.of(context).size.shortestSide * 0.4,
              height: MediaQuery.of(context).size.longestSide * 0.08,
              alignment: Alignment.center,
              child: Container(
                transform: Matrix4.rotationZ(math.pi / 4),
                transformAlignment: Alignment.center,
                child: Image.network(image_link),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
