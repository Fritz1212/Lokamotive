import 'package:flutter/material.dart';
import 'package:flutter_application_1/animated_text_dashboard.dart';
import 'package:flutter_application_1/history_travel_dashboard.dart';
import 'package:flutter_application_1/navbar.dart';
import 'package:flutter_application_1/news_carousel.dart';
import 'package:flutter_application_1/profile_page.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:io'; 

class DashboardPage extends StatefulWidget {
  final String userName;
  final ValueChanged<String> onNameChanged;
  const DashboardPage({
    Key? key,
    required this.userName,
    required this.onNameChanged,
  }) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  File? profileImage;
  String currentLocation = "Detecting location...";
  List<String> travelHistory = []; // Empty for demonstration
  final List<Map<String, String>> newsItems = [
    {
      'image': 'assets/Image/news_carousel1.png',
      'title': 'New Train Schedule Update',
    },
    {
      'image': 'assets/Image/news_carousel2.png',
      'title': 'Track Maintenance Notice',
    },
    // Add more news items
  ];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            currentLocation = "Location permissions denied";
          });
          return;
        }
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.best),
      );

      // Get place name from coordinates
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        setState(() {
          currentLocation = placemarks[0].subAdministrativeArea ?? "Unknown location";
        });
      } else{
        setState(() {
          currentLocation = "Unknown location";
        });
      }
    } catch (e) {
      setState(() {
        currentLocation = "Failed to get location";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              NewsCarousel(newsItems: newsItems),
              _buildWelcomeSection(),
              TravelHistory(),
            ],
          ),
        ),
      ),
      // bottomNavigationBar: _buildBottomNavigationBar(context),
      bottomNavigationBar: BottomNavbar(
        selectedIndex: 0,
        onItemTapped: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => DashboardPage(userName: widget.userName, onNameChanged: widget.onNameChanged)),
            );
          } else if (index == 1) {
            // Navigator.pushReplacement(
            //   context,
            //   MaterialPageRoute(builder: (context) => RoutePage()), // Replace with your RoutePage
            // );
            print('Route Page');
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage()), // Replace with your ProfilePage
            );
          }
        },
      )
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: const Color(0xff365D93),
                backgroundImage:
                    profileImage != null ? FileImage(profileImage!) : null,
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.location_on,
                        color: Color(0xff102E48), size: 16),
                    const SizedBox(width: 4),
                    Text(
                      currentLocation,
                      style: const TextStyle(
                        color: Color(0xff102E48),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Bagian animasi teks
          AnimatedGreetingText(username: widget.userName),
          const Text(
            'Let\'s start your journey!',
            style: TextStyle(
              fontSize: 20,
              color: Color(0xff000000),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 20, 16, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Select Menu",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xff102E48), // Warna navy
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMenuButton(
                'Check Schedule',
                "assets/Icon/check_schedule_icon.svg",
                () => print('Check Schedule'),
              ),
              _buildMenuButton(
                'Find Route',
                "assets/Icon/find_route_icon.svg",
                () => print('Find Route'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuButton(String title, String iconPath, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: SvgPicture.asset(
              iconPath,
              width: 50,
              height: 50,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }


  // Widget _buildHistorySection() {
  //   return Container(
  //     padding: const EdgeInsets.all(16),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         const Text(
  //           'Go Again',
  //           style: TextStyle(
  //             fontSize: 18,
  //             fontWeight: FontWeight.bold,
  //           ),
  //         ),
  //         const SizedBox(height: 16),
  //         travelHistory.isEmpty
  //             ? _buildEmptyHistory()
  //             : Column(
  //                 children: [
  //                   _buildHistoryItem('Rumah Talenta BCA'),
  //                   _buildHistoryItem('BCA Learning Institute'),
  //                   _buildHistoryItem('Aeon Mall Sentul'),
  //                 ],
  //               ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildEmptyHistory() {
  //   return Container(
  //     padding: const EdgeInsets.all(24),
  //     decoration: BoxDecoration(
  //       color: Colors.grey[100],
  //       borderRadius: BorderRadius.circular(12),
  //     ),
  //     child: const Column(
  //       children: [
  //         Icon(Icons.history, size: 48, color: Colors.grey),
  //         SizedBox(height: 16),
  //         Text(
  //           'No travel history yet',
  //           style: TextStyle(
  //             fontSize: 16,
  //             color: Colors.grey,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildHistoryItem(String destination) {
  //   return Container(
  //     margin: const EdgeInsets.only(bottom: 12),
  //     padding: const EdgeInsets.all(16),
  //     decoration: BoxDecoration(
  //       border: Border.all(color: Colors.orange),
  //       borderRadius: BorderRadius.circular(12),
  //     ),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Text(
  //           destination,
  //           style: const TextStyle(
  //             fontSize: 16,
  //             fontWeight: FontWeight.w500,
  //           ),
  //         ),
  //         const Icon(Icons.arrow_forward_ios, size: 16),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildBottomNavigationBar(BuildContext context) {
  //   return Container(
  //     height: MediaQuery.of(context).size.height * 0.075,
  //     decoration: BoxDecoration(
  //       color: Color(0xff102E48),
  //       borderRadius: const BorderRadius.only(
  //         topLeft: Radius.circular(15),
  //         topRight: Radius.circular(15),
  //       ),
  //     ),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceAround,
  //       children: [
  //         _buildNavItem("assets/Icon/home_icon.svg", true),
  //         _buildNavItem("assets/Icon/route_icon.svg", false),
  //         _buildNavItem("assets/Icon/person_icon.svg", false),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildNavItem(String iconPath, bool isSelected) {
  //   return SvgPicture.asset(
  //     iconPath,
  //     colorFilter: ColorFilter.mode(
  //       isSelected ? Color(0xFFF28A33) : Color(0xffFFFFFF),
  //       BlendMode.srcIn,
  //     ), 
  //     width: 30,
  //     height: 32,
  //   );
  // }
}