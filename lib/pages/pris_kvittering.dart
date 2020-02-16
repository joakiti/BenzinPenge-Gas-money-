import 'package:benzin_penge/mixin/error_message_mixin.dart';
import 'package:benzin_penge/model/address.dart';
import 'package:benzin_penge/model/address_distance.dart';
import 'package:benzin_penge/repositories/implementations/distance_provider.dart';
import 'package:benzin_penge/repositories/implementations/gasoline_price_provider.dart';
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
  List<AddressDistance> addresses = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    future: seedAddressDistance(widget.directionPoints),
                    builder: (context, AsyncSnapshot<List<AddressDistance>> snapshot) {
                      if (snapshot.hasData) {
                        addresses = snapshot.data;
                        return Column(
                          children: snapshot.data.map(createListTileFromAddressDescription).toList(),
                        );
                      } else if (snapshot.hasError) {
                        //showSnackBarError(error_scaffoldKey, "Vi kunne ikke fremsøge din kvittering lige nu. Prøv igen senere");
                       return Container();
                      }
                      else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
                  buildAddresses()
                ]),
              ),
            ),
            ReceiptIcon(),
          ],
        ),
      ),
    );
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
          style: Theme.of(context).textTheme.display3,
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
    startingPoint.icon = GAddress.mapAddressTypeToIcon(directionPoints[0].types);
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
    return ListTile(
        leading: Icon(
          address.icon,
          color: Theme.of(context).highlightColor,
        ),
        subtitle: Text("${address.distanceText} væk",
            style: Theme.of(context).textTheme.display3),
        trailing: Text(
          gasDisplay,
          style: Theme.of(context).textTheme.display4,
        ),
        enabled: true,
        onTap: () {},
        title: Text(address.to.description.split(",")[0],
            style: Theme.of(context).textTheme.body2),
        dense: true);
  }

  buildAddresses() {
    List<Widget> children = [];
    for (int i = 0; i < addresses.length; i++) {
      children.add(
          createListTileFromAddressDescription(addresses[i])
      );
    }
    return Column(
      children: children,
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
                border:
                    Border.all(width: 5, color: Theme.of(context).cardColor),
                borderRadius: BorderRadius.all(Radius.circular(45)),
                color: Theme.of(context).highlightColor),
            child: Container(
                padding: EdgeInsets.all(10),
                child: Icon(
                  Icons.receipt,
                  size: 45,
                  color: Theme.of(context).cardColor,
                ))),
      ),
    );
  }
}
