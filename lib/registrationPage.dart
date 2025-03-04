import 'package:flutter/material.dart';
import 'package:lokamotive/preferencePage.dart';
import 'package:lokamotive/signin.dart';

class AccountRegistration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF225477),
              Color(0xFFFFFFFF).withOpacity(0.6)
            ], // Gradasi dari biru ke biru muda
            begin: Alignment.topCenter,
            end: Alignment.center,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center, // Teks rata kiri
              children: [
                Container(
                  margin: EdgeInsets.only(top: 30),
                  child: RegisterImage(),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Register',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0x225477),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                ColoredBox(
                  color: Colors.red,
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    "Let's Get Started",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                SizedBox(height: 0),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    "Create An Account",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                      child: Text(
                    "Full Name",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  )),
                ),
                KotakTeks(),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                      child: Text(
                    "Email",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  )),
                ),
                KotakTeks(),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                      child: Text(
                    "Password",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  )),
                ),
                KotakTeks(),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TransportationPreferenceScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF225477),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "Register",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an Account? ",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Implementasi untuk navigasi ke halaman Sign In
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  SigninPage()), // Ganti SignInPage dengan halaman Sign In yang kamu buat
                        );
                      },
                      child: Text(
                        "Sign In",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFF28A33),
                          decoration: TextDecoration.underline,
                          decorationColor: Color(0xFFF28A33),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Dummy widget for illustration
class RegisterImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300, // Ubah ukuran tinggi sesuai kebutuhan
      width: 800, // Buat gambar memenuhi lebar layar
      child: Image.asset(
        'assets/Mobile login-amico 1.png', // Ganti dengan path gambar Anda
        fit: BoxFit.cover, // Pastikan gambar tetap proporsional
      ),
    );
  }
}

class KotakTeks extends StatelessWidget {
  const KotakTeks({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 5, bottom: 10),
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Color(0x8FBDF4).withOpacity(0.2),
      ),
      child: TextField(
        decoration: InputDecoration(border: InputBorder.none),
      ),
    );
  }
}

// FN F5 untuk debug
// save untuk reload (ctrl + s)