import 'package:benzin_penge/model/address.dart';
import 'package:benzin_penge/ui_components/address_icon.dart';
import 'package:flutter/material.dart';

class AddressAutoCompleteEntry extends StatefulWidget {
  final GAddress address;
  final Widget buttonEndRow;
  final Function onPressed;

  AddressAutoCompleteEntry({this.address, this.buttonEndRow, this.onPressed});

  @override
  _AddressAutoCompleteEntryState createState() =>
      _AddressAutoCompleteEntryState();
}

class _AddressAutoCompleteEntryState extends State<AddressAutoCompleteEntry> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).accentColor,
            borderRadius: BorderRadius.all(Radius.circular(15))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
                child: Container(
                    margin: EdgeInsets.all(10),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            child: GAddressIcon(widget.address)),
                        widget.buttonEndRow == null
                            ? Container()
                            : widget.buttonEndRow,
                      ],
                    )))
          ],
        ),
      ),
    );
  }
}
