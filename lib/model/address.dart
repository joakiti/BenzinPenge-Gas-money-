import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class GAddress {
  String city;
  String street;
  String number;
  String postal;
  String placeId;
  String id;
  String country;
  String description;
  int matchedSubStringBegin;
  int matchedSubStringend;
  List<String> types;

  GAddress(
      {this.city,
      this.street,
      this.number,
      this.postal,
      this.placeId,
      this.id,
      this.country,
      this.description,
      this.matchedSubStringBegin,
      this.matchedSubStringend,
      this.types});

  static IconData mapAddressTypeToIcon(List<String> types) {
    if (types != null) {
      if (types.contains("store")) {
        return Icons.store;
      }
      if (types.contains("no_icon")) {
        return null;
      }
      if (types.contains("school")) {
        return Icons.school;
      }
      if (types.contains("route")) {
        return FontAwesomeIcons.road;
      }
      if (types.contains("establishment")) {
        return Icons.business;
      }
      if (types.contains("political")) {
        return Icons.location_city;
      }
      if (types.contains("street_address")) {
        return Icons.home;
      }
    }
    return Icons.location_on;
  }
}
