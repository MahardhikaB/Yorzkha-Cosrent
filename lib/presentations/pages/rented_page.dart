// page yang berisi deskripsi kostum

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yorzkha_cos/components/textfield.dart';
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
  Rent? rent;

  @override
  void initState() {
    // TODO: implement initState
    getRent();
    super.initState();
  }

  void getRent() async {
    rent = await Rent.getLastRentByCostumId(widget.costum.id);
    setState(() {});
  }

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
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  // Gambar
                  Image.network(widget.costum.imageUrl, width: 100, height: 150),
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
                            widget.costum.namaKostum,
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text('Ukuran: ${widget.costum.ukuran}'),
                          const SizedBox(height: 8),
                          Text(
                              'Harga: ${currencyFormatter.format(widget.costum.harga)} / 3 Days'),
                          const SizedBox(height: 8),
                          Text(
                              'Status: ${widget.costum.isAvailable ? 'Tersedia' : 'Digunakan'}'),
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
                margin: const EdgeInsets.only(right: 8, left: 8, top: 32),
                child: SizedBox(
                  width: double.infinity,
                  height: 800,
                  child: DottedBorder(
                    strokeWidth: 1,
                    borderType: BorderType.RRect,
                    dashPattern: const [18, 4],
                    color: Theme.of(context).colorScheme.inversePrimary,
                    radius: const Radius.circular(8),
                    child: Center(
                      child: Column(
                        children: [
                          const SizedBox(height: 8),
                          Text(
                            'D A T A   P E M I N J A M',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.inversePrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 16, left: 16, top: 4, bottom: 4),
                            child: MyTextField(
                              hintText: '',
                              obscureText: false,
                              controller: TextEditingController(
                                text: 'NIK : ${rent?.nik}',
                              ),
                              keyboardType: TextInputType.number,
                              readOnly: true,
                              ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 16, left: 16, top: 4, bottom: 4),
                            child: MyTextField(
                              hintText: '',
                              obscureText: false,
                              controller: TextEditingController(
                                text: 'Nama : ${rent?.nama}',
                              ),
                              keyboardType: TextInputType.text,
                              readOnly: true,
                              ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 16, left: 16, top: 4, bottom: 4),
                            child: MyTextField(
                              hintText: '',
                              obscureText: false,
                              controller: TextEditingController(
                                text: 'Alamat : ${rent?.alamat}',
                              ),
                              keyboardType: TextInputType.text,
                              readOnly: true,
                              ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 16, left: 16, top: 4, bottom: 4),
                            child: MyTextField(
                              hintText: '',
                              obscureText: false,
                              controller: TextEditingController(
                                text: 'Jenis Kelamin : ${rent?.jenisKelamin}',
                              ),
                              keyboardType: TextInputType.text,
                              readOnly: true,
                              ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 16, left: 16, top: 4, bottom: 4),
                            child: MyTextField(
                              hintText: '',
                              obscureText: false,
                              controller: TextEditingController(
                                text: 'No. HP : ${rent?.noTelp}',
                              ),
                              keyboardType: TextInputType.number,
                              readOnly: true,
                              ),
                          ),
                        ],
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
                      splashColor: Theme.of(context).colorScheme.inversePrimary,
                      onTap: () async {
                        // snckbar
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: const Text('Kostum telah dikembalikan',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                          ),
                        );
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
                      child: const SizedBox(
                        height: 50,
                        child: Center(
                          child: Text(
                            'R E T U R N',
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
