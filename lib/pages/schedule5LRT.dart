import 'package:flutter/material.dart';
import 'package:lokamotive/pages/schedule2LRTTo.dart';
import 'package:lokamotive/pages/schedule3MRT.dart';
import 'schedule2.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class Schedule5LRT extends StatefulWidget {
  final String destStation;

  const Schedule5LRT({super.key, required this.destStation});

  @override
  State<StatefulWidget> createState() => _Schedule5LRTState();
}

class _Schedule5LRTState extends State<Schedule5LRT> {
  void initState() {
    super.initState();
    GlobalSchedule2.destStation = widget.destStation;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            const Expanded(
                child: Stack(
              clipBehavior: Clip.none,
              children: [
                TopFunc(),
                ReturnButton(),
              ],
            )),
            TrainMap(idx: 0),
          ],
        ));
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
                pageBuilder: (context, animation, secondaryAnimation) =>
                    Schedule2LRTTo(
                  selectedStation: GlobalSchedule.selectedStation,
                  updateSearchQuery: GlobalSchedule.updateSearchQuery,
                  scheduleText: GlobalSchedule.scheduleText,
                ),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
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
        ));
  }
}

class LocationTimeWidget extends StatelessWidget {
  final String time;
  final Color circleColor;

  const LocationTimeWidget({
    Key? key,
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
                  "",
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
          SizedBox(height: MediaQuery.of(context).size.height * 0.08)
        ],
      ),
    );
  }
}

class TrainMap extends StatefulWidget {
  final int idx;

  const TrainMap({super.key, required this.idx});

  @override
  State<StatefulWidget> createState() => _TrainMapState();
}

class _TrainMapState extends State<TrainMap> {
  List<String> schedule = [];

  Future<void> loadSchedule() async {
    String data = await rootBundle.loadString('assets/scheduleDataLRT.json');
    List<dynamic> jsonData = json.decode(data);

    setState(() {
      var selectedRoute = jsonData.firstWhere(
        (item) =>
            item['from'] == GlobalSchedule2.deptStation &&
            item['to'] == GlobalSchedule2.destStation,
        orElse: () => null,
      );

      if (selectedRoute != null) {
        schedule = List<String>.from(selectedRoute['times']);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    loadSchedule();
  }

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
              itemCount: schedule.length,
              itemBuilder: (context, index) {
                String scheduleTimeString = schedule[index];

                DateTime now = DateTime.now();
                DateTime scheduleTime = DateTime(
                  now.year,
                  now.month,
                  now.day,
                  int.parse(scheduleTimeString.split(":")[0]),
                  int.parse(scheduleTimeString.split(":")[1]),
                );

                Color circleColor = scheduleTime.isBefore(now)
                    ? Color(0xFFF28A33)
                    : Color(0xFFFBBD8A);

                return LocationTimeWidget(
                  time: schedule[index],
                  circleColor: circleColor,
                );
              },
              separatorBuilder: (context, index) {
                return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.08);
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

  _DottedVerticalLinePainter(
      this.color, this.dashHeight, this.dashGap, this.width);

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
