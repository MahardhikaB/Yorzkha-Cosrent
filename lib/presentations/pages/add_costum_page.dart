import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddCostumPage extends StatefulWidget {
  const AddCostumPage({Key? key});

  @override
  _AddCostumPageState createState() => _AddCostumPageState();
}

class _AddCostumPageState extends State<AddCostumPage> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController ukuranController = TextEditingController();
  final TextEditingController hargaController = TextEditingController();
  final TextEditingController availabilityController = TextEditingController();

  // Fungsi untuk menambahkan data kostum ke Firebase
  Future<void> create() async {
    try {
      await FirebaseFirestore.instance.collection('Costum').add({
        'name': namaController.text,
        'size': ukuranController.text,
        'price': hargaController.text,
        'isAvailable': availabilityController.text,
      });

      // Tambahkan logika setelah berhasil menambahkan data ke Firebase
      // Misalnya, kembali ke halaman sebelumnya atau tampilkan pesan sukses.
    } catch (e) {
      // Handle error saat gagal menambahkan data ke Firebase
      print('Error creating costum: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Costum'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
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
              decoration: const InputDecoration(labelText: 'Price'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: availabilityController,
              decoration: const InputDecoration(labelText: 'Availability'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: create,
              child: const Text('Add Costum'),
            ),
          ],
        ),
      ),
    );
  }
}
