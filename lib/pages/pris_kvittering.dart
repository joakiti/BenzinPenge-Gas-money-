import 'dart:async';

import 'package:benzin_penge/mixin/error_message_mixin.dart';
import 'package:benzin_penge/model/address.dart';
import 'package:benzin_penge/model/address_distance.dart';
import 'package:benzin_penge/pages/tilfoej_ruter.dart';
import 'package:benzin_penge/repositories/implementations/distance_provider.dart';
import 'package:benzin_penge/repositories/implementations/gasoline_price_provider.dart';
import 'package:benzin_penge/ui_components/address_autocomplete_entry.dart';
import 'package:benzin_penge/ui_components/address_icon.dart';
import 'package:benzin_penge/ui_components/modal_fit.dart';
import 'package:benzin_penge/ui_components/nav_icon.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:benzin_penge/ui_components/user_icon_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrisKvittering extends StatefulWidget {
  final List<GAddress> directionPoints;

  PrisKvittering({this.directionPoints});

  @override
  _PrisKvitteringState createState() => _PrisKvitteringState();
}

class _PrisKvitteringState extends State<PrisKvittering> with ErrorMessage {
  Future<List<AddressDistance>> addressDistanceFuture;

  /// Read values from this List<AddressDistance>
  List<AddressDistance> addressesDistanceFetched;

  @override
  void initState() {
    addressDistanceFuture = seedAddressDistance(widget.directionPoints);
    addressDistanceFuture.then((v) {
      addressesDistanceFetched = v;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 45.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Theme.of(context).highlightColor, width: 3),
                      borderRadius: BorderRadius.all(Radius.circular(45))),
                  child: FloatingActionButton(
                    child: Icon(
                      Icons.person_add,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => UserIconPicker());
                    },
                  )),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 50.0, left: 25, right: 25),
              child: Card(
                elevation: 20,
                child: ListView(children: [
                  buildHeader(),
                  FutureBuilder(
                    future: addressDistanceFuture,
                    builder: (context,
                        AsyncSnapshot<List<AddressDistance>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.data == null) {
                          return AddAdditionalAddress(widget: widget);
                        }
                        return Column(
                          children: snapshot.data
                              .map(createListTileFromAddressDescription)
                              .toList()
                                /**
                           * Add a add more address entry.
                           */
                                ..add(
                                  AddAdditionalAddress(widget: widget),
                                ),
                        );
                        /**
                         * We must wait for the view to be loaded, before we display a snack bar
                         */
                      } else if (snapshot.hasError) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          showSnackBarErrorWithContext(context,
                              "Fejl under indlæsning af oplysninger\n ${snapshot.error.toString()}");
                        });
                        return Container();
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 18.0),
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 15,
                          ),
                          FutureBuilder(
                              future: addressDistanceFuture,
                              builder: (context,
                                  AsyncSnapshot<List<AddressDistance>>
                                      snapshot) {
                                if (snapshot.hasData &&
                                    snapshot.connectionState ==
                                        ConnectionState.done) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8.0, right: 8),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.black),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(25)),
                                              color: Theme.of(context)
                                                  .highlightColor),
                                          child: Center(
                                            child: Container(
                                              margin: EdgeInsets.all(20),
                                              child: PriceTile(
                                                  price: totalPriceDistance(),
                                                  noLiter: totalLiterUsed(),
                                                  noKilometers:
                                                      totalKilometersUsed(),
                                                  description: "Samlet pris",
                                                  icon: Icons.monetization_on,
                                                  color: Colors.indigoAccent),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                } else {
                                  return Container();
                                }
                              }),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 70,
                  )
                ]),
              ),
            ),
            ReceiptIcon(),
          ],
        ),
      ),
    );
  }

  totalPriceDistance() {
    return addressesDistanceFetched.fold(
        0, (s, v) => s + v.priceOfDistanceInGas);
  }

  Column buildHeader() {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.only(left: 25, right: 25, top: 35, bottom: 8),
        child: Text(
          "Dispensation for kørsel",
          style: Theme.of(context).textTheme.display4,
          textAlign: TextAlign.center,
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, bottom: 14),
        child: Text(
          "Du kan også tilføje andre udgifter, som broafgift, eller kørselspenge",
          style: Theme.of(context).textTheme.display2,
          textAlign: TextAlign.center,
        ),
      ),
      Stack(
        children: <Widget>[
          DottedLine(
            direction: Axis.horizontal,
            lineLength: double.infinity,
            lineThickness: 1.0,
            dashColor: Colors.black12,
            dashGapLength: 8,
            dashLength: 9,
          ),
          Transform.translate(
            offset: Offset(-10, -10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.all(Radius.circular(45))),
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(10, -10),
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.all(Radius.circular(45))),
              ),
            ),
          ),
        ],
      )
    ]);
  }

  /// Returns true if addresses could be fetched with no errors
  Future<List<AddressDistance>> seedAddressDistance(
      List<GAddress> directionPoints) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double gasolinePrice =
        await context.repository<GasolinePricesProvider>().provide();
    int kmPerLiter = prefs.getInt("km/l");

    List<AddressDistance> result = [];
    AddressDistance startingPoint = AddressDistance(
        distanceText: "0 km", from: directionPoints[0], to: directionPoints[0]);
    startingPoint.priceOfDistanceInGas = 0;
    startingPoint.literUsed = 0;
    startingPoint.distance = 0;
    startingPoint.icon =
        GAddress.mapAddressTypeToIcon(directionPoints[0].types);
    result.add(startingPoint);

    for (int i = 0; i < directionPoints.length - 1; i++) {
      GAddress from = directionPoints[i];
      GAddress to = directionPoints[i + 1];
      AddressDistance dist =
          await provideDistance(from, to, kmPerLiter, gasolinePrice);
      result.add(dist);
    }
    return result;
  }

  Future<AddressDistance> provideDistance(
      GAddress from, GAddress to, int kmPerLiter, double gasolinePrice) async {
    AddressDistance dist =
        await context.repository<DistanceProvider>().provide(args: [from, to]);
    dist.literUsed =
        num.parse(((dist.distance / 1000) / kmPerLiter).toStringAsFixed(2));
    dist.priceOfDistanceInGas = (gasolinePrice * dist.literUsed).toInt();
    dist.icon = GAddress.mapAddressTypeToIcon(to.types);
    return dist;
  }

  Widget createListTileFromAddressDescription(AddressDistance address) {
    String gasDisplay = "${address.priceOfDistanceInGas},-";
    if (address.priceOfDistanceInGas == 0) {
      gasDisplay = "";
    }

    return InkWell(
      onLongPress: () {
        showMaterialModalBottomSheet(
            context: context,
            expand: false,
            builder: (context, scrollController) => ModalFit(
                  scrollController: scrollController,
                  onDeletePressed: () {
                    var addresses = widget.directionPoints;
                    addresses.removeWhere((element) =>
                        element.description == address.to.description);
                    setState(() {
                      addressDistanceFuture =
                          seedAddressDistance(widget.directionPoints);
                      addressDistanceFuture.then((v) {
                        addressesDistanceFetched = v;
                      });
                    });
                  },
                ));
      },
      child: Column(
        children: <Widget>[
          AddressAutoCompleteEntry(
            address: address.to,
            buttonEndRow: Column(
              children: <Widget>[
                Text(
                  gasDisplay,
                  style: Theme.of(context)
                      .textTheme
                      .display4
                      .merge(TextStyle(color: Theme.of(context).cardColor)),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text("${address.distanceText} væk",
                      style: Theme.of(context).textTheme.display3),
                ),
              ],
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  totalLiterUsed() {
    return addressesDistanceFetched.fold(0.0, (t, v) {
      return t + v.literUsed;
    });
  }

  totalKilometersUsed() {
    return addressesDistanceFetched.fold(0.0, (t, v) {
      return num.parse(((t + (v.distance / 1000)).toStringAsFixed(2)));
    });
  }
}

class AddAdditionalAddress extends StatelessWidget {
  const AddAdditionalAddress({
    Key key,
    @required this.widget,
  }) : super(key: key);

  final PrisKvittering widget;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TilfoejRuter(widget.directionPoints)));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: DottedBorder(
          borderType: BorderType.RRect,
          radius: Radius.circular(20),
          child: Container(
            decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.all(Radius.circular(15))),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                    child: Container(
                        margin: EdgeInsets.all(10),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                "Tilføj flere destinationer",
                                style: Theme.of(context)
                                    .textTheme
                                    .display2
                                    .merge(TextStyle(color: Colors.black)),
                              ),
                            ),
                            Icon(Icons.add, color: Colors.black),
                          ],
                        )))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PriceTile extends StatelessWidget {
  const PriceTile(
      {Key key,
      @required this.price,
      @required this.color,
      @required this.noKilometers,
      @required this.icon,
      @required this.description,
      @required this.noLiter})
      : super(key: key);
  final int price;
  final double noLiter;
  final double noKilometers;
  final String description;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(
              description,
              style: Theme.of(context)
                  .textTheme
                  .display4
                  .merge(TextStyle(fontSize: 17, color: Colors.white)),
            ),
            Spacer(),
            Icon(icon, size: 20, color: Colors.white),
          ],
        ),
        Divider(
          color: Colors.white,
        ),
        buildPriceEntry(
            context,
            "Pris pr. liter",
            "${RepositoryProvider.of<GasolinePricesProvider>(context).gasPrice.toString()} kr pr. liter",
            Icons.local_gas_station),
        Divider(
          color: Colors.white,
        ),
        buildPriceEntry(context, "Antal liter", "${noLiter.toString()} L.",
            Icons.invert_colors),
        Divider(
          color: Colors.white,
        ),
        buildPriceEntry(context, "Antal km", "${noKilometers.toString()} km",
            Icons.confirmation_number),
        Divider(
          color: Colors.white,
        ),
        Row(
          children: <Widget>[
            Text("DKK",
                style: Theme.of(context)
                    .textTheme
                    .display4
                    .merge(TextStyle(color: Colors.white))),
            Spacer(),
            Text(price.toString() + ",-",
                style: Theme.of(context)
                    .textTheme
                    .display4
                    .merge(TextStyle(color: Colors.white))),
          ],
        ),
      ],
    );
  }

  Container buildPriceEntry(
      BuildContext context, String description, String end, IconData icon) {
    return Container(
      margin: EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          Icon(icon, color: Colors.white70),
          Text(description,
              style: Theme.of(context)
                  .textTheme
                  .display3
                  .merge(TextStyle(color: Colors.white70))),
          Spacer(),
          Text(end,
              style: Theme.of(context)
                  .textTheme
                  .display3
                  .merge(TextStyle(color: Colors.white70)))
        ],
      ),
    );
  }
}

class ReceiptIcon extends StatelessWidget {
  const ReceiptIcon({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
            decoration: BoxDecoration(
                border: Border.all(
                    width: 5, color: Theme.of(context).scaffoldBackgroundColor),
                borderRadius: BorderRadius.all(Radius.circular(45)),
                color: Theme.of(context).highlightColor),
            child: Container(
                padding: EdgeInsets.all(10),
                child: Icon(
                  Icons.receipt,
                  size: 45,
                  color: Theme.of(context).scaffoldBackgroundColor,
                ))),
      ),
    );
  }
}
