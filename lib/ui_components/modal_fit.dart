import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ModalFit extends StatelessWidget {
  final ScrollController scrollController;
  final Function onDeletePressed;

  const ModalFit({Key key, this.scrollController, this.onDeletePressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        child: SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
              title: Text('Fjern',
                  style: Theme.of(context)
                      .textTheme
                      .display2
                      .merge(TextStyle(color: Colors.redAccent))),
              leading: Icon(Icons.delete, color: Colors.redAccent),
              onTap: () {
                onDeletePressed();
                Navigator.of(context).pop();
              }),
          ListTile(
            title: Text(
              'Annuller',
              style: Theme.of(context).textTheme.display2,
            ),
            leading: Icon(Icons.edit),
            onTap: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    ));
  }
}
