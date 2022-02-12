import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rider_app/Assistants/requestAssistant.dart';
import 'package:rider_app/configMaps.dart';

class AssistantMethods {
  static Future<String> searchCoordinatesAddress(Position position) async {
    String placeAddress = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapkey";

    var response = await RequestAssistant.getRequest(url);

    if (response != "failed") {
      placeAddress = response["results"][0]["formatted_address"];
    }

    return placeAddress;
  }
}