import 'package:flutter/material.dart';
import 'RoutePage2.dart';

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

  @override
  _ExpandableCardUwiState createState() => _ExpandableCardUwiState();
}

class _ExpandableCardUwiState extends State<ExpandableCardUwi> {
  bool _isExpanded = false;

  bool get _hasPintuMasuk =>
      widget.pintuMasuk1 != null || widget.pintuMasuk2 != null;

  void _onCardTap() {
    if (_hasPintuMasuk) {
      setState(() {
        _isExpanded = !_isExpanded;
      });
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RutePage2(
              namaLokasi: 'Rumah Talenta BCA', lokasiTujuan: widget.nama),
        ),
      );
    }
  }

  void _navigateToNextPage(String pintuMasuk) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RutePage2(
          namaLokasi: 'Rumah Talenta BCA',
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
              height: 65,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Color(0xFFEAEAEA),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  Icon(Icons.history, color: Colors.black),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.nama,
                        style: TextStyle(fontSize: 15, color: Colors.black),
                      ),
                      Text(
                        widget.alamat,
                        style: TextStyle(fontSize: 10, color: Colors.black),
                      ),
                    ],
                  )
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
