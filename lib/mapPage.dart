import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
import 'routePage.dart';
import 'RoutePage2.dart';

class MapPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Peta
          Positioned.fill(
            child: Image.asset(
              'assets/GAMBARSAKRAL.png', // Placeholder untuk OpenStreetMap
              fit: BoxFit.cover,
            ),
          ),

          // Tombol Back
          Positioned(
            top: 400,
            left: 18,
            width: 61,
            height: 61,
            child: FloatingActionButton(
              mini: true,
              backgroundColor: Colors.white,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => RoutePage()));
              },
              child: Image.asset(
                'assets/iconspng/backMapPage.png', // Sesuaikan dengan path file PNG
                width: 21,
                height: 19,
              ),
              shape: CircleBorder(),
              elevation: 4,
            ),
          ),

          // Tombol GPS
          Positioned(
            top: 400,
            right: 18,
            width: 61,
            height: 61,
            child: FloatingActionButton(
              mini: true,
              backgroundColor: Colors.white,
              onPressed: () {},
              child: Image.asset(
                'assets/iconspng/navIconMapPage.png',
                width: 27,
                height: 27,
              ),
              shape: const CircleBorder(),
              elevation: 4,
            ),
          ),

          // Informasi Lokasi
          Positioned(
            // top: 400,
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              width: 412,
              height: 330,
              padding: const EdgeInsets.all(40),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(45),
                  topRight: Radius.circular(45),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Current Location",
                    style: TextStyle(
                      color: Color(0xFFF28A33),
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    child: _CurrentLocationTitle("Rumah Talenta BCA"),
                  ),
                  const SizedBox(height: 2),
                  _currDescription(
                      "Jl. Pakuan No.3, Sumur Batu, Kec. Babakan Madang, Kabupaten Bogor, Jawa Barat 16810"),
                  const SizedBox(height: 10),
                  const Divider(),
                  const SizedBox(height: 3),
                  const Text(
                    "Nearest public transportation",
                    style: TextStyle(fontSize: 12, color: Colors.black),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 348,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RutePage2(
                                      lokasiTujuan: 'Input your destination',
                                      namaLokasi: 'Rumah Talenta BCA',
                                    )));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff225477),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        // shadowColor: Colors.black.withOpacity(0.2),
                        // elevation: 4,
                      ),
                      child: const Text(
                        "Next",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _CurrentLocationTitle(String currLocation) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          currLocation,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            foregroundColor: Color(0xFFF28A33),
            backgroundColor: Colors.white,
            side: const BorderSide(color: Color(0xFFF28A33)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            shadowColor: Colors.black.withOpacity(0.2),
            elevation: 2,
          ),
          child: const Text("edit"),
        ),
      ],
    );
  }

  Widget _currDescription(String desc) {
    return Container(
      width: 251,
      child: Text(
        desc,
        style: TextStyle(fontSize: 12, color: Colors.black),
        maxLines: 3,
      ),
    );
  }
}
