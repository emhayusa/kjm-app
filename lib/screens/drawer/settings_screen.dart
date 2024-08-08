import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    //_navigateToNextScreen();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white, // Adjust background color as needed
      body: Stack(
        children: [
          Image.asset(
            'assets/images/BG_Bakery.png', // Replace with your logo path
            // Adjust height as needed
            width: screenWidth,
            height: screenHeight,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/Ngupahan_Logo.png', // Replace with your logo path
                  width: 130, // Adjust width as needed
                  height: 130, // Adjust height as needed
                ),
                const Text(
                  "Reducing Food Waste",
                  style: TextStyle(fontSize: 12),
                ),
                const Text(
                  "Increasing Food Security",
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
