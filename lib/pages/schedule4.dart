import 'package:flutter/material.dart';
import 'package:lokamotive/pages/schedule3.dart';
import 'package:lokamotive/pages/schedule5.dart';
import 'schedule2.dart';

class Schedule4 extends StatelessWidget {
  const Schedule4({super.key});

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
            )),
            TrainSchedule(),
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
                    const Schedule3(),
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

class InfoTrain extends StatelessWidget {
  const InfoTrain({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
        child: Center(
      child: Transform.translate(
        offset: Offset(0, MediaQuery.of(context).size.height / 100 - 20),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.7,
          height: MediaQuery.of(context).size.height * 0.14,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.65,
                height: MediaQuery.of(context).size.height * 0.03,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(2),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Bogor",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFFFFFFFF)),
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.03,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.07,
                      height: MediaQuery.of(context).size.height * 0.07,
                      child: Image.asset("assets/Vector(5).png"),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.03,
                    ),
                    Container(
                      padding: const EdgeInsets.all(2),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Manggarai",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFFFFFFFF)),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.057,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.54,
                height: MediaQuery.of(context).size.height * 0.053,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "KRL SCHEDULE",
                      style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFFFFFFFF)),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }
}

class TrainScheduleCard extends StatelessWidget {
  final String trainNumber;
  final String departureTime;

  const TrainScheduleCard({
    super.key,
    required this.trainNumber,
    required this.departureTime,
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
                    Schedule5(),
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
              width: MediaQuery.of(context).size.width * 0.87,
              height: MediaQuery.of(context).size.height * 0.065,
              decoration: BoxDecoration(
                color: const Color(0xFFFBBD8A),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(width: MediaQuery.of(context).size.width * 0.07),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.61,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "KRL",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.035,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width:
                                    MediaQuery.of(context).size.width * 0.047,
                                child: Image.asset("assets/Vector(4).png"),
                              ),
                              SizedBox(
                                  width: MediaQuery.of(context).size.width *
                                      0.012),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.55,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "#$trainNumber",
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF225477),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.12,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          departureTime,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF225477),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.07,
                    child: Image.asset("assets/Vector(2).png"),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.03),
      ],
    );
  }
}

class TrainSchedule extends StatelessWidget {
  const TrainSchedule({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.7,
      child: ListView(
        children: const [
          TrainScheduleCard(trainNumber: "1025", departureTime: "12.25"),
          TrainScheduleCard(trainNumber: "1027", departureTime: "13.25"),
          TrainScheduleCard(trainNumber: "1029", departureTime: "14.25"),
          TrainScheduleCard(trainNumber: "1031", departureTime: "15.25"),
          TrainScheduleCard(trainNumber: "1033", departureTime: "16.25"),
          TrainScheduleCard(trainNumber: "1035", departureTime: "17.25"),
          TrainScheduleCard(trainNumber: "1037", departureTime: "18.25"),
          TrainScheduleCard(trainNumber: "1039", departureTime: "19.25"),
          TrainScheduleCard(trainNumber: "1041", departureTime: "20.25"),
          TrainScheduleCard(trainNumber: "1043", departureTime: "21.25"),
        ],
      ),
    );
  }
}
