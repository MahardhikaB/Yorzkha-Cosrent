import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yorzkha_cos/components/dropdown.dart';
import 'package:yorzkha_cos/components/textfield.dart';
import 'package:yorzkha_cos/logic/costum.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class AddCostumPage extends StatefulWidget {
  const AddCostumPage({Key? key}) : super(key: key);

  @override
  _AddCostumPageState createState() => _AddCostumPageState();
}

class _AddCostumPageState extends State<AddCostumPage> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController ukuranController = TextEditingController();
  final TextEditingController hargaController = TextEditingController();
  final TextEditingController availabilityController = TextEditingController();
  final TextEditingController deskripsiController = TextEditingController();
  String availability = 'Tersedia'; // Default value
  final List<String> availabilityOptions = ['Tersedia', 'Tidak Tersedia'];

  ImagePicker imagePicker = ImagePicker();
  XFile? imageFile;
  final storage = FirebaseStorage.instance;
  final uuid = const Uuid();

  Future<void> pickImage(ImageSource imageSource) async {
    final pickedImage = await imagePicker.pickImage(source: imageSource);
    if (pickedImage == null) return;
    imageFile = pickedImage;
    setState(() {});
  }

  Future<String> uploadImage() async {
    if (imageFile == null) return '';
    try {
      final fileName = uuid.v1();
      final destination = 'images/$fileName.jpg';

      // Upload file to Firebase Storage
      await storage.ref(destination).putFile(File(imageFile!.path));

      // Get download URL after uploading
      final url = await storage.ref(destination).getDownloadURL();

      return url;

      // TODO: Simpan URL ke Firestore atau lakukan tindakan lain sesuai kebutuhan
    } catch (e) {
      print('Error uploading image: $e');
      return '';
    }
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
                width: 150,
                height: 150,
                child: (imageFile != null)
                    ? Image.file(File(imageFile!.path))
                    : const SizedBox()),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DottedBorder(
                  borderType: BorderType.RRect,
                  color: Theme.of(context).colorScheme.inversePrimary,
                  dashPattern: const [16, 4],
                  radius: const Radius.circular(8),
                  child: Container(
                    padding: EdgeInsets.all(8),
                    child: Material(
                      borderRadius: BorderRadius.circular(8),
                      color: Theme.of(context).colorScheme.secondary,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        splashFactory: InkRipple.splashFactory,
                        splashColor: Theme.of(context).colorScheme.inversePrimary,
                        onTap: () {
                          pickImage(ImageSource.gallery);
                        },
                        child: const SizedBox(
                          height: 40,
                          width: 138,
                          child: Center(
                            child: Text('Pick Image')
                          )
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                DottedBorder(
                  borderType: BorderType.RRect,
                  color: Theme.of(context).colorScheme.inversePrimary,
                  dashPattern: const [16, 4],
                  radius: const Radius.circular(8),
                  child: Container(
                    padding: EdgeInsets.all(8),
                    child: Material(
                      borderRadius: BorderRadius.circular(8),
                      color: Theme.of(context).colorScheme.secondary,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        splashFactory: InkRipple.splashFactory,
                        splashColor: Theme.of(context).colorScheme.inversePrimary,
                        onTap: () {
                          pickImage(ImageSource.camera);
                        },
                        child: SizedBox(
                          height: 40,
                          width: 138,
                          child: Center(
                            child: const Text('Take Image')
                          )
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
              child: DottedBorder(
                strokeWidth: 1,
                borderType: BorderType.RRect,
                dashPattern: const [20, 6],
                color: Theme.of(context).colorScheme.inversePrimary,
                radius: const Radius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      MyTextField(
                        hintText: 'Nama Kostum',
                        obscureText: false,
                        controller: namaController,
                        keyboardType: TextInputType.text,
                      ),
                      const SizedBox(height: 16),
                      MyTextField(
                        hintText: 'Ukuran Kostum',
                        obscureText: false,
                        controller: ukuranController,
                        keyboardType: TextInputType.text,
                      ),
                      const SizedBox(height: 16),
                      MyTextField(
                        hintText: 'Harga Kostum',
                        obscureText: false,
                        controller: hargaController,
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),
                      MyDropdown(
                        hintText: 'Status Kostum',
                        value: availability,
                        items: availabilityOptions,
                        onChanged: (String? newValue) {
                          setState(() {
                            availability = newValue!;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      MyTextField(
                        hintText: 'Deskripsi Kostum',
                        obscureText: false,
                        controller: deskripsiController,
                        keyboardType: TextInputType.text,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                  left: 16, right: 16, bottom: 8, top: 16),
              child: DottedBorder(
                borderType: BorderType.RRect,
                color: Theme.of(context).colorScheme.inversePrimary,
                dashPattern: const [16, 4],
                radius: const Radius.circular(8),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(5),
                  child: Material(
                    borderRadius: BorderRadius.circular(8),
                    color: Theme.of(context).colorScheme.secondary,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      splashFactory: InkRipple.splashFactory,
                      splashColor: Theme.of(context).colorScheme.inversePrimary,
                      onTap: () async {
                        String url = await uploadImage();
                        await Costum.create(
                          namaController,
                          ukuranController,
                          hargaController,
                          availability,
                          url,
                          deskripsiController,
                          context,
                        );
                      },
                      child: const SizedBox(
                        height: 50,
                        child: Center(
                          child: Text(
                            'T A M B A H  K O S T U M',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
