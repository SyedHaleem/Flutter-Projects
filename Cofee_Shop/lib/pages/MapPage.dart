import 'dart:async';
import 'package:cofee_shop/config/Colors.dart';
import 'package:cofee_shop/consts/consts.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Completer<GoogleMapController> _mapController =
  Completer<GoogleMapController>();

  final TextEditingController _disfromController = TextEditingController();
  final TextEditingController _distoController = TextEditingController();

  LatLng locfrom = const LatLng(0.0, 0.0);
  LatLng locto = const LatLng(0.0, 0.0);
  LatLng? _currentP;

  Set<Polyline> polylines = {};
  List<Marker> markers = [];
  List<LatLng> _polylineCoordinates = [];

  static const CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(37.4223, -122.0848),
    zoom: 14,
  );

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, size: 20, color: CofeeBox),
          onPressed: () async {
            if (_currentP != null) {
              try {
                List<Placemark> placemarks = await placemarkFromCoordinates(
                  _currentP!.latitude,
                  _currentP!.longitude,
                );
                if (placemarks.isNotEmpty) {
                  Placemark placemark = placemarks.first;
                  String address =
                      '${placemark.locality}, ${placemark.administrativeArea}, ${placemark.country}';
                  Get.back(result: address);
                } else {
                  Get.back(result: 'Unknown Location');
                }
              } catch (e) {
                print('Error fetching address: $e');
                Get.back(result: 'Error fetching address');
              }
            } else {
              Get.back(result: 'No location available');
            }
          },
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            trafficEnabled: true,
            onMapCreated: (GoogleMapController controller) =>
                _mapController.complete(controller),
            initialCameraPosition: _initialCameraPosition,
            markers: Set<Marker>.from(markers),
            polylines: polylines,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
          ),
          Positioned(
            top: 80,
            left: MediaQuery.of(context).size.width * 0.06,
            right: MediaQuery.of(context).size.width * 0.06,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: TextField(
                style: TextStyle(color: CofeeText),
                controller: _disfromController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: searchBgColor,
                  hintText: "From",
                  hintStyle: TextStyle(color: CofeeText),
                  prefixIcon: const Icon(Icons.location_on, color: CofeeText),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 150,
            left: MediaQuery.of(context).size.width * 0.06,
            right: MediaQuery.of(context).size.width * 0.06,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: TextField(
                style: TextStyle(color: CofeeText),
                controller: _distoController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: searchBgColor,
                  hintText: "To",
                  hintStyle: TextStyle(color: CofeeText),
                  prefixIcon: const Icon(Icons.location_on, color: CofeeText),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 650,
            right: 7,
            child: SizedBox(
              width: 45,
              height: 45,
              child: FloatingActionButton(
                onPressed: () async {
                  if (_disfromController.text.isNotEmpty &&
                      _distoController.text.isNotEmpty) {
                    await _getLatLongAndPolyline();
                    _moveCameraToBounds();
                  } else if (_currentP != null) {
                    _moveCameraToPosition(_currentP!);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Location not available yet!")),
                    );
                  }
                },
                child: const Icon(
                  Icons.my_location,
                  color: Colors.white,
                  size: 20,
                ),
                backgroundColor: CofeeBox,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    final Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _currentP = LatLng(position.latitude, position.longitude);
      markers.add(
        Marker(
          markerId: const MarkerId("currentLocation"),
          position: _currentP!,
          infoWindow: const InfoWindow(title: "My Location"),
        ),
      );
    });
  }

  Future<void> _getLatLongAndPolyline() async {
    try {
      List<Location> locationFrom =
      await locationFromAddress(_disfromController.text);
      List<Location> locationTo =
      await locationFromAddress(_distoController.text);

      locfrom = LatLng(locationFrom[0].latitude, locationFrom[0].longitude);
      locto = LatLng(locationTo[0].latitude, locationTo[0].longitude);

      markers = [
        Marker(
          markerId: const MarkerId("FromLocation"),
          position: locfrom,
          infoWindow: const InfoWindow(title: "From Location"),
        ),
        Marker(
          markerId: const MarkerId("ToLocation"),
          position: locto,
          infoWindow: const InfoWindow(title: "To Location"),
        ),
      ];

      _polylineCoordinates.clear();
      PolylinePoints polylinePoints = PolylinePoints();
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
          googleApiKey: GOOGLE_MAPS_API_KEY,
          request: PolylineRequest(
            origin: PointLatLng( locfrom.latitude, locfrom.longitude),
            destination: PointLatLng(locto.latitude, locto.longitude),
            mode: TravelMode.driving,
      ));

      if (result.points.isNotEmpty) {
        for (var point in result.points) {
          _polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        }
      } else {
        debugPrint("Error fetching polyline: ${result.errorMessage}");
      }

      setState(() {
        polylines = {
          Polyline(
            polylineId: const PolylineId("route"),
            color: CofeeText,
            width: 4,
            points: _polylineCoordinates,
          ),
        };
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> _moveCameraToPosition(LatLng pos) async {
    final GoogleMapController controller = await _mapController.future;
    CameraPosition newPosition = CameraPosition(
      target: pos,
      zoom: 16,
    );
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(newPosition),
    );
  }

  Future<void> _moveCameraToBounds() async {
    final GoogleMapController controller = await _mapController.future;
    controller.animateCamera(CameraUpdate.newLatLngBounds(
      LatLngBounds(
        southwest: LatLng(
          locfrom.latitude < locto.latitude ? locfrom.latitude : locto.latitude,
          locfrom.longitude < locto.longitude
              ? locfrom.longitude
              : locto.longitude,
        ),
        northeast: LatLng(
          locfrom.latitude > locto.latitude ? locfrom.latitude : locto.latitude,
          locfrom.longitude > locto.longitude
              ? locfrom.longitude
              : locto.longitude,
        ),
      ),
      100,
    ));
  }
}
