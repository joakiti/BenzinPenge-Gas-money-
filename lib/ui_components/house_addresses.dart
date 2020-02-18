import 'package:benzin_penge/ui_components/house_icon.dart';
import 'package:flutter/material.dart';

class StoredAddresses extends StatelessWidget {

  final int noStored;

  StoredAddresses(this.noStored);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        HouseIcon(
          icon: Icons.map,
          iconSize: 70,
          size: 12,
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                  height: 23,
                  width: 23,
                  decoration: BoxDecoration(
                      color: Theme.of(context).highlightColor,
                      borderRadius: BorderRadius.all(Radius.circular(45))),
                  child: Container(
                      child: Center(
                          child: Text(
                    "$noStored",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Theme.of(context).scaffoldBackgroundColor),
                  )))),
            ),
          ),
        )
      ],
    );
  }
}
