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

class _PrisKvitteringState extends State<PrisKvittering> {
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
                child: ListView(
                    children: buildHeader()
                      ..add(FutureBuilder(
                        future: buildListTiles(widget.directionPoints),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            return snapshot.data;
                          } else {
                            return Center(child: CircularProgressIndicator());
                          }
                        },
                      ))),
              ),
            ),
            buildReceiptIcon(context),
          ],
        ),
      ),
    );
  }

  Widget buildReceiptIcon(BuildContext context) {
    return Positioned(
      child: Padding(
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
      ),
    );
  }

  List<Widget> buildHeader() {
    return [
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
    ];
  }

  Future<Widget> buildListTiles(List<GAddress> directionPoints) async {
    List<Widget> listTiles = new List();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double gasolinePrice =
        await context.repository<GasolinePricesProvider>().provide("");
    for (int i = 0; i < directionPoints.length; i++) {
      String title = directionPoints[i].description.split(",")[0];
      GAddress address = directionPoints[i];
      if (i == 0) {
        listTiles.add(createListTileFromAddressDescription(title, Icons.home,
            distance: null));
      } else if (i != directionPoints.length) {
        GAddress secondAddress = directionPoints[i - 1];
        AddressDistance dist = await context
            .repository<DistanceProvider>()
            .provide([address, secondAddress]);
        double literAntal = num.parse(
            ((dist.distance / 1000) / prefs.getInt("km/l")).toStringAsFixed(2));
        int price = (gasolinePrice * literAntal).toInt();
        IconData icon =
            i != directionPoints.length - 1 ? Icons.more_vert : Icons.home;
        listTiles.add(createListTileFromAddressDescription(title, icon,
            distance: dist.distanceText, priceForDistance: price));
      }
    }
    return Column(
      children: listTiles,
    );
  }

  Widget createListTileFromAddressDescription(String title, IconData icon,
      {String distance, int priceForDistance, GAddress address}) {
    String milesAway = "Du starter her";
    if (distance != null) {
      milesAway = "$distance kilometer væk";
    }
    String priceForDistanceToString = "";
    if (priceForDistance != null) {
      priceForDistanceToString = "$priceForDistance,-";
    }
    return ListTile(
        leading: Icon(
          icon,
          color: Theme.of(context).highlightColor,
        ),
        subtitle: Text(milesAway, style: Theme.of(context).textTheme.display3),
        trailing: Text(
          priceForDistanceToString,
          style: Theme.of(context).textTheme.display4,
        ),
        enabled: true,
        onTap: () {},
        title: Text(title, style: Theme.of(context).textTheme.body2),
        dense: true);
  }
}
