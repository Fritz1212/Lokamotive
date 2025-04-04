import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lokamotive/pages/schedule2LRTFrom.dart';
import 'package:lokamotive/pages/schedule5LRT.dart';
import 'schedule2.dart' as schedule2;

class Schedule2LRTTo extends StatefulWidget {
  final String selectedStation;
  final Function(String) updateSearchQuery;
  final String scheduleText;

  const Schedule2LRTTo({
    Key? key,
    required this.selectedStation,
    required this.updateSearchQuery,
    required this.scheduleText,
  }) : super(key: key);

  @override
  _Schedule3State createState() => _Schedule3State();
}

class _Schedule3State extends State<Schedule2LRTTo> {
  String selectedSchedule = "Select Train Schedule";

  void updateSchedule(String scheduleText) {
    setState(() {
      selectedSchedule = scheduleText;
    });
  }

  List<String> stationNames = [];
  String selectedStation = "Destination Station";
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    loadStations();
    GlobalSchedule2.deptStation = widget.selectedStation;
  }

  void updateSearchQuery(String query) {
    setState(() {
      searchQuery = query;
    });
  }

  Future<void> loadStations() async {
    // Load the JSON file
    String data = await rootBundle.loadString('assets/scheduleDataLRT.json');
    List<dynamic> jsonData = json.decode(data);

    Set<String> uniqueStations = Set();

    for (var schedule in jsonData) {
      uniqueStations.add(schedule['from']);
      uniqueStations.add(schedule['to']);
    }

    setState(() {
      stationNames = uniqueStations.toList();
    });
  }

  List<String> getFilteredStations() {
    if (searchQuery.isEmpty) {
      return stationNames;
    }
    return stationNames
        .where((station) =>
            station.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
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
                schedule2.TopFunc(),
                SearchSchedule(
                  selectedStation: selectedStation,
                  onSearchQueryChanged: updateSearchQuery,
                  onScheduleUpdated: '',
                ),
                ReturnButton(),
              ],
            )),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: ListView.builder(
                padding: const EdgeInsets.all(30.0),
                itemCount: getFilteredStations().length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedStation = getFilteredStations()[
                            index]; // Perbarui selectedStation
                      });
                    },
                    child: TrainContainer(text: getFilteredStations()[index]),
                  );
                },
              ),
            ),
          ],
        ));
  }
}

class GlobalSchedule2 {
  static String destStation = "";
  static String deptStation = "";
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
                    Schedule2LRTFrom(),
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

class SearchSchedule extends StatefulWidget {
  final String selectedStation;
  final Function(String) onSearchQueryChanged;
  final String onScheduleUpdated;
  final bool isReadOnly;

  const SearchSchedule({
    required this.selectedStation,
    required this.onSearchQueryChanged,
    required this.onScheduleUpdated,
    this.isReadOnly = false,
    Key? key,
  }) : super(key: key);

  @override
  _SearchScheduleState createState() => _SearchScheduleState();
}

class _SearchScheduleState extends State<SearchSchedule> {
  TimeOfDay? selectedTimeFrom;
  TimeOfDay? selectedTimeUntil;
  late TextEditingController _stationController;
  int _selectedValue = -1;
  String scheduleText = "Select Train Schedule";

  String getScheduleText() {
    if (_selectedValue == -1) {
      return "Select Train Schedule";
    } else if (_selectedValue == 0) {
      return "1 Today";
    } else if (_selectedValue == 1) {
      if (selectedTimeFrom != null && selectedTimeUntil != null) {
        return "Set Your Own Schedule: From ${selectedTimeFrom!.format(context)} Until ${selectedTimeUntil!.format(context)}";
      } else {
        return "Set Your Own Schedule";
      }
    } else {
      return "Select Train Schedule";
    }
  }

  @override
  void initState() {
    super.initState();
    _stationController = TextEditingController(text: widget.selectedStation);
    _selectedValue = -1;
  }

  @override
  void didUpdateWidget(SearchSchedule oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedStation != widget.selectedStation) {
      _stationController.text = widget.selectedStation;
    }
  }

  @override
  void dispose() {
    _stationController.dispose();
    super.dispose();
  }

  void scheduleTrain2(BuildContext context) {
    if (widget.isReadOnly) return;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.35,
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.2,
                    height: 5,
                    child: const Divider(
                      color: Color.fromARGB(64, 0, 0, 0),
                      thickness: 1,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
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
                            SizedBox(
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
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.black),
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
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.02,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.8,
                              height: MediaQuery.of(context).size.height * 0.06,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.35,
                                    child: TimePickerScreen(
                                      labelText: "From",
                                      onTimeSelected: (time) {
                                        setModalState(() {
                                          selectedTimeFrom = time;
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.35,
                                    child: TimePickerScreen(
                                      labelText: "Until",
                                      onTimeSelected: (time) {
                                        setModalState(() {
                                          selectedTimeUntil = time;
                                        });
                                      },
                                    ),
                                  ),
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
                                onPressed: (widget.selectedStation !=
                                            "Destination Station" &&
                                        (_selectedValue == 0 ||
                                            (_selectedValue == 1 &&
                                                selectedTimeFrom != null &&
                                                selectedTimeUntil != null)))
                                    ? () {
                                        setState(() {
                                          _selectedValue = _selectedValue;
                                          selectedTimeFrom = selectedTimeFrom;
                                          selectedTimeUntil = selectedTimeUntil;
                                        });
                                        setModalState(() {
                                          scheduleText = getScheduleText();
                                        });
                                        Navigator.of(context)
                                            .push(PageRouteBuilder(
                                          pageBuilder: (context, animation,
                                                  secondaryAnimation) =>
                                              Schedule5LRT(
                                                  destStation:
                                                      widget.selectedStation),
                                          transitionsBuilder: (context,
                                              animation,
                                              secondaryAnimation,
                                              child) {
                                            return SlideTransition(
                                              position: Tween<Offset>(
                                                begin: const Offset(1.0, 0.0),
                                                end: Offset.zero,
                                              ).animate(animation),
                                              child: child,
                                            );
                                          },
                                        ));
                                      }
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF225477),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text(
                                  "Apply",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
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
                topRight: Radius.circular(15)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 5,
                spreadRadius: 0,
                offset: const Offset(0, 4),
              )
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.75,
              height: MediaQuery.of(context).size.height * 0.07,
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
                                ])),
                        Container(
                            width: MediaQuery.of(context).size.width * 0.6,
                            height: MediaQuery.of(context).size.height * 0.03,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: TextEditingController(
                                          text: widget.selectedStation),
                                      readOnly: widget.isReadOnly,
                                      focusNode: widget.isReadOnly
                                          ? AlwaysDisabledFocusNode()
                                          : null,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                      ),
                                      style: const TextStyle(
                                          fontSize: 17, color: Colors.black),
                                    ),
                                  ),
                                ])),
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
                onTap: () {
                  scheduleTrain2(context);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.75,
                  height: MediaQuery.of(context).size.height * 0.07,
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
                            SizedBox(
                                width: MediaQuery.of(context).size.width * 0.6,
                                height:
                                    MediaQuery.of(context).size.height * 0.07,
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Schedule",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Color.fromARGB(89, 0, 0, 0)),
                                      ),
                                      Text(
                                        widget.onScheduleUpdated.isNotEmpty
                                            ? widget.onScheduleUpdated
                                            : getScheduleText(),
                                        style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ])),
                          ],
                        ),
                      )
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
