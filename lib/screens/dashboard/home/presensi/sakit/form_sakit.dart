// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:kjm_security/main.dart';
import 'camerascreen.dart';
import 'previewscreen.dart';
import 'package:location/location.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';

class FormSakit extends StatefulWidget {
  const FormSakit({super.key});

  @override
  State<FormSakit> createState() => _FormSakitState();
}

class _FormSakitState extends State<FormSakit> {
  final _formKey = GlobalKey<FormState>();
  //String apiUrl = 'https://geoportal.big.go.id/api-dev/file/upload';
  String apiUrlDatang = 'https://satukomando.id/api-prod/sakit/datang-new';
  String apiUrlPulang = 'https://satukomando.id/api-prod/sakit/pulang-new';

  bool _isUploading = false;

  bool isLoading = true;

  final TextEditingController _tglController = TextEditingController();

  bool isCaptured = false;

  late XFile image;
  late CameraController _cameraController;

  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

  @override
  void initState() {
    super.initState();
    _tglController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
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

  @override
  void dispose() {
    // Dispose any resources used by the image picker
    super.dispose();
  }

  /*
  Future<void> _uploadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user = prefs.getString('user') ?? '';
    var data = jsonDecode(user);
    print(data);

    setState(() {
      _isUploading = true;
    });

    try {
      Map<String, dynamic> requestBody = {
        'data': '{"longitude":' +
            _longController.text +
            ',"latitude":' +
            _latController.text +
            ',"user":' +
            jsonEncode(data['pegawai']['user']) +
            '}',
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
  */
  Future<void> _uploadDataFoto() async {
    //String apiUrl = 'https://geoportal.big.go.id/api-dev/file/upload';

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user = prefs.getString('user') ?? '';
    var data = jsonDecode(user);

    setState(() {
      _isUploading = true;
    });

    try {
      final request = http.MultipartRequest('POST', Uri.parse(apiUrlDatang));

      final stream = http.ByteStream(image.openRead());
      final length = await image.length();

      final multipartFile = http.MultipartFile(
        'file',
        stream,
        length,
        filename: path.basename(image.path),
      );
      request.fields['data'] =
          '{"tanggal":"${_tglController.text}","user":${jsonEncode(data['pegawai']['user'])}}';
      //print(jsonEncode(data['pegawai']['user']));
      //request.fields['guest_name'] = _namaController.text;
      //request.fields['come_to'] = _tujuanController.text;
      //request.fields['purpose'] = _keperluanController.text;

      request.files.add(multipartFile);
      request.headers.addAll({'x-access-token': data['accessToken']});
      final response = await request.send();

      final totalBytes = response.contentLength;
      response.stream.listen(
        (List<int> event) {
          final sentBytes = event.length;
          print('sent $sentBytes, $totalBytes!');
          //_updateProgress(sentBytes, totalBytes!);
        },
        onDone: () {
          //print(response.statusCode);
          //print(response.request);

          if (response.statusCode == 200) {
            // Upload completed successfully
            //Navigator.pop(context);
            //widget.onClose();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
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
            print(response.statusCode);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                    'Data gagal dikirim, Cek tanggal sudah pernah di ajukan'),
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
            const SnackBar(
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
        const SnackBar(
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

  Future<File> _compressImage(File file) async {
    //final dir = await getTemporaryDirectory();
    //final targetPath = dir.absolute.path + "/temp.jpg";

    //var result = await FlutterImageCompress.compressAndGetFile(
    //  file.absolute.path,
    //  targetPath,
    //  quality: 70,
    //);

    //return result!;
    return file;
  }

  Future<SharedPreferences> _getSharedPreferences() async {
    return SharedPreferences.getInstance();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        _tglController.text = _dateFormat.format(pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    //double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Form Isian Sakit'),
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
                          labelText: 'Nama',
                        ),
                      );
                      // SharedPreferences instance is available
                      //final SharedPreferences sharedPreferences =snapshot.data;
                    }
                    return Container();
                  },
                ),
                TextFormField(
                  controller: _tglController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Tanggal Off',
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () {
                        _selectDate(context);
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Masukkan Tanggal';
                    }
                    return null;
                  },
                ),
                Container(
                  width: double.infinity,
                  color: Colors.grey,
                  height: 0.5 * screenHeight,
                  child: isCaptured
                      ? PreviewScreen(file: image)
                      : CameraScreen(cameraController: _cameraController),
                ),
                SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: isCaptured
                        ? null
                        : () async {
                            if (_formKey.currentState!.validate()) {
                              print("capture");
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
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.all(20),
                    ),
                    child: Text(
                        isCaptured ? 'Foto Oke' : 'Ambil Foto Surat Sakit'),
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
                    child: Text(_isUploading ? 'Processing..' : 'Kirim Sakit'),
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
