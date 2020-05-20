import 'dart:async';

import 'package:benzin_penge/interfaces/search_bar_interface.dart';
import 'package:benzin_penge/mixin/error_message_mixin.dart';
import 'package:benzin_penge/repositories/implementations/address_autocomplete_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddressSearchBar extends StatefulWidget {
  final Function onAddressReceived;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final SearchInterface parent;
  final TextEditingController searchController;
  final FocusNode keyboardFocus;
  final Function onStartSearch;

  AddressSearchBar(
      {@required this.scaffoldKey,
      @required this.parent,
      @required this.onAddressReceived,
      @required this.searchController,
      @required this.keyboardFocus,
      @required this.onStartSearch});

  @override
  _AddressSearchBarState createState() => _AddressSearchBarState();
}

class _AddressSearchBarState extends State<AddressSearchBar> with ErrorMessage {
  String lastSearch;
  bool errorMessageShowing = false;

  @override
  void initState() {
    widget.searchController.addListener(_onSearchChanged);
    widget.keyboardFocus.addListener(_keyboardListener);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    widget.searchController.removeListener(_onSearchChanged);
    widget.keyboardFocus.removeListener(_keyboardListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: new BoxDecoration(
              color: Theme.of(context).accentColor.withOpacity(0.55),
              border: Border.all(color: Colors.white30, width: 0.5),
              borderRadius: BorderRadius.all(Radius.circular(45))),
          child: Container(
            margin: EdgeInsets.all(2),
            child: TextField(
              focusNode: widget.keyboardFocus,
              controller: widget.searchController,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.white70,
                  ),
                  hintText: "Indtast start addresse..",
                  hintStyle: Theme.of(context)
                      .textTheme
                      .subtitle
                      .merge(TextStyle(fontSize: 15))),
            ),
          ),
        ),
      ),
    );
  }

  _onSearchChanged() {
    /**
     * The user has not entered anything new, so dont do anything.
     */
    widget.onStartSearch();
    String searchText = widget.searchController.text;
    if (lastSearch == searchText) {
      return;
    } else if (widget.searchController.text == "") {
      widget.parent.setLookingUpResultsNull();
      return;
    }
    lastSearch = searchText;
    widget.parent.setLookingUpResultsTrue();

    context
        .repository<AddressAutoCompleteProvider>()
        .provide(args: searchText)
        .then((addresses) {
      widget.parent.setLookingUpResultsFalse();
      setState(() {
        widget.onAddressReceived(addresses);
      });
    }).timeout(Duration(milliseconds: 2000), onTimeout: () {
      widget.parent.setLookingUpResultsNull();

      setState(() {
        showSnackBarError(
            widget.scaffoldKey,
            "Det ser ud til vi ikke kan finde nogle resultater til dig lige nu. Prøv igen senere.",
            errorMessageShowing);
        errorMessageShowing = true;
        Timer t = new Timer(Duration(seconds: 5), () {
          errorMessageShowing = false;
        });
      });
    });
  }

  void _keyboardListener() {
    if (widget.keyboardFocus.hasFocus) {
      // keyboard appeared
      widget.parent.setFloatingActionButtionInvisible();
    } else {
      Timer(Duration(milliseconds: 150), () {
        widget.parent.setFloatingActionButtionVisible();
      });
      // keyboard dismissed
    }
  }
}
