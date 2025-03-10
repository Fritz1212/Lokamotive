import 'package:flutter/material.dart';
import 'edit_profile_page.dart';
import 'navbar.dart';
import 'dashboard_page.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:flutter_js/flutter_js.dart';
import 'dart:io';
import 'RoutePage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String profileName = GlobalData.userName;
  String profileEmail = GlobalData.email;
  File? profileImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Builder(builder: (context) {
        return Directionality(
          textDirection: TextDirection.ltr,
          child: Column(
            children: [
              _buildProfileHeader(context),
              const Spacer(),
            ],
          ),
        );
      })),
      bottomNavigationBar: BottomNavbar(
        selectedIndex: 2, // Set the current index to 2 for the profile page
        onItemTapped: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => DashboardPage(
                      email: GlobalData.email,
                      userName: GlobalData.userName,
                      onNameChanged: (newName) {
                        setState(() {
                          profileName = newName;
                        });
                      })),
            );
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      RoutePage()), // Replace with your RoutePage
            );
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage()),
            );
          }
        },
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(5.0),
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.3,
            decoration: const BoxDecoration(
              color: Color(0xFF102E48),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(150, 16, 46, 72),
                  blurRadius: 15,
                  spreadRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
          ),
          Column(
            children: [
              const SizedBox(
                  // width: MediaQuery.of(contex).size.width * 0.85,
                  //
                  ),
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  // Foto profile
                  Transform.translate(
                    offset: const Offset(0, 134),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 30),
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 40),
                          Text(
                            profileName,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            profileEmail,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Divider(
                            color: Color(0xffFFFFFF),
                            thickness: 1.5,
                            height: 1,
                          ),
                          const SizedBox(height: 10),
                          _buildProfileOption('Edit Profile', () async {
                            final updatedData =
                                await Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const EditProfilePage()),
                            );
                            if (updatedData != null) {
                              setState(() {
                                // Perbarui data hanya jika ada yang berubah
                                if (updatedData.containsKey('name')) {
                                  profileName = updatedData['name'];
                                }
                                if (updatedData.containsKey('email')) {
                                  profileEmail = updatedData['email'];
                                }
                                if (updatedData.containsKey('profileImage')) {
                                  profileImage = updatedData['profileImage'];
                                }
                              });
                            }
                          }),
                          _buildProfileOption(
                            'Edit Transportation Preference',
                            () => print('Edit Transportation tapped'),
                          ),
                          _buildProfileOption(
                            'Change Password',
                            () => print('Change Password tapped'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    // top: MediaQuery.of(context).size.height * 0.32,
                    top: 40,
                    width: MediaQuery.of(context).size.width * 0.32,
                    height: MediaQuery.of(context).size.height * 0.15,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: const Color(0xff365D93),
                      backgroundImage: profileImage != null
                          ? FileImage(profileImage!)
                          : null,
                      // backgroundImage: AssetImage('assets/profile_image.jpg'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileOption(String title, VoidCallback onTap) {
    return Material(
      color: const Color.fromARGB(
          0, 255, 255, 255), // Pastikan transparan agar efek ripple terlihat
      child: InkWell(
        onTap: onTap,
        borderRadius:
            BorderRadius.circular(8), // Untuk animasi ripple lebih rapi
        child: Container(
          height: 100,
          padding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 16,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: const Color.fromARGB(
                0, 255, 255, 255), // Untuk tampilan lebih jelas
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }

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
  //         _buildNavItem("assets/Icon/home_icon.svg", false),
  //         _buildNavItem("assets/Icon/route_icon.svg", false),
  //         _buildNavItem("assets/Icon/person_icon.svg", true),
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
