import 'package:flutter/material.dart';

class RiwayatPemberianSampahTab extends StatelessWidget {
  const RiwayatPemberianSampahTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            BackButton(
              onPressed: () {
                Navigator.pushNamed(
                    context, '/home'); // Navigate to the dashboard route
              },
            ),
            const Expanded(
              child: Center(
                child: Text(
                  "Riwayat Pembelian Sampah",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            /*
            IconButton(
              icon: Icon(Icons.filter_list),
              onPressed: () {
                // Filter button action
              },
            ),
            */
          ],
        ),
        const Expanded(
          child: Center(
            child: Text(
              "Coming Soon",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D2D2D)),
            ),
          ),
        ),
      ],
    );
  }
}
