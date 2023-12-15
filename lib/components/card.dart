
import 'package:flutter/material.dart';
import 'package:yorzkha_cos/logic/costum.dart';
import 'package:yorzkha_cos/presentations/pages/deskripsi_page.dart';

class MyCard extends StatelessWidget {
  final Costum costum;

  const MyCard({
    super.key,
    required this.costum,
  });

  @override
  Widget build(BuildContext context) {
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
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DeskripsiPage(costum: costum),
              ),
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.network(costum.imageUrl, width: 80, height: 80),
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
                  Text('Harga: ${costum.harga}'),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      
                      // status
                      const Text('Status: '),
                      Text(costum.isAvailable ? 'Tersedia' : 'Digunakan'),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.circle,
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