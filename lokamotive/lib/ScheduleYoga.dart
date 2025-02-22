import 'package:flutter/material.dart';
import 'schedule1.dart';

class Schedule2Yoga extends StatelessWidget {
  const Schedule2Yoga({super.key});

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
        height: MediaQuery.of(context).size.height * 0.3,
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
      top: MediaQuery.of(context).size.height * 0.035,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.2,
        height: MediaQuery.of(context).size.height * 0.1,
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => Schedule1(),
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

class SearchSchedule extends StatefulWidget {
  const SearchSchedule({super.key});

  @override
  _SearchScheduleState createState() => _SearchScheduleState();
}

List<int> _selectedValue = [0, 1]; 


class _SearchScheduleState extends State<SearchSchedule> {
  int? _currentValue = 0;

  void scheduleTrain2(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)), // Agar sudut atas membulat
      ),
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.4, // Setinggi 40% layar
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Divider(
                color: Color.fromARGB(50, 0, 0, 0), 
                thickness: 2,        
                indent: 150,          
                endIndent: 150,       
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Pilih Jadwal Kereta",
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      )
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.06,
                      child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _currentValue = 0;
                            });
                            Navigator.pop(context);
                          },
                          child: Row(
                            children: [
                              Radio<int>(
                                value: _selectedValue[0],
                                groupValue: _currentValue,
                                activeColor: Colors.orange, // Change selected color
                                onChanged: (value) {
                                  setState(() {
                                    _currentValue = value;
                                  });
                                },
                              ),
                              const Text(
                                "1 Hari ini",
                                style: TextStyle(fontSize: 16, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    ),
                    Container(),
                    Container(),
                    Container(),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.15,
      left: MediaQuery.of(context).size.width * 0.05,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.22,
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
              width: MediaQuery.of(context).size.width * 0.75,
              height: MediaQuery.of(context).size.height * 0.06,
              child: Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.1,
                    height: 40,
                    child: Image.asset("assets/Vector.png"),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.05,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    height: MediaQuery.of(context).size.height * 0.1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.6,
                          height: MediaQuery.of(context).size.height * 0.03,
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
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.6,
                          height: MediaQuery.of(context).size.height * 0.03,
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
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.75,
              height: 30,
              child: const Divider(
                color: Color.fromARGB(64, 0, 0, 0),  
                thickness: 1, 
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.75,
              height: MediaQuery.of(context).size.height * 0.06,
              child: Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.1,
                    height: 40,
                    child: Image.asset("assets/Vector(1).png"),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.05,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    height: MediaQuery.of(context).size.height * 0.1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.6,
                          height: MediaQuery.of(context).size.height * 0.03,
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
                        GestureDetector(
                          onTap: () {scheduleTrain2(context);},
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.6,
                            height: MediaQuery.of(context).size.height * 0.03,
                            child: const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Select Train Schedule",
                                style: TextStyle(fontSize: 17, color: Colors.black),
                              ),
                            ),
                          )
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
    ); 
  }
}

class ListTrain extends StatelessWidget {
  const ListTrain({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.62,
      child: ListView(
        padding: const EdgeInsets.all(30.0),
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.85,
            height: MediaQuery.of(context).size.height * 0.055,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.06,
                  height: MediaQuery.of(context).size.height * 0.05,
                  child: Image.asset("assets/Vector.png")
                ),
                const SizedBox(
                  width: 15,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: MediaQuery.of(context).size.height * 0.05,
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
          Container(
            width: MediaQuery.of(context).size.width * 0.85,
            height: MediaQuery.of(context).size.height * 0.055,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.06,
                  height: MediaQuery.of(context).size.height * 0.05,
                  child: Image.asset("assets/Vector.png")
                ),
                const SizedBox(
                  width: 15,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: MediaQuery.of(context).size.height * 0.05,
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
            width: MediaQuery.of(context).size.width * 0.85,
            height: MediaQuery.of(context).size.height * 0.055,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.06,
                  height: MediaQuery.of(context).size.height * 0.05,
                  child: Image.asset("assets/Vector.png")
                ),
                const SizedBox(
                  width: 15,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: MediaQuery.of(context).size.height * 0.05,
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
            width: MediaQuery.of(context).size.width * 0.85,
            height: MediaQuery.of(context).size.height * 0.055,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.06,
                  height: MediaQuery.of(context).size.height * 0.05,
                  child: Image.asset("assets/Vector.png")
                ),
                const SizedBox(
                  width: 15,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: MediaQuery.of(context).size.height * 0.05,
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
            width: MediaQuery.of(context).size.width * 0.85,
            height: MediaQuery.of(context).size.height * 0.055,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.06,
                  height: MediaQuery.of(context).size.height * 0.05,
                  child: Image.asset("assets/Vector.png")
                ),
                const SizedBox(
                  width: 15,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: MediaQuery.of(context).size.height * 0.05,
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
            width: MediaQuery.of(context).size.width * 0.85,
            height: MediaQuery.of(context).size.height * 0.055,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.06,
                  height: MediaQuery.of(context).size.height * 0.05,
                  child: Image.asset("assets/Vector.png")
                ),
                const SizedBox(
                  width: 15,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: MediaQuery.of(context).size.height * 0.05,
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
            width: MediaQuery.of(context).size.width * 0.85,
            height: MediaQuery.of(context).size.height * 0.055,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.06,
                  height: MediaQuery.of(context).size.height * 0.05,
                  child: Image.asset("assets/Vector.png")
                ),
                const SizedBox(
                  width: 15,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: MediaQuery.of(context).size.height * 0.05,
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
            width: MediaQuery.of(context).size.width * 0.85,
            height: MediaQuery.of(context).size.height * 0.055,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.06,
                  height: MediaQuery.of(context).size.height * 0.05,
                  child: Image.asset("assets/Vector.png")
                ),
                const SizedBox(
                  width: 15,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: MediaQuery.of(context).size.height * 0.05,
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
          const SizedBox(
            height: 15,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.85,
            height: MediaQuery.of(context).size.height * 0.055,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.06,
                  height: MediaQuery.of(context).size.height * 0.05,
                  child: Image.asset("assets/Vector.png")
                ),
                const SizedBox(
                  width: 15,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: MediaQuery.of(context).size.height * 0.05,
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
            width: MediaQuery.of(context).size.width * 0.85,
            height: MediaQuery.of(context).size.height * 0.055,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.06,
                  height: MediaQuery.of(context).size.height * 0.05,
                  child: Image.asset("assets/Vector.png")
                ),
                const SizedBox(
                  width: 15,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: MediaQuery.of(context).size.height * 0.05,
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
        ],
      )
    );
  }
}