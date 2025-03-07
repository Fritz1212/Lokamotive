import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:latlong2/latlong.dart' as latlng;
import 'package:location/location.dart' as location;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

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
  Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
    _getRoute(); // Automatically get route when screen loads
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

    mapController.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, 100)); // 100 = padding
  }

  void _getRoute() async {
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleApiKey: _apiKey,
        request: PolylineRequest(
          origin: PointLatLng(_center.latitude, _center.longitude),
          destination: PointLatLng(_target.latitude, _target.longitude),
          mode: TravelMode.driving,
        ));

    if (result.points.isNotEmpty) {
      polylineCoordinates.clear();
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }

      setState(() {
        _polylines.clear();
        _polylines.add(
          Polyline(
            polylineId: PolylineId("route"),
            points: polylineCoordinates,
            color: Colors.blue,
            width: 5,
          ),
        );
      });
    } else {
      print("Error: ${result.errorMessage}");
    }
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
