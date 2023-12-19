import 'package:dio/dio.dart';

class KTP {
  final String nik;
  final String nama;
  final String jenisKelamin;
  final String alamat;

  const KTP({
    required this.nik,
    required this.nama,
    required this.jenisKelamin,
    required this.alamat,
  });

  factory KTP.fromJson(Map<String, dynamic> json) {
    return KTP(
      nik: json['nik'] ?? '',
      nama: json['nama'] ?? '',
      jenisKelamin: json['jenis_kelamin'] ?? '',
      alamat: json['alamat'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nik': nik,
      'nama': nama,
      'jenis_kelamin': jenisKelamin,
      'alamat': alamat,
    };
  }

  static Future<KTP?> getDataByUploadImage(String filePath, String url, Dio dio) async {
    String fileName = filePath.split('/').last;
    FormData formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(filePath, filename: fileName),
    });
    late Response response;
    try {
      response = await dio.post(
        url,
        data: formData,
      );
    } on DioException catch (_) {
      return null;
    }
    return KTP.fromJson(response.data as Map<String, dynamic>);
  }
}