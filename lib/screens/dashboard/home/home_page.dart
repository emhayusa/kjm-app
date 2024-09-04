import 'package:flutter/material.dart';
import 'package:kjm_security/screens/dashboard/home/buku_tamu/main.dart';
import 'package:kjm_security/screens/dashboard/home/clock.dart';
import 'package:kjm_security/screens/dashboard/home/greeting.dart';
import 'package:kjm_security/screens/dashboard/home/item_kategori.dart';
import 'package:kjm_security/screens/dashboard/home/kunjungan/main.dart';
import 'package:kjm_security/screens/dashboard/home/laporan/main.dart';
import 'package:kjm_security/screens/dashboard/home/lembur/main.dart';
import 'package:kjm_security/screens/dashboard/home/paket/main.dart';
import 'package:kjm_security/screens/dashboard/home/parkir/main.dart';
import 'package:kjm_security/screens/dashboard/home/patroli/main.dart';
import 'package:kjm_security/screens/dashboard/home/presensi/main.dart';
import 'package:kjm_security/screens/dashboard/home/top_background.dart';
import 'package:kjm_security/screens/dashboard/home/wi/main.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    //double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("KJM SECURITY - SATPAM"),
        backgroundColor: Colors.blue[300],
        centerTitle: true,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          ClipPath(
            clipper: TopBackground(),
            child: Container(
              height: 130,
              width: screenWidth,
              color: Colors.blue[300],
            ),
          ),
          Column(
            children: [
              Greeting(),
              SizedBox(
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.only(right: 20),
                    width: 60,
                    height: 40,
                    child: Image.asset("assets/icons/schedule.png"),
                  ),
                  const MyClock()
                ],
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFdedefc),
                      Color(0xFFe3e3e3),
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PresensiMenu()),
                            );
                          },
                          child: ItemKategori(
                            title: "Presensi\n",
                            icon: "assets/icons/presensi.png",
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LemburMenu()),
                            );
                          },
                          child: ItemKategori(
                            title:
                                "Lembur\n", // (Jenis (Backup,Penebalan), Lokasi Site, dan Keterangan (Sakit, Ijin, Tanpa Keterangan, Lain2), Nama yang diganti)
                            icon: "assets/icons/lembur.png",
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MainPatroli()),
                            );
                          },
                          child: ItemKategori(
                            title: "Patroli\n",
                            icon: "assets/icons/patroli.png",
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            // Get.toNamed(Routes.DATA)
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => WorkingInstruction()),
                            );
                          },
                          child: ItemKategori(
                            title: "WI",
                            icon: "assets/icons/delivery.png",
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            //Get.toNamed(Routes.TANYA)
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MainParkir()),
                            );
                          },
                          child: ItemKategori(
                            title: "Parkir",
                            icon: "assets/icons/parking.png",
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            //Get.toNamed(Routes.TANYA)
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MainKejadian()),
                            );
                          },
                          child: ItemKategori(
                            title: "Laporan",
                            icon: "assets/icons/kejadian.png",
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            //Get.toNamed(Routes.TANYA)
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const KunjunganMain()),
                            );
                          },
                          child: ItemKategori(
                            title: "Kunjungan",
                            icon: "assets/icons/supervisor.png",
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            //Get.toNamed(Routes.DINAS)
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PaketMain()),
                            );
                          },
                          child: ItemKategori(
                            title: "Paket",
                            icon: "assets/icons/activity.png",
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            //Get.toNamed(Routes.SERVICES)
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const BukuTamuMain()),
                            );
                          },
                          child: ItemKategori(
                            title: "Buku \nTamu",
                            icon: "assets/icons/book.png",
                          ),
                        ),
                        /*InkWell(
                            onTap: () {
                              // Get.toNamed(Routes.DATA)
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Kehadiran()),
                              );
                            },
                            child: ItemKategori(
                              title: "Kehadiran",
                              icon: "assets/icons/news.png",
                            ),
                          ),*/
                      ],
                    ),
                    /*
                      SizedBox(height: 20),
                      */
                    /*
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          /*InkWell(
                            onTap: () {
                              //Get.toNamed(Routes.TANYA)
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Kejadian()),
                              );
                            },
                            child: ItemKategori(
                              title: "Pesan",
                              icon: "assets/icons/message.png",
                            ),
                          ),*/

                          /*InkWell(
                            onTap: () {
                              //Get.toNamed(Routes.SOS)
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Sos()),
                              );
                            },
                            child: ItemKategori(
                              title: "SOS",
                              icon: "assets/icons/sos.png",
                            ),
                          ),
                          */
                        ],
                      ),*/
                    //SizedBox(height: 20),
                    /*
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              //Get.toNamed(Routes.TANYA)
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Lokasi()),
                              );
                            },
                            child: ItemKategori(
                              title: "Kendaraan",
                              icon: "assets/icons/delivery.png",
                            ),
                          ),
                        ],
                      ),*/
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  width: screenWidth * 0.7,
                  height: screenWidth * 0.7,
                  child: Image.asset("assets/images/logo_kjm_small.png"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
