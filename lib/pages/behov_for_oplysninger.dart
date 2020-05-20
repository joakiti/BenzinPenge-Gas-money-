import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'start_rute.dart';

class BehovForOplysninger extends StatefulWidget {
  @override
  _BehovForOplysningerState createState() => _BehovForOplysningerState();
}

class _BehovForOplysningerState extends State<BehovForOplysninger> {
  int _kmLiter;

  /**
   * Wait until we have loaded data from preferences.
   */
  Future<int> _showPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt("km/l") ?? 10;
  }

  Future<int> _showDialog(int initial) {
    return showDialog<int>(
        context: context,
        builder: (BuildContext context) {
          return new NumberPickerDialog.integer(
            minValue: 1,
            maxValue: 50,
            title: new Text("Sæt en km/l"),
            initialIntegerValue: initial,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton.extended(
            backgroundColor: Colors.green,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => StartRuteOplysninger()));
            },
            label: Text("Næste")),
        body: SafeArea(
          child: FutureBuilder(
            future: _showPage(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              _kmLiter = snapshot.data;
              return snapshot.hasData
                  ? Container(
                      child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            "Oplysninger",
                            style: Theme.of(context).textTheme.headline,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            "Vi har behov for et circa tal på hvor langt din bil kører på literen. Vi bruger dette tal til at udregne prisen for dine fremtidige ruter. Skulle din stil ændrer sig kan du altid ændre tallet."
                          ),
                        ),
                        Center(
                          child: Row(
                            children: <Widget>[
                              FlatButton(
                                child: Text(
                                  "Hvad kører din bil I km/l?",
                                  style: TextStyle(
                                      fontSize: 22,
                                      decoration: TextDecoration.underline,
                                      color: Colors.blueAccent),
                                ),
                                onPressed: () {
                                  _showDialog(_kmLiter).then((v) async {
                                    setState(() {
                                      _kmLiter = v;
                                    });
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    prefs.setInt("km/l", v);
                                  });
                                },
                              ),
                              Spacer(),
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Text(_kmLiter.toString() + "km/l"),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ))
                  : Container();
            },
          ),
        ));
  }
}
