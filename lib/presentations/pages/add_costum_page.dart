import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yorzkha_cos/logic/costum.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';


class AddCostumPage extends StatefulWidget {
  const AddCostumPage({Key? key}):super(key: key);

  @override
  _AddCostumPageState createState() => _AddCostumPageState();
}

class _AddCostumPageState extends State<AddCostumPage> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController ukuranController = TextEditingController();
  final TextEditingController hargaController = TextEditingController();
  final TextEditingController availabilityController = TextEditingController();
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
        title: const Text('Add Costum'),
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
                : const SizedBox()
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
                  String url = await uploadImage();
                  await Costum.create(
                    namaController,
                    ukuranController,
                    hargaController,
                    availability,
                    url,
                    context,
                  );
                },
                child: const Text('Add Costum'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
