import 'dart:convert';

import 'package:http/http.dart' as http;

const API_KEY =
    'pk.eyJ1IjoiZW5nZ2VteTk1IiwiYSI6ImNsMGpkNWI1eTA5aDAzanF0YThhOGJuMjkifQ.1t1qejpgb6tjK0JssTXC1g';

class LocationHelper {
  static String generateLocationPreviewImage(
    double latitude,
    double longitude,
  ) {
    return 'https://api.mapbox.com/styles/v1/mapbox/satellite-streets-v11/static/pin-l-marker+ff0000($longitude,$latitude)/$longitude,$latitude,17,0/600x300@2x?access_token=$API_KEY';
  }

  static Future<String> getPlaceAddress(double lat, double lng) async {
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$API_KEY';
    final response = await http.get(Uri.parse(url));

    return json.decode(response.body)['results'][0]['formatted_address'];
  }
}
