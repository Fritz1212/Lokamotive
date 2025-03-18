import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart' as latlng;
import 'package:location/location.dart' as location;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

class GlobalonPage {
  static String onPage = '';
}

class WebSocketService {
  final String serverUrl =
      "ws://192.168.115.24:3000"; // Change to your actual server URL
  late WebSocketChannel channel;
  Function(dynamic)? onMessageReceived;

  void connect() {
    channel = WebSocketChannel.connect(Uri.parse(serverUrl));
    channel.stream.listen((message) {
      print("Received: $message");
      if (onMessageReceived != null) {
        onMessageReceived!(jsonDecode(message));
      }
    }, onDone: () {
      print("WebSocket closed.");
    }, onError: (error) {
      print("WebSocket error: $error");
    });
  }

  void sendGetRecommendedRoutes(String userId, String start, String destination,
      {String? preference}) {
    final data = {
      "action": "getRecommendedRoutes",
      "userId": userId,
      "start": start,
      "destination": destination,
      "preference": preference ?? "default"
    };

    channel.sink.add(jsonEncode(data));
  }

  // void disconnect() {
  //   channel.sink.close(status.normalClosure);
  // }
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
  List<dynamic> routes = [];

  late LatLng _center = LatLng(-6.585267761752595, 106.88177004571635);
  late LatLng _target;
  final String _apiKey = "AIzaSyDCQcVU2E2VKsb2cn-FYiE1Jry0IHsSe2o";

  LatLng? _currentLocation;
  String _currentLocationName = '';
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
    wsService.onMessageReceived = (data) {
      setState(() {
        if (data["routes"] != null) {
          routes = data["routes"];
        }
      });
    };
  }

  @override
  void dispose() {
    // wsService.disconnect();
    super.dispose();
  }

  Future<List<Map<String, dynamic>>> getRoutes() async {
    wsService.sendGetRecommendedRoutes(
        "user123", _currentLocationName, widget.target,
        preference: "fastest");

    // Wait for the routes to be received
    await Future.delayed(Duration(seconds: 2));

    // Assuming routes are received and stored in the `routes` variable
    return routes.map((route) {
      return {
        'coordinates': route['coordinates'].map((coord) {
          return LatLng(coord['lat'], coord['lng']);
        }).toList()
      };
    }).toList();
  }

  Future<void> _initializeTarget() async {
    print("Entering _initializeTarget function");
    try {
      _target = await _getLatLngFromPlaceName(widget.target);
      setState(() {
        _isTargetInitialized = true;
      });

      setState(
        () async {
          await _getCurrentLocation(); // Call _getCurrentLocation after initializing the target
          _getRoute();
        },
      );
    } catch (e) {
      print('Error: $e');
    }
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

      _customIcon = await BitmapDescriptor.fromAssetImage(
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
    LocationPermission permission = await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    String placeName = '';

    _fetchNearbyTrainStations(position.latitude, position.longitude);

    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        placeName = "${place.name}, ${place.locality}, ${place.country}";
        _currentLocationName = placeName;
      }
    } catch (e) {
      print("Error getting place name: $e");
    }

    if (mounted) {
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);

        print("Current location: $_currentLocationName");
      });
    }
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
    print("tempat : $_currentLocationName");
    if (GlobalonPage.onPage == "detailPage") {
      if (_currentLocationName == null || _currentLocationName.isEmpty) {
        print("Error: _currentLocationName is not set.");
        return;
      }

      // Fetch nearby train stations
      _fetchNearbyTrainStations(_center.latitude, _center.longitude);

      print("masuk sini");

      // Send route request and get formatted routes
      List<Map<String, dynamic>> formattedRoutes = await getRoutes();

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
        target: _center,
        zoom: 11.0,
      ),
      markers: {
        if (GlobalonPage.onPage == "detailPage")
          Marker(
            markerId: MarkerId('Your Location'),
            icon: BitmapDescriptor.defaultMarker,
            position: _center,
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
