import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:kjm_app/model/cekBox.model.dart';
import 'package:kjm_app/screens/dashboard/home/wi/inbound/form_cek_inbound.dart';
import 'package:kjm_app/utils/image_loader.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class ListInbound extends StatefulWidget {
  const ListInbound({super.key});

  @override
  State<ListInbound> createState() => _ListInboundState();
}

class _ListInboundState extends State<ListInbound> {
  late DateTime selectedDate;
  bool isLoading = false;
  TextEditingController searchController = TextEditingController();
  List<CekBoxModel> datas = [];
  //  Tamu('1', 'Joko', 'PT. Katulampa', 'Divisi Sales', 'Promosi barang',
  //      '2023-05-16 08:00:00', '2023-05-16 08:23:00'),
  //  Tamu('2', 'Budi', 'Perorangan', 'Divisi HRD', 'Melamar pekerjaan',
  //     '2023-05-16 09:00:00', '-'),
  //];

  List<CekBoxModel> filteredDatas = [];

  //String apiUrl = 'https://geoportal.big.go.id/api-dev/check-points/kantor/';
  String apiUrl = 'https://satukomando.id/api-prod/cek-inbound/';
  String apiView = 'https://satukomando.id/api-prod/cek-/photoDatang/';

  @override
  void initState() {
    super.initState();
    fetchData();
    selectedDate = DateTime.now(); // Initialize selectedDate with current date
    // filteredTamus = tamus;
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
      //_uploadProgress = 0.0;
      //_image = null;
    });
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String user = prefs.getString('user') ?? '';
      var data = jsonDecode(user);
      //print(data['pegawai']['lokasi']['uuid']);
      // final response = await http.get(Uri.parse('$API_PROFILE/$userId'));
      var urlnya = apiUrl + "lokasi/" + data['pegawai']['lokasi']['uuid'];
      //print(urlnya);
      final response = await http.get(Uri.parse(urlnya),
          headers: {"x-access-token": data['accessToken']});
      if (response.statusCode == 200) {
        print(response.body);
        //print(json.decode(response.body));
        //final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

        //return parsed.map<Photo>((json) => Photo.fromJson(json)).toList();
        final List<dynamic> data = json.decode(response.body);
        // Create a list of model objects
        List<CekBoxModel> tamuList =
            data.map((json) => CekBoxModel.fromJson(json)).toList();

        //print(response.body);
        //print(json.decode(response.body));
        //final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

        print(tamuList.length);

        setState(() {
          datas = tamuList;
          filteredDatas = tamuList;
        });
      } else {
        print('Gagal mengambil data ');
      }
    } catch (e) {
      print('Terjadi kesalahan saat mengambil data: $e');
    }
    setState(() {
      isLoading = false;
      //_uploadProgress = 0.0;
      //_image = null;
    });
  }

  void filterTamus(String searchTerm) {
    setState(() {
      filteredDatas = datas
          .where((data) =>
              //permission.date
              //    .toLowerCase()
              //    .contains(searchTerm.toLowerCase()) ||
              data.noSurat.toLowerCase().contains(searchTerm.toLowerCase()))
          .toList();
    });
  }

  void navigateToFormKendaraan() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FormCekInbound()),
    );
    fetchData(); // Refresh the items when returning from the second widget
  }

  void handleRefresh() async {
    setState(() {
      datas = [];
    });
    fetchData(); // Refresh the items when returning from the second widget
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inbound'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: fetchData,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: TextFormField(
                controller: searchController,
                onChanged: filterTamus,
                decoration: InputDecoration(
                  labelText: 'Cari No Surat',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            Expanded(
              child: datas.isEmpty
                  ? isLoading
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : Center(
                          child: Text("tidak menemukan data"),
                        )
                  : filteredDatas.length == 0
                      ? Center(
                          child: Text("tidak menemukan data"),
                        )
                      : ListView.builder(
                          itemCount: filteredDatas.length,
                          itemBuilder: (BuildContext context, int index) {
                            CekBoxModel data = filteredDatas[index];
                            //print(data.waktuDatang);
                            //print(DateFormat("yyyy-MM-ddTHH:mm:ssZ")
                            //    .parseUTC(tamu.waktuDatang.toIso8601String()));
                            //print(DateFormat('dd MMM yyyy hh:mm:ss a')
                            //    .format(tamu.waktuDatang.toLocal()));
                            return Card(
                              margin: EdgeInsets.all(4.0),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListTile(
                                  leading: buildImageFromUrl(
                                      '$apiView/${data.uuid}', 50.0),
                                  title: Text('No Surat: ${data.noSurat}'),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          'Waktu Datang: ${DateFormat('dd MMM yyyy, hh:mm:ss a').format(data.waktuDatang.toLocal())}\nNo Polisi: ${data.noPolisi}\nNama Driver: ${data.namaDriver}'),
                                      data.waktuKabin == null
                                          ? ElevatedButton(
                                              onPressed: () {
                                                //Navigator.push(
                                                //  context,
                                                // MaterialPageRoute(
                                                //     builder: (context) =>
                                                //         FormBoxKabin(
                                                //              box: data,
                                                //              refreshListCallback:
                                                //                  fetchData)),
                                                //);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                //backgroundColor: AppColors.secondaryColor,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                              child: Text('Inbound Tahap 2'),
                                            )
                                          : SizedBox(),
                                      data.waktuBox == null
                                          ? ElevatedButton(
                                              onPressed: () {
                                                //Navigator.push(
                                                //  context,
                                                //  MaterialPageRoute(
                                                //      builder: (context) =>
                                                //          FormBoxBox(
                                                //              box: data,
                                                //              refreshListCallback:
                                                //                  fetchData)),
                                                //);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                //backgroundColor: AppColors.secondaryColor,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                              child: Text('Inbound Tahap 3'),
                                            )
                                          : SizedBox(),
                                    ],
                                  ),
                                  //trailing: Text(permission.date),
                                  onTap: () {
                                    //Navigator.push(
                                    //  context,
                                    //  MaterialPageRoute(
                                    //      builder: (context) => DetailCekBox(
                                    //            box: data,
                                    //          )),
                                    //);
                                  },
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
      floatingActionButton: SizedBox(
        width: 80,
        height: 80,
        child: FloatingActionButton(
          onPressed: navigateToFormKendaraan,
          tooltip: 'Tambah Cek Inbound',
          child: Icon(
            Icons.add,
            size: 60.0, // Increase the size of the icon if needed
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
