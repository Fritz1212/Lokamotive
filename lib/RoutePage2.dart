import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lokamotive/detailPage.dart';
// import 'package:http/http.dart' as http;
import 'package:lokamotive/main.dart';
import 'package:lokamotive/mapPage.dart';
import 'routePage.dart';
import 'detailPage.dart';

class RutePage2 extends StatelessWidget {
  final String lokasiTujuan;
  final String namaLokasi;

  const RutePage2({
    Key? key,
    required this.lokasiTujuan,
    required this.namaLokasi,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 320 / 917 * screenHeight,
                decoration: BoxDecoration(
                  color: Color(0xFF225477),
                ),
              ),
              Positioned(
                top: 20 / 917 * screenHeight,
                left: 10 / 412 * screenWidth,
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white, size: 20),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RoutePage()),
                    );
                  },
                ),
              ),
              Positioned(
                top: 69 / 917 * screenHeight,
                left: 20 / 412 * screenWidth,
                right: 20 / 412 * screenWidth,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) =>
                              MapPage(), // Ganti dengan halaman tujuan
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Container(
                          height: 133 / 917 * screenHeight,
                          width: 341 / 412 * screenWidth,
                          color: Colors.white,
                          child: Center(child: Text("Map Placeholder")),
                        ),
                      ),
                    ),

                    SizedBox(height: 17 / 917 * screenHeight),
                    _buildLocationInput(),
                    // _buildTextField(Icons.location_on, "Rumah Talenta BCA"),
                    // SizedBox(height: 10),
                    // _buildTextField(Icons.place, "Indonesia Arena"),
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildCategoryHeader("All Routes"),
                  SizedBox(height: 8 / 917 * screenHeight),
                  ElevatedButton(
                    child: _buildRouteItem(
                        "150", "Bogor", "Karet", "30", "10000", false, false),
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => detailPage()));
                    },
                  ),
                  _buildRouteItem("200", "Bogor", "Tanah Abang 2", "30",
                      "12000", false, false),
                  _buildRouteItem(
                      "235", "Bogor", "Palmerah", "30", "12000", false, true),
                  _buildCategoryHeader("KRL Only"),
                  SizedBox(height: 8 / 917 * screenHeight),
                  _buildRouteItem(
                      "130", "Bogor", "Manggarai", "12", "12000", true, false),
                  _buildRouteItem(
                      "180", "Bogor", "Citayam", "12", "12000", true, false),
                  _buildRouteItem(
                      "250", "Bogor", "Nambo", "12", "12000", true, true),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLocationField(
          icon: Icons.location_on,
          iconColor: Colors.white,
          hintText: namaLokasi,
        ),
        SizedBox(height: 1), // Spacer kecil
        Padding(
          padding: const EdgeInsets.only(left: 18),
          child: Column(
            children: List.generate(
                1,
                (index) =>
                    Icon(Icons.more_vert, color: Colors.white, size: 14)),
          ),
        ),
        SizedBox(height: 1), // Spacer kecil
        _buildLocationField(
          icon: Icons.location_on,
          iconColor: Color(0xFFFBBD8A),
          hintText: lokasiTujuan,
        ),
      ],
    );
  }

  /// Field Input Lokasi
  Widget _buildLocationField(
      {required IconData icon,
      required Color iconColor,
      required String hintText}) {
    return Center(
      // Pastikan Row tidak melebar ke samping
      child: Row(
        mainAxisSize: MainAxisSize.min, // Jangan buat Row penuh
        children: [
          Icon(icon, color: iconColor, size: 28),
          SizedBox(width: 15),
          SizedBox(
            width: 281.14,
            height: 32.48,
            child: TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(7),
                  borderSide: BorderSide.none, // Hapus border luar
                ),
                hintText: hintText,
                hintStyle:
                    TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryHeader(String title) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      color: Colors.grey.shade300,
      child: Text(
        title,
        style: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 16,
            color: Colors.black.withOpacity(0.5)),
      ),
    );
  }

  Widget _buildRouteItem(String duration, String start, String end,
      String leaveTime, String price, bool isKRLOnly, bool isLastItem) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 35, vertical: 12),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 0),
                // color: Colors.red,
                width: 70,
                child: Column(
                  children: [
                    Text(duration,
                        style: TextStyle(
                            height: 0.8,
                            fontWeight: FontWeight.bold,
                            fontSize: 30)),
                    Text("min", style: TextStyle(height: 1.5, fontSize: 12)),
                  ],
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          'assets/iconspng/krlIcon.png',
                          width: 20,
                          height: 24,
                        ),
                        SizedBox(width: 5),
                        Text(start, style: TextStyle(fontSize: 13)),
                        SizedBox(width: 10),
                        Icon(Icons.arrow_forward, size: 20),
                        SizedBox(width: 5),
                        Image.asset(
                          'assets/iconspng/${isKRLOnly ? 'krlIcon.png' : 'tjIcon.png'}',
                          width: 20,
                          height: 24,
                        ),
                        SizedBox(width: 5),
                        Text(end, style: TextStyle(fontSize: 13)),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        _buildLeaveTime(leaveTime),
                        Spacer(),
                        Text("Est price: Rp $price",
                            style: TextStyle(fontSize: 10)),
                      ],
                    ),
                    if (!isLastItem) SizedBox(height: 5),
                    if (!isLastItem)
                      Divider(
                          thickness: 1, color: Colors.black.withOpacity(0.2)),
                    if (isLastItem) SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLeaveTime(String minutes) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: "Leaves in ",
            style: TextStyle(color: Colors.black, fontSize: 10),
          ),
          TextSpan(
            text: "$minutes min",
            style: TextStyle(
                color: Color(0XFFF28A33),
                fontSize: 10,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
