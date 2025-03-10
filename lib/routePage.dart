import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dashboard_page.dart';
import 'expendaleCard.dart';
import 'mapPage.dart';

class RoutePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: Colors.white,
        // appBar: AppBar(
        //   backgroundColor: Colors.white,
        //   leading: Icon(CupertinoIcons.home),
        //   title: Text("LokaMotive"),
        // ),

        body: Container(
          height: double.infinity,
          child: Column(
            children: [
              SizedBox(
                height: 385 / 917 * screenHeight,
                child: Stack(
                  clipBehavior: Clip.none, // mencegah widget biar ga kepotong
                  children: [
                    // Center(
                    //   child: ElevatedButton(
                    //     onPressed: () {
                    //       Navigator.pushNamed(context, '/second');
                    //     },
                    //     child: Text("Go to Second Page"),
                    //   ),
                    // ),
                    Container(
                      width: 413 / 412 * screenWidth,
                      height: 364 / 917 * screenHeight,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(60),
                          bottomRight: Radius.circular(60),
                          topLeft: Radius.zero,
                          topRight: Radius.zero,
                        ),
                        image: DecorationImage(
                          image: AssetImage('assets/test.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    Positioned(
                      top: 39 / 917 * screenHeight,
                      left: 27 / 412 * screenWidth,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Color(0xFF102E48),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: Image.asset('assets/iconspng/backRutePage.png',
                              width: 21, height: 19),
                          // const Icon(Icons.arrow_back, color: Colors.white, size: 30),
                          onPressed: () {
                            // Kembali ke halaman sebelumnya
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DashboardPage(
                                    email: GlobalData.email,
                                    userName: GlobalData.userName,
                                    onNameChanged: (newName) {
                                      print("iya nama keganti");
                                    }),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    Positioned(
                      top: 206.4 / 917 * screenHeight,
                      left: 30 / 412 * screenWidth,
                      child: Container(
                        width: 351 / 412 * screenWidth,
                        height: 217 / 917 * screenHeight,
                        padding: const EdgeInsets.all(18),
                        decoration: const BoxDecoration(
                          color: Color(0xFF225477),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                        ),

                        // BUAT INTERACTIVE MAP (BISA DIPENCET) & BUAT SEARCH BAR
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
                              child: Container(
                                width: 287 / 412 * screenWidth,
                                height: 122 / 917 * screenHeight,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                            ),

                            // const SizedBox(height: 16),
                            Container(
                              margin:
                                  EdgeInsets.only(top: 16 / 917 * screenHeight),
                              width: 287 / 412 * screenWidth,
                              height: 38 / 917 * screenHeight,
                              child: TextField(
                                style: TextStyle(color: Colors.black),
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  hintText: "Search Location",
                                  hintStyle: TextStyle(
                                    color: Colors.black.withOpacity(0.7),
                                    fontSize: 13,
                                  ),
                                  prefixIcon: Padding(
                                    padding: EdgeInsets.all(0),
                                    child: Image.asset(
                                      'assets/iconspng/locationIconRutePage.png',
                                      width: 27,
                                      height: 27,
                                    ),
                                  ),
                                  suffixIcon: Padding(
                                    padding: EdgeInsets.all(0),
                                    child: Image.asset(
                                      'assets/iconspng/searchIconRutePage.png',
                                      width: 27,
                                      height: 27,
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 351 / 412 * screenWidth,
                height: 380 / 917 * screenHeight,
                decoration: const BoxDecoration(
                    color: Color(0xFF225477),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    )),
                margin: EdgeInsets.only(top: 70 / 917 * screenHeight),
                padding: EdgeInsets.only(top: 20 / 917 * screenHeight),
                child: SingleChildScrollView(
                    child: Column(children: [
                  ExpandableCardUwi(
                    nama: "Rumah Pak BUDI",
                    alamat: "Jl Pakuan No.3",
                    pintuMasuk1: "Gerbang Masuk",
                    pintuMasuk2: "Lobby Utama",
                  ),
                  SizedBox(height: 10 / 917 * screenHeight),
                  ExpandableCardUwi(
                      nama: "Rumah Pak Yoga", alamat: "Jl Sawi No.3"),
                  SizedBox(height: 10 / 917 * screenHeight),
                  ExpandableCardUwi(
                      nama: "Rumah Pak Tofer", alamat: "Jl Paku No.3"),
                  SizedBox(height: 10 / 917 * screenHeight),
                  ExpandableCardUwi(
                      nama: "Rumah Pak Iyan", alamat: "Jl Palu No.3"),
                  SizedBox(height: 10 / 917 * screenHeight),
                  ExpandableCardUwi(
                      nama: "Rumah Pak Yoga", alamat: "Jl Sawi No.3"),
                  SizedBox(height: 10 / 917 * screenHeight),
                ])),
              )
            ],
          ),
        ));
  }
}
