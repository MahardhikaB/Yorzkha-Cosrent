import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
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
        title: const Text('Update Costum'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(
                width: 200,
                height: 200,
                child: (imageFile != null)
                    ? Image.file(File(imageFile!.path))
                    : Image.network(widget.costum.imageUrl),
              ),
              ElevatedButton(
                onPressed: () {
                  pickImage(ImageSource.gallery);
                },
                child: const Text('Pick Image'),
              ),
              TextFormField(
                controller: namaController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: ukuranController,
                decoration: const InputDecoration(labelText: 'Size'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: hargaController,
                keyboardType: TextInputType.number, // Keyboard untuk angka
                decoration: const InputDecoration(labelText: 'Price'),
              ),
              const SizedBox(height: 16),
              DropdownButton<String>(
                value: availability,
                onChanged: (String? newValue) {
                  setState(() {
                    availability = newValue!;
                  });
                },
                items: availabilityOptions.map((String option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  // Update costum dengan informasi terbaru
                  await Costum.update(
                    widget.costum.id,
                    namaController.text,
                    ukuranController.text,
                    int.tryParse(hargaController.text) ?? 0,
                    availability == 'Tersedia',
                    await uploadImage(),
                    context,
                  );
                },
                child: const Text('Update Costum'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
