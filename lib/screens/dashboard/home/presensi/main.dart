import 'package:flutter/material.dart';
import 'package:kjm_security/screens/dashboard/home/presensi/izin/main.dart';
import 'package:kjm_security/screens/dashboard/home/presensi/off/main.dart';
import 'package:kjm_security/screens/dashboard/home/presensi/presensi/main.dart';
import 'package:kjm_security/screens/dashboard/home/presensi/sakit/main.dart';

class PresensiMenu extends StatefulWidget {
  const PresensiMenu({super.key});

  @override
  State<PresensiMenu> createState() => _PresensiMenuState();
}

class _PresensiMenuState extends State<PresensiMenu> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Menu Presensi'),
          centerTitle: true,
        ),
        body: GridView.builder(
          itemCount: 4,
          padding: const EdgeInsets.all(20),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
          ),
          itemBuilder: (context, index) {
            late String title;
            late IconData icon;
            late VoidCallback onTap;

            switch (index) {
              case 0:
                title = "Presensi Reguler";
                icon = Icons.access_alarm_outlined;
                onTap = () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MainKehadiran()),
                  );
                };
                break;
              case 1:
                title = "Izin";
                icon = Icons.calendar_today_outlined;
                onTap = () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MainIzin()),
                  );
                };
                break;
              case 2:
                title = "Off";
                icon = Icons.mobile_off_outlined;
                onTap = () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MainOff()),
                  );
                };
                break;
              case 3:
                title = "Sakit";
                icon = Icons.local_hospital_outlined;
                onTap = () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MainSakit()),
                  );
                };
                break;
            }

            return Material(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(9),
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(9),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 50,
                      height: 50,
                      child: Icon(icon, size: 50),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          },
        ));
  }
}
