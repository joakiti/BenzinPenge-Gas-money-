import 'dart:async';

import 'package:flutter/material.dart';
import 'package:synchronized/synchronized.dart';

abstract class ErrorMessage {
  var lock = new Lock();

  void showSnackBarError(
      GlobalKey<ScaffoldState> key, String msg, errorMessageShowing) async {
      if (!errorMessageShowing) {
        key.currentState
          ..showSnackBar(
            SnackBar(
              duration: new Duration(seconds: 2),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Container(child: Text(msg))),
                  Icon(Icons.error)
                ],
              ),
              backgroundColor: Colors.red,
            ),
          );
      }
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
            Expanded(child: Container(child: Text(msg))),
            Icon(Icons.error)
          ],
        ),
        backgroundColor: Colors.red,
      ),
    );
}
