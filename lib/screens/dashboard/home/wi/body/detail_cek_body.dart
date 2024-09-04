import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kjm_security/model/cekBody.model.dart';
import 'package:kjm_security/utils/image_loader.dart';

class DetailCekBody extends StatefulWidget {
  final CekBodyModel data;

  const DetailCekBody({super.key, required this.data});

  @override
  State<DetailCekBody> createState() => _DetailCekBodyState();
}

class _DetailCekBodyState extends State<DetailCekBody> {
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
  String apiUrl = 'https://satukomando.id/api-prod/cek-body/';
  String apiView = 'https://satukomando.id/api-prod/cek-body/photo/';

  @override
  void initState() {
    super.initState();
    //fetchTamu(widget.kode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Body'),
      ),
      body: SingleChildScrollView(
        child: Card(
          margin: EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(height: 16.0),
              ListTile(
                leading: const Icon(Icons.check_box_outline_blank),
                title: Text("Deskripsi: ${widget.data.description}"),
              ),
              ListTile(
                leading: const Icon(Icons.check_box_outline_blank),
                title: Text("Temuan: ${widget.data.temuan ?? "-"}"),
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
