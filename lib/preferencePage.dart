import 'package:flutter/material.dart';

class TransportationPreferenceScreen extends StatefulWidget {
  @override
  _TransportationPreferenceScreenState createState() =>
      _TransportationPreferenceScreenState();
}

class _TransportationPreferenceScreenState
    extends State<TransportationPreferenceScreen> {
  final List<String> transportationImages = [
    'assets/Preferred Trans (2).png',
    'assets/Preferred Trans (3).png',
    'assets/Preferred Trans (4).png',
    'assets/Preferred Trans (5).png',
  ];

  Set<int> selectedIndexes = {}; // Menyimpan index gambar yang dipilih

  void toggleSelection(int index) {
    setState(() {
      if (selectedIndexes.contains(index)) {
        selectedIndexes.remove(index); // Jika sudah dipilih, hapus dari set
      } else {
        selectedIndexes.add(index); // Jika belum dipilih, tambahkan ke set
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.grey[800],
        title: Text(
          "Transportation Preference",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Choose\nPreferred\nTransportation",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: transportationImages.length,
                itemBuilder: (context, index) {
                  bool isSelected = selectedIndexes.contains(index);
                  return GestureDetector(
                    onTap: () => toggleSelection(index),
                    child: Container(
                      decoration: BoxDecoration(
                        border: isSelected
                            ? Border.all(
                                color: Color(0xFFF28A33),
                                width: 5) // Border kuning
                            : null, // Tidak ada border jika tidak dipilih
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          transportationImages[index],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            Text(
              "*You can change your preference later",
              style: TextStyle(fontSize: 12, color: Colors.black),
            ),
            SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                onPressed: () {
                  // Jika tidak ada yang dipilih, tetap bisa lanjut
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF225477),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  selectedIndexes.isNotEmpty ? "Submit" : "Skip",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
