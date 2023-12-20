import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:yorzkha_cos/components/text_form_field.dart';
import 'package:yorzkha_cos/components/textfield.dart';
import 'package:yorzkha_cos/logic/costum.dart';
import 'package:yorzkha_cos/logic/ktp.dart';
import 'package:yorzkha_cos/logic/rent.dart';
import 'package:yorzkha_cos/presentations/pages/scan_page.dart';

class RentFormPage extends StatefulWidget {
  final Costum costum;
  const RentFormPage({super.key, required this.costum});

  @override
  State<RentFormPage> createState() => _RentFormPageState();
}

class _RentFormPageState extends State<RentFormPage> {
  final TextEditingController nikController = TextEditingController();
  final TextEditingController namaController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController jenisKelaminController = TextEditingController();
  final TextEditingController noHpController = TextEditingController();
  final TextEditingController namaKostumController = TextEditingController();

  @override
  void initState() {
    super.initState();
    namaKostumController.text = widget.costum.namaKostum;

    // Menampilkan snckbar jika membuka halaman ini dari halaman lain
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final snackBar = SnackBar(
        content: const Text(
            'Tekan ikon kamera untuk memindai KTP\n Agar mempermudah proses pengisian form',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            )),
        duration: const Duration(seconds: 4),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
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
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'RENT FORM',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(left: 16, right: 16, top: 32),
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
                      MyTextFormField(
                        hintText: 'NIK',
                        obscureText: false,
                        controller: nikController,
                        validator: (value) {
                          if (value?.length != 16 ||
                              value == null ||
                              value.isEmpty) {
                            return 'Format NIK Salah';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),
                      MyTextField(
                        hintText: 'Nama',
                        obscureText: false,
                        controller: namaController,
                        keyboardType: TextInputType.text,
                      ),
                      const SizedBox(height: 16),
                      MyTextField(
                        hintText: 'Alamat',
                        obscureText: false,
                        controller: alamatController,
                        keyboardType: TextInputType.text,
                      ),
                      const SizedBox(height: 16),
                      MyTextField(
                        hintText: 'Jenis Kelamin',
                        obscureText: false,
                        controller: jenisKelaminController,
                        keyboardType: TextInputType.text,
                      ),
                      const SizedBox(height: 16),
                      MyTextField(
                        hintText: 'No HP',
                        obscureText: false,
                        controller: noHpController,
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),
                      MyTextField(
                        hintText: 'Nama Kostum',
                        obscureText: false,
                        controller: namaKostumController,
                        keyboardType: TextInputType.text,
                        readOnly: true,
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            ),
            // Second Dotted Border
            Row(
              children: [
                Container(
                  width: 250,
                  margin: const EdgeInsets.only(left: 16, right: 16, top: 32),
                  child: DottedBorder(
                    borderType: BorderType.RRect,
                    color: Theme.of(context).colorScheme.inversePrimary,
                    dashPattern: const [16, 4],
                    radius: const Radius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      child: Material(
                        borderRadius: BorderRadius.circular(8),
                        color: Theme.of(context).colorScheme.secondary,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(8),
                          splashFactory: InkRipple.splashFactory,
                          splashColor:
                              Theme.of(context).colorScheme.inversePrimary,
                          onTap: () async {
                            // jika form kosong maka tampilkan snackbar
                            if (nikController.text.isEmpty ||
                                namaController.text.isEmpty ||
                                alamatController.text.isEmpty ||
                                jenisKelaminController.text.isEmpty ||
                                noHpController.text.isEmpty) {
                              final snackBar = SnackBar(
                                content: const Text(
                                    'Harap isi semua form terlebih dahulu',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    )),
                                backgroundColor:
                                    Theme.of(context).colorScheme.inversePrimary,
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                              return;
                            }
                            await Rent.create(
                              nikController.text,
                              namaController.text,
                              alamatController.text,
                              jenisKelaminController.text,
                              noHpController.text,
                              widget.costum.id,
                            );
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          child: const SizedBox(
                            height: 50,
                            child: Center(
                              child: Text(
                                'R E N T',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Tombol kamera dengan icon
                Container(
                  width: 62,
                  margin: const EdgeInsets.only(right: 16, top: 32),
                  child: DottedBorder(
                    borderType: BorderType.RRect,
                    color: Theme.of(context).colorScheme.inversePrimary,
                    dashPattern: const [16, 4],
                    radius: const Radius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      child: Material(
                        borderRadius: BorderRadius.circular(8),
                        color: Theme.of(context).colorScheme.secondary,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(8),
                          splashFactory: InkRipple.splashFactory,
                          splashColor:
                              Theme.of(context).colorScheme.inversePrimary,
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ScanPage(),
                              ),
                            );

                            // Lakukan pengecekan sebelum menggunakan hasilnya
                            if (result != null && result is KTP) {
                              // Data yang diterima adalah instance dari KTP, lakukan sesuatu dengan data tersebut
                              nikController.text = result.nik;
                              namaController.text = result.nama;
                              alamatController.text = result.alamat;
                              jenisKelaminController.text = result.jenisKelamin;
                            } else {
                              // Data yang diterima tidak sesuai dengan yang diharapkan
                              print(
                                  'Hasil dari ScanPage tidak valid atau tidak ada.');
                            }
                          },
                          child: const SizedBox(
                            height: 50,
                            child: Center(
                              child: Icon(
                                Icons.camera_alt,
                                color: Colors.black,
                                size: 30,
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
          ],
        ),
      ),
    );
  }
}
