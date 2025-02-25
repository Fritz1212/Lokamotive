import 'package:flutter/material.dart';

class Schedule2 extends StatelessWidget {
  const Schedule2({super.key});

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
                SearchSchedule(),
                ReturnButton(),
              ],
            )
          ),
          ListTrain(),
        ],
      )
    );
  }
}

class TopFunc extends StatelessWidget {
  const TopFunc({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: 255,
        decoration: const BoxDecoration(
          color: Color(0xFF225477),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(70),
            bottomRight: Radius.circular(70)
          )
        ),
      );
  }
}

class ReturnButton extends StatelessWidget {
  const ReturnButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 30,
      child: Container(
        width: 100,
        height: 100,
        child: Image.asset("assets/Semua Button.png"),
      )
    );
  }
}

class SearchSchedule extends StatelessWidget {
  const SearchSchedule({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 140,
      left: 30,
      child: Container(
        width: 369,
        height: 200,
        decoration: BoxDecoration(
          color: const Color(0xFFF7F7F7), 
          border: Border.all(
            color: const Color(0xFFA2A2A2),
            width: 1,
          ),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15),
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15)
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5), 
              blurRadius: 5, 
              spreadRadius: 0, 
              offset: const Offset(0, 4), 
            )
          ]
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 300,
              height: 60,
              child: Row(
                children: [
                  SizedBox(
                    width: 34,
                    height: 40,
                    child: Image.asset("assets/Vector.png"),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  SizedBox(
                    width: 246,
                    height: 60,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 246,
                          height: 25,
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Station",
                                style: TextStyle(
                                  fontSize: 16, 
                                  color: Color.fromARGB(89, 0, 0, 0),
                                ),
                              ),
                            ]
                          )
                        ),
                        Container(
                          width: 246,
                          height: 25,
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: "Departure Station",
                                    border: InputBorder.none,
                                  ),
                                  style: TextStyle(
                                    fontSize: 17,
                                  ),
                                )
                              ),
                            ]
                          )
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 300,
              height: 30,
              child: Divider(
                color: Color.fromARGB(64, 0, 0, 0),  
                thickness: 1, 
              ),
            ),
            SizedBox(
              width: 300,
              height: 60,
              child: Row(
                children: [
                  SizedBox(
                    width: 34,
                    height: 40,
                    // color: Colors.black,
                    child: Image.asset("assets/Vector(1).png"),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  SizedBox(
                    width: 246,
                    height: 60,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 246,
                          height: 25,
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Schedule",
                                style: TextStyle(fontSize: 16, color: Color.fromARGB(89, 0, 0, 0)),
                              ),
                            ]
                          )
                        ),
                        Container(
                          width: 246,
                          height: 25,
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: "Select Train Schedule",
                                    border: InputBorder.none,
                                  ),
                                  style: TextStyle(
                                    fontSize: 17,
                                  ),
                                )
                              ),
                            ]
                          )
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    ); 
  }
}

class ListTrain extends StatelessWidget {
  const ListTrain({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 600,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 350,
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 23,
                  height: 28,
                  child: Image.asset("assets/Vector.png")
                ),
                const SizedBox(
                  width: 15,
                ),
                Container(
                  width: 300,
                  height: 40,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "PESING",
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
              width: 370,
              height: 5,
              child: Divider(
                color: Color.fromARGB(64, 0, 0, 0),  
                thickness: 1, 
              ),
            ),
          const SizedBox(
            height: 15,
          ),
          SizedBox(
            width: 350,
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 23,
                  height: 28,
                  child: Image.asset("assets/Vector.png")
                ),
                const SizedBox(
                  width: 15,
                ),
                Container(
                  width: 300,
                  height: 40,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "PALMERAH",
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
              width: 370,
              height: 5,
              child: Divider(
                color: Color.fromARGB(64, 0, 0, 0),  
                thickness: 1, 
              ),
            ),
          const SizedBox(
            height: 15,
          ),
          SizedBox(
            width: 350,
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 23,
                  height: 28,
                  child: Image.asset("assets/Vector.png")
                ),
                const SizedBox(
                  width: 15,
                ),
                Container(
                  width: 300,
                  height: 40,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "JAKARTA KOTA",
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
              width: 370,
              height: 5,
              child: Divider(
                color: Color.fromARGB(64, 0, 0, 0),  
                thickness: 1, 
              ),
            ),
          const SizedBox(
            height: 15,
          ),
          SizedBox(
            width: 350,
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 23,
                  height: 28,
                  child: Image.asset("assets/Vector.png")
                ),
                const SizedBox(
                  width: 15,
                ),
                Container(
                  width: 300,
                  height: 40,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "MANGGARAI",
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
              width: 370,
              height: 5,
              child: Divider(
                color: Color.fromARGB(64, 0, 0, 0),  
                thickness: 1, 
              ),
            ),
          const SizedBox(
            height: 15,
          ),
          SizedBox(
            width: 350,
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 23,
                  height: 28,
                  child: Image.asset("assets/Vector.png")
                ),
                const SizedBox(
                  width: 15,
                ),
                Container(
                  width: 300,
                  height: 40,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "BOGOR",
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
              width: 370,
              height: 5,
              child: Divider(
                color: Color.fromARGB(64, 0, 0, 0),  
                thickness: 1, 
              ),
            ),
          const SizedBox(
            height: 15,
          ),
          SizedBox(
            width: 350,
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 23,
                  height: 28,
                  child: Image.asset("assets/Vector.png")
                ),
                const SizedBox(
                  width: 15,
                ),
                Container(
                  width: 300,
                  height: 40,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "DEPOK",
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
              width: 370,
              height: 5,
              child: Divider(
                color: Color.fromARGB(64, 0, 0, 0),  
                thickness: 1, 
              ),
            ),
          const SizedBox(
            height: 15,
          ),
          SizedBox(
            width: 350,
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 23,
                  height: 28,
                  child: Image.asset("assets/Vector.png")
                ),
                const SizedBox(
                  width: 15,
                ),
                Container(
                  width: 300,
                  height: 40,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "PARUNG PANJANG",
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
              width: 370,
              height: 5,
              child: Divider(
                color: Color.fromARGB(64, 0, 0, 0),  
                thickness: 1, 
              ),
            ),
          const SizedBox(
            height: 15,
          ),
          SizedBox(
            width: 350,
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 23,
                  height: 28,
                  child: Image.asset("assets/Vector.png")
                ),
                const SizedBox(
                  width: 15,
                ),
                Container(
                  width: 300,
                  height: 40,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "PASAR MINGGU",
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
              width: 370,
              height: 5,
              child: Divider(
                color: Color.fromARGB(64, 0, 0, 0),  
                thickness: 1, 
              ),
            ),
        ],
      )
    );
  }
}