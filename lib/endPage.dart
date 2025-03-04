import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:google_fonts/google_fonts.dart';

class endPage extends StatelessWidget {
  const endPage({super.key});

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
                'assets/animasi_end.riv',
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
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/third');
              },
              child: Text("Detail",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            )
          ],
        ),
      ),
    );
  }
}
