import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kjm_app/model/cekLoker.model.dart';
import 'package:kjm_app/utils/image_loader.dart';

class DetailCekLoker extends StatefulWidget {
  final CekLokerModel loker;

  const DetailCekLoker({super.key, required this.loker});

  @override
  State<DetailCekLoker> createState() => _DetailCekLokerState();
}

class _DetailCekLokerState extends State<DetailCekLoker> {
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
  String apiUrl = 'https://satukomando.id/api-prod/cek-loker/';
  String apiView = 'https://satukomando.id/api-prod/cek-loker/photo/';

  @override
  void initState() {
    super.initState();
    //fetchTamu(widget.kode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Loker'),
      ),
      body: SingleChildScrollView(
        child: Card(
          margin: EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(height: 16.0),
              ListTile(
                leading: Icon(Icons.check_box_outline_blank),
                title: Text("Deskripsi: " + widget.loker.description),
              ),
              ListTile(
                leading: Icon(Icons.access_time),
                title: Text("Waktu: " +
                    DateFormat('dd MMM yyyy, hh:mm:ss a')
                        .format(widget.loker.createdAt.toLocal())),
              ),
              widget.loker.uuid != "code"
                  ? buildImageFromUrl('$apiView${widget.loker.uuid}', 150.0)
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
