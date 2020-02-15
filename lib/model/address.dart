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


}
