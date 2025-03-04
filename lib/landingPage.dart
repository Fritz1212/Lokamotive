import 'package:flutter/material.dart';

class FadeInWidget extends StatefulWidget {
  FadeInWidget({required this.imagePath});
  final String imagePath;
  
  @override
  State<FadeInWidget> createState() => _FadeIn();
}
  
class _FadeIn extends State<FadeInWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _controller.forward();
  }
  
  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
        scale: Tween<double>(begin: 0.8, end: 1.6).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut)
      ),
      child: Image.asset(widget.imagePath, width: 150),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            Expanded(
              child: Container(
                alignment: Alignment.center,
                child: FadeInWidget(imagePath: "assets/LokaMotive-logo2.png"),
                width: 350,
                height: 350
              ),
            ),
            Align (
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.all(25),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 34, 84, 119),
                    foregroundColor: Colors.white,
                    minimumSize: Size(350, 50),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)
                    )
                  ),
                  onPressed: () {},
                  child: Text(
                    "Get Started",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17
                    )
                    )
                )
              )
            ),
          ],)
        )
      )
    );
  }
}

