import 'package:benzin_penge/model/address.dart';

class AddressDistance {
  int distance;
  String distanceText;
  int durationNoTraffic;
  String durationNoTrafficText;
  int durationWithTraffic;
  String durationWithTrafficText;
  GAddress from;
  GAddress to;

  AddressDistance(
      {this.distance,
      this.distanceText,
      this.durationNoTraffic,
      this.durationNoTrafficText,
      this.durationWithTraffic,
      this.durationWithTrafficText,
      this.from,
      this.to});
}
