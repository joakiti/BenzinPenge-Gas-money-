import 'package:benzin_penge/model/address.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class GAddressIcon extends StatefulWidget {
  GAddress address;
  double size;
  var color;

  GAddressIcon(this.address, {this.size = 20, this.color});

  @override
  _GAddressIconState createState() => _GAddressIconState(size);
}

class _GAddressIconState extends State<GAddressIcon> {

  double size;
  bool fontAwesomeIconUsed = false;

  _GAddressIconState(this.size);

  @override
  Widget build(BuildContext context) {
    IconData iconData = mapAddressTypeToIcon(widget.address.types);
    return Row(
      children: <Widget>[
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
        ),
        Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: createTextColumn()),
        ),
      ],
    );
  }

  List<Widget> createTextColumn() {
    return widget.address.description
        .split(", ")
        .asMap()
        .map((index, val) {
      if (index == 0) {
        return MapEntry(
            index,
            Text(
              val + "",
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

  IconData mapAddressTypeToIcon(List<String> types) {
    if (types.contains("store")) {
      return Icons.store;
    }
    if (types.contains("school")) {
      return Icons.school;
    }
    if (types.contains("route")) {
      setState(() {
        fontAwesomeIconUsed = true;
      });
      return FontAwesomeIcons.road;
    }
    if (types.contains("establishment")) {
      return Icons.business;
    }
    if (types.contains("political")) {
      return Icons.location_city;
    }
    if (types.contains("street_address")) {
      return Icons.home;
    }
    return Icons.location_on;
  }
}
