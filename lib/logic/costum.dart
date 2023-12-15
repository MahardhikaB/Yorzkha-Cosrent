import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Costum {
  String id;
  int harga;
  String namaKostum;
  String ukuran;
  bool isAvailable;
  String imageUrl;

  Costum({
    required this.id, 
    required this.harga, 
    required this.namaKostum, 
    required this.ukuran,
    required this.isAvailable,
    required this.imageUrl,
    });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['NamaKostum'] = namaKostum;
    data['Ukuran'] = ukuran;
    data['Harga'] = harga;
    data['isAvailable'] = isAvailable;
    data['imageUrl'] = imageUrl;
    return data;
  }

  factory Costum.fromSnapshot(DocumentSnapshot snapshot) {
    return Costum(
      id: snapshot.id,
      namaKostum: snapshot.get('NamaKostum') as String,
      ukuran: snapshot.get('Ukuran') as String,
      harga: snapshot.get('Harga') as int,
      isAvailable: snapshot.get('isAvailable') as bool,
      imageUrl: snapshot.get('imageUrl') as String,
    );
  }

  // create function
  static Future<void> create(TextEditingController namaController, TextEditingController ukuranController, TextEditingController hargaController, String availability, String imageUrl, BuildContext context) async {
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
        'imageUrl': imageUrl,
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

  // update function
  static Future<void> update(String documentId, String namaKostum, String ukuran, int harga, bool isAvailable, String imageUrl, BuildContext context) async {
    // show loading circle
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    try {
      // update data to firebase using the documentId
      await FirebaseFirestore.instance.collection('Costum').doc(documentId).update({
        'NamaKostum': namaKostum,
        'Ukuran': ukuran,
        'Harga': harga,
        'isAvailable': isAvailable,
        'imageUrl': imageUrl,
      });

      // pop loading circle
      if (context.mounted) {
        Navigator.pop(context);
      }

      // display success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Costum updated successfully'),
        ),
      );

      // go back to previous page
      Navigator.pop(context);

      
    } catch (e) {
      // Handle error saat gagal mengupdate data ke Firebase
      print('Error updating costum: $e');
    }
  }

  // delete function
  static Future<void> deleteCostum(String documentId, BuildContext context) async {
    try {
      // delete data from firebase using the documentId
      await FirebaseFirestore.instance.collection('Costum').doc(documentId).delete();

      // display success message
      print('Costum deleted successfully');
      
    } catch (e) {
      // Handle error saat gagal menghapus data dari Firebase
      print('Error deleting costum: $e');
    }
  }
}