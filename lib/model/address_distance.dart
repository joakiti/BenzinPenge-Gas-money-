import 'package:benzin_penge/model/address.dart';
import 'package:copyable/copyable.dart';

class AddressDistance implements Copyable<AddressDistance> {
  int distance;
  int durationNoTraffic;
  int durationWithTraffic;
  String distanceText;
  String durationNoTrafficText;
  String durationWithTrafficText;
  GAddress from;
  GAddress to;
  double literUsed;
  int priceOfDistanceInGas;

  AddressDistance(
      {this.distance,
      this.distanceText,
      this.durationNoTraffic,
      this.durationNoTrafficText,
      this.durationWithTraffic,
      this.durationWithTrafficText,
      this.from,
      this.to});

  @override
  AddressDistance copy() {
    // TODO: implement copy
    AddressDistance copy = AddressDistance();
    copy.distance = this.distance;
    copy.distanceText = this.distanceText;
    copy.durationNoTraffic = this.durationNoTraffic;
    copy.durationNoTrafficText = this.durationNoTrafficText;
    copy.durationWithTraffic = this.durationWithTraffic;
    copy.durationWithTrafficText = this.durationWithTrafficText;
    copy.literUsed = this.literUsed;
    copy.priceOfDistanceInGas = this.priceOfDistanceInGas;
    return copy;
  }

  @override
  AddressDistance copyWith() {
    // TODO: implement copyWith
    return null;
  }

  @override
  AddressDistance copyWithMaster(AddressDistance master) {
    // TODO: implement copyWithMaster
    return null;
  }
}
