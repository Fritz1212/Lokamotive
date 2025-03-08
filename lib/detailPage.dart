import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:lokamotive/RoutePage2.dart';
import 'endPage.dart';
import 'google_map.dart';

class detailPage extends StatelessWidget {
  const detailPage({super.key});

  Widget _buildStationRow(String station, String time, String price) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(Icons.directions_bus, size: 30, color: Colors.black54),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(station,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Row(
                children: [
                  Text(time, style: TextStyle(color: Colors.black54)),
                  SizedBox(width: 20),
                  Text(price, style: TextStyle(color: Colors.black54)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
          child: Stack(
        children: [
          Container(child: GoogleMapWidget()),
          Container(
            margin: EdgeInsets.only(top: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 350,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.all(8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset("assets/Image/Group 63.png",
                                width: 50, height: 30),
                            Image.asset("assets/Image/Ellipse 40.png",
                                width: 5, height: 5),
                            Image.asset("assets/Image/Ellipse 40.png",
                                width: 5, height: 5),
                            Image.asset("assets/Image/Ellipse 40.png",
                                width: 5, height: 5),
                            Image.asset("assets/Image/mdi_location.png",
                                width: 50, height: 30),
                          ],
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 250,
                            height: 30,
                            color: Colors.white,
                            child: Row(
                              children: [
                                Text(
                                  "Rumah Talenta BCA",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 250,
                                child: Divider(
                                  color: Colors.black,
                                  height: 10,
                                  thickness: 1,
                                ),
                              )
                            ],
                          ),
                          Container(
                            width: 250,
                            height: 30,
                            color: Colors.white,
                            child: Row(
                              children: [
                                Text(
                                  "Indonesia Arena",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Positioned(
            top: 420,
            left: 20,
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RutePage2(
                              lokasiTujuan: "Rumah Talenta BCA",
                              namaLokasi: "Indonesia Arena")));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: CircleBorder(),
                ),
                child: Icon(Icons.arrow_back, color: Colors.black),
              ),
            ),
          ),

          Positioned.fill(
              child: Align(
            alignment: Alignment.bottomCenter,
            child: DraggableScrollableSheet(
              initialChildSize: 0.3, // Start at 30% of screen height
              minChildSize: 0.2, // Minimum height when collapsed
              maxChildSize: 0.8, // Maximum height when expanded
              builder: (context, scrollController) {
                return Container(
                  constraints: BoxConstraints.expand(),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(48)),
                    boxShadow: [
                      BoxShadow(color: Colors.black26, blurRadius: 10),
                    ], // End of BoxShadow
                  ), // End of BoxDecoration
                  padding: EdgeInsets.all(16),
                  child: SingleChildScrollView(
                    controller: scrollController, // Enables scrolling
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: 100,
                          height: 2,
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(10),
                          ), // End of BoxDecoration
                        ), // End of Container

                        SizedBox(height: 35),

                        Container(
                          padding: EdgeInsets.all(20),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      width: 300,
                                      color: Colors.transparent,
                                      child: Text(
                                        "2h 30min (Rp 10.000,00)",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.orange,
                                        ), // End of TextStyle
                                      ),
                                    ),
                                    Container(
                                      color: Colors.transparent,
                                      width: 300,
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            _buildStationRow(
                                                "KRL Station, Bogor",
                                                "09:00",
                                                "Rp 6.500,00"),
                                          ]),
                                    ),
                                    Container(
                                      color: Colors.transparent,
                                      width: 300,
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            _buildStationRow(
                                                "KRL Station, Manggarai",
                                                "09:15",
                                                "Rp 6.500,00"), // End of Text
                                          ]),
                                    )
                                  ],
                                ),
                              ]),
                        ),

                        SingleChildScrollView(
                          controller: scrollController,
                        ),

                        SizedBox(height: 20),
                      ], // End of Column children
                    ), // End of Column
                  ), // End of SingleChildScrollView
                ); // End of Container
              }, // End of builder
            ), // End of DraggableScrollableSheet
          )),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Column(mainAxisAlignment: MainAxisAlignment.end, children: [
              Container(
                margin: EdgeInsets.only(bottom: 20),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => endPage()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 34, 84, 119),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ), // End of RoundedRectangleBorder
                    minimumSize: Size(350, 60),
                  ), // End of ElevatedButton.styleFrom
                  child: Text("Done",
                      style: TextStyle(fontSize: 20, color: Colors.white)),
                ), // End of ElevatedButton
              ),
            ]),
          ]),

          // End of Positioned
        ],
      )),
    );
  }
}
