import 'package:benzin_penge/interfaces/search_bar_interface.dart';
import 'package:benzin_penge/mixin/error_message_mixin.dart';
import 'package:benzin_penge/model/address.dart';
import 'package:benzin_penge/pages/tilfoej_ruter.dart';
import 'package:benzin_penge/ui_components/address_search.dart';
import 'package:benzin_penge/ui_components/nav_icon.dart';
import 'package:flutter/material.dart';

class StartRuteOplysninger extends StatefulWidget {
  @override
  _StartRuteOplysningerState createState() => _StartRuteOplysningerState();
}

class _StartRuteOplysningerState extends SearchInterface<StartRuteOplysninger>
    with ErrorMessage {
  GAddress selectedAddress;

  @override
  void initState() {
    // TODO: implement initState
    shouldShowFloatingActionButton = false;
    super.initState();
  }

  void goToTilfoejRuter() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => TilfoejRuter(selectedAddress)));
  }

  void displayErrorUserDidNotPickAddress() {
    showSnackBarError(scaffoldKey,
        "Du skal vælge en addresse fra søgningen, før du kan gå videre.");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      floatingActionButton:
          shouldShowFloatingActionButton && selectedAddress != null
              ? FloatingActionButton(
                  backgroundColor: Theme.of(context).bottomAppBarColor,
                  onPressed: goToTilfoejRuter,
                  child: Icon(Icons.navigation))
              : Container(),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Hvor starter ruten?",
                    style: Theme.of(context).textTheme.headline,
                  ),
                ),
                Text(
                    "Du kan tilføje ekstra udgifter, og opdele betaling senere"),
                AddressSearch(
                    endRowWidget: NavigationIcon(),
                    lookingUpResults: lookingUpResults,
                    parent: this,
                    scaffoldKey: scaffoldKey,
                    onAddressSelected: onAddressSelected,
                    nextPage: goToTilfoejRuter),
              ],
            ),
          ],
        ),
      ),
    );
  }

  onAddressSelected(GAddress selected) {
    setState(() {
      selectedAddress = selected;
    });
  }
}
