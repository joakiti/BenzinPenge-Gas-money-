import 'dart:async';

import 'package:benzin_penge/interfaces/search_bar_interface.dart';
import 'package:benzin_penge/model/address.dart';
import 'package:benzin_penge/ui_components/address_searchbar.dart';
import 'package:flutter/material.dart';

import 'address_autocompletion_results.dart';

class AddressSearch extends StatefulWidget {
  final scaffoldKey;
  final SearchInterface parent;
  final Function onAddressSelected;
  final bool lookingUpResults;
  final Widget endRowWidget;
  final Function nextPage;

  AddressSearch(
      {@required this.scaffoldKey,
      @required this.parent,
      @required this.onAddressSelected,
      @required this.lookingUpResults,
      this.endRowWidget,
      this.nextPage});

  @override
  _AddressSearchState createState() => _AddressSearchState();
}

class _AddressSearchState extends State<AddressSearch> {
  GAddress selected;
  bool typing = false;
  List<GAddress> _suggestions;
  FocusNode _keyboardFocus = new FocusNode();
  TextEditingController _searchController = new TextEditingController();

  @override
  void initState() {
    _suggestions = List();
    _keyboardFocus.addListener(dontDisplayButtonContentOnKeyboard);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _searchController.dispose();
    _keyboardFocus.removeListener(dontDisplayButtonContentOnKeyboard);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Column(
        children: <Widget>[
          AddressSearchBar(
            keyboardFocus: _keyboardFocus,
            searchController: _searchController,
            scaffoldKey: widget.scaffoldKey,
            parent: widget.parent,
            onStartSearch: widget.parent.setLookingUpResultsTrue,
            onAddressReceived: onAddressesReceived,
          ),
          AddressAutocompletionResults(
              endRowWidget: widget.endRowWidget,
              lookingUpResults: widget.parent.lookingUpResults,
              suggestions: _suggestions,
              onTap: addressSelected,
              nextPage: widget.nextPage),
          typing
              ? Container()
              : Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 90),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    height: 80,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        selected != null
                            ? Text(selected.description)
                            : Text(
                                "Du har ikke valgt en addresse endnu",
                                textAlign: TextAlign.end,
                              )
                      ],
                    ),
                  ),
                )
        ],
      ),
    );
  }

  onAddressesReceived(List<GAddress> addresses) {
    if (addresses != _suggestions) {
      setState(() {
        if (addresses != null) {
          widget.parent.setLookingUpResultsFalse();
          _suggestions = addresses;
        }
      });
    }
  }

  addressSelected(GAddress v) {
    this.setState(() {
      _keyboardFocus.unfocus();
      selected = v;
    });
    widget.onAddressSelected(v);
  }

  void dontDisplayButtonContentOnKeyboard() {
    if (_keyboardFocus.hasFocus) {
      setState(() {
        typing = true;
      });
    } else {
      Timer(Duration(milliseconds: 150), () {
        setState(() {
          typing = false;
        });
      });
    }
  }
}
