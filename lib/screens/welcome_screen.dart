import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:kjm_security/widgets/custom_button.dart';
import 'package:kjm_security/widgets/custom_button_nofill.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  String _appVersion = '';
  AppUpdateInfo? _updateInfo;

  @override
  void initState() {
    super.initState();
    _fetchAppVersion();
    _checkForUpdate();
  }

  Future<void> _fetchAppVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      setState(() {
        _appVersion = packageInfo.version;
      });
    } catch (e) {
      _showSnackBar("Error fetching app version: $e");
    }
  }

  Future<void> _checkForUpdate() async {
    try {
      final AppUpdateInfo updateInfo = await InAppUpdate.checkForUpdate();
      setState(() {
        _updateInfo = updateInfo;
      });

      if (_updateInfo?.updateAvailability ==
          UpdateAvailability.updateAvailable) {
        _showUpdateModal();
      }
    } catch (e) {
      _showSnackBar("Error checking for update: $e");
    }
  }

  void _showUpdateModal() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Update Available',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                'A new version of the app is available. Please update to the latest version.',
              ),
              const SizedBox(height: 16),
              CustomButton(
                text: 'Update',
                onPressed: () async {
                  Navigator.pop(context);
                  if (_updateInfo?.updateAvailability ==
                      UpdateAvailability.updateAvailable) {
                    try {
                      await InAppUpdate.performImmediateUpdate();
                    } catch (e) {
                      _showSnackBar("Error performing update: $e");
                    }
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(children: [
        Column(
          children: <Widget>[
            Image.asset(
              'assets/images/MaskGroup.png', // Replace with your logo path
              // Adjust height as needed
              width: screenWidth,
              height: screenHeight / 2,
              fit: BoxFit.fill,
            ),
            const SizedBox(
              height: 120,
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomButton(
                text: 'Login',
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomButtonNoFill(
                text: 'Register',
                onPressed: () {
                  Navigator.pushNamed(context, '/register');
                },
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomButtonNoFill(
                text: 'Activation',
                onPressed: () {
                  Navigator.pushNamed(context, '/activation');
                },
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Version: $_appVersion',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
        Center(
          child: Image.asset(
            'assets/images/LogoNgupahan.png', // Replace with your logo path
            width: 130, // Adjust width as needed
            height: 130, // Adjust height as needed
          ),
        )
      ]),
    );
  }
}
