import 'dart:async';
import 'package:benzin_penge/model/address.dart';
import 'package:benzin_penge/model/credentials.dart';
import 'package:benzin_penge/repositories/interfaces/interface_provider.dart';
import 'package:dio/dio.dart';
import 'package:place_picker/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddressAutoCompleteProvider implements AsyncProvider<List<GAddress>> {
  String sessionToken;
  String lastSearch;
  Timer t;

  @override
  Future<List<GAddress>> provide(addressSubstring) async {
    if (addressSubstring.isEmpty) {
      return List();
    }

    if (t != null && t.isActive) {
      print("Timer is active");
      return null;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String sessionTokenKey = "autocomplete_address_substring";

    if (prefs.containsKey(sessionTokenKey) &&
            lastSearch != null &&
            (addressSubstring.toString().startsWith(lastSearch)) ||
        (lastSearch.toString().startsWith(addressSubstring))) {
      /**
       * If the user is deleting, we dont auto complete.
       */
      sessionToken = prefs.get(sessionTokenKey);
      lastSearch = addressSubstring;
    } else {
      sessionToken = Uuid().generateV4();
      prefs.setString(sessionTokenKey, sessionToken);
      lastSearch = addressSubstring;
    }

    String baseUrl =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String language = 'da';
    String types = '';
    String request =
        '$baseUrl?input=$addressSubstring&key=$PLACES_API_KEY&language=$language&types=$types&components=country:dk&sessiontoken=$sessionToken';

    Response response = await Dio().get(request);

    final predictions = response.data['predictions'];
    List<GAddress> addresses = new List(predictions.length);

    print(predictions);
    if (predictions.length == 0) {
      return null;
    }

    for (var i = 0; i < predictions.length; i++) {
      final prediction = predictions[i];
      String description = prediction['description'];
      description = description.replaceAll(", Danmark", "");
      addresses[i] = GAddress(
        description: description,
        placeId: prediction['place_id'],
        types: prediction['types'].cast<String>(),

      );
    }
    t = Timer(Duration(milliseconds: 450), () {
      print("Ready to receive auto completion calls");
    });
    return addresses;
  }
}
