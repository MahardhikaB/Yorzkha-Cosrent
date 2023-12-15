// page yang berisi deskripsi kostum

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:yorzkha_cos/logic/costum.dart';

class DeskripsiPage extends StatelessWidget {
  final Costum costum;

  const DeskripsiPage({
    Key? key,
    required this.costum,
  }) : super(key: key);

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              costum.namaKostum,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text('Ukuran: ${costum.ukuran}'),
            const SizedBox(height: 16),
            Text('Harga: ${costum.harga}'),
            const SizedBox(height: 16),
            Text('Status: ${costum.isAvailable ? 'Tersedia' : 'Digunakan'}'),

            // Dotted Border
            Flexible(
              child: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: DottedBorder(
                            strokeWidth: 1,
                            borderType: BorderType.RRect,
                            dashPattern: const [18, 4],
                            color: Theme.of(context).colorScheme.inversePrimary,
                            radius: const Radius.circular(8),
                            child: Text(
                              'Deskripsi',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.inversePrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
