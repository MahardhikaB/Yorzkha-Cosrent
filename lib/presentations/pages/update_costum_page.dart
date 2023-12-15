import 'package:flutter/material.dart';
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
  final TextEditingController availabilityController = TextEditingController();
  String availability = 'Tersedia'; // Default value
  final List<String> availabilityOptions = ['Tersedia', 'Tidak Tersedia'];

  

  @override
  Widget build(BuildContext context) {
    namaController.text = widget.costum.namaKostum;
    ukuranController.text = widget.costum.ukuran;
    hargaController.text = widget.costum.harga.toString();
    availability = widget.costum.isAvailable ? 'Tersedia' : 'Tidak Tersedia';
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
              onPressed: () {
                Costum.update(
                  widget.costum.id,
                  namaController.text,
                  ukuranController.text,
                  int.tryParse(hargaController.text) ?? 0,
                  availability == 'Tersedia' ? true : false,
                  widget.costum.imageUrl,
                  context,
                );
              },
              child: const Text('Add Costum'),
            ),
          ],
        ),
      ),
    );
  }
}
