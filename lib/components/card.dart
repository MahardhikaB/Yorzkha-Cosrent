
import 'package:flutter/material.dart';
import 'package:yorzkha_cos/logic/costum.dart';
import 'package:yorzkha_cos/presentations/pages/deskripsi_page.dart';
import 'package:yorzkha_cos/presentations/pages/rented_page.dart';
import 'package:intl/intl.dart';

class MyCard extends StatelessWidget {
  final Costum costum;

  const MyCard({
    super.key,
    required this.costum,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp');
    return Container(
      width: double.infinity,
      height: 120,
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.inversePrimary,
          width: 3,
        ),
      ),
      child: Material(
        clipBehavior: Clip.hardEdge,
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            // if costum is available, go to rent form page
            if (costum.isAvailable) {
              Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DeskripsiPage(costum: costum),
              ),
            );
            } else {
              // if costum is not available, go to rented page
              Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RentedPage(costum: costum),
              ),
            );
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.network(costum.imageUrl, width: 60, height: 60),
              Container(
                width: 1,
                margin: const EdgeInsets.symmetric(vertical: 16),
                height: double.infinity,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    costum.namaKostum, 
                    style: const TextStyle(fontWeight: FontWeight.bold)
                  ),
                  const SizedBox(height: 8),
                  Text('Ukuran: ${costum.ukuran}'),
                  const SizedBox(height: 8),
                  Text('Harga: ${currencyFormatter.format(costum.harga)} / 3 Days'),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      
                      // status
                      const Text('Status: '),
                      Text(costum.isAvailable ? 'Tersedia' : 'Digunakan'),
                      const SizedBox(width: 6),
                      Icon(
                        Icons.circle,
                        size: 14,
                        color: costum.isAvailable ? Colors.green : Colors.red,
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}