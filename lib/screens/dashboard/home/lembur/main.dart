import 'package:flutter/material.dart';
import 'package:kjm_security/screens/dashboard/home/lembur/backup/main.dart';
import 'package:kjm_security/screens/dashboard/home/lembur/lembur/main.dart';

class LemburMenu extends StatefulWidget {
  const LemburMenu({super.key});

  @override
  State<LemburMenu> createState() => _LemburMenuState();
}

class _LemburMenuState extends State<LemburMenu> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Menu Lembur'),
          centerTitle: true,
        ),
        body: GridView.builder(
          itemCount: 2,
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
                title = "Lembur";
                icon = Icons.group_add_outlined;
                onTap = () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MainLembur()),
                  );
                };
                break;
              case 1:
                title = "Backup";
                icon = Icons.group_outlined;
                onTap = () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MainBackup()),
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
