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
      'ws://172.20.10.2:3000'; // Change to your actual server URL
  late WebSocketChannel channel;
  Function(dynamic)? onMessageReceived;

  Completer<List<Map<String, dynamic>>>? routeCompleter;

  //3. Ambil pake ni function
  void connect() {
    channel = WebSocketChannel.connect(Uri.parse(serverUrl));

    channel.stream.listen((message) {
      print("📩 Received: $message");

      dynamic decoded;

      try {
        decoded = jsonDecode(message);
      } catch (e) {
        print("❌ Failed to decode message: $e");
        routeCompleter?.completeError(Exception("Invalid JSON"));
        return;
      }

      print("🔍 Decoded: (${decoded.runtimeType})");

      if (decoded is List) {
        try {
          final routes = decoded.cast<Map<String, dynamic>>();
          if (routeCompleter != null && !routeCompleter!.isCompleted) {
            routeCompleter!.complete(routes);
            print("✅ Route completer completed with: $routes");
          }
        } catch (e) {
          print("❌ Error casting list elements: $e");
          routeCompleter
              ?.completeError(Exception("Casting to List<Map> failed"));
        }
      } else if (decoded is Map && decoded['status'] == 'error') {
        // Server returned an error message
        print("❌ Server error: ${decoded['message']}");
        return;
      } else {
        print("⚠️ Unexpected response type: ${decoded.runtimeType}");
        routeCompleter?.completeError(Exception("Unexpected response format"));
      }

      // Clean up
      routeCompleter = null;

      // Forward to message handler if defined
      if (onMessageReceived != null) {
        try {
          GlobalonPage.decodedMessage = onMessageReceived!(decoded);
        } catch (e) {
          print("❌ Error in onMessageReceived: $e");
        }
      }
    });
  }

  //2. format pengirim request ke server (action udah getRecommendedRoutes)
  void sendGetRecommendedRoutes(
      String userId,
      String? start,
      String destination,
      double _currentLocationLat,
      double _currentLocationLang,
      double _targetLat,
      double _targetLang,
      {String? preference}) {
    final data = {
      "action": "getRecommendedRoutes",
      "userId": userId,
      "start": start,
      "destination": destination,
      "startLat": _currentLocationLat,
      "startLng": _currentLocationLang,
      "destinationLat": _targetLat,
      "destinationLng": _targetLang,
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
  final String _apiKey = "AIzaSyDAgMexUNwu84Kd5IqC-Kg97ZX7dsACV18";
  List<dynamic> routes = [];

  LatLng? _currentLocation = LatLng(-6.2088, 106.8456);
  late LatLng _target;
  String? _currentLocationName;

  Set<Marker> _markers = {};
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

    if (GlobalonPage.onPage == "detailPage") {
      _init();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _init() async {
    await _initializeTarget();
    await _getCurrentLocation();
    await _getRoute();
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
    if (_currentLocation == null) {
      throw Exception("Current location not set.");
    }

    wsService.routeCompleter = Completer<List<Map<String, dynamic>>>();

    wsService.sendGetRecommendedRoutes(
      "user123",
      _currentLocationName,
      widget.target,
      _currentLocation!.latitude,
      _currentLocation!.longitude,
      _target.latitude,
      _target.longitude,
      preference: "jalan kaki",
    );

    print("🚀 Sent route request, waiting.....");

    return wsService.routeCompleter!.future.timeout(
      Duration(seconds: 20),
      onTimeout: () {
        print("⏰ Timeout waiting for route data");
        throw Exception("Timeout waiting for route");
      },
    );
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
        ImageConfiguration(size: Size(10, 10)),
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
    if (_currentLocation == null || _target == null) {
      print("Error: Location data not ready.");
      return;
    }

    String url = "https://maps.googleapis.com/maps/api/directions/json?"
        "origin=${_currentLocation!.latitude},${_currentLocation!.longitude}&"
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
        _currentLocation!.latitude < _target.latitude
            ? _currentLocation!.latitude
            : _target.latitude,
        _currentLocation!.longitude < _target.longitude
            ? _currentLocation!.longitude
            : _target.longitude,
      ),
      northeast: LatLng(
        _currentLocation!.latitude > _target.latitude
            ? _currentLocation!.latitude
            : _target.latitude,
        _currentLocation!.longitude > _target.longitude
            ? _currentLocation!.longitude
            : _target.longitude,
      ),
    );

    mapController
        .animateCamera(CameraUpdate.newLatLngBounds(bounds, 175)); //padding
  }

  Future<void> _getRoute() async {
    try {
      print("plis lah ampe sini ${GlobalonPage.onPage}");

      final sanitizedRaw = await requestFormatedRoute()
          .timeout(Duration(seconds: 30), onTimeout: () {
        print("⏰ Timeout waiting for route response!");
        throw Exception("Route request timed out.");
      });

      if (sanitizedRaw is! List) {
        print("❌ ERROR: Expected List but got ${sanitizedRaw.runtimeType}");
        return;
      }

      final List<dynamic> sanitized = sanitizedRaw;
      Set<Marker> newMarkers = {};
      List<Polyline> newPolylines = [];
      int polylineIdCounter = 1;

      TravelMode _mapMode(String mode) {
        switch (mode.toLowerCase()) {
          case 'walking':
          case 'jalan kaki':
            return TravelMode.walking;
          case 'mrt':
          case 'lrt':
          case 'transjakarta':
            return TravelMode.transit;
          default:
            return TravelMode.driving;
        }
      }

      final Map<String, Color> modeColors = {
        'walking': Colors.green,
        'jalan kaki': Colors.green,
        'mrt': Colors.blue,
        'lrt': Colors.purple,
        'transjakarta': Colors.orange,
      };

      for (var route in sanitized) {
        if (route is! Map || route['route'] is! Map) {
          print("❌ Skipping invalid route: $route");
          continue;
        }

        var path = (route['route']?['path']);
        var segments = (route['route']?['segments']);

        if (path is! List || segments is! List) {
          print(
              "⚠️ Skipping: path/segments malformed: path=${path.runtimeType}, segments=${segments.runtimeType}");
          continue;
        }

        if (path.length < 2) continue;

        int segmentCount = segments.length;
        int chunkSize = (path.length / (segmentCount + 1)).floor();

        for (int i = 0; i <= segmentCount; i++) {
          int startIdx = i * chunkSize;
          int endIdx = ((i + 1) * chunkSize < path.length)
              ? (i + 1) * chunkSize
              : path.length - 1;

          if (startIdx >= path.length || endIdx >= path.length) {
            print(
                "⚠️ Skipping segment $i: startIdx=$startIdx, endIdx=$endIdx, path.length=${path.length}");
            continue;
          }

          var start = path[startIdx];
          var end = path[endIdx];

          if (start is! Map ||
              end is! Map ||
              !start.containsKey('lat') ||
              !start.containsKey('lang') ||
              !end.containsKey('lat') ||
              !end.containsKey('lang')) {
            print("❌ Invalid path points at index $startIdx and $endIdx");
            continue;
          }

          for (int i = 0; i < path.length; i++) {
            final point = path[i];
            if (i + 1 == path.length) {
              newMarkers.add(
                Marker(
                  markerId: MarkerId('point_$i'),
                  position: LatLng(point['lat'], point['lang']),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueAzure),
                ),
              );
            }
            newMarkers.add(
              Marker(
                markerId: MarkerId('point_$i'),
                position: LatLng(point['lat'], point['lang']),
                icon: BitmapDescriptor.defaultMarker,
                infoWindow: InfoWindow(title: 'Point $i'),
              ),
            );
          }

          String mode = 'driving';
          if (i < segments.length) {
            var segment = segments[i];
            if (segment is Map && segment['mode'] != null) {
              mode = segment['mode'].toString().toLowerCase();
            }
          }

          var result = await PolylinePoints().getRouteBetweenCoordinates(
            googleApiKey: _apiKey,
            request: PolylineRequest(
              origin: PointLatLng(start['lat'], start['lang']),
              destination: PointLatLng(end['lat'], end['lang']),
              mode: _mapMode(mode),
            ),
          );

          if (result.points.isNotEmpty) {
            List<LatLng> polylineSegment = result.points
                .map((point) => LatLng(point.latitude, point.longitude))
                .toList();

            newPolylines.add(
              Polyline(
                polylineId: PolylineId('polyline_$polylineIdCounter'),
                color: modeColors[mode] ?? Colors.grey,
                width: 5,
                points: polylineSegment,
              ),
            );
            polylineIdCounter++;
          } else {
            print(
                "⚠️ Polyline API failed for $mode segment: ${result.errorMessage}");
          }
        }
      }

      setState(() {
        _polylines = Set<Polyline>.from(newPolylines);
        _markers.addAll(newMarkers);
      });
    } catch (e, stack) {
      print('💥 EXCEPTION: $e');
      print('📍 STACK TRACE:\n$stack');
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
        target: _currentLocation!,
        zoom: 11.0,
      ),
      markers: {
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
