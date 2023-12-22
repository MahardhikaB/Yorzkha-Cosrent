import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
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
      // Harus Sama dengan IP Address yang ada di server python dan Hp harus ada di satu jaringan (wifi) yang sama dengan server python
      baseUrl: 'http://192.168.58.33:5000',
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
        const SnackBar(
          content: Text('Failed to get data from server'),
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
    setState(() {
      imageFile = pickedImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            'Y O R Z K H A   C O S R E N T',
            style: TextStyle(
              color: Theme.of(context).colorScheme.inversePrimary,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DottedBorder(
                borderType: BorderType.RRect,
                color: Theme.of(context).colorScheme.inversePrimary,
                dashPattern: const [16, 4],
                radius: const Radius.circular(8),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  child: SizedBox(
                    height: 300,
                    width: 300,
                    child: (imageFile == null)
                        ? const Center(
                            child: Text('Preview Image'),
                          )
                        : (imageFile != null)
                            ? Image.file(
                                File(imageFile!.path),
                                width: 300,
                                height: 300,
                              )
                            : const SizedBox.shrink(),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  DottedBorder(
                    borderType: BorderType.RRect,
                    color: Theme.of(context).colorScheme.inversePrimary,
                    dashPattern: const [16, 4],
                    radius: const Radius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      child: Material(
                        borderRadius: BorderRadius.circular(8),
                        color: Theme.of(context).colorScheme.secondary,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(8),
                          splashFactory: InkRipple.splashFactory,
                          splashColor:
                              Theme.of(context).colorScheme.inversePrimary,
                          onTap: () {
                            pickImage(ImageSource.gallery);
                          },
                          child: const SizedBox(
                              height: 40,
                              width: 130,
                              child: Center(child: Text('Pick Image'))),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 44),
                  DottedBorder(
                    borderType: BorderType.RRect,
                    color: Theme.of(context).colorScheme.inversePrimary,
                    dashPattern: const [16, 4],
                    radius: const Radius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      child: Material(
                        borderRadius: BorderRadius.circular(8),
                        color: Theme.of(context).colorScheme.secondary,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(8),
                          splashFactory: InkRipple.splashFactory,
                          splashColor:
                              Theme.of(context).colorScheme.inversePrimary,
                          onTap: () {
                            pickImage(ImageSource.camera);
                          },
                          child: const SizedBox(
                              height: 40,
                              width: 130,
                              child: Center(child: Text('Take Image'))),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                child: DottedBorder(
                  borderType: BorderType.RRect,
                  color: Theme.of(context).colorScheme.inversePrimary,
                  dashPattern: const [16, 4],
                  radius: const Radius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    child: Material(
                      borderRadius: BorderRadius.circular(8),
                      color: Theme.of(context).colorScheme.secondary,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        splashFactory: InkRipple.splashFactory,
                        splashColor: Theme.of(context).colorScheme.inversePrimary,
                        onTap: () {
                          // if there is no image, do nothing and go back
                          if (imageFile == null) {
                            return;
                          }
                          sendImage(dio);
                        },
                        child: const SizedBox(
                            height: 40,
                            width: double.infinity,
                            child: Center(
                              child: Text('Send Image'),
                            )),
                      ),
                    ),
                  ),
                ),
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
      ),
    );
  }
}
