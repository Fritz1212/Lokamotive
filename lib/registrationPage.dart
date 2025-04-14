import 'package:flutter/material.dart';
import 'package:lokamotive/preferencePage.dart';
import 'package:lokamotive/signin.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class AccountRegistration extends StatefulWidget {
  @override
  _AccountRegistrationState createState() => _AccountRegistrationState();
}

class _AccountRegistrationState extends State<AccountRegistration> {
  late WebSocketChannel channel;

  @override
  void initState() {
    super.initState();
    channel = IOWebSocketChannel.connect('ws://172.20.10.2:3000');
  }

  void sendAccount(String message) {
    channel.sink.add(message);
  }

  void closeWebSocket() {
    channel.sink.close();
  }

  void dispose() {
    closeWebSocket();
    super.dispose();
  }

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? fullNameError;
  String? emailError;
  String? passwordError;

  void validateInputs() {
    setState(() {
      fullNameError =
          fullNameController.text.isEmpty ? "Full Name is required" : null;
      emailError = emailController.text.isEmpty ? "Email is required" : null;
      passwordError = passwordController.text.length < 6
          ? "Password must be at least 6 characters"
          : null;
    });
  }

  bool get isFormValid =>
      fullNameError == null && emailError == null && passwordError == null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF225477), Color(0xFFFFFFFF).withOpacity(0.6)],
            begin: Alignment.topCenter,
            end: Alignment.center,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    margin: EdgeInsets.only(top: 30), child: RegisterImage()),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Register',
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF225477)),
                  ),
                ),
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    "Let's Get Started",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    "Create An Account",
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ),
                SizedBox(height: 16),

                // Full Name Input
                Align(
                    alignment: Alignment.centerLeft,
                    child: LabelText("Full Name")),
                InputBox(
                    controller: fullNameController,
                    errorText: fullNameError,
                    hintText: "Enter your full name"),

                // Email Input
                Align(
                    alignment: Alignment.centerLeft, child: LabelText("Email")),
                InputBox(
                    controller: emailController,
                    errorText: emailError,
                    hintText: "Enter your email"),

                // Password Input
                Align(
                    alignment: Alignment.centerLeft,
                    child: LabelText("Password")),
                InputBox(
                    controller: passwordController,
                    errorText: passwordError,
                    isPassword: true,
                    hintText: "Enter your password"),

                SizedBox(height: 24),

                // Register Button
                ElevatedButton(
                  onPressed: () {
                    validateInputs();
                    if (isFormValid) {
                      sendAccount(
                          '{"action" : "Regis", "user_name" : "${fullNameController.text}", "email" : "${emailController.text}", "passwordz" : "${passwordController.text}"}');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TransportationPreferenceScreen(
                            email: emailController.text,
                            userName: fullNameController.text,
                            onNameChanged: (newName) {
                              fullNameController.text = newName;
                            },
                          ),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF225477),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Center(
                    child: Text(
                      "Register",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),

                Container(
                  height: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an Account? ",
                          style:
                              TextStyle(fontSize: 14, color: Colors.black54)),
                      GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SigninPage())),
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
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class InputBox extends StatelessWidget {
  final TextEditingController controller;
  final String? errorText;
  final bool isPassword;
  final String hintText;

  const InputBox({
    Key? key,
    required this.controller,
    this.errorText,
    this.isPassword = false,
    required this.hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 5),
          padding: EdgeInsets.symmetric(horizontal: 16),
          height: 55,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Color(0xFF8FBDF4).withOpacity(0.2),
            border: Border.all(
                color: errorText != null
                    ? Colors.red
                    : Color.fromARGB(255, 255, 255, 255)),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(255, 255, 255, 255),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            obscureText: isPassword,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.grey.shade600),
            ),
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4.0, left: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(errorText!,
                  style: TextStyle(color: Colors.red, fontSize: 12)),
            ),
          ),
      ],
    );
  }
}

class LabelText extends StatelessWidget {
  final String text;

  const LabelText(this.text, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Text(
        text,
        style: TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
      ),
    );
  }
}

class RegisterImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      width: 500,
      child: Image.asset(
        'assets/Mobile login-amico 1.png',
        fit: BoxFit.contain,
      ),
    );
  }
}
