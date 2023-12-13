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
  String availability = 'Tersedia'; // Default value
  final List<String> availabilityOptions = ['Tersedia', 'Tidak Tersedia'];

  // Fungsi untuk menambahkan data kostum ke Firebase
  Future<void> create() async {
    // show loading circle
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    try {
      // Konversi harga menjadi integer
      final int harga = int.tryParse(hargaController.text) ?? 0;

      // Konversi availability menjadi boolean
      final bool isAvailable = availability == 'Tersedia' ? true : false;

      await FirebaseFirestore.instance.collection('Costum').add({
        'NamaKostum': namaController.text,
        'Ukuran': ukuranController.text,
        'Harga': harga,
        'isAvailable': isAvailable,
      });

      // pop loading circle
      if (context.mounted) {
        Navigator.pop(context);
      }

      // Tampilkan pesan sukses
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Costum added successfully'),
        ),
      );

      // Kembali ke halaman sebelumnya
      Navigator.pop(context);


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
              onPressed: create,
              child: const Text('Add Costum'),
            ),
          ],
        ),
      ),
    );
  }
}
