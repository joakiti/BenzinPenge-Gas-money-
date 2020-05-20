import 'package:benzin_penge/interfaces/search_bar_interface.dart';
import 'package:benzin_penge/mixin/error_message_mixin.dart';
import 'package:benzin_penge/model/address.dart';
import 'package:benzin_penge/pages/pris_kvittering.dart';
import 'package:benzin_penge/ui_components/address_search.dart';
import 'package:benzin_penge/ui_components/house_addresses.dart';
import 'package:flutter/material.dart';

class TilfoejRuter extends StatefulWidget {
  final List<GAddress> originAddress;

  TilfoejRuter(this.originAddress);

  @override
  _TilfoejRuterState createState() => _TilfoejRuterState();
}

class _TilfoejRuterState extends SearchInterface<TilfoejRuter>
    with ErrorMessage {
  List<GAddress> fromAddresses;
  GAddress toAddress;
  bool hasBegunTyping = false;

  @override
  void initState() {
    fromAddresses = widget.originAddress;
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void goToPrisKvittering() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PrisKvittering(
                directionPoints: fromAddresses..add(toAddress))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      floatingActionButton: displayActionButton(),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0, top: 16.0, right: 23),
                        //23 due to size of map icon
                        child: AnimatedDefaultTextStyle(
                          duration: Duration(milliseconds: 200),
                          style: hasBegunTyping
                              ? Theme.of(context)
                                  .textTheme
                                  .headline
                                  .merge(TextStyle(fontSize: 12.0))
                              : Theme.of(context).textTheme.headline,
                          child: Text(
                            "Hvor skal du hen?",
                          ),
                        ),
                      ),
                    ),
                    /**
                     *                 Expanded(
                        child: Align(
                        alignment: Alignment.centerRight,
                        child: StoredAddresses(addresses.length, 23, 23)),
                        ),
                     */
                  ],
                ),
                AddressSearch(
                    endRowWidget: Container(
                      width: 35,
                      height: 35,
                    ),
                    lookingUpResults: lookingUpResults,
                    parent: this,
                    onBegunTyping: () {
                      setState(() {
                        hasBegunTyping = true;
                      });
                    },
                    scaffoldKey: scaffoldKey,
                    onAddressSelected: onAddressSelected,
                    nextPage: () {
                      goToPrisKvittering();
                    }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  onAddressSelected(GAddress selected) {
    setState(() {
      toAddress = selected;
    });
  }

  displayActionButton() {
    if (shouldShowFloatingActionButton) {
      Color displayColor = Theme.of(context).highlightColor;
      Function onPressed = goToPrisKvittering;
      return FloatingActionButton(
        onPressed: onPressed,
        child: Icon(Icons.receipt,
            color: Theme.of(context).scaffoldBackgroundColor),
        backgroundColor: displayColor,
      );
    } else {
      return Container();
    }
  }
}
