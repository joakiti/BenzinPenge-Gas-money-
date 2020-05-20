import 'package:benzin_penge/interfaces/search_bar_interface.dart';
import 'package:benzin_penge/mixin/error_message_mixin.dart';
import 'package:benzin_penge/model/address.dart';
import 'package:benzin_penge/pages/tilfoej_ruter.dart';
import 'package:benzin_penge/ui_components/address_search.dart';
import 'package:benzin_penge/ui_components/nav_icon.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class StartRuteOplysninger extends StatefulWidget {
  @override
  _StartRuteOplysningerState createState() => _StartRuteOplysningerState();
}

class _StartRuteOplysningerState extends SearchInterface<StartRuteOplysninger>
    with ErrorMessage {
  GAddress selectedAddress;
  bool hasError = false;
  bool hasBegunTyping = false;

  @override
  void initState() {
    // TODO: implement initState
    shouldShowFloatingActionButton = false;
    super.initState();
  }

  void goToTilfoejRuter() {
    if (selectedAddress != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => TilfoejRuter(selectedAddress)));
    } else {
      displayErrorUserDidNotPickAddress();
    }
  }

  void displayErrorUserDidNotPickAddress() {
    showSnackBarError(scaffoldKey,
        "Du skal vælge en addresse fra søgningen, før du kan gå videre.", hasError);
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
                  child: AnimatedDefaultTextStyle(
                    duration: Duration(milliseconds: 200),
                    style: hasBegunTyping ? Theme.of(context).textTheme.headline.merge(TextStyle(fontSize: 12.0)) : Theme.of(context).textTheme.headline,
                    child: Text(
                    "Hvor starter ruten?",
                  ),
                  )
                ),
                Text(
                    "Du kan tilføje ekstra udgifter, og opdele betaling senere"),
                AddressSearch(
                    endRowWidget: NavigationIcon(),
                    lookingUpResults: lookingUpResults,
                    parent: this,
                    onBegunTyping: () {
                      this.setState(() {
                        hasBegunTyping = true;
                      });
                    },
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
