import 'package:flutter/material.dart';
import 'package:lokamotive/dashboard_page.dart';
import 'package:rive/rive.dart';
import 'package:google_fonts/google_fonts.dart';

class endPage extends StatefulWidget {
  const endPage({super.key});

  @override
  State<endPage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<endPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 7), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => DashboardPage(
                  userName: GlobalData.userName,
                  email: GlobalData.email,
                  onNameChanged: (String value) {},
                )), // Replace with your next page
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 450,
              height: 450,
              child: RiveAnimation.asset(
                'assets/Animation/animasi_end.riv',
                fit: BoxFit.cover,
              ),
            ),
            Text(
              "Anda Telah Sampai Tujuan !",
              style: GoogleFonts.inter(
                color: Color.fromARGB(500, 34, 84, 119),
                fontSize: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
