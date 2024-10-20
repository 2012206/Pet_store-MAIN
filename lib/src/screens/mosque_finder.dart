import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pet_store_app/src/components/core/app_colors.dart';
import 'package:pet_store_app/src/components/text/customText.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';

import '../components/widgets/topHeadingContainer.dart';
import '../models/mosque_model.dart';

class MosqueFinder extends StatefulWidget {
  const MosqueFinder({super.key});

  @override
  State<MosqueFinder> createState() => _MosqueFinderState();
}

class _MosqueFinderState extends State<MosqueFinder> {
  Position? _currentPosition;

  Future<List<MosqueModel>> getMosques(Position position) async {
    const String apiKey = 'AIzaSyDYQzujbUNPEqqjiYaLje5UrzVOf4vElTc';
    String apiUrl =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${position.latitude},${position.longitude}&rankby=distance&types=veterinary_care&key=$apiKey';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      List<MosqueModel> mosqueModels = (data["results"] as List)
          .map(
            (result) => MosqueModel(
              name: result["name"],
              address: result["vicinity"],
              latLng: LatLng(
                result["geometry"]["location"]["lat"],
                result["geometry"]["location"]["lng"],
              ),
              imageUrl: result["icon"],
              placesId: result["place_id"],
            ),
          )
          .toList();

      return mosqueModels;
    } else {
      throw Exception('Failed to find mosques details');
    }
  }

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  @override
  void initState() {
    super.initState();
    requestPermissionAndLoadData();
  }

  Future<void> requestPermissionAndLoadData() async {
    var permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      // Handle case where permission is denied
      return;
    }

    // Permission granted, load data or perform actions
    Position? position = await Geolocator.getCurrentPosition();
    if (position != null) {
    } else {
      // Handle case where location retrieval failed
      print('Failed to get current location.');
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (_controller.isCompleted) {
      disposeController();
    }
  }

  disposeController() async {
    GoogleMapController controller = await _controller.future;
    controller.dispose();
  }

  Future<Position> getCurrentPosition() async {
    try {
      final position = await Geolocator.getCurrentPosition();
      return position;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding:  EdgeInsets.symmetric(horizontal: 16.sp),
          child: TopHeadingContainer(text: "Pet Shelter Finder"),
        ),
        Expanded(
          child: SizedBox(
              child: FutureBuilder<Position>(
            future: getCurrentPosition(),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  enabled: true,
                  child: SizedBox(
                    width: Get.width * 0.5,
                    height: 10.h,
                  ),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: CustomText(
                    text: "Something went wrong...",
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                );
              }
              _currentPosition = snapshot.data;


              Future<List<MosqueModel>> _futureMosques =
                  getMosques(snapshot.data!);

              LatLng _kMapCenter =
                  LatLng(snapshot.data!.latitude, snapshot.data!.longitude);

              return FutureBuilder<List<MosqueModel>>(
                future: _futureMosques,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: CustomText(
                        text: snapshot.error.toString(),
                        fontSize: 16.sp,
                      ),
                    );
                  }

                  if (!snapshot.hasData || (snapshot.data?.isEmpty ?? true)) {
                    Get.snackbar("No Mosque Found", "No Mosques Near You");
                  }

                  return GoogleMap(
                    onMapCreated: (GoogleMapController controllerMap) async {
                      if (!_controller.isCompleted) {
                        _controller.complete(controllerMap);
                      }
                    },
                    // markers: snapshot.data?.map((data) => Marker(
                    //             markerId: MarkerId(data.placesId),
                    //             position: LatLng(
                    //               data.latLng.latitude,
                    //               data.latLng.longitude,
                    //             ),
                    //             infoWindow: InfoWindow(
                    //               title: data.name,
                    //               snippet: data.address,
                    //             ),
                    //           ),).toSet() ?? <Marker>{},
                    markers: {
                      ...?snapshot.data?.map(
                            (data) => Marker(
                          markerId: MarkerId(data.placesId),
                          position: LatLng(
                            data.latLng.latitude,
                            data.latLng.longitude,
                          ),
                          infoWindow: InfoWindow(
                            title: data.name,
                            snippet: data.address,
                          ),
                        ),
                      ).toSet(),
                      if (_currentPosition != null)
                        Marker(
                          markerId: MarkerId("current_location"),
                          position: _kMapCenter,
                          icon: BitmapDescriptor.defaultMarkerWithHue(
                              BitmapDescriptor.hueBlue),
                          infoWindow: InfoWindow(
                            title: "You are here",
                          ),
                        ),
                    },
                    circles:  {
                      if (_currentPosition != null)
                        Circle(
                          circleId: CircleId("current_location_circle"),
                          center: _kMapCenter,

                          fillColor: Colors.blue.withOpacity(0.5),
                          strokeColor: Colors.blue,
                          strokeWidth: 2,
                          radius: 20
                        ),
                    },
                    mapType: MapType.normal,
                    initialCameraPosition: CameraPosition(
                      target: _kMapCenter,
                      zoom: 16.0,
                      tilt: 0,
                      bearing: 0,
                    ),
                  );
                },
              );
            },
          )),
        ),
      ],
    );
  }
}
