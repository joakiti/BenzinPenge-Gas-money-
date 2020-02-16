import 'package:benzin_penge/model/address.dart';
import 'package:benzin_penge/pages/pris_kvittering.dart';
import 'package:benzin_penge/pages/start_rute.dart';
import 'package:benzin_penge/pages/tilfoej_ruter.dart';
import 'package:benzin_penge/repositories/implementations/address_autocomplete_provider.dart';
import 'package:benzin_penge/repositories/implementations/distance_provider.dart';
import 'package:benzin_penge/repositories/implementations/gasoline_price_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'pages/behov_for_oplysninger.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  Future<bool> _hasBehovForOplysninger() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey("km/l");
  }

  AddressAutoCompleteProvider autoCompleteProvider = AddressAutoCompleteProvider();

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AddressAutoCompleteProvider>(
            create: (context) => autoCompleteProvider),
        RepositoryProvider<DistanceProvider>(
            create: (context) => DistanceProvider()),
        RepositoryProvider<GasolinePricesProvider>(
            create: (context) => GasolinePricesProvider())
      ],
      child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            highlightColor: Colors.indigoAccent,
            scaffoldBackgroundColor: Color(0xFF1D1D1D),
            bottomAppBarColor: Color(0xFF7cb342),
            backgroundColor: Color(0xFF1D1D1D),
            accentColor: Color(0xFF303030),
            textTheme: TextTheme(
              headline: TextStyle(
                  fontSize: 48.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
              title: TextStyle(
                  fontSize: 36.0,
                  fontStyle: FontStyle.italic,
                  color: Colors.white),
              body1: TextStyle(
                  fontSize: 14.0, fontFamily: 'Hind', color: Colors.white),
              caption: TextStyle(
                  fontSize: 14.0, fontFamily: 'Hind', color: Colors.white),
              display1: TextStyle(
                  fontSize: 14.0, fontFamily: 'Hind', color: Colors.white),
              display2: TextStyle(
                  fontSize: 14.0, fontFamily: 'Hind', color: Colors.white),
              display3: TextStyle(
                  fontSize: 12.0, fontFamily: 'Hind', color: Colors.black38),
              display4: TextStyle(
                  fontSize: 25.0,
                  fontFamily: 'Hind',
                  color: Colors.black87,
                  fontWeight: FontWeight.bold),
              body2: TextStyle(
                  fontSize: 14.0, fontFamily: 'Hind', color: Colors.black),
              overline: TextStyle(
                  fontSize: 14.0, fontFamily: 'Hind', color: Colors.white),
              subhead: TextStyle(
                  fontSize: 14.0, fontFamily: 'Hind', color: Colors.white),
              button: TextStyle(
                  fontSize: 14.0, fontFamily: 'Hind', color: Colors.white),
              subtitle: TextStyle(
                  fontSize: 14.0, fontFamily: 'Roboto', color: Colors.white30),
            ),
          ),
          /**
           * Check if it is the first run, is data contained in stash?
           */
          home: FutureBuilder(
              future: _hasBehovForOplysninger(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData && snapshot.data) {
                  GAddress origin = GAddress(
                      description: "hello,",
                      placeId:
                      "EiVGYWxrb25lciBBbGxlLCBGcmVkZXJpa3NiZXJnLCBEYW5tYXJrIi4qLAoUChIJGcoa3LpTUkYRJ-L6RKWKo3ISFAoSCaFXG8FSUlJGESeCH2l2ndG0");
                  GAddress destination = GAddress(
                      description: "asdf,",
                      types: [],
                      placeId:
                      "Eh5EaWVzZWx2ZWosIEvDuGJlbmhhdm4sIERhbm1hcmsiLiosChQKEgnF7iEefVNSRhHjyLdOgUkwBxIUChIJse35PnlUUkYRqLw2nyZVnz4");
                  //return PrisKvittering(directionPoints: [origin, destination, origin]);
                  return StartRuteOplysninger();
                }
                if (snapshot.hasData && !snapshot.data) {
                  return BehovForOplysninger();
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              })),
    );
  }
}
