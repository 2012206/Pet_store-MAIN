import 'package:google_maps_flutter/google_maps_flutter.dart';

class MosqueModel {
  // name of temple
  final String name;

  // the address
  final String address;

  // geo location
  final LatLng latLng;

  // ImageUrls
  final String imageUrl;

  // id given to each item by places api
  final String placesId;

  const MosqueModel({
    required this.name,
    required this.address,
    required this.latLng,
    required this.imageUrl,
    required this.placesId,
  });
}
