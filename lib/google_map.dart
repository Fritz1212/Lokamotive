import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as location;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class GlobalonPage {
  static String onPage = '';
  static var decodedMessage;
}

class WebSocketService {
  final String serverUrl =
      "ws://10.68.108.159:3000"; // Change to your actual server URL
  late WebSocketChannel channel;
  Function(dynamic)? onMessageReceived;

  //3. Ambil pake ni function
  void connect() {
    channel = WebSocketChannel.connect(Uri.parse(serverUrl));
    channel.stream.listen((message) {
      print("Received: $message");
      if (onMessageReceived != null) {
        print("Pesan Sedang di decode");
        GlobalonPage.decodedMessage = onMessageReceived!(jsonDecode(message));
      }
    }, onDone: () {
      print("Berhasil Dapet Data !");
    }, onError: (error) {
      print("Error Ngambil Data: $error");
    });
  }

  //2. format pengirim request ke server (action udah getRecommendedRoutes)
  void sendGetRecommendedRoutes(String userId, String start, String destination,
      {String? preference}) {
    final data = {
      "action": "getRecommendedRoutes",
      "userId": userId,
      "start": start,
      "destination": destination,
      "preference": preference ?? "default"
    };

    //gas kirim
    channel.sink.add(jsonEncode(data));
  }
}

class GoogleMapWidget extends StatefulWidget {
  const GoogleMapWidget({Key? key, required this.onPage, required this.target})
      : super(key: key);
  final String onPage;
  final String target;

  @override
  State<GoogleMapWidget> createState() => _GoogleMapWidgetState();
}

class _GoogleMapWidgetState extends State<GoogleMapWidget> {
  late GoogleMapController mapController;
  final WebSocketService wsService = WebSocketService();
  final String _apiKey = "AIzaSyDCQcVU2E2VKsb2cn-FYiE1Jry0IHsSe2o";
  List<dynamic> routes = [];

  late LatLng _currentLocation;
  late LatLng _target;
  late String _currentLocationName = '';

  List<Marker> _markers = [];
  BitmapDescriptor? _customIcon;

  List<LatLng> polylineCoordinates = [];
  List<LatLng> _currentRoute = [];
  Set<Polyline> _polylines = {};
  int _currentIndex = 0;
  Timer? _timer;
  bool _isTargetInitialized = false;

  @override
  void initState() {
    super.initState();
    GlobalonPage.onPage = widget.onPage;
    wsService.connect();
    _initializeTarget();
    _getCurrentLocation();
    _getRoute();
  }

  @override
  void dispose() {
    super.dispose();
  }

  //4. Siapin latitude longitude dari target
  Future<void> _initializeTarget() async {
    print("Inisiasi Target (mendapatkan latitude longitude target)");
    try {
      _target = await _getLatLngFromPlaceName(widget.target);
      setState(() {
        _isTargetInitialized = true;
      });
    } catch (e) {
      print('Koordinat target tidak ditemukan: $e');
    }
  }

  //1. request buat dapetin rute dar server
  Future<List<Map<String, dynamic>>> requestFormatedRoute() async {
    wsService.sendGetRecommendedRoutes(
        "user123", _currentLocationName, widget.target,
        preference: "fastest");

    await Future.delayed(Duration(seconds: 2));

    // return hasil formmatedRoutes
    return GlobalonPage.decodedMessage;
  }

  Future<LatLng> _getLatLngFromPlaceName(String placeName) async {
    List<Location> locations = await locationFromAddress(placeName);
    if (locations.isNotEmpty) {
      return LatLng(locations.first.latitude, locations.first.longitude);
    } else {
      throw Exception('No location found for the given place name.');
    }
  }

  Future<void> _fetchNearbyTrainStations(double lat, double lng) async {
    String url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json"
        "?location=$lat,$lng"
        "&radius=50000"
        "&type=train_station"
        "&key=$_apiKey";

    final response = await http.get(Uri.parse(url));
    print(response.body);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List results = data['results'];

      _customIcon = await BitmapDescriptor.asset(
        ImageConfiguration(size: Size(48, 48)),
        'assets/train_station_icon.png',
      );

      List<Marker> trainMarkers = results.map((place) {
        return Marker(
          markerId: MarkerId(place['place_id']),
          position: LatLng(
            place['geometry']['location']['lat'],
            place['geometry']['location']['lng'],
          ),
          icon: _customIcon!,
          infoWindow: InfoWindow(
            title: place['name'],
            snippet: place['vicinity'],
          ),
        );
      }).toList();

      if (mounted) {
        setState(() {
          _markers.addAll(trainMarkers);
        });
      }
    }
  }

  Future<void> _getCurrentLocation() async {
    String placeName = '';

    final LocationSettings locationSettings =
        LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 100);

    Position positionUser =
        await Geolocator.getCurrentPosition(locationSettings: locationSettings);

    _currentLocation = LatLng(positionUser.latitude, positionUser.longitude);

    //tunjukin semua stasiun kereta terdekat
    _fetchNearbyTrainStations(positionUser.latitude, positionUser.longitude);

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          positionUser.latitude, positionUser.longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        placeName = "${place.name}";
        _currentLocationName = placeName;
      }
    } catch (e) {
      print("Nama lokasi tidak ditemukan: $e");
    }
  }

  Future<void> _fetchRoute() async {
    String url = "https://maps.googleapis.com/maps/api/directions/json?"
        "origin=${_currentLocation.latitude},${_currentLocation.longitude}&"
        "destination=${_target.latitude},${_target.longitude}&"
        "key=$_apiKey";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['routes'].isNotEmpty) {
        String encodedPolyline =
            data['routes'][0]['overview_polyline']['points'];
        polylineCoordinates = _decodePolyline(encodedPolyline);
        print("Polyline coordinates: $polylineCoordinates");
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
  /// Starts polyline animation by adding points gradually
  void _startAnimation() {
    print("Starting polyline animation...");
    if (polylineCoordinates.isEmpty) {
      print("No polyline coordinates to animate.");
      return;
    }

    _currentIndex = 0; // Initialize the current index

    _timer = Timer.periodic(Duration(milliseconds: 50), (timer) {
      // Increase duration if needed
      if (_currentIndex < polylineCoordinates.length) {
        if (mounted) {
          setState(() {
            _currentRoute.add(polylineCoordinates[_currentIndex]);
            _currentIndex++;
            _updatePolyline();
          });
        }
      } else {
        _timer?.cancel();
      }
    });
  }

  void _adjustCamera() {
    if (mapController == null) return;

    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(
        _currentLocation.latitude < _target.latitude
            ? _currentLocation.latitude
            : _target.latitude,
        _currentLocation.longitude < _target.longitude
            ? _currentLocation.longitude
            : _target.longitude,
      ),
      northeast: LatLng(
        _currentLocation.latitude > _target.latitude
            ? _currentLocation.latitude
            : _target.latitude,
        _currentLocation.longitude > _target.longitude
            ? _currentLocation.longitude
            : _target.longitude,
      ),
    );

    mapController
        .animateCamera(CameraUpdate.newLatLngBounds(bounds, 175)); //padding
  }

  void _getRoute() async {
    PolylinePoints polylinePoints = PolylinePoints();
    if (GlobalonPage.onPage == "detailPage") {
      if (_currentLocationName.isEmpty) {
        print("Error: _currentLocationName is not set.");
        return;
      }

      // Fetch nearby train stations
      try {
        _fetchNearbyTrainStations(
            _currentLocation.latitude, _currentLocation.longitude);
        print("Stasiun terdekat berhasil ditampilkan");
      } catch (e) {
        print("Gagal menampilkan stasiun terdekat: $e");
      }

      // kirim route request
      List<Map<String, dynamic>> formattedRoutes = await requestFormatedRoute();

      List<List<LatLng>> allPolylines = []; // Store multiple polylines

      for (var route in formattedRoutes) {
        List<LatLng> polylineSegment = [];

        for (int i = 0; i < route['coordinates'].length - 1; i++) {
          var start = route['coordinates'][i];
          var end = route['coordinates'][i + 1];

          PolylineResult result =
              await polylinePoints.getRouteBetweenCoordinates(
            googleApiKey: _apiKey,
            request: PolylineRequest(
              origin: PointLatLng(start.latitude, start.longitude),
              destination: PointLatLng(end.latitude, end.longitude),
              mode: TravelMode.transit, // Change mode if needed
            ),
          );

          if (result.points.isNotEmpty) {
            for (var point in result.points) {
              polylineSegment.add(LatLng(point.latitude, point.longitude));
            }
          } else {
            print("Error fetching polyline: ${result.errorMessage}");
          }
        }

        allPolylines.add(polylineSegment);
      }

      // Clear previous polylines
      polylineCoordinates.clear();

      // Merge all segments into one polyline for display
      for (var segment in allPolylines) {
        polylineCoordinates.addAll(segment);
      }

      if (polylineCoordinates.isNotEmpty) {
        print("Polyline coordinates: $polylineCoordinates");
        _startAnimation(); // Start animating the polyline
      } else {
        print("No polyline coordinates to animate.");
      }
    }
  }

  void _updatePolyline() {
    print("Updating polyline...");
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
      if (GlobalonPage.onPage == "detailPage") {
        _adjustCamera();
      } else {
        print("");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isTargetInitialized) {
      return Center(child: CircularProgressIndicator());
    }

    return GoogleMap(
      onMapCreated: _onMapCreated,
      polylines: _polylines,
      initialCameraPosition: CameraPosition(
        target: _currentLocation,
        zoom: 11.0,
      ),
      markers: {
        if (GlobalonPage.onPage == "detailPage")
          Marker(
            markerId: MarkerId('Your Location'),
            icon: BitmapDescriptor.defaultMarker,
            position: _currentLocation,
          ),
        if (GlobalonPage.onPage == "detailPage")
          Marker(
            markerId: MarkerId('Your Destination'),
            icon: BitmapDescriptor.defaultMarker,
            position: _target,
          ),
        if (GlobalonPage.onPage == "RutePage2" && _customIcon != null)
          Marker(
            markerId: MarkerId('Custom Icon'),
            icon: _customIcon!,
            position: _target,
          ),
        ..._markers
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
