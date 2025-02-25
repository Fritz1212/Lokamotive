import 'package:flutter/material.dart';
import 'package:lokamotive_schedule/pages/schedule4.dart';
import 'schedule2.dart';

class Schedule3 extends StatelessWidget {
  const Schedule3({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Expanded(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                TopFunc(),
                SearchSchedule(),
                ReturnButton(),
              ],
            )
          ),
          DestinationFunc(),
        ],
      )
    );
  }
}

class ReturnButton extends StatelessWidget {
  const ReturnButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.035,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.2,
        height: MediaQuery.of(context).size.height * 0.1,
        child: GestureDetector(
          onTap: () { 
            Navigator.of(context).push(PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => Schedule2(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(-1.0, 0.0), // Mulai dari kiri
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                );
              },
            ));
          },
          child: Image.asset("assets/Semua Button.png"),
        ),
      )
    );
  }
}

class DestinationFunc extends StatelessWidget {
  const DestinationFunc({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.62,
      child: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.03,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Choose your destination",
                  style: TextStyle(
                    fontSize: 20, 
                    color: Color(0xFF225477),
                    fontWeight: FontWeight.w800,
                  ),
                )
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.03,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.094,
            decoration: const BoxDecoration(
              color:Color(0xFFFBBD8A),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12)
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.05,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.76,
                  height: MediaQuery.of(context).size.height * 0.094,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.76,
                        height: MediaQuery.of(context).size.height * 0.04,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Commuter Line Bogor",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF102E48)
                              ),
                            ),
                          ],
                        )
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.76,
                        height: MediaQuery.of(context).size.height * 0.043,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.all(5),
                              height: MediaQuery.of(context).size.height * 0.043,
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Bogor",
                                    style: TextStyle(
                                      fontSize: 15, 
                                      fontWeight: FontWeight.w500
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.1,
                              height: MediaQuery.of(context).size.height * 0.043,
                              child: Image.asset("assets/Vector(3).png"),
                            ),
                            Container(
                              padding: EdgeInsets.all(5),
                              height: MediaQuery.of(context).size.height * 0.043,
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Manggarai",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.09, 
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shadowColor: Colors.transparent,
                      backgroundColor: Colors.transparent,
                    ),
                    onPressed: () {
                      Navigator.of(context).push(PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) => Schedule4(),
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          return SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(1.0, 0.0), // Mulai dari kanan
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          );
                        },
                      ));
                    },
                    child: Image.asset("assets/Vector(2).png"),
                  ),
                )
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.094,
            decoration: const BoxDecoration(
              color:Color(0xFFFBBD8A),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12)
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.05,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.76,
                  height: MediaQuery.of(context).size.height * 0.094,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.76,
                        height: MediaQuery.of(context).size.height * 0.04,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Commuter Line Bogor",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF102E48)
                              ),
                            ),
                          ],
                        )
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.76,
                        height: MediaQuery.of(context).size.height * 0.043,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.all(5),
                              height: MediaQuery.of(context).size.height * 0.043,
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Bogor",
                                    style: TextStyle(
                                      fontSize: 15, 
                                      fontWeight: FontWeight.w500
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.1,
                              height: MediaQuery.of(context).size.height * 0.043,
                              child: Image.asset("assets/Vector(3).png"),
                            ),
                            Container(
                              padding: EdgeInsets.all(5),
                              height: MediaQuery.of(context).size.height * 0.043,
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Manggarai",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.09,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shadowColor: Colors.transparent,
                      backgroundColor: Colors.transparent,
                    ),
                    onPressed: () {
                      Navigator.of(context).push(PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) => Schedule4(),
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          return SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(1.0, 0.0), // Mulai dari kanan
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          );
                        },
                      ));
                    },
                    child: Image.asset("assets/Vector(2).png"),
                  ),
                )
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.094,
            decoration: const BoxDecoration(
              color:Color(0xFFFBBD8A),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12)
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.05,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.76,
                  height: MediaQuery.of(context).size.height * 0.094,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.76,
                        height: MediaQuery.of(context).size.height * 0.04,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Commuter Line Bogor",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF102E48)
                              ),
                            ),
                          ],
                        )
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.76,
                        height: MediaQuery.of(context).size.height * 0.043,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.all(5),
                              height: MediaQuery.of(context).size.height * 0.043,
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Bogor",
                                    style: TextStyle(
                                      fontSize: 15, 
                                      fontWeight: FontWeight.w500
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.1,
                              height: MediaQuery.of(context).size.height * 0.043,
                              child: Image.asset("assets/Vector(3).png"),
                            ),
                            Container(
                              padding: EdgeInsets.all(5),
                              height: MediaQuery.of(context).size.height * 0.043,
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Manggarai",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.09,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shadowColor: Colors.transparent,
                      backgroundColor: Colors.transparent,
                    ),
                    onPressed: () {
                      Navigator.of(context).push(PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) => Schedule4(),
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          return SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(1.0, 0.0), // Mulai dari kanan
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          );
                        },
                      ));
                    },
                    child: Image.asset("assets/Vector(2).png"),
                  ),
                )
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.094,
            decoration: const BoxDecoration(
              color:Color(0xFFFBBD8A),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12)
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.05,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.76,
                  height: MediaQuery.of(context).size.height * 0.094,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.76,
                        height: MediaQuery.of(context).size.height * 0.04,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Commuter Line Bogor",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF102E48)
                              ),
                            ),
                          ],
                        )
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.76,
                        height: MediaQuery.of(context).size.height * 0.043,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.all(5),
                              height: MediaQuery.of(context).size.height * 0.043,
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Bogor",
                                    style: TextStyle(
                                      fontSize: 15, 
                                      fontWeight: FontWeight.w500
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.1,
                              height: MediaQuery.of(context).size.height * 0.043,
                              child: Image.asset("assets/Vector(3).png"),
                            ),
                            Container(
                              padding: EdgeInsets.all(5),
                              height: MediaQuery.of(context).size.height * 0.043,
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Manggarai",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.09,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shadowColor: Colors.transparent,
                      backgroundColor: Colors.transparent,
                    ),
                    onPressed: () {
                      Navigator.of(context).push(PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) => Schedule4(),
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          return SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(1.0, 0.0), // Mulai dari kanan
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          );
                        },
                      ));
                    },
                    child: Image.asset("assets/Vector(2).png"),
                  ),
                )
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.094,
            decoration: const BoxDecoration(
              color:Color(0xFFFBBD8A),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12)
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.05,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.76,
                  height: MediaQuery.of(context).size.height * 0.094,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.76,
                        height: MediaQuery.of(context).size.height * 0.04,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Commuter Line Bogor",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF102E48)
                              ),
                            ),
                          ],
                        )
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.76,
                        height: MediaQuery.of(context).size.height * 0.043,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.all(5),
                              height: MediaQuery.of(context).size.height * 0.043,
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Bogor",
                                    style: TextStyle(
                                      fontSize: 15, 
                                      fontWeight: FontWeight.w500
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.1,
                              height: MediaQuery.of(context).size.height * 0.043,
                              child: Image.asset("assets/Vector(3).png"),
                            ),
                            Container(
                              padding: EdgeInsets.all(5),
                              height: MediaQuery.of(context).size.height * 0.043,
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Manggarai",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.09,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shadowColor: Colors.transparent,
                      backgroundColor: Colors.transparent,
                    ),
                    onPressed: () {
                      Navigator.of(context).push(PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) => Schedule4(),
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          return SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(1.0, 0.0), // Mulai dari kanan
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          );
                        },
                      ));
                    },
                    child: Image.asset("assets/Vector(2).png"),
                  ),
                )
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.094,
            decoration: const BoxDecoration(
              color:Color(0xFFFBBD8A),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12)
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.05,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.76,
                  height: MediaQuery.of(context).size.height * 0.094,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.76,
                        height: MediaQuery.of(context).size.height * 0.04,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Commuter Line Bogor",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF102E48)
                              ),
                            ),
                          ],
                        )
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.76,
                        height: MediaQuery.of(context).size.height * 0.043,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.all(5),
                              height: MediaQuery.of(context).size.height * 0.043,
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Bogor",
                                    style: TextStyle(
                                      fontSize: 15, 
                                      fontWeight: FontWeight.w500
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.1,
                              height: MediaQuery.of(context).size.height * 0.043,
                              child: Image.asset("assets/Vector(3).png"),
                            ),
                            Container(
                              padding: EdgeInsets.all(5),
                              height: MediaQuery.of(context).size.height * 0.043,
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Manggarai",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.09,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shadowColor: Colors.transparent,
                      backgroundColor: Colors.transparent,
                    ),
                    onPressed: () {
                      Navigator.of(context).push(PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) => Schedule4(),
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          return SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(1.0, 0.0), // Mulai dari kanan
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          );
                        },
                      ));
                    },
                    child: Image.asset("assets/Vector(2).png"),
                  ),
                )
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
        ],
      ),
    );
  }
}