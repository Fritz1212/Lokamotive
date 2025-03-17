import 'package:flutter/material.dart';
import 'package:lokamotive/pages/schedule4.dart';
import 'schedule2.dart';

class Schedule3 extends StatefulWidget {
  final String selectedStation;
  final Function(String) updateSearchQuery;
  final String scheduleText;
  
  const Schedule3({
    Key? key,
    required this.selectedStation,
    required this.updateSearchQuery,
    required this.scheduleText,
  }) : super(key: key);

  @override
  _Schedule3State createState() => _Schedule3State();
}

class _Schedule3State extends State<Schedule3> {
  String selectedSchedule = "Select Train Schedule";

  void updateSchedule(String scheduleText) {
    setState(() {
      selectedSchedule = scheduleText;
    });
  }

  void initState() {
    super.initState();
    GlobalSchedule.selectedStation = widget.selectedStation;
    GlobalSchedule.scheduleText = widget.scheduleText;
    GlobalSchedule.updateSearchQuery = widget.updateSearchQuery;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Expanded(
              child: Stack(
            clipBehavior: Clip.none,
            children: [
              TopFunc(),
              SearchSchedule(
                selectedStation: widget.selectedStation, 
                onSearchQueryChanged: widget.updateSearchQuery, 
                onScheduleUpdated: widget.scheduleText,
                isReadOnly: true,
              ),
              ReturnButton(),
            ],
          )),
          DestinationFunc(),
        ],
      )
    );
  }
}

class GlobalSchedule {
  static String selectedStation = "";
  static String scheduleText = "";
  static Function(String) updateSearchQuery = (String query) {};
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
                    const Schedule2(),
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

class TrainRouteCard extends StatelessWidget {
  final String title;
  final String startStation;
  final String endStation;

  const TrainRouteCard({
    super.key,
    required this.title,
    required this.startStation,
    required this.endStation,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              Navigator.of(context).push(PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const Schedule4(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(1.0, 0.0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  );
                },
              ));
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.094,
              decoration: BoxDecoration(
                color: const Color(0xFFFBBD8A),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  SizedBox(width: MediaQuery.of(context).size.width * 0.05),
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                title,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF102E48),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.76,
                          height: MediaQuery.of(context).size.height * 0.043,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Center(
                                child: Text(
                                  startStation,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.1,
                                height: MediaQuery.of(context).size.height * 0.043,
                                child: Image.asset("assets/Vector(3).png"),
                              ),
                              Center(
                                child: Text(
                                  endStation,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.09,
                    child: Image.asset("assets/Vector(2).png"),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
      ],
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
          const TrainRouteCard(
            title: "Commuter Line Bogor",
            startStation: "Bogor",
            endStation: "Manggarai",
          ),
          const TrainRouteCard(
            title: "Commuter Line Bogor",
            startStation: "Bogor",
            endStation: "Jakata Kota",
          ),
          const TrainRouteCard(
            title: "Commuter Line Bogor",
            startStation: "Bogor",
            endStation: "Depok",
          ),
          const TrainRouteCard(
            title: "Commuter Line Bogor",
            startStation: "Bogor",
            endStation: "Bekasi",
          ),
          const TrainRouteCard(
            title: "Commuter Line Bogor",
            startStation: "Bogor",
            endStation: "Citayam",
          ),
          const TrainRouteCard(
            title: "Commuter Line Bogor",
            startStation: "Bogor",
            endStation: "PalMerah",
          ),
        ],
      ),
    );
  }
}
