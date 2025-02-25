import 'package:flutter/material.dart';
import 'package:lokamotive_schedule/pages/schedule3.dart';
import 'schedule1.dart';

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

class TimePickerScreen extends StatefulWidget {
  final String labelText; // Parameter untuk teks label

  const TimePickerScreen({super.key, required this.labelText});

  @override
  _TimePickerScreenState createState() => _TimePickerScreenState();
}

class _TimePickerScreenState extends State<TimePickerScreen> {
  TimeOfDay? _selectedTime; // State untuk menyimpan waktu yang dipilih

  // Fungsi untuk menampilkan TimePicker
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(), // Waktu awal yang ditampilkan
    );

    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime; // Perbarui state dengan waktu yang dipilih
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TimePickerButton(
        labelText: widget.labelText, // Teruskan labelText ke TimePickerButton
        selectedTime: _selectedTime, // Waktu yang dipilih
        onTimePicked: () => _selectTime(context), // Panggil fungsi _selectTime
      ),
    );
  }
}

class TimePickerButton extends StatelessWidget {
  final String labelText; // Parameter untuk teks label
  final TimeOfDay? selectedTime; // Parameter untuk waktu yang dipilih
  final VoidCallback onTimePicked; // Callback untuk membuka TimePicker

  const TimePickerButton({
    super.key,
    required this.labelText,
    required this.selectedTime,
    required this.onTimePicked,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.35,
      height: MediaQuery.of(context).size.height * 0.06,
      child: ElevatedButton(
        onPressed: onTimePicked, // Panggil callback untuk membuka TimePicker
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(30, 34, 84, 119),
          shadowColor: Colors.blue,
          elevation: 0,
          surfaceTintColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.35,
              height: MediaQuery.of(context).size.height * 0.025,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    labelText, // Tampilkan teks label di sini
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                      color: Colors.black,
                    ),
                  ),
                ],
              )
            ),
            Container(
              // Tampilkan waktu yang dipilih di sini
              height: MediaQuery.of(context).size.height * 0.035,
              child: selectedTime != null
                  ? Text(
                      selectedTime!.format(context), // Format waktu yang dipilih
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    )
                  : const Text(
                      "Choose Time", // Teks default jika waktu belum dipilih
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchSchedule extends StatefulWidget {
  const SearchSchedule({super.key});

  @override
  _SearchScheduleState createState() => _SearchScheduleState();
}

class _SearchScheduleState extends State<SearchSchedule> {
  TimeOfDay? selectedTime;

  void scheduleTrain2(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      builder: (context) {
        int _selectedValue = 0; 

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.4,
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Divider(
                    color: Color.fromARGB(50, 0, 0, 0),
                    thickness: 2,
                    indent: 150,
                    endIndent: 150,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.04,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Choose Train Schedule",
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              height: MediaQuery.of(context).size.height * 0.05,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Transform.scale(
                                    scale: 1.3, 
                                    child: Radio<int>(
                                      value: 0,
                                      groupValue: _selectedValue,
                                      activeColor: Colors.orange,
                                      onChanged: (int? value) {
                                        if (value != null) {
                                          setModalState(() {
                                            _selectedValue = value; 
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                  const Text(
                                    "1 Today",
                                    style: TextStyle(fontSize: 15, color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              height: MediaQuery.of(context).size.height * 0.05,
                              alignment: Alignment.centerLeft,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Transform.scale(
                                      scale: 1.3, 
                                      child: Radio<int>(
                                        value: 1,
                                        groupValue: _selectedValue,
                                        activeColor: Colors.orange,
                                        onChanged: (int? value) {
                                          if (value != null) {
                                            setModalState(() {
                                              _selectedValue = value; 
                                            });
                                          }
                                        },
                                      ),
                                    ),
                                  const Text(
                                    "Set Your Own Schedule",
                                    style: TextStyle(fontSize: 15, color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.02,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              height: MediaQuery.of(context).size.height * 0.06,  
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width * 0.35,
                                    child: const TimePickerScreen(labelText: "From",),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width * 0.35,
                                    child: const TimePickerScreen(labelText: "Until",),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.02,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.8,
                              height: MediaQuery.of(context).size.height * 0.06,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).push(PageRouteBuilder(
                                    pageBuilder: (context, animation, secondaryAnimation) => Schedule3(),
                                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                      return SlideTransition(
                                        position: Tween<Offset>(
                                          begin: const Offset(1.0, 0.0), // Mulai dari kiri
                                          end: Offset.zero,
                                        ).animate(animation),
                                        child: child,
                                      );
                                    },
                                  ));
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF225477),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text(
                                  "Apply",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ), // Spasi
                ],
              ),
            );
          },
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
            Container(
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
            GestureDetector(
              onTap: () {scheduleTrain2(context);},
              child: SizedBox(
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
                    Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.6,
                            height: MediaQuery.of(context).size.height * 0.05,
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Schedule",
                                  style: TextStyle(fontSize: 16, color: Color.fromARGB(89, 0, 0, 0)),
                                ),
                                Text(
                                  "Select Train Schedule",
                                  style: TextStyle(fontSize: 17, color: Colors.black),
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
            ),
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