import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:kjm_security/model/warehouseType.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FormCekOutbound extends StatefulWidget {
  const FormCekOutbound({super.key});

  @override
  State<FormCekOutbound> createState() => _FormCekOutboundState();
}

class _FormCekOutboundState extends State<FormCekOutbound> {
  final _formKey = GlobalKey<FormState>();
  XFile? _image;
  bool _isUploading = false;
  bool isLoading = false;

  double _uploadProgress = 0.0;
  String _selectedOption1 = "";

  List<WarehouseType> datas = [];

  final ImagePicker _picker_one = ImagePicker();
  //final ImagePicker _picker_two = ImagePicker();

  List<XFile?> _images = [null];
  //TextEditingController _deskripsiController = TextEditingController();
  //TextEditingController _temuanController = TextEditingController();
  TextEditingController _vendorController = TextEditingController();
  //TextEditingController _petugasController = TextEditingController();
  TextEditingController _jenis_kendaraanController = TextEditingController();
  TextEditingController _asalController = TextEditingController();
  TextEditingController _no_sealController = TextEditingController();
  TextEditingController _waktu_start_asalController = TextEditingController();
  TextEditingController _waktu_tibaController = TextEditingController();

  TextEditingController _noPolisiController = TextEditingController();
  TextEditingController _no_surat_jalanController = TextEditingController();
  TextEditingController _namaSopirController = TextEditingController();
  String apiUrl = 'https://satukomando.id/api-prod/outbound/';
  String apiUrlView = 'https://satukomando.id/api-prod/warehouse-type/';

  @override
  void initState() {
    super.initState();
    fetchData();
    // Initialize selectedDate with current date
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
      var urlnya = apiUrlView;
      //print(urlnya);
      final response = await http.get(Uri.parse(urlnya),
          headers: {"x-access-token": data['accessToken']});
      if (response.statusCode == 200) {
        print(response.body);
        //print(json.decode(response.body));
        //final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

        //return parsed.map<Photo>((json) => Photo.fromJson(json)).toList();
        //final List<dynamic> data = json.decode(response.body);
        //print(data);
        //data.map((json) => json);
        // Create a list of model objects
        //List<Laporan> dataList =
        //    data.map((json) => Laporan.fromJson(json)).toList();

        final List<dynamic> datanya = json.decode(response.body);

        List<WarehouseType> tamuList =
            datanya.map((json) => WarehouseType.fromJson(json)).toList();

        // Create a list of model objects

        print(tamuList.length);

        //print(dataList.length);

        setState(() {
          datas = tamuList;
          _selectedOption1 = tamuList[0].name;
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

  @override
  void dispose() {
    // Dispose any resources used by the image picker
    super.dispose();
  }

/*
  Future<void> _openCamera(BuildContext context) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      setState(() {
        _image = image;
      });
      //File imageFile = File(image.path);
      //_uploadImage(imageFile, context);
    }
  }
*/
  Future<void> _uploadData() async {
    //String apiUrl = 'https://geoportal.big.go.id/api-dev/file/upload';
    String apiUrl = 'https://satukomando.id/api-prod/outbound/';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user = prefs.getString('user') ?? '';
    var data = jsonDecode(user);
    setState(() {
      _isUploading = true;
      _uploadProgress = 0.0;
    });

    try {
      final request = http.MultipartRequest('POST', Uri.parse(apiUrl));
      for (int i = 0; i < _images.length; i++) {
        if (_images[i] != null) {
          final stream = http.ByteStream(_images[i]!.openRead());
          final length = await _images[i]!.length();
          final multipartFile = http.MultipartFile(
            'files', // Ensure unique field names
            stream,
            length,
            filename: path.basename(_images[i]!.path),
          );
          request.files.add(multipartFile);
        }
      }
      print(_selectedOption1);
      List<WarehouseType> filtered = [];
      filtered = datas
          .where((data) =>
              data.name.toLowerCase().contains(_selectedOption1.toLowerCase()))
          .toList();
      print(filtered[0].toJson());
      request.fields['data'] = '{"nama_sopir":"' +
          _namaSopirController.text +
          '", "no_polisi":"' +
          _noPolisiController.text +
          '", "nama_vendor":"' +
          _vendorController.text +
          '", "jenis_kendaraan":"' +
          _jenis_kendaraanController.text +
          '", "asal":"' +
          _asalController.text +
          '", "waktu_tiba":"' +
          _waktu_tibaController.text +
          '","warehouseType":' +
          jsonEncode(filtered[0].toJson()) +
          ',"user":' +
          jsonEncode(data['pegawai']['user']) +
          ',"lokasi":' +
          jsonEncode(data['pegawai']['lokasi']) +
          '}';

      request.headers.addAll({'x-access-token': data['accessToken']});
      var streamedResponse = await request.send();

      streamedResponse.stream.listen((value) {
        setState(() {
          _uploadProgress += value.length / streamedResponse.contentLength!;
        });
      });

      if (streamedResponse.statusCode == 200) {
        //print('Uploaded successfully');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Data berhasil dikirim'),
            behavior:
                SnackBarBehavior.floating, // Ubah lokasi menjadi di bagian atas
            duration: Duration(seconds: 3),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Data gagal dikirim'),
            behavior:
                SnackBarBehavior.floating, // Ubah lokasi menjadi di bagian atas
            duration: Duration(seconds: 3),
            backgroundColor: Colors.red,
          ),
        );
        //print(streamedResponse);
        print(streamedResponse.statusCode);
        print(streamedResponse.reasonPhrase);
        //print('Upload failed');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terjadi error..'),
          behavior:
              SnackBarBehavior.floating, // Ubah lokasi menjadi di bagian atas
          duration: Duration(seconds: 3),
          backgroundColor: Colors.red,
        ),
      );
      print('Error uploading data: $e');
    } finally {
      setState(() {
        _isUploading = false;
        _uploadProgress = 0.0;
      });
    }

    //Navigator.of(context).pop();
  }

  Future<void> _captureImage(int index) async {
    try {
      //final ImagePicker picker = ImagePicker();
      //final pickedFile = await picker.pickImage(source: ImageSource.camera);
      final pickedFile =
          await _picker_one.pickImage(source: ImageSource.camera);

      if (pickedFile != null) {
        XFile compressedImage = await _compressImage(File(pickedFile.path));
        setState(() {
          _images[index] = compressedImage;
        });
      }
    } catch (e) {
      print('Error capturing image: $e');
    }
  }

  Future<XFile> _compressImage(File file) async {
    final dir = await getTemporaryDirectory();
    final targetPath =
        "${dir.absolute.path}/temp_${DateTime.now().millisecondsSinceEpoch}.jpg";

    var result = await FlutterImageCompress.compressAndGetFile(
      file.path,
      targetPath,
      quality: 70,
    );

    return result!;
    //return file;
  }

  Future<SharedPreferences> _getSharedPreferences() async {
    return SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Isian Outbond'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /*
                _image != null
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            //to show image, you type like this.
                            File(_image!.path),
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.width,
                            height: 200,
                          ),
                        ),
                      )
                    : Container(),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => _openCamera(context),
                  style: ElevatedButton.styleFrom(
                    //backgroundColor: AppColors.secondaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(20),
                  ),
                  child: Text('Ambil Photo Datang'),
                ),
                */
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () => _captureImage(0),
                          child: Container(
                            margin: EdgeInsets.all(10),
                            width: 100,
                            height: 100,
                            color: Colors.grey[200],
                            child: _images[0] == null
                                ? Icon(Icons.camera_alt,
                                    size: 50, color: Colors.grey[400])
                                : Image.file(File(_images[0]!.path),
                                    fit: BoxFit.cover),
                          ),
                        ),
                        Text("Foto Depan Mobil"),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 10),
                FutureBuilder<SharedPreferences>(
                  future: _getSharedPreferences(),
                  builder: (context, snapshot) {
                    //rint(snapshot.data?.getString('name'));
                    if (snapshot.hasData) {
                      //print(snapshot);
                      String? user = snapshot.data?.getString('user');

                      var data = jsonDecode(user!);
                      print(data);
                      String? nama = data['pegawai']["namaLengkap"];

                      return TextFormField(
                        initialValue: nama,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Nama Pelapor',
                        ),
                      );
                      // SharedPreferences instance is available
                      //final SharedPreferences sharedPreferences =snapshot.data;
                    }
                    return Container();
                  },
                ),
                FutureBuilder<SharedPreferences>(
                  future: _getSharedPreferences(),
                  builder: (context, snapshot) {
                    //rint(snapshot.data?.getString('name'));
                    if (snapshot.hasData) {
                      //print(snapshot);
                      String? user = snapshot.data?.getString('user');

                      var data = jsonDecode(user!);
                      print(data);
                      String? nama = data['pegawai']["lokasi"]["lokasiName"];

                      return TextFormField(
                        initialValue: nama,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Nama Lokasi',
                        ),
                      );
                      // SharedPreferences instance is available
                      //final SharedPreferences sharedPreferences =snapshot.data;
                    }
                    return Container();
                  },
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: _selectedOption1,
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: "Kategori",
                  ),
                  onChanged: (val) {
                    setState(() {
                      _selectedOption1 = val!;
                    });
                  },
                  //(val) => _handleOption1Change,
                  items: datas.map((WarehouseType option) {
                    return DropdownMenuItem<String>(
                      value: option.name,
                      child: Text(option.name),
                    );
                  }).toList(),
                ),
                TextFormField(
                  controller: _namaSopirController,
                  //maxLines: 4,
                  decoration: InputDecoration(
                    labelText: 'Nama Sopir (wajib)',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Masukkan Nama Sopir';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _noPolisiController,
                  //maxLines: 4,
                  decoration: InputDecoration(
                    labelText: 'No Polisi (wajib)',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Masukkan No Polisi';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _vendorController,
                  //maxLines: 4,
                  decoration: InputDecoration(
                    labelText: 'Nama Vendor (wajib)',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Masukkan Nama Vendor';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _jenis_kendaraanController,
                  //maxLines: 4,
                  decoration: InputDecoration(
                    labelText: 'Jenis Kendaraan (wajib)',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Masukkan Jenis Kendaraan';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _asalController,
                  //maxLines: 4,
                  decoration: InputDecoration(
                    labelText: 'Asal (wajib)',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Masukkan Asal';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _waktu_tibaController,
                  //maxLines: 4,
                  decoration: InputDecoration(
                    labelText: 'Waktu Tiba (wajib)',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Masukkan Waktu Tiba';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed:
                        _images.any((image) => image == null) || _isUploading
                            ? null
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  _uploadData();
                                }
                              },
                    style: ElevatedButton.styleFrom(
                      //backgroundColor: AppColors.secondaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.all(20),
                    ),
                    child: Text(_isUploading ? 'Processing..' : 'Simpan'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      /*actions: [
        ElevatedButton(
          onPressed: _isUploading
              ? null
              : () {
                  Navigator.of(context).pop();
                },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isUploading
              ? null
              : () {
                  if (_formKey.currentState!.validate()) {
                    _uploadData();
                  }
                },
          child: Text(_isUploading ? 'Processing..' : 'Submit'),
        ),
      ],*/
      // Validasi berhasil
    );
  }
}
