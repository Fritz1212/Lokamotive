import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class FadeInWidget extends StatefulWidget {
  
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
      child: RiveAnimation.asset("Assets/untitled.riv", fit: BoxFit.contain),
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
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center( 
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            Expanded(
              child: Container(
                alignment: Alignment.center,
                child: FadeInWidget(),
                width: 200,
                height: 200
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
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)
                    )
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/second');
                  },
                  child: Text(
                    "Get Started",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20
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

