import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:latlong2/latlong.dart' as latlng;
import 'package:location/location.dart' as location;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GoogleMapWidget extends StatefulWidget {
  const GoogleMapWidget({super.key});

  @override
  State<GoogleMapWidget> createState() => _GoogleMapWidgetState();
}

class _GoogleMapWidgetState extends State<GoogleMapWidget> {
  late GoogleMapController mapController;

  final LatLng _center = LatLng(-6.585267761752595, 106.88177004571635);
  final LatLng _target = LatLng(-6.2145557175814465, 106.80063812452127);
  final String _apiKey = "AIzaSyDCQcVU2E2VKsb2cn-FYiE1Jry0IHsSe2o";

  List<LatLng> polylineCoordinates = [];
  List<LatLng> _currentRoute = [];
  Set<Polyline> _polylines = {};
  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _getRoute();
  }

  Future<void> _fetchRoute() async {
    String url = "https://maps.googleapis.com/maps/api/directions/json?"
        "origin=${_center.latitude},${_center.longitude}&"
        "destination=${_target.latitude},${_target.longitude}&"
        "key=$_apiKey";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['routes'].isNotEmpty) {
        String encodedPolyline =
            data['routes'][0]['overview_polyline']['points'];
        polylineCoordinates = _decodePolyline(encodedPolyline);
        _startAnimation();
      }
    }
  }

  /// Decodes Google Maps encoded polyline into LatLng points
  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> polylineCoordinates = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int shift = 0, result = 0;
      int b;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int deltaLat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += deltaLat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int deltaLng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += deltaLng;

      polylineCoordinates.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return polylineCoordinates;
  }

  /// Starts polyline animation by adding points gradually
  void _startAnimation() {
    _timer = Timer.periodic(Duration(milliseconds: 1), (timer) {
      if (_currentIndex < polylineCoordinates.length) {
        setState(() {
          _currentRoute.add(polylineCoordinates[_currentIndex]);
          _currentIndex++;
          _updatePolyline();
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  void _adjustCamera() {
    if (mapController == null) return;

    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(
        _center.latitude < _target.latitude
            ? _center.latitude
            : _target.latitude,
        _center.longitude < _target.longitude
            ? _center.longitude
            : _target.longitude,
      ),
      northeast: LatLng(
        _center.latitude > _target.latitude
            ? _center.latitude
            : _target.latitude,
        _center.longitude > _target.longitude
            ? _center.longitude
            : _target.longitude,
      ),
    );

    mapController
        .animateCamera(CameraUpdate.newLatLngBounds(bounds, 175)); //padding
  }

  void _getRoute() async {
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: _apiKey,
      request: PolylineRequest(
        origin: PointLatLng(_center.latitude, _center.longitude),
        destination: PointLatLng(_target.latitude, _target.longitude),
        mode: TravelMode.driving,
      ),
    );

    if (result.points.isNotEmpty) {
      polylineCoordinates.clear();
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }

      _startAnimation(); // Start animating the polyline
    } else {
      print("Error: ${result.errorMessage}");
    }
  }

  void _updatePolyline() {
    setState(() {
      _polylines.clear();
      _polylines.add(
        Polyline(
          polylineId: PolylineId("animated_route"),
          points: _currentRoute,
          color: Colors.blue,
          width: 5,
        ),
      );
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;

    Future.delayed(Duration(milliseconds: 500), () {
      _adjustCamera();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: _onMapCreated,
      polylines: _polylines,
      initialCameraPosition: CameraPosition(
        target: _center,
        zoom: 11.0,
      ),
      markers: {
        Marker(
          markerId: MarkerId('Your Location'),
          icon: BitmapDescriptor.defaultMarker,
          position: _center,
        ),
        Marker(
          markerId: MarkerId('Your Destination'),
          icon: BitmapDescriptor.defaultMarker,
          position: _target,
        )
      },
    );
  }

  Future<void> getLocationUpdate() async {
    bool _serviceEnabled;
    location.PermissionStatus _permissionGranted;

    // cek lokasi dinyalain gak ????
    _serviceEnabled = await location.Location().serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.Location().requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    // cek permission lokasi
    _permissionGranted = await location.Location().hasPermission();
    if (_permissionGranted == location.PermissionStatus.denied) {
      _permissionGranted = await location.Location().requestPermission();
    } else {
      return;
    }
  }
}

void showLocation() async {
  final userLocation = await location.Location().getLocation();
  print("Location: ${userLocation.latitude}, ${userLocation.longitude}");
}
