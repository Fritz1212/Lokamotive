import 'package:flutter/material.dart';
import 'RoutePage2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class ExpandableCardUwi extends StatefulWidget {
  final String nama;
  final String alamat;
  final String? pintuMasuk1;
  final String? pintuMasuk2;

  const ExpandableCardUwi({
    Key? key,
    required this.nama,
    required this.alamat,
    this.pintuMasuk1,
    this.pintuMasuk2,
  }) : super(key: key);

  Future<Position> getCurrentLocation() {
    return Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(accuracy: LocationAccuracy.best));
  }

  Future<String> getPlaceName(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        return "${place.name}";
      } else {
        return "No place found";
      }
    } catch (e) {
      return "Error: $e";
    }
  }

  @override
  _ExpandableCardUwiState createState() => _ExpandableCardUwiState();
}

class _ExpandableCardUwiState extends State<ExpandableCardUwi> {
  bool _isExpanded = false;
  bool get _hasPintuMasuk =>
      widget.pintuMasuk1 != null || widget.pintuMasuk2 != null;

  void _onCardTap() async {
    Position posisi = await widget.getCurrentLocation();
    String namaTempat =
        await widget.getPlaceName(posisi.latitude, posisi.longitude);
    if (_hasPintuMasuk) {
      setState(() {
        _isExpanded = !_isExpanded;
      });
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              RutePage2(namaLokasi: namaTempat, lokasiTujuan: widget.nama),
        ),
      );
    }
  }

  void _navigateToNextPage(String pintuMasuk) async {
    Position posisi = await widget.getCurrentLocation();
    String namaTempat =
        await widget.getPlaceName(posisi.latitude, posisi.longitude);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RutePage2(
          namaLokasi: namaTempat,
          lokasiTujuan: widget.nama,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onCardTap,
      child: Card(
        color: Color(0xFFEAEAEA),
        child: Column(
          children: [
            // Bagian utama yang bisa diklik
            Container(
              width: 287,
              height: 80,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Color(0xFFEAEAEA),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  Icon(Icons.history, color: Colors.black),
                  SizedBox(width: 10),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.nama,
                        style: TextStyle(fontSize: 15, color: Colors.black),
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        widget.alamat,
                        style: TextStyle(fontSize: 10, color: Colors.black),
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  )),
                ],
              ),
            ),

            // Bagian expandable (hanya muncul jika ada pintu masuk)
            if (_hasPintuMasuk)
              AnimatedContainer(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                width: 287,
                duration: Duration(milliseconds: 600),
                curve: Curves.easeOut,
                height: _isExpanded ? _getExpandedHeight() : 0,
                child: SingleChildScrollView(
                  physics: NeverScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(color: Colors.black),
                      Padding(
                        padding: EdgeInsets.only(left: 30),
                        child: Column(
                          children: [
                            if (widget.pintuMasuk1 != null) ...[
                              GestureDetector(
                                onTap: () =>
                                    _navigateToNextPage(widget.pintuMasuk1!),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(widget.pintuMasuk1!),
                                    Icon(Icons.bookmark, size: 20),
                                  ],
                                ),
                              ),
                              Divider(color: Colors.black),
                            ],
                            if (widget.pintuMasuk2 != null)
                              GestureDetector(
                                onTap: () =>
                                    _navigateToNextPage(widget.pintuMasuk2!),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(widget.pintuMasuk2!),
                                    Icon(Icons.bookmark, size: 20),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }

  /// Menghitung tinggi `AnimatedContainer` agar pas jika hanya satu pintu masuk
  double _getExpandedHeight() {
    int count = 0;
    if (widget.pintuMasuk1 != null) count++;
    if (widget.pintuMasuk2 != null) count++;
    return count * 40.0 + 20; // Setiap pintu sekitar 40, divider 20
  }
}
