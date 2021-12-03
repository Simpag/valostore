import 'package:flutter/material.dart';
import '../../constants.dart';

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
      margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
      decoration: BoxDecoration(
        color: Colors.black54,
        boxShadow: [
          BoxShadow(
            offset: Offset(0.00, 10.00),
            color: CustomColors.LightBlue.withOpacity(0.20),
            blurRadius: 10,
          ),
        ],
        borderRadius: BorderRadius.circular(_radius),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(left: 15.0),
            width: MediaQuery.of(context).size.shortestSide * 0.3,
            child: Text(
              name,
              style: TextStyle(fontSize: 18, color: Colors.white70),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(width: 25),
          Container(
            width: MediaQuery.of(context).size.shortestSide * 0.4,
            height: MediaQuery.of(context).size.longestSide * 0.08,
            child: Expanded(
              child: Image.network(image_link),
            ),
          ),
        ],
      ),
    );
  }
}
