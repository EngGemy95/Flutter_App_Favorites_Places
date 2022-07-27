import 'dart:io';

import 'package:explorer/helpers/db_helper.dart';
import 'package:explorer/helpers/location_helper.dart';
import 'package:flutter/foundation.dart';
import '../models/place.dart';

class GreatePlaces with ChangeNotifier {
  List<Place> _itemsPlaces = [];

  List<Place> get getItemsPlaces {
    return [..._itemsPlaces];
  }

  Future<void> addPlace(
    String pickedTitle,
    File? pickedImage,
    PlaceLocation placeLocation,
  ) async {
    final pickedAddress = await LocationHelper.getPlaceAddress(
      placeLocation.latitude,
      placeLocation.longitude,
    );
    final updateLocation = PlaceLocation(
      latitude: placeLocation.latitude,
      longitude: placeLocation.longitude,
      address: pickedAddress,
    );
    final newPlace = Place(
      id: DateTime.now().toString(),
      title: pickedTitle,
      location: updateLocation,
      image: pickedImage,
    );
    _itemsPlaces.add(newPlace);
    notifyListeners();

    DBHelper.insertPlace(
      'user_places',
      {
        'id': newPlace.id,
        'title': newPlace.title,
        'image': newPlace.image!.path,
        'loc_lat': newPlace.location!.latitude,
        'loc_lng': newPlace.location!.longitude,
        'address': newPlace.location!.address ?? '',
      },
    );
  }

  Future<void> fetchAndSetPlaces() async {
    final placesDataList = await DBHelper.getPlaces('user_places');
    _itemsPlaces = placesDataList.map((item) {
      return Place(
        id: item['id'],
        title: item['title'],
        image: File(item['image']),
        location: PlaceLocation(
          latitude: item['loc_lat'],
          longitude: item['loc_lng'],
          address: item['address'],
        ),
      );
    }).toList();
    notifyListeners();
  }

  Place selectPlaceById(String id) {
    return _itemsPlaces.firstWhere((Place) => Place.id == id);
  }
}
