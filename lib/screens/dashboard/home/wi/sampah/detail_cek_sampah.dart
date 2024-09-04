import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kjm_security/model/cekSampah.model.dart';
import 'package:kjm_security/utils/image_loader.dart';

class DetailCekSampah extends StatefulWidget {
  final CekSampahModel data;

  const DetailCekSampah({super.key, required this.data});

  @override
  State<DetailCekSampah> createState() => _DetailCekSampahState();
}

class _DetailCekSampahState extends State<DetailCekSampah> {
  /*
  Paketan paket = Paketan(
      recipient: 'recipient',
      code: 'code',
      arrivedDatetime: DateTime.now(),
      address: 'address',
      hp: 'hp');
      */
  String selectedItem = '';

  //String apiUrl = 'https://geoportal.big.go.id/api-dev/packages/';
  //String apiView = 'https://geoportal.big.go.id/api-dev/packages/photo/';
  //String apiAmbil = 'https://geoportal.big.go.id/api-dev/packages/ambil/';
  String apiUrl = 'https://satukomando.id/api-prod/cek-sampah-new/';
  String apiView = 'https://satukomando.id/api-prod/cek-sampah-new/photo/';

  @override
  void initState() {
    super.initState();
    //fetchTamu(widget.kode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Sampah'),
      ),
      body: SingleChildScrollView(
        child: Card(
          margin: EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(height: 16.0),
              ListTile(
                leading: Icon(Icons.check_box_outline_blank),
                title: Text("Deskripsi: ${widget.data.deskripsi}"),
              ),
              ListTile(
                leading: Icon(Icons.check_box_outline_blank),
                title: Text("Nama Petugas: ${widget.data.nama_petugas}"),
              ),
              ListTile(
                leading: Icon(Icons.check_box_outline_blank),
                title: Text("Nama Vendor: ${widget.data.nama_vendor}"),
              ),
              ListTile(
                leading: Icon(Icons.check_box_outline_blank),
                title: Text("Temuan: ${widget.data.temuan}"),
              ),
              ListTile(
                leading: Icon(Icons.access_time),
                title: Text("Waktu: " +
                    DateFormat('dd MMM yyyy, hh:mm:ss a')
                        .format(widget.data.createdAt.toLocal())),
              ),
              widget.data.uuid != "code"
                  ? buildImageFromUrl('$apiView${widget.data.uuid}', 150.0)
                  : Container(),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
