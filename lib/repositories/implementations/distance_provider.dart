import 'package:benzin_penge/model/address.dart';
import 'package:benzin_penge/model/address_distance.dart';
import 'package:benzin_penge/model/credentials.dart';
import 'package:benzin_penge/repositories/interfaces/interface_provider.dart';
import 'package:dio/dio.dart';

class DistanceProvider implements AsyncProvider {
  List<GAddress> cacheArgs;
  AddressDistance cacheDistance;

  @override
  Future<AddressDistance> provide({args}) async {
    if (args.hashCode == cacheArgs.hashCode) return cacheDistance;

    GAddress origin = args[0];
    GAddress destination = args[1];

    String baseUrl = 'https://maps.googleapis.com/maps/api/distancematrix/json';
    String language = 'da';
    String departureTime = 'now';
    String request =
        '$baseUrl?origins=place_id:${origin.placeId}&destinations=place_id:${destination.placeId}&key=$PLACES_API_KEY&language=$language&departure_time=$departureTime';

    Response response = await Dio()
        .get(request)
        .timeout(new Duration(seconds: 3), onTimeout: () {
      print("Failed fetching distance");
      return Future.error(null);
    });
    AddressDistance data =
        parseResponseToAddressDistance(response, origin, destination);

    cacheArgs = args;
    cacheDistance = data;
    return data;
  }

  parseResponseToAddressDistance(
      Response response, GAddress origin, GAddress destination) {
    final data = response.data;
    final distance = data['rows'][0]['elements'][0]['distance'];
    final duration = data['rows'][0]['elements'][0]['duration'];
    final durationInTraffic =
        data['rows'][0]['elements'][0]['duration_in_traffic'];
    final textDistance = distance['text'];
    final inMeters = distance['value'];
    final noTrafficDuration = duration['value'];
    final noTrafficDurationText = duration['text'];
    final trafficDuration = durationInTraffic['value'];
    final trafficDurationText = durationInTraffic['text'];
    return AddressDistance(
        distance: inMeters,
        distanceText: textDistance,
        durationNoTraffic: noTrafficDuration,
        durationNoTrafficText: noTrafficDurationText,
        durationWithTraffic: trafficDuration,
        durationWithTrafficText: trafficDurationText,
        from: origin,
        to: destination);
  }
}
