import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:yorzkha_cos/components/dropdown.dart';
import 'package:yorzkha_cos/components/textfield.dart';
import 'package:yorzkha_cos/logic/costum.dart';

class UpdateCostumPage extends StatefulWidget {
  final Costum costum;
  const UpdateCostumPage({Key? key, required this.costum});

  @override
  _UpdateCostumPageState createState() => _UpdateCostumPageState();
}

class _UpdateCostumPageState extends State<UpdateCostumPage> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController ukuranController = TextEditingController();
  final TextEditingController hargaController = TextEditingController();
  TextEditingController deskripsiController = TextEditingController();
  String availability = 'Tersedia'; // Default value
  final List<String> availabilityOptions = ['Tersedia', 'Tidak Tersedia'];

  ImagePicker imagePicker = ImagePicker();
  XFile? imageFile;
  final storage = FirebaseStorage.instance;
  final uuid = const Uuid();

  @override
  void initState() {
    super.initState();
    // Inisialisasi nilai controller berdasarkan data awal
    namaController.text = widget.costum.namaKostum;
    ukuranController.text = widget.costum.ukuran;
    hargaController.text = widget.costum.harga.toString();
    availability = widget.costum.isAvailable ? 'Tersedia' : 'Tidak Tersedia';
    deskripsiController.text = widget.costum.deskripsi;
  }

  Future<void> pickImage(ImageSource imageSource) async {
    final pickedImage = await imagePicker.pickImage(source: imageSource);
    if (pickedImage == null) return;
    imageFile = pickedImage;
    setState(() {});
  }

  Future<void> deleteOldImage() async {
    try {
      final oldImageUrl = widget.costum.imageUrl;
      if (oldImageUrl.isNotEmpty) {
        await storage.refFromURL(oldImageUrl).delete();
        print('Old image deleted successfully');
      }
    } catch (e) {
      print('Error deleting old image: $e');
    }
  }

  Future<String> uploadImage() async {
    if (imageFile == null) return widget.costum.imageUrl;

    try {
      // Hapus gambar lama sebelum mengunggah gambar baru
      await deleteOldImage();

      final fileName = uuid.v1();
      final destination = 'images/$fileName.jpg';
      // Upload file to Firebase Storage
      await storage.ref(destination).putFile(File(imageFile!.path));

      // Get download URL after uploading
      final url = await storage.ref(destination).getDownloadURL();

      return url;
    } catch (e) {
      print('Error uploading image: $e');
      return widget.costum.imageUrl;
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
            Container(
              padding: const EdgeInsets.only(top: 16),
              child: DottedBorder(
                borderType: BorderType.RRect,
                color: Theme.of(context).colorScheme.inversePrimary,
                dashPattern: const [16, 4],
                radius: const Radius.circular(8),
                child: Container(
                    padding: const EdgeInsets.all(16),
                    width: 310,
                    height: 180,
                    child: (imageFile != null)
                        ? Image.file(
                            File(imageFile!.path),
                            width: 300,
                            height: 300,
                          )
                        : (imageFile == null)
                            ? Image.network(
                                widget.costum.imageUrl,
                                width: 300,
                                height: 300,
                              )
                            : const Center(
                                child: Text('Preview Image'),
                              )),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DottedBorder(
                  borderType: BorderType.RRect,
                  color: Theme.of(context).colorScheme.inversePrimary,
                  dashPattern: const [16, 4],
                  radius: const Radius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.all(8),
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
                const SizedBox(width: 14),
                DottedBorder(
                  borderType: BorderType.RRect,
                  color: Theme.of(context).colorScheme.inversePrimary,
                  dashPattern: const [16, 4],
                  radius: const Radius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.all(8),
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
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(left: 24, right: 24, top: 16),
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
                  left: 24, right: 24, bottom: 16, top: 16),
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
                        await Costum.update(
                          widget.costum.id,
                          namaController.text,
                          ukuranController.text,
                          int.tryParse(hargaController.text) ?? 0,
                          availability == 'Tersedia',
                          await uploadImage(),
                          deskripsiController.text,
                          context,
                        );
                      },
                      child: const SizedBox(
                        height: 50,
                        child: Center(
                          child: Text(
                            'U P D A T E  K O S T U M',
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
