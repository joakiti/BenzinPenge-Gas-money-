import 'package:flutter/material.dart';

class NavigationIcon extends StatelessWidget {

  final IconData icon;

  const NavigationIcon({
    Key key,
    this.icon
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Theme.of(context).highlightColor,
            borderRadius: BorderRadius.all(Radius.circular(45.0))),
        child: Transform.rotate(
          angle: 1,
          child: Container(
              padding: EdgeInsets.all(10),
              child: Icon(
                Icons.navigation,
                color: Theme.of(context).scaffoldBackgroundColor,
              )),
        ));
  }
}
