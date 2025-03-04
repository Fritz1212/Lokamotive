import 'package:flutter/material.dart';

class TravelHistory extends StatefulWidget {
  @override
  _TravelHistoryState createState() => _TravelHistoryState();
}

class _TravelHistoryState extends State<TravelHistory> {
  List<String> travelHistory = []; // List untuk menyimpan perjalanan pengguna

  // Tambahkan perjalanan baru
  void _addHistory(String destination) {
    setState(() {
      travelHistory.add(destination);
    });
  }

  // Hapus perjalanan tertentu
  void _removeHistory(int index) {
    setState(() {
      travelHistory.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Go Again',
            style: TextStyle(
              fontSize: 20,
              color: Color(0xff102E48),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        travelHistory.isEmpty ? _buildEmptyHistory() : _buildHistoryList(),
        SizedBox(height: 10),
        _buildAddHistoryButton(), // Tombol untuk menambahkan perjalanan manual
      ],
    );
  }

  // Widget jika tidak ada riwayat perjalanan
  Widget _buildEmptyHistory() {
    return Container(
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        children: [
          Icon(Icons.history, size: 48, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'No travel history yet',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  // Widget daftar riwayat perjalanan
  Widget _buildHistoryList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: travelHistory.length,
      itemBuilder: (context, index) {
        return _buildHistoryItem(travelHistory[index], index);
      },
    );
  }

  // Widget item history perjalanan
  Widget _buildHistoryItem(String destination, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.orange),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            destination,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _removeHistory(index),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ],
      ),
    );
  }

  // Tombol untuk menambahkan riwayat perjalanan
  Widget _buildAddHistoryButton() {
    return Center(
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(Color(0xffFBBD8A)),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        onPressed: () {
          _addHistory("New Destination ${travelHistory.length + 1}");
        },
        child: const Text(
          "Add History",
          style: TextStyle(
            color: Color(0xff102E48),
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
