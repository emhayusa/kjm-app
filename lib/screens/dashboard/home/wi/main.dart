import 'package:flutter/material.dart';
import 'package:kjm_app/screens/dashboard/home/wi/bagasi/main.dart';
import 'package:kjm_app/screens/dashboard/home/wi/body/main.dart';
import 'package:kjm_app/screens/dashboard/home/wi/inbound/main.dart';
import 'package:kjm_app/screens/dashboard/home/wi/linehaul/main.dart';
import 'package:kjm_app/screens/dashboard/home/wi/loker/main.dart';
import 'package:kjm_app/screens/dashboard/home/wi/outbound/main.dart';
import 'package:kjm_app/screens/dashboard/home/wi/sampah/main.dart';

class WorkingInstruction extends StatefulWidget {
  const WorkingInstruction({super.key});

  @override
  State<WorkingInstruction> createState() => _WorkingInstructionState();
}

class _WorkingInstructionState extends State<WorkingInstruction> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Working Instruction'),
          centerTitle: true,
        ),
        body: GridView.builder(
          itemCount: 7,
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
                title = "Pengecekan Sampah";
                icon = Icons.landslide;
                onTap = () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ListSampahScreen()),
                  );
                };
                break;
              case 1:
                title = "Kendaraan \nInbound";
                icon = Icons.fire_truck;
                onTap = () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ListInbound()),
                  );
                };
                break;
              case 2:
                title = "Cek Body";
                icon = Icons.person;
                onTap = () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ListBodyScreen()),
                  );
                };
                break;
              case 3:
                title = "Kendaraan \nOutbound";
                icon = Icons.fire_truck_outlined;
                onTap = () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ListOutbound()),
                  );
                };
                break;
              case 4:
                title = "Cek Bagasi";
                icon = Icons.car_repair;
                onTap = () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ListBagasi()),
                  );
                };
                break;
              case 5:
                title = "Kendaraan \nLinehaul";
                icon = Icons.fire_truck_rounded;
                onTap = () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ListInhaul()),
                  );
                };
                break;
              case 6:
                title = "Cek Loker";
                icon = Icons.fact_check_outlined;
                onTap = () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ListLoker()),
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
