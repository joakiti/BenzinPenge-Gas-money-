import 'package:benzin_penge/model/address.dart';
import 'package:benzin_penge/ui_components/address_autocomplete_entry.dart';
import 'package:flutter/material.dart';

class AddressAutocompletionResults extends StatelessWidget {
  final bool lookingUpResults;
  final List<GAddress> suggestions;
  final Function onTap;
  final Widget endRowWidget;
  final Function nextPage;

  AddressAutocompletionResults(
      {this.lookingUpResults,
      this.suggestions,
      this.onTap,
      this.endRowWidget,
      this.nextPage});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
          child: lookingUpResults == null
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Brug søgebaren for oven, for at finde dit rejsepunkt",
                        style: Theme.of(context).textTheme.subtitle),
                  ],
                )
              : lookingUpResults
                  ? Center(child: CircularProgressIndicator())
                  : suggestions.length > 0
                      ? ListView(
                          children: suggestions.map((v) {
                          return InkWell(
                              onTap: () {
                                onTap(v);
                              },
                              child: AddressAutoCompleteEntry(
                                  address: v,
                                  buttonEndRow: GestureDetector(
                                      onTap: () {
                                        onTap(v);
                                        nextPage();
                                      },
                                      child: endRowWidget)));
                        }).toList())
                      : Center(
                          child: Text(
                              "Vi kunne ikke finde noget ud fra din søgning."),
                        ) //_suggestions.map(buildListTiles).toList()),
          ),
    );
  }
}
