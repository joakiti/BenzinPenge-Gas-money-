import 'package:benzin_penge/model/address.dart';
import 'package:flutter/material.dart';


class GAddressIcon extends StatelessWidget {

  double size;
  bool fontAwesomeIconUsed = false;
  GAddress address;

  GAddressIcon(this.address, {this.size});

  @override
  Widget build(BuildContext context) {
    IconData iconData = GAddress.mapAddressTypeToIcon(address.types);
    return Row(
      children: <Widget>[
        iconData != null ?
        Container(
          decoration: BoxDecoration(
              color: Theme.of(context).highlightColor,
              borderRadius: BorderRadius.all(Radius.circular(45))),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                String.fromCharCode(iconData.codePoint),
                style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontSize: fontAwesomeIconUsed ? size*0.9 : size,
                    fontFamily: iconData.fontFamily,
                    package: iconData.fontPackage),
              ),
            ),
          ),
        ) : Container(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: createTextColumn(context)),
          ),
        ),
      ],
    );
  }

  List<Widget> createTextColumn(BuildContext context) {
    return address.description
        .split(", ")
        .asMap()
        .map((index, val) {
      if (index == 0) {
        return MapEntry(
            index,
            Text(
              val ,
              style: TextStyle(
                  color: Theme.of(context)
                      .secondaryHeaderColor,
                  fontWeight: FontWeight.bold
              ),
            ));
      }
      return MapEntry(index, Text(val, style: Theme.of(context).textTheme.display3.merge(TextStyle(color: Colors.white70)),));
    })
        .values
        .toList();
  }
}

