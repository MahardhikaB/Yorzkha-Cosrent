import 'package:flutter/material.dart';
import 'package:yorzkha_cos/logic/costum.dart';
import 'package:yorzkha_cos/logic/rent.dart';


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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Peminjaman'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: nikController,
                decoration: const InputDecoration(
                  labelText: 'NIK',
                ),
              ),
              TextField(
                controller: namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama',
                ),
              ),
              TextField(
                controller: alamatController,
                decoration: const InputDecoration(
                  labelText: 'Alamat',
                ),
              ),
              TextField(
                controller: jenisKelaminController,
                decoration: const InputDecoration(
                  labelText: 'Jenis Kelamin',
                ),
              ),
              TextField(
                controller: noHpController,
                decoration: const InputDecoration(
                  labelText: 'No HP',
                ),
              ),
              TextField(
                controller: namaKostumController,
                decoration: const InputDecoration(
                  labelText: 'Nama Kostum',
                ),
                readOnly: true,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
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
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}