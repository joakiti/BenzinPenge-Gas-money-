import 'package:benzin_penge/repositories/implementations/user_images_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserIconPicker extends StatefulWidget {
  @override
  _UserIconPickerState createState() => _UserIconPickerState();
}

class _UserIconPickerState extends State<UserIconPicker> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Dialog(
      elevation: 0.0,
      backgroundColor: Theme.of(context).cardColor,
      child: Stack(
        children: <Widget>[
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 3,
                  children: RepositoryProvider.of<UserImagesProvider>(context)
                      .getAllImages()),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  RaisedButton(
                    color: Theme.of(context).highlightColor,
                    child: Text("Tilføj"),
                    onPressed: () {},
                  ),
                ],
              )
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryIconTheme.color,
                    ),
                alignment: Alignment.topCenter,
                child: Center(
                  child: Container(
                    child: Text(
                      "Vælg dit ikon",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    ));
  }
}
