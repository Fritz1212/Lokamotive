import 'package:flutter/material.dart';
import 'package:lokamotive_schedule/pages/schedule2.dart';

class Schedule1 extends StatelessWidget {
  const Schedule1({super.key});

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
                TopPic(),
                ReturnButton(),
                TopText(),
                BottomFunc(),
              ],
            )
          ),
        ],
      )
    );
  }
}

class TopPic extends StatelessWidget {
  const TopPic({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.35,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/Future of the Subway 1.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.35,
          width: double.infinity,
          color: Color.fromARGB(65, 16, 46, 72),
        ),
      ],
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
              pageBuilder: (context, animation, secondaryAnimation) => Schedule1(),
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

class TransportCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final VoidCallback onSelect;

  const TransportCard({
    Key? key,
    required this.title,
    required this.imagePath,
    required this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      height: MediaQuery.of(context).size.height * 0.12,
      decoration: BoxDecoration(
        color: const Color(0xFF225477),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.275,
            height: MediaQuery.of(context).size.height * 0.08,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.05,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.225,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.17,
                        height: MediaQuery.of(context).size.height * 0.03,
                        child: ElevatedButton(
                          onPressed: onSelect,
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "SELECT",
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFFF28A33)),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.575,
            height: MediaQuery.of(context).size.height * 0.08,
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: AssetImage(imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BottomFunc extends StatelessWidget {
  const BottomFunc({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      child: ClipPath(
        clipper: CustomShapeClipper(),
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.5,
              width: double.infinity,
              color: Colors.white,
            ),
            Center(
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.35,
                  ),
                  TransportCard(
                    title: "KRL",
                    imagePath: "assets/10 Bustling Facts About Buses - The Fact Site 1.png",
                    onSelect: () {
                      Navigator.of(context).push(PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) => Schedule2(),
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          return SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(1.0, 0.0), // Mulai dari kiri
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          );
                        },
                      ));
                    },
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  TransportCard(
                    title: "LRT",
                    imagePath: "assets/Segera Beroperasi, Ini Daftar Tarif LRT Jabodebek Setelah Disubsidi Pemerintah 1.png",
                    onSelect: () {
                      Navigator.of(context).push(PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) => Schedule2(),
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          return SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(1.0, 0.0), // Mulai dari kiri
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          );
                        },
                      ));
                    },
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  TransportCard(
                    title: "MRT",
                    imagePath: "assets/download (3) 1.png",
                    onSelect: () {
                      Navigator.of(context).push(PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) => Schedule2(),
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          return SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(1.0, 0.0), // Mulai dari kiri
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          );
                        },
                      ));
                    },
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  TransportCard(
                    title: "Transjakarta",
                    imagePath: "assets/download (4) 1.png",
                    onSelect: () {
                      Navigator.of(context).push(PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) => Schedule2(),
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          return SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(1.0, 0.0), // Mulai dari kiri
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          );
                        },
                      ));
                    },
                  ),
                ],
              )
            )
          ],
        )
      ),
    );
  }
}

class CustomShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height * 0.2); // Turun ke bawah dengan radius 15 (perkiraan)
    path.quadraticBezierTo(-10, size.height * 0.3, 60, size.height * 0.3); // Radius 15 di kiri atas
    path.lineTo(size.width - 60, size.height * 0.3); // Lurus ke kanan
    path.quadraticBezierTo(size.width, size.height * 0.3, size.width, size.height * 0.355); // Radius 15 di kanan atas
    path.lineTo(size.width, size.height); // Langsung ke kanan bawah
    path.lineTo(0, size.height); // Langsung ke kiri bawah
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class TopText extends StatelessWidget {
  const TopText({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.15,
      left: 0,
      right: 0, 
      child: Align(
        alignment: Alignment.topCenter, 
        child: Transform.translate(
          offset: Offset(0, MediaQuery.of(context).size.height / 100 - 35),
          child: Container(
            width: 370,
            height: 100,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Choose Your Transport",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  "Start Your Journey!",
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
