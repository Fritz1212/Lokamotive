import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import '../pages/routes_page.dart';
// import 'profile_page.dart';

class BottomNavbar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const BottomNavbar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.075,
      decoration: const BoxDecoration(
        color: Color(0xff102E48),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem("assets/Icon/home_icon.svg", 0, context),
          _buildNavItem("assets/Icon/route_icon.svg", 1, context),
          _buildNavItem("assets/Icon/person_icon.svg", 2, context),
        ],
      ),
    );
  }

  Widget _buildNavItem(String iconPath, int index, BuildContext context) {
    bool isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () => onItemTapped(index),
      child: SvgPicture.asset(
        iconPath,
        colorFilter: ColorFilter.mode(
          isSelected ? const Color(0xFFF28A33) : const Color(0xffFFFFFF),
          BlendMode.srcIn,
        ),
        width: 30,
        height: 32,
      ),
    );
  }
}
