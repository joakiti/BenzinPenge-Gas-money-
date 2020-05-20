import 'package:flutter/material.dart';

abstract class ErrorMessage {

  void showSnackBarError(GlobalKey<ScaffoldState> key, String msg, errorMessageShowing) {
    if (!errorMessageShowing) {
      key.currentState
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: Container(
                        child: Text(
                            msg))),
                Icon(Icons.error)
              ],
            ),
            backgroundColor: Colors.red,
          ),
        );
    }
  }
  void showSnackBarErrorWithContext(BuildContext context, String msg) {
    Scaffold.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: Container(
                      child: Text(
                          msg))),
              Icon(Icons.error)
            ],
          ),
          backgroundColor: Colors.red,
        ),
      );
  }
}