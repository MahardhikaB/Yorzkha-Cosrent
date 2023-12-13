// i have ID, field Harga, NamaKostum, and Ukuran. Create me a model base on those field
import 'package:cloud_firestore/cloud_firestore.dart';

class Costum {
  String id;
  int harga;
  String namaKostum;
  String ukuran;
  bool isAvailable;

  Costum({
    required this.id, 
    required this.harga, 
    required this.namaKostum, 
    required this.ukuran,
    required this.isAvailable,
    });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['NamaKostum'] = this.namaKostum;
    data['Ukuran'] = this.ukuran;
    data['Harga'] = this.harga;
    data['isAvailable'] = this.isAvailable;
    return data;
  }

  factory Costum.fromSnapshot(DocumentSnapshot snapshot) {
    return Costum(
      id: snapshot.id,
      namaKostum: snapshot.get('NamaKostum') as String,
      ukuran: snapshot.get('Ukuran') as String,
      harga: snapshot.get('Harga') as int,
      isAvailable: snapshot.get('isAvailable') as bool,
    );
  }

  // delete function
  static Future<void> deleteCostum(String documentId) async {
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