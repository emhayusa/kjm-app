import 'package:flutter/material.dart';
import 'package:kjm_app/screens/dashboard/kompos/custom_tab.dart';
import 'package:kjm_app/screens/dashboard/kompos/riwayat_pembelian_sampah.dart';
import 'package:kjm_app/screens/dashboard/kompos/riwayat_pemberian_sampah.dart';
import 'package:kjm_app/widgets/custom_button.dart';

class KomposPage extends StatefulWidget {
  const KomposPage({super.key});

  @override
  State<KomposPage> createState() => _KomposPageState();
}

class _KomposPageState extends State<KomposPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              const TabBar(
                tabs: [
                  CustomTab(
                    iconPath: 'assets/images/beri_sampah.png',
                    text: 'Pemberian\nSampah',
                  ),
                  CustomTab(
                    iconPath: 'assets/images/beli_sampah.png',
                    text: 'Pembelian\nKompos',
                  ),
                ],
                labelColor: Colors.black, // Tab label color
                unselectedLabelColor: Colors.grey, // Unselected tab label color
              ),

              const Expanded(
                child: TabBarView(
                  children: [
                    RiwayatPemberianSampahTab(),
                    RiwayatPembelianSampahTab(),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: CustomButton(
                  onPressed: () {
                    //Navigator.pushNamed(context, '/composer');
                  },
                  text: "Request Pickup Sampah",
                ),
              ), // Add space between TabBarView and ElevatedButton
            ],
          ),
        ),
      ),
    );
  }
}
