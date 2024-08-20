import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:kjm_app/model/reportType.dart';
import 'package:path/path.dart' as path;
import 'package:async/async.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FormKejadian extends StatefulWidget {
  const FormKejadian({super.key});

  @override
  State<FormKejadian> createState() => _FormKejadianState();
}

class _FormKejadianState extends State<FormKejadian> {
  final _formKey = GlobalKey<FormState>();
  List<File?> _images = [null, null];

  XFile? _image;
  bool _isUploading = false;
  double _uploadProgress = 0.0;
  bool isLoading = false;

  String _selectedOption1 = "";

  List<ReportType> datas = [];
  //List<String> _options1 = [
  //  'Kebakaran',
  //  'Perkelahian',
  //  'Pencurian',
  //  'Kerusakan',
  //];
  final ImagePicker _picker = ImagePicker();
  TextEditingController _situasiController = TextEditingController();
  TextEditingController _waktuController = TextEditingController();
  TextEditingController _hasilController = TextEditingController();
  TextEditingController _penangananController = TextEditingController();

  String apiUrl = 'https://satukomando.id/api-prod/report/new';
  String apiUrlView = 'https://satukomando.id/api-prod/report-type/';

  @override
  void initState() {
    super.initState();
    //fetchUser();
    fetchData();
    // Initialize selectedDate with current date
    // filteredTamus = tamus;
  }

  Future<void> _pickImage(int index) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _images[index] = File(pickedFile.path);
      });
    }
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

        List<ReportType> tamuList =
            datanya.map((json) => ReportType.fromJson(json)).toList();

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

  Future<void> _uploadDataOld() async {
    //String apiUrl = 'https://geoportal.big.go.id/api-dev/file/upload';

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user = prefs.getString('user') ?? '';
    var data = jsonDecode(user);
    print(data);

    setState(() {
      _isUploading = true;
    });

    try {
      if (_image != null) {
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
        List<ReportType> filtered = [];
        filtered = datas
            .where((data) => data.name
                .toLowerCase()
                .contains(_selectedOption1.toLowerCase()))
            .toList();
        print(filtered[0].toJson());
        request.fields['data'] = '{"waktu":"' +
            _waktuController.text +
            '","kronologi":"' +
            _situasiController.text +
            '","tindakan":"' +
            _penangananController.text +
            '","hasil":"' +
            _hasilController.text +
            '","reportType":' +
            jsonEncode(filtered[0].toJson()) +
            ',"user":' +
            jsonEncode(data['pegawai']['user']) +
            ',"lokasi":' +
            jsonEncode(data['pegawai']['lokasi']) +
            '}';
        //print(jsonEncode(data['pegawai']['user']));
        //request.fields['guest_name'] = _namaController.text;
        //request.fields['come_to'] = _tujuanController.text;
        //request.fields['purpose'] = _keperluanController.text;

        request.headers.addAll({'x-access-token': data['accessToken']});
        final response = await request.send();

        final totalBytes = response.contentLength;
        print("total bytes");
        print(totalBytes);
        await response.stream.listen(
          (List<int> event) {
            //final sentBytes = event.length;
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

  Future<void> _uploadData() async {
    //String apiUrl = 'https://geoportal.big.go.id/api-dev/file/upload';
    String apiUrl = 'https://satukomando.id/api-prod/report/new';
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
      List<ReportType> filtered = [];
      filtered = datas
          .where((data) =>
              data.name.toLowerCase().contains(_selectedOption1.toLowerCase()))
          .toList();
      print(filtered[0].toJson());
      request.fields['data'] = '{"waktu":"' +
          _waktuController.text +
          '","kronologi":"' +
          _situasiController.text +
          '","tindakan":"' +
          _penangananController.text +
          '","hasil":"' +
          _hasilController.text +
          '","reportType":' +
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

  Future<SharedPreferences> _getSharedPreferences() async {
    return SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Isian Kejadian'),
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
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  for (int i = 0; i < 2; i++)
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () => _pickImage(i),
                          child: Container(
                            margin: EdgeInsets.all(10),
                            width: 80,
                            height: 80,
                            color: Colors.grey[200],
                            child: _images[i] == null
                                ? Icon(Icons.add_a_photo,
                                    size: 50, color: Colors.grey[400])
                                : Image.file(_images[i]!, fit: BoxFit.cover),
                          ),
                        ),
                        Text("Foto ${i + 1}")
                      ],
                    ),
                ]),
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
                  child: Text('Ambil Photo'), //3 foto dari galeri (BA, )
                ),
                */
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
                          labelText: 'Nama Petugas',
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
                DropdownButtonFormField<String>(
                  value: _selectedOption1,
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: "Jenis Kejadian (wajib)",
                  ),
                  onChanged: (val) {
                    setState(() {
                      _selectedOption1 = val!;
                    });
                  },
                  //(val) => _handleOption1Change,
                  items: datas.map((ReportType option) {
                    return DropdownMenuItem<String>(
                      value: option.name,
                      child: Text(option.name),
                    );
                  }).toList(),
                ),
                TextFormField(
                  controller: _waktuController,
                  //maxLines: 4,
                  decoration: InputDecoration(
                    labelText: 'Waktu Kejadian (wajib)',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Masukkan Waktu';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _situasiController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    labelText: 'Kronologis (wajib)',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Masukkan Kronologis';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _penangananController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    labelText: 'Tindakan (wajib)',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Masukkan Tindakan';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _hasilController,
                  //initialValue: widget.reportan.description,
                  //readOnly: true,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'Hasil (wajib)',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Masukkan Hasil';
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
