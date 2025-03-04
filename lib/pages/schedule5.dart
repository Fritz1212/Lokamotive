import 'package:flutter/material.dart';
import 'schedule2.dart';
import 'schedule4.dart';

class Schedule5 extends StatelessWidget {
  const Schedule5({super.key});

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
                InfoTrain(),
                ReturnButton(),
              ],
            )
          ),
          TrainMap(),
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
              pageBuilder: (context, animation, secondaryAnimation) => Schedule4(),
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

class LocationTimeWidget extends StatelessWidget {
  final String location;
  final String time;
  final Color circleColor;

  const LocationTimeWidget({
    Key? key,
    required this.location,
    required this.time,
    required this.circleColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.89,
      height: MediaQuery.of(context).size.height * 0.03,
      child: Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.height * 0.009,
          ),
          Container(
            width: MediaQuery.of(context).size.height * 0.03,
            decoration: BoxDecoration(
              color: circleColor, // Warna lingkaran
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.height * 0.04,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.height * 0.25,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  location,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.height * 0.064,
            child: Center(
              child: Text(
                time,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.08
          )
        ],
      ),
    );
  }
}

class TrainMap extends StatelessWidget {
  const TrainMap({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.7,
      child: Stack(
        children: [
          Row(  
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.08,
                child: const DottedVerticalLine(
                  height: double.infinity, 
                  color: Color(0xFF225477),
                  dashHeight: 1,
                  dashGap: 5,
                  width: 2,
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.79,
              ),
            ],
          ),
          Positioned.fill(
            child: ListView.separated(
              padding: EdgeInsets.zero,
              itemCount: 9, 
              itemBuilder: (context, index) {
                return const LocationTimeWidget(
                  location: "Jakarta",
                  time: "14:45",
                  circleColor:Color(0xFFF28A33),
                );
              },
              separatorBuilder: (context, index) {
                return SizedBox(height: MediaQuery.of(context).size.height * 0.08);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DottedVerticalLine extends StatelessWidget {
  final double height;
  final Color color;
  final double dashHeight;
  final double dashGap;
  final double width;

  const DottedVerticalLine({
    Key? key,
    this.height = 100,
    this.color = Colors.blue,
    this.dashHeight = 5,
    this.dashGap = 5,
    this.width = 2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(width, height),
      painter: _DottedVerticalLinePainter(color, dashHeight, dashGap, width),
    );
  }
}

class _DottedVerticalLinePainter extends CustomPainter {
  final Color color;
  final double dashHeight;
  final double dashGap;
  final double width;

  _DottedVerticalLinePainter(this.color, this.dashHeight, this.dashGap, this.width);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = width
      ..strokeCap = StrokeCap.round;

    double startY = 5;
    while (startY < size.height) {
      canvas.drawLine(
        Offset(size.width / 2, startY),
        Offset(size.width / 2, startY + dashHeight),
        paint,
      );
      startY += dashHeight + dashGap;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
