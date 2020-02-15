import 'package:benzin_penge/interfaces/search_bar_interface.dart';
import 'package:benzin_penge/mixin/error_message_mixin.dart';
import 'package:benzin_penge/model/address.dart';
import 'package:benzin_penge/pages/pris_kvittering.dart';
import 'package:benzin_penge/ui_components/address_search.dart';
import 'package:benzin_penge/ui_components/house_addresses.dart';
import 'package:flutter/material.dart';

class TilfoejRuter extends StatefulWidget {
  final GAddress originAddress;

  TilfoejRuter(this.originAddress);

  @override
  _TilfoejRuterState createState() => _TilfoejRuterState();
}

class _TilfoejRuterState extends SearchInterface<TilfoejRuter> with ErrorMessage {

  Set<GAddress> addresses = new Set();

  @override
  void initState() {
    addresses.add(widget.originAddress);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void goToTilfoejRuter() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                PrisKvittering(directionPoints: addresses.toList())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      floatingActionButton: shouldShowFloatingActionButton
          ? FloatingActionButton.extended(
              backgroundColor:
                  addresses.length > 1 ? Theme.of(context).highlightColor : Colors.white30,
              onPressed: addresses.length > 1
                  ? goToTilfoejRuter
                  : () {
                      showSnackBarError(scaffoldKey,
                          "Du har ikke indtastet nok addresser til at danne en rute.");
                    },
              label: Text("Næste", style: TextStyle(fontWeight: FontWeight.bold),))
          : Container(),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 16.0, top: 16.0, bottom: 16.0),
                    child: Text(
                      "Hvor skal du hen?",
                      style: Theme.of(context).textTheme.headline,
                    ),
                  ),
                ),
                StoredAddresses(addresses.length),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16, left: 16),
              child: Text("Ruten beregnes i rækkefølge af tilføjelser"),
            ),
            AddressSearch(
              lookingUpResults: lookingUpResults,
              parent: this,
              scaffoldKey: scaffoldKey,
              onAddressSelected: (v) {
                setState(() {
                  addresses.add(v);
                });
              },
            )
          ],
        ),
      ),
    );
  }
}
