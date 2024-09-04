import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kjm_security/model/cekBagasi.model.dart';
import 'package:kjm_security/utils/image_loader.dart';

class DetailCekBagasi extends StatefulWidget {
  final CekBagasiModel data;

  const DetailCekBagasi({super.key, required this.data});

  @override
  State<DetailCekBagasi> createState() => _DetailCekBagasiState();
}

class _DetailCekBagasiState extends State<DetailCekBagasi> {
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
  String apiUrl = 'https://satukomando.id/api-prod/cek-bagasi/';
  String apiView = 'https://satukomando.id/api-prod/cek-bagasi/photo/';

  @override
  void initState() {
    super.initState();
    //fetchTamu(widget.kode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Bagasi'),
      ),
      body: SingleChildScrollView(
        child: Card(
          margin: EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(height: 16.0),
              ListTile(
                leading: Icon(Icons.check_box_outline_blank),
                title: Text("Deskripsi: " + widget.data.deskripsi),
              ),
              ListTile(
                leading: Icon(Icons.check_box_outline_blank),
                title: Text("Nama Perwakilan: " + widget.data.nama_perwakilan),
              ),
              ListTile(
                leading: Icon(Icons.check_box_outline_blank),
                title: Text("Nama Supervisor: " + widget.data.nama_supervisor),
              ),
              ListTile(
                leading: Icon(Icons.check_box_outline_blank),
                title: Text("Temuan: " + widget.data.temuan),
              ),
              ListTile(
                leading: Icon(Icons.check_box_outline_blank),
                title: Text("Waktu Mulai: " + widget.data.waktu_mulai),
              ),
              ListTile(
                leading: Icon(Icons.check_box_outline_blank),
                title: Text("Waktu Selesai: " + widget.data.waktu_selesai),
              ),
              ListTile(
                leading: Icon(Icons.access_time),
                title: Text("Waktu Lapor: " +
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
