// page yang berisi deskripsi kostum

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yorzkha_cos/logic/costum.dart';
import 'package:yorzkha_cos/presentations/pages/rent_form_page.dart';

class DeskripsiPage extends StatelessWidget {
  final Costum costum;

  const DeskripsiPage({
    Key? key,
    required this.costum,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currencyFormatter =
        NumberFormat.currency(locale: 'id', symbol: 'Rp.', decimalDigits: 0);
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
            // Gambar dan Nama
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  // Gambar
                  Image.network(costum.imageUrl, width: 100, height: 150),
                  const SizedBox(width: 16),
                  Container(
                    height: 150,
                    width: 1,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                  const SizedBox(width: 16),
                  // Nama dan Teks
                  Center(
                    child: Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            costum.namaKostum,
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text('Ukuran: ${costum.ukuran}'),
                          const SizedBox(height: 8),
                          Text(
                              'Harga: ${currencyFormatter.format(costum.harga)} / 3 Days'),
                          const SizedBox(height: 8),
                          Text(
                              'Status: ${costum.isAvailable ? 'Tersedia' : 'Digunakan'}'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Dotted Border
            Flexible(
              child: Container(
                margin: const EdgeInsets.only(right: 8, left: 8, top: 16),
                child: SizedBox(
                  height: 800,
                  width: double.infinity,
                  child: DottedBorder(
                    strokeWidth: 1,
                    borderType: BorderType.RRect,
                    dashPattern: const [18, 4],
                    color: Theme.of(context).colorScheme.inversePrimary,
                    radius: const Radius.circular(8),
                    child: Text(
                      costum.deskripsi,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Second Dotted Border
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(left: 8, right: 8, top: 16),
              child: DottedBorder(
                borderType: BorderType.RRect,
                color: Theme.of(context).colorScheme.inversePrimary,
                dashPattern: const [16, 4],
                radius: const Radius.circular(8),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(5),
                  child: Material(
                    borderRadius: BorderRadius.circular(8),
                    color: Theme.of(context).colorScheme.secondary,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      splashFactory: InkRipple.splashFactory,
                      splashColor:
                          Theme.of(context).colorScheme.inversePrimary,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                RentFormPage(costum: costum),
                          ),
                        );
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
          ],
        ),
      ),
    );
  }
}
