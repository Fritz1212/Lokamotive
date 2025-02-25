import 'package:flutter/material.dart';

class Tes extends StatelessWidget {
  const Tes({super.key});

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
            ),
          ),
          SizedBox(height: 40),
          Expanded(
            flex: 2,
            child: ListTrain()
          ),
        ],
      ),
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
          bottomRight: Radius.circular(70),
        ),
      ),
    );
  }
}

class ReturnButton extends StatelessWidget {
  const ReturnButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.05,
      left: MediaQuery.of(context).size.width * 0.05,
      child: SizedBox(
        width: 50,
        height: 50,
        child: Image.asset("assets/Semua Button.png"),
      ),
    );
  }
}

class SearchSchedule extends StatelessWidget {
  const SearchSchedule({super.key});

  @override
  Widget build(BuildContext context) { 
    double width = MediaQuery.of(context).size.width * 0.85;
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.15,
      left: MediaQuery.of(context).size.width * 0.075,
      child: Container(
        width: width,
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 5,
              spreadRadius: 0,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Image.asset("assets/Vector.png", width: 30, height: 30),
                const SizedBox(width: 20),
                const Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Departure Station",
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(),
            Row(
              children: [
                Image.asset("assets/Vector(1).png", width: 30, height: 30),
                const SizedBox(width: 20),
                const Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Select Train Schedule",
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
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
    return ListView(
      padding: const EdgeInsets.all(30.0),
      children: [
        trainTile("PESING"),
        trainTile("PALMERAH"),
        trainTile("JAKARTA KOTA"),
        trainTile("MANGGARAI"),
        trainTile("BOGOR"),
        trainTile("DEPOK"),
        trainTile("PARUNG PANJANG"),
        trainTile("PASAR MINGGU"),
        trainTile("PASAR MINGGU"),
        trainTile("PASAR MINGGU"),
        trainTile("PASAR MINGGU"),
      ],
    );
  }

  Widget trainTile(String station) {
    return Column(
      children: [
        Row(
          children: [
            Image.asset("assets/Vector.png", width: 24, height: 40),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                station,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
        const Divider(),
      ],
    );
  }
}
