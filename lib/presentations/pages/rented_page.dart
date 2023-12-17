// page yang berisi deskripsi kostum

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:yorzkha_cos/logic/costum.dart';
import 'package:yorzkha_cos/logic/rent.dart';

class RentedPage extends StatefulWidget {
  final Costum costum;

  const RentedPage({
    Key? key,
    required this.costum,
  }) : super(key: key);

  @override
  State<RentedPage> createState() => _RentedPageState();
}

class _RentedPageState extends State<RentedPage> {
  Rent? rent = null;

  void getRent() async {
    rent = await Rent.getLastRentByCostumId(widget.costum.id);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRent();
    setState(() {});
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              widget.costum.namaKostum,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text('Ukuran: ${widget.costum.ukuran}'),
            const SizedBox(height: 16),
            Text('Harga: ${widget.costum.harga}'),
            const SizedBox(height: 16),
            Text(
                'Status: ${widget.costum.isAvailable ? 'Tersedia' : 'Digunakan'}'),

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
                  child: Column(
                    children: [
                      Text(
                        'NIK: ${rent?.nik}',
                      ),
                      Text(
                        'Namaa Peminjam: ${rent?.nama}',
                      ),
                      Text(
                        'Alamat: ${rent?.alamat}',
                      ),
                      Text(
                        'Jenis Kelamin: ${rent?.jenisKelamin}',
                      ),
                      Text(
                        'No Telp: ${rent?.noTelp}',
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Second Dotted Border
            Container(
              margin: const EdgeInsets.only(left: 16, right: 16),
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
                      splashColor: Theme.of(context).colorScheme.inversePrimary,
                      onTap: () async {
                        // find costum by costumId then update isAvailable
                        final costumDoc = await FirebaseFirestore.instance
                            .collection('Costum')
                            .doc(widget.costum.id)
                            .get();
                        await costumDoc.reference.update({
                          'isAvailable': true,
                        });
                        Navigator.pop(context);
                      },
                      child: FloatingActionButton(
                          onPressed: null,
                          backgroundColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          elevation: 0,
                          child: Center(
                            child: Text(
                              'Returned',
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          )),
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
