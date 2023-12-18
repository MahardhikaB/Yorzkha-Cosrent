import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:yorzkha_cos/components/card.dart';
import 'package:yorzkha_cos/logic/costum.dart';
import 'package:yorzkha_cos/presentations/pages/add_costum_page.dart';
import 'package:yorzkha_cos/presentations/pages/update_costum_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // logout function
  void logout() async {
    FirebaseAuth.instance.signOut();
  }

  // Navigate to AddCostumPage
  void navigateToAddCostumPage() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const AddCostumPage()));
  }

  @override
  Widget build(BuildContext context) {
    // Take collection from firestore
    final costumCollection =
        FirebaseFirestore.instance.collection('Costum').orderBy('NamaKostum');
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Row(
            children: [
              const SizedBox(width: 48),
              Text(
                'Y O R Z K H A   C O S R E N T',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
        actions: [
          // Logout button
          IconButton(
            onPressed: logout,
            icon: const Icon(Icons.logout),
            color: Colors.red,
          )
        ],
        elevation: 0,
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            children: [
              const Text(
                'DAFTAR KOSTUM',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Flexible(
                child: Container(
                  height: 800,
                  width: double.infinity,
                  margin: const EdgeInsets.all(16),
                  clipBehavior: Clip.hardEdge,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(8)),
                  child: Stack(
                    children: [
                      // First Dotted Border
                      DottedBorder(
                        strokeWidth: 2,
                        borderType: BorderType.RRect,
                        dashPattern: const [20, 6],
                        color: Theme.of(context).colorScheme.inversePrimary,
                        radius: const Radius.circular(8),
                        child: Positioned.fill(
                          child: StreamBuilder(
                            stream: costumCollection.snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else {
                                return ListView.builder(
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder: (context, index) {
                                    final costum = Costum.fromSnapshot(
                                        snapshot.data!.docs[index]);
                                    return Slidable(
                                      startActionPane: ActionPane(
                                        motion: const Padding(
                                          padding: EdgeInsets.all(16.0),
                                          child: StretchMotion(),
                                        ),
                                        children: [
                                          // Edit button
                                          SlidableAction(
                                            borderRadius:
                                                const BorderRadius.only(
                                              topLeft: Radius.circular(8),
                                              bottomLeft: Radius.circular(8),
                                            ),
                                            onPressed: (context) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      UpdateCostumPage(
                                                    costum: costum,
                                                  ),
                                                ),
                                              );
                                            },
                                            backgroundColor: Colors.blue,
                                            icon: Icons.edit,
                                          ),
                                          // Delete button
                                          SlidableAction(
                                            borderRadius:
                                                const BorderRadius.only(
                                              topRight: Radius.circular(8),
                                              bottomRight: Radius.circular(8),
                                            ),
                                            onPressed: (context) {
                                              // Menampilkan dialog konfirmasi sebelum menghapus
                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialog(
                                                  title:
                                                      const Text('Konfirmasi'),
                                                  content: const Text(
                                                      'Apakah Anda yakin ingin menghapus kostum ini?'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(
                                                            context); // Tutup dialog
                                                      },
                                                      child:
                                                          const Text('Batal'),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        // Hapus kostum jika dikonfirmasi
                                                        Costum.deleteCostum(
                                                            costum.id,
                                                            costum.imageUrl,
                                                            context);
                                                        Navigator.pop(
                                                            context); // Tutup dialog
                                                      },
                                                      child:
                                                          const Text('Hapus'),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                            backgroundColor: Colors.red,
                                            icon: Icons.delete,
                                          ),
                                        ],
                                      ),
                                      child: MyCard(costum: costum),
                                    );
                                  },
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Second Dotted Border
              Container(
                margin: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
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
                          navigateToAddCostumPage();
                        },
                        child:
                            const SizedBox(height: 50, child: Icon(Icons.add)),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
