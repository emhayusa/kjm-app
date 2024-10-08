import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:async/async.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FormPaket extends StatefulWidget {
  const FormPaket({super.key});

  @override
  State<FormPaket> createState() => _FormPaketState();
}

class _FormPaketState extends State<FormPaket> {
  final _formKey = GlobalKey<FormState>();

  bool _isUploading = false;
  double _uploadProgress = 0.0;

  List<XFile?> _images = [null, null];
  TextEditingController _pengirimController = TextEditingController();
  TextEditingController _keteranganController = TextEditingController();
  TextEditingController _penerimaController = TextEditingController();
  TextEditingController _alamatController = TextEditingController();
  TextEditingController _hpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // filteredTamus = tamus;
  }

  @override
  void dispose() {
    // Dispose any resources used by the image picker
    super.dispose();
  }

  Future<void> _uploadData() async {
    //String apiUrl = 'https://geoportal.big.go.id/api-dev/file/upload';
    String apiUrl = 'https://satukomando.id/api-prod/paket/datang-new';
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
      request.fields['data'] = '{"namaPengirim":"' +
          _pengirimController.text +
          '","keterangan":"' +
          _keteranganController.text +
          '","namaPenerima":"' +
          _penerimaController.text +
          '","alamat":"' +
          _alamatController.text +
          '","hp":"' +
          _hpController.text +
          '","user":' +
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
    /*
      //final stream = http.ByteStream(_image!.openRead());
      //final length = await _image!.length();

      final multipartFile = http.MultipartFile(
        'file',
        stream,
        length,
        filename: path.basename(_image!.path),
      );

      request.files.add(multipartFile);
      request.headers.addAll({'x-access-token': data['accessToken']});
      final response = await request.send();

      final totalBytes = response.contentLength;
      //print("total bytes");
      //print(totalBytes);
      response.stream.listen(
        (List<int> event) {
          final sentBytes = event.length;
          // print('sent $sentBytes');
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
    */

    //Navigator.of(context).pop();
  }

  Future<void> _captureImage(int index) async {
    try {
      final ImagePicker picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.camera);
      //final pickedFile = index == 0
      //    ? await _picker_one.pickImage(source: ImageSource.camera)
      //    : await _picker_two.pickImage(source: ImageSource.camera);

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
        title: const Text('Form Isian Paket'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
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
                        Text("Foto Kurir"),
                      ],
                    ),
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () => _captureImage(1),
                          child: Container(
                            margin: EdgeInsets.all(10),
                            width: 100,
                            height: 100,
                            color: Colors.grey[200],
                            child: _images[1] == null
                                ? Icon(Icons.camera_alt,
                                    size: 50, color: Colors.grey[400])
                                : Image.file(File(_images[1]!.path),
                                    fit: BoxFit.cover),
                          ),
                        ),
                        Text("Foto Paket"),
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
                TextFormField(
                  controller: _pengirimController,
                  decoration: InputDecoration(
                    labelText: 'Nama Pengirim (wajib)',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Masukkan Nama Pengirim';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _keteranganController,
                  decoration: InputDecoration(
                    labelText: 'Keterangan (wajib)',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Masukkan Keterangan';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _penerimaController,
                  decoration: InputDecoration(
                    labelText: 'Nama Penerima (wajib)',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Masukkan Nama Penerima';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _hpController,
                  decoration: InputDecoration(
                    labelText: 'HP Penerima (wajib)',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Masukkan HP Penerima';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _alamatController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    labelText: 'Alamat Penerima (wajib)',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Masukkan Alamat Penerima';
                    }
                    return null;
                  },
                ),
                if (_isUploading) ...[
                  SizedBox(height: 20),
                  LinearProgressIndicator(value: _uploadProgress),
                ],
                SizedBox(
                  height: 50,
                ),
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
