import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FormCekSampah extends StatefulWidget {
  const FormCekSampah({super.key});

  @override
  State<FormCekSampah> createState() => _FormCekSampahState();
}

class _FormCekSampahState extends State<FormCekSampah> {
  final _formKey = GlobalKey<FormState>();
  XFile? _image;
  bool _isUploading = false;
  bool isLoading = false;

  double _uploadProgress = 0.0;
  final ImagePicker _picker_one = ImagePicker();
  final ImagePicker _picker_two = ImagePicker();

  List<XFile?> _images = [null, null];
  TextEditingController _deskripsiController = TextEditingController();
  TextEditingController _temuanController = TextEditingController();
  TextEditingController _vendorController = TextEditingController();
  TextEditingController _petugasController = TextEditingController();
  //TextEditingController _waktuController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize selectedDate with current date
    // filteredTamus = tamus;
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
    String apiUrl = 'https://satukomando.id/api-prod/cek-sampah-new';
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

      request.fields['data'] = '{"deskripsi":"' +
          _deskripsiController.text +
          '", "nama_vendor":"' +
          _vendorController.text +
          '", "nama_petugas":"' +
          _petugasController.text +
          '", "temuan":"' +
          _temuanController.text +
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

    //Navigator.of(context).pop();
  }

  Future<void> _captureImage(int index) async {
    try {
      //final ImagePicker picker = ImagePicker();
      //final pickedFile = await picker.pickImage(source: ImageSource.camera);
      final pickedFile = index == 0
          ? await _picker_one.pickImage(source: ImageSource.camera)
          : await _picker_two.pickImage(source: ImageSource.camera);

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
        title: const Text('Form Isian Cek Sampah'),
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
                  child: Text('Ambil Photo'),
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
                        Text("Foto 1"),
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
                        Text("Foto 2"),
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
                  controller: _petugasController,
                  //maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: 'Nama Petugas Kebersihan (wajib)',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Masukkan Nama Petugas Kebersihan';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _vendorController,
                  //maxLines: 4,
                  decoration: InputDecoration(
                    labelText: 'Nama Vendor (opsional)',
                  ),
                ),
                TextFormField(
                  controller: _deskripsiController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    labelText: 'Deskripsi (wajib)',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Masukkan Deskripsi';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _temuanController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    labelText: 'Temuan (opsional)',
                  ),
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
