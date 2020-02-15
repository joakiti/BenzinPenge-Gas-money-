import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class SearchInterface<T extends StatefulWidget> extends State<T> {
  bool lookingUpResults;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  bool shouldShowFloatingActionButton = true;

  void setFloatingActionButtionVisible() {
    setState(() {
      shouldShowFloatingActionButton = true;
    });
  }

  void setFloatingActionButtionInvisible() {
    setState(() {
      shouldShowFloatingActionButton = false;
    });
  }

  void setLookingUpResultsNull() {
    setState(() {
      lookingUpResults = null;
    });
  }

  void setLookingUpResultsTrue() {
    setState(() {
      lookingUpResults = true;
    });
  }

  void setLookingUpResultsFalse() {
    setState(() {
      lookingUpResults = false;
    });
  }
}
