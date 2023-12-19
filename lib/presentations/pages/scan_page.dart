import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yorzkha_cos/logic/ktp.dart';


// buat scan page yang mempunyai 2 tombol yaitu tombol take picture dan pick image
class ScanPage extends StatefulWidget {
  const ScanPage({Key? key}) : super(key: key);

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  bool isLoading = false;
  ImagePicker imagePicker = ImagePicker();
  XFile? imageFile;

  final dio = Dio(
    BaseOptions(
      baseUrl: 'http://192.168.18.21:5000',
    ),
  );

  Future<void> sendImage(Dio dio) async {
    setState(() {
      isLoading = true;
    });
    final ktp = await KTP.getDataByUploadImage(imageFile!.path, '/ocr', dio);
    if (ktp != null) {
      Navigator.pop(context, ktp);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Failed to get data from server'),
        ),
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> pickImage(ImageSource imageSource) async {
    final pickedImage = await imagePicker.pickImage(source: imageSource);
    if (pickedImage == null) return;
    imageFile = pickedImage;
    // setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Page'),
      ),
      body: Center(
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    pickImage(ImageSource.camera);
                  },
                  child: const Text('Take Picture'),
                ),
                ElevatedButton(
                  onPressed: () {
                    pickImage(ImageSource.gallery);
                  },
                  child: const Text('Pick Image'),
                ),
                ElevatedButton(
                  onPressed: () {
                    sendImage(dio);
                  },
                  child: const Text('Send Image'),
                ),
              ],
            ),
            (isLoading)
                ? Container(
                    color: Colors.black.withOpacity(0.5),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}