import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dashboard_page.dart';
import 'expendaleCard.dart';
import 'mapPage.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class RoutePage extends StatefulWidget {
  RoutePage({super.key});

  @override
  State<RoutePage> createState() => RoutePageState();
}

class RoutePageState extends State<RoutePage> {
  final TextEditingController _controller = TextEditingController();
  var _channel = WebSocketChannel.connect(Uri.parse('ws://172.20.10.2:3000'));
  List<dynamic> suggestions = [];

  @override
  void initState() {
    super.initState();
    String ip = dotenv.get('IP_ADDRESS');
    if (ip != null) {
      _channel = WebSocketChannel.connect(Uri.parse('ws://$ip:3000'));
    }
    _channel.stream.listen((message) {
      final Map<String, dynamic> data = jsonDecode(message);
      print("${message}");

      if (data["status"] == "success") {
        List results = data["results"];
        print("Parsed results: $results"); // Debugging

        // Update suggestions and trigger a UI rebuild
        setState(() {
          suggestions.addAll(results);
        });
      } else {
        print("Error: ${data["message"]}");
      }
    });
  }

  void search(String query) {
    setState(() {
      suggestions.clear();
      final message =
          jsonEncode({"action": "search", "query": _controller.text});
      print("Sending WebSocket message: $message"); // Debugging
      _channel.sink.add(message);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: Container(
          height: double.infinity,
          child: Column(
            children: [
              SizedBox(
                height: 385 / 917 * screenHeight,
                child: Stack(
                  clipBehavior: Clip.none, // mencegah widget biar ga kepotong
                  children: [
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
                                child: GestureDetector(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) => MapPage());
                                  },
                                  child: Container(
                                    width: 287 / 412 * screenWidth,
                                    height: 122 / 917 * screenHeight,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                )),
                            Container(
                              margin:
                                  EdgeInsets.only(top: 16 / 917 * screenHeight),
                              width: 287 / 412 * screenWidth,
                              height: 38 / 917 * screenHeight,
                              child: TextField(
                                controller: _controller,
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
                                  suffixIcon: IconButton(
                                    icon: Icon(Icons.search),
                                    onPressed: () {
                                      search(_controller.text);
                                    },
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                onSubmitted: (value) {
                                  search(value);
                                },
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
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: suggestions.length,
                        itemBuilder: (context, index) {
                          final suggestion = suggestions[index]['description'];
                          List<String> parts =
                              suggestion.split(","); // Split name and address

                          String nama =
                              parts.isNotEmpty ? parts[0] : "Unknown Name";
                          String alamat =
                              parts.length > 1 ? parts[1] : "Unknown Address";
                          return Column(
                            children: [
                              ExpandableCardUwi(
                                nama: nama,
                                alamat: alamat,
                                pintuMasuk1: "Gerbang Masuk",
                                pintuMasuk2: "Lobby Utama",
                              ),
                              SizedBox(height: 10 / 917 * screenHeight),
                            ],
                          );
                        })),
              ),
            ],
          ),
        ));
  }
}
