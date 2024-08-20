import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kjm_app/model/inbound.dart';
import 'package:kjm_app/screens/dashboard/home/wi/inbound/form_cek_inbound.dart';
import 'package:kjm_app/screens/dashboard/home/wi/inbound/form_foto.dart';
import 'package:kjm_app/screens/dashboard/home/wi/inbound/form_tiga.dart';
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
  List<InboundModel> datas = [];
  //  Tamu('1', 'Joko', 'PT. Katulampa', 'Divisi Sales', 'Promosi barang',
  //      '2023-05-16 08:00:00', '2023-05-16 08:23:00'),
  //  Tamu('2', 'Budi', 'Perorangan', 'Divisi HRD', 'Melamar pekerjaan',
  //     '2023-05-16 09:00:00', '-'),
  //];

  List<InboundModel> filteredDatas = [];

  //String apiUrl = 'https://geoportal.big.go.id/api-dev/check-points/kantor/';
  String apiUrl = 'https://satukomando.id/api-prod/inbound/';
  String apiView = 'https://satukomando.id/api-prod/inbound/photo/';

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
        List<InboundModel> tamuList =
            data.map((json) => InboundModel.fromJson(json)).toList();

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
              data.namaSopir.toLowerCase().contains(searchTerm.toLowerCase()))
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
                            InboundModel data = filteredDatas[index];
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
                                  title: Text('No Surat: ${data.noSuratJalan}'),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          'Waktu Tiba: ${data.waktuTiba}\nNo Polisi: ${data.noPolisi}\nNama Sopir: ${data.namaSopir}'),
                                      data.waktu3 == null
                                          ? ElevatedButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          FormFoto(
                                                              data: data,
                                                              id: 3,
                                                              label:
                                                                  "Stopper Ban",
                                                              refreshListCallback:
                                                                  fetchData)),
                                                );
                                              },
                                              style: ElevatedButton.styleFrom(
                                                //backgroundColor: AppColors.secondaryColor,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                              child: Text('Foto Stopper Ban'),
                                            )
                                          : Text(
                                              'Waktu Stopper Ban: ${data.waktu3}'),
                                      data.waktu4 == null
                                          ? ElevatedButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          FormFoto(
                                                              data: data,
                                                              id: 4,
                                                              label:
                                                                  "Kabin Sopir",
                                                              refreshListCallback:
                                                                  fetchData)),
                                                );
                                              },
                                              style: ElevatedButton.styleFrom(
                                                //backgroundColor: AppColors.secondaryColor,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                              child: Text('Foto Kabin Sopir'),
                                            )
                                          : Text(
                                              'Waktu Kabin Sopir: ${data.waktu4}'),
                                      data.waktu5 == null
                                          ? ElevatedButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          FormFoto(
                                                              data: data,
                                                              id: 5,
                                                              label:
                                                                  "Rem tangan",
                                                              refreshListCallback:
                                                                  fetchData)),
                                                );
                                              },
                                              style: ElevatedButton.styleFrom(
                                                //backgroundColor: AppColors.secondaryColor,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                              child: Text('Foto Rem Tangan'),
                                            )
                                          : Text(
                                              'Waktu Rem Tangan: ${data.waktu5}'),
                                      data.waktu6 == null
                                          ? ElevatedButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          FormFoto(
                                                              data: data,
                                                              id: 6,
                                                              label: "Seal",
                                                              refreshListCallback:
                                                                  fetchData)),
                                                );
                                              },
                                              style: ElevatedButton.styleFrom(
                                                //backgroundColor: AppColors.secondaryColor,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                              child: Text('Foto Seal'),
                                            )
                                          : Text('Waktu Seal: ${data.waktu6}'),
                                      data.waktu7 == null
                                          ? ElevatedButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => FormFoto(
                                                          data: data,
                                                          id: 7,
                                                          label:
                                                              "Kabin Box Terisi",
                                                          refreshListCallback:
                                                              fetchData)),
                                                );
                                              },
                                              style: ElevatedButton.styleFrom(
                                                //backgroundColor: AppColors.secondaryColor,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                              child:
                                                  Text('Foto Kabin Box Terisi'),
                                            )
                                          : Text(
                                              'Waktu Kabin Box Terisi: ${data.waktu7}'),
                                      data.waktu8 == null
                                          ? ElevatedButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => FormFoto(
                                                          data: data,
                                                          id: 8,
                                                          label:
                                                              "Kabin Box Kosong",
                                                          refreshListCallback:
                                                              fetchData)),
                                                );
                                              },
                                              style: ElevatedButton.styleFrom(
                                                //backgroundColor: AppColors.secondaryColor,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                              child:
                                                  Text('Foto Kabin Box Kosong'),
                                            )
                                          : Text(
                                              'Waktu Kabin Box Kosong: ${data.waktu8}'),
                                      data.waktu9 == null
                                          ? ElevatedButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          FormFoto(
                                                              data: data,
                                                              id: 9,
                                                              label:
                                                                  "Temuan Paket",
                                                              refreshListCallback:
                                                                  fetchData)),
                                                );
                                              },
                                              style: ElevatedButton.styleFrom(
                                                //backgroundColor: AppColors.secondaryColor,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                              child: Text('Foto Temuan paket'),
                                            )
                                          : Text(
                                              'Waktu Temuan Paket: ${data.waktu9}'),
                                      data.waktuBerangkat == null
                                          ? ElevatedButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          FormTiga(
                                                              data: data,
                                                              refreshListCallback:
                                                                  fetchData)),
                                                );
                                              },
                                              style: ElevatedButton.styleFrom(
                                                //backgroundColor: AppColors.secondaryColor,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                              child: Text('Tahap Akhir'),
                                            )
                                          : Text(
                                              'Waktu Berangkat: ${data.waktuBerangkat}'),
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
