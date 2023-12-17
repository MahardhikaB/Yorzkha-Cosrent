import 'package:cloud_firestore/cloud_firestore.dart';

class Rent {
  String id;
  String nik;
  String nama;
  String alamat;
  String jenisKelamin;
  String noTelp;
  String costumId;
  Timestamp createdAt;

  Rent({
    required this.id,
    required this.nik,
    required this.nama,
    required this.alamat,
    required this.jenisKelamin,
    required this.noTelp,
    required this.costumId,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Nik'] = nik;
    data['Nama'] = nama;
    data['Alamat'] = alamat;
    data['JenisKelamin'] = jenisKelamin;
    data['NoTelp'] = noTelp;
    data['CostumId'] = costumId;
    data['CreatedAt'] = createdAt;
    return data;
  }

  factory Rent.fromSnapshot(DocumentSnapshot snapshot) {
    return Rent(
      id: snapshot.id,
      nik: snapshot.get('Nik') as String,
      nama: snapshot.get('Nama') as String,
      alamat: snapshot.get('Alamat') as String,
      jenisKelamin: snapshot.get('JenisKelamin') as String,
      noTelp: snapshot.get('NoTelp') as String,
      costumId: snapshot.get('CostumId') as String,
      createdAt: snapshot.get('CreatedAt') as Timestamp,
    );
  }

  // create function
  static Future<void> create(
    String nik,
    String nama,
    String alamat,
    String jenisKelamin,
    String noTelp,
    String costumId,
  ) async {
    final data = <String, dynamic>{
      'Nik': nik,
      'Nama': nama,
      'Alamat': alamat,
      'JenisKelamin': jenisKelamin,
      'NoTelp': noTelp,
      'CostumId': costumId,
      'CreatedAt': Timestamp.now(),
    };

    await FirebaseFirestore.instance.collection('Rent').add(data);
    // find costum by costumId then update isAvailable
    final costumDoc = await FirebaseFirestore.instance
        .collection('Costum')
        .doc(costumId)
        .get();
    await costumDoc.reference.update({
      'isAvailable': false,
    });
  }

  // function to get last rented data by costum id
  static Future<Rent?> getLastRentByCostumId(String costumId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('Rent')
        .where('CostumId', isEqualTo: costumId)
        .orderBy('CreatedAt', descending: true)
        .limit(1)
        .get();
    if (snapshot.docs.isEmpty) return null;
    return Rent.fromSnapshot(snapshot.docs.first);
  }
}