import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kjm_security/main.dart';
//import 'package:kjm_security/main.dart';
import 'package:kjm_security/model/jenisPresensi.dart';
import 'camerascreen.dart';
import 'previewscreen.dart';
import 'package:location/location.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';

class FormLembur extends StatefulWidget {
  final String mode;
  const FormLembur({super.key, required this.mode});

  @override
  State<FormLembur> createState() => _FormLemburState();
}

class _FormLemburState extends State<FormLembur> {
  final _formKey = GlobalKey<FormState>();
  //String apiUrl = 'https://geoportal.big.go.id/api-dev/file/upload';
  String apiUrlDatang = 'https://satukomando.id/api-prod/backup/datang-new';
  String apiUrlPulang = 'https://satukomando.id/api-prod/backup/pulang-new';
  String apiUrlView = 'https://satukomando.id/api-prod/jenis-presensi/';

  bool _isUploading = false;

  String _selectedOption1 = "izin";

  List<JenisPresensi> datas = [];

  Location _location = Location();
  late LocationData currentLocation;
  bool isLoading = true;

  TextEditingController _longController = TextEditingController();
  TextEditingController _latController = TextEditingController();
  TextEditingController _backupController = TextEditingController();
  TextEditingController _namaController = TextEditingController();
  TextEditingController _lokasiController = TextEditingController();

  List<String> _options1 = [
    'izin',
    'sakit',
    'resign',
    'mutasi',
    'tanpa keterangan',
  ];
  bool isCaptured = false;

  late XFile image;
  late CameraController _cameraController;

  @override
  void initState() {
    super.initState();
    //fetchData();
    _initializeLocation();
    _cameraController = CameraController(cameras[1], ResolutionPreset.medium);
    _cameraController.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            //print('Access was desnied');
            break;
          default:
            //print(e.description);
            break;
        }
      }
    });
  }
  /*
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

        List<JenisPresensi> tamuList =
            datanya.map((json) => JenisPresensi.fromJson(json)).toList();

        // Create a list of model objects

        print(tamuList.length);

        //print(dataList.length);

        setState(() {
          datas = tamuList;
          _selectedOption1 = tamuList[2].name;
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
  }*/

  @override
  void dispose() {
    // Dispose any resources used by the image picker
    super.dispose();
  }

  Future<void> _initializeLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    // Memeriksa apakah layanan lokasi telah diaktifkan
    serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    // Memeriksa izin lokasi telah diberikan
    permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    // Mendapatkan lokasi saat ini
    currentLocation = await _location.getLocation();
    //print(currentLocation);

    _latController.text = currentLocation.latitude!.toString();
    _longController.text = currentLocation.longitude!.toString();

    setState(() {
      isLoading = false;
    });
  }

  Future<bool> uploadImageAndAttributes(
      String imagePath, Map<String, dynamic> attributes) async {
    try {
      // API endpoint URL
      var url = Uri.parse('https://techlab.id/api-kawal/banjir');

      // Create multipart request for the image
      var request = http.MultipartRequest('POST', url);

      // Add image file to the request
      var image = await http.MultipartFile.fromPath('file', imagePath);
      request.files.add(image);

      // Add attributes to the request
      attributes.forEach((key, value) {
        request.fields[key] = value.toString();
      });

      // Send the request
      var response = await request.send();
      print(response);
      // Check the response status
      if (response.statusCode == 200) {
        return true; // Success
      } else {
        print('Failed to upload data: ${response.reasonPhrase}');
        return false; // Failure
      }
    } catch (e) {
      print('Exception while uploading data: $e');
      return false; // Failure
    }
  }

  Future<void> _uploadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user = prefs.getString('user') ?? '';
    var data = jsonDecode(user);
    print(data);

    setState(() {
      _isUploading = true;
    });

    try {
      print(_selectedOption1);
      List<JenisPresensi> filtered = [];
      filtered = datas
          .where((data) =>
              data.name.toLowerCase().contains(_selectedOption1.toLowerCase()))
          .toList();
      print(filtered[0].toJson());
      if (_selectedOption1 != 'Backup') {
        _backupController.text = "";
      }
      Map<String, dynamic> requestBody = {
        'data': '{"longitude":' +
            _longController.text +
            ',"latitude":' +
            _latController.text +
            ',"namaBackup":"' +
            _backupController.text +
            '","jenisPresensi":' +
            jsonEncode(filtered[0].toJson()) +
            ',"user":' +
            jsonEncode(data['pegawai']['user']) +
            '}',
        //'user_id': userId,
        //'password': password,
        //'new_password': newPassword,
      };
      final response = await http.post(
          Uri.parse(widget.mode == "datang" ? apiUrlDatang : apiUrlPulang),
          headers: {
            'Content-Type': 'application/json',
            'x-access-token': data['accessToken']
          },
          body: jsonEncode(requestBody));
      //request.fields['guest_name'] = _namaController.text;
      //request.fields['come_to'] = _tujuanController.text;
      //request.fields['purpose'] = _keperluanController.text;

      if (response.statusCode == 200) {
        // Upload completed successfully
        //Navigator.pop(context);
        //widget.onClose();
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
        // Handle API error response
        print(response.reasonPhrase);
        var data = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Data gagal dikirim ' + data["message"]),
            behavior:
                SnackBarBehavior.floating, // Ubah lokasi menjadi di bagian atas
            duration: Duration(seconds: 3),
            backgroundColor: Colors.red,
          ),
        );
      }

      setState(() {
        _isUploading = false;
        //_uploadProgress = 0.0;
        //_image = null;
      });
    } catch (e) {
      // Menangani kesalahan yang terjadi saat mengunggah gambar
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Oops.. Error terjadi..'),
          behavior:
              SnackBarBehavior.floating, // Ubah lokasi menjadi di bagian atas
          duration: Duration(seconds: 3),
          backgroundColor: Colors.red,
        ),
      );
    }

    //Navigator.of(context).pop();
  }

  Future<void> _uploadDataFoto() async {
    //String apiUrl = 'https://geoportal.big.go.id/api-dev/file/upload';

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user = prefs.getString('user') ?? '';
    var data = jsonDecode(user);
    //print(data);

    setState(() {
      _isUploading = true;
    });

    try {
      final request = http.MultipartRequest('POST',
          Uri.parse(widget.mode == "datang" ? apiUrlDatang : apiUrlPulang));

      final stream = http.ByteStream(image.openRead());
      final length = await image.length();

      final multipartFile = http.MultipartFile(
        'file',
        stream,
        length,
        filename: path.basename(image.path),
      );
      //print(_selectedOption1);
      request.fields['data'] = '{"longitude":' +
          _longController.text +
          ',"latitude":' +
          _latController.text +
          ',"namaBackup":"' +
          _namaController.text +
          '","lokasi":"' +
          _lokasiController.text +
          '","alasan":"' +
          _selectedOption1 +
          '","user":' +
          jsonEncode(data['pegawai']['user']) +
          '}';
      //print(jsonEncode(data['pegawai']['user']));
      //request.fields['guest_name'] = _namaController.text;
      //request.fields['come_to'] = _tujuanController.text;
      //request.fields['purpose'] = _keperluanController.text;

      request.files.add(multipartFile);
      request.headers.addAll({'x-access-token': data['accessToken']});
      final response = await request.send();

      //final totalBytes = response.contentLength;
      //print("total bytes");
      //print(totalBytes);
      await response.stream.listen(
        (List<int> event) {
          //final sentBytes = event.length;
          // print('sent $sentBytes');
          //_updateProgress(sentBytes, totalBytes!);
        },
        onDone: () {
          print(response.statusCode);
          //print(response.request);

          if (response.statusCode == 200) {
            // Upload completed successfully
            //Navigator.pop(context);
            //widget.onClose();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Data berhasil dikirim'),
                behavior: SnackBarBehavior
                    .floating, // Ubah lokasi menjadi di bagian atas
                duration: Duration(seconds: 3),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          } else {
            // Handle API error response
            print(response.reasonPhrase);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Data gagal dikirim'),
                behavior: SnackBarBehavior
                    .floating, // Ubah lokasi menjadi di bagian atas
                duration: Duration(seconds: 3),
                backgroundColor: Colors.red,
              ),
            );
          }

          setState(() {
            _isUploading = false;
            //_uploadProgress = 0.0;
            //_image = null;
          });
        },
        onError: (error) {
          // Handle upload error
          // print(error);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Terjadi Error..'),
              behavior: SnackBarBehavior
                  .floating, // Ubah lokasi menjadi di bagian atas
              duration: Duration(seconds: 3),
              backgroundColor: Colors.red,
            ),
          );
          setState(() {
            _isUploading = false;
            //_uploadProgress = 0.0;
            //_image = null;
          });
        },
      );
    } catch (e) {
      // Menangani kesalahan yang terjadi saat mengunggah gambar
      //print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Oops.. Error terjadi..'),
          behavior:
              SnackBarBehavior.floating, // Ubah lokasi menjadi di bagian atas
          duration: Duration(seconds: 3),
          backgroundColor: Colors.red,
        ),
      );
    }

    //Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    String mode = widget.mode == "datang" ? "Datang" : "Pulang";
    double screenHeight = MediaQuery.of(context).size.height;
    //double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Form Isian Backup ${mode}'),
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
                Container(
                  width: double.infinity,
                  color: Colors.grey,
                  height: 0.5 * screenHeight,
                  child: isCaptured
                      ? PreviewScreen(file: image)
                      : CameraScreen(cameraController: _cameraController),
                ),
                TextFormField(
                  readOnly: true,
                  controller: _longController,
                  decoration: InputDecoration(
                    labelText: 'Longitude',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Masukkan Longitude';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _latController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Latitude',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Masukkan Latitude';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                widget.mode == "datang"
                    ? TextFormField(
                        controller: _lokasiController,
                        decoration: InputDecoration(
                          labelText: 'Lokasi',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Masukkan Lokasi';
                          }
                          return null;
                        },
                      )
                    : SizedBox(),
                widget.mode == "datang"
                    ? TextFormField(
                        controller: _namaController,
                        decoration: InputDecoration(
                          labelText: 'Nama yang digantikan',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Masukkan Nama yang digantikan';
                          }
                          return null;
                        },
                      )
                    : SizedBox(),
                SizedBox(height: 10),
                widget.mode == "datang"
                    ? DropdownButtonFormField<String>(
                        value: _selectedOption1,
                        isExpanded: true,
                        decoration: InputDecoration(
                          labelText: "Alasan",
                        ),
                        onChanged: (val) {
                          setState(() {
                            _selectedOption1 = val!;
                          });
                        },
                        //(val) => _handleOption1Change,
                        items: _options1.map((String option) {
                          return DropdownMenuItem<String>(
                            value: option,
                            child: Text(option),
                          );
                        }).toList(),
                      )
                    : SizedBox(),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: isCaptured
                        ? null
                        : () async {
                            if (!_cameraController.value.isInitialized) {
                              return;
                            }
                            if (_cameraController.value.isTakingPicture) {
                              return;
                            }

                            try {
                              await _cameraController
                                  .setFlashMode(FlashMode.auto);
                              XFile picture =
                                  await _cameraController.takePicture();
                              //print(picture);
                              setState(() {
                                image = picture;
                                isCaptured = true;
                              });

                              //Navigator.push(
                              //    context,
                              //    MaterialPageRoute(
                              //        builder: (context) =>
                              //            GalleryView(
                              //                file: picture)));
                            } on CameraException catch (e) {
                              debugPrint('Something went wrong! $e');
                              return;
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.all(20),
                    ),
                    child: Text(isCaptured ? 'Foto Oke' : 'Ambil Foto'),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: !isCaptured
                        ? null
                        : () async {
                            if (_formKey.currentState!.validate()) {
                              _uploadDataFoto();
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.all(20),
                    ),
                    child: Text(_isUploading ? 'Processing..' : 'Kirim Backup'),
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
