import 'package:flutter/material.dart';

class HouseIcon extends StatelessWidget {
  final IconData icon;
  final double iconSize;
  final double size;

  HouseIcon({this.icon, this.iconSize, this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Theme.of(context).accentColor,
            border: Border.all(color: Theme.of(context).highlightColor),
            borderRadius: BorderRadius.all(Radius.circular(50))),
        child: Container(
            margin: EdgeInsets.all(size),
            child: Icon(
              icon,
              size: iconSize,
              color: Theme.of(context).highlightColor,
            )));
  }
}
