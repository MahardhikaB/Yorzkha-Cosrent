import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:yorzkha_cos/components/card.dart';
import 'package:yorzkha_cos/logic/costum.dart';
import 'package:yorzkha_cos/presentations/pages/add_costum_page.dart';

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
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AddCostumPage()));
  }

  @override
  Widget build(BuildContext context) {
    // Take collection from firestore
    final costumCollection = FirebaseFirestore.instance.collection('Costum').orderBy('NamaKostum');
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
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration:BoxDecoration(borderRadius: BorderRadius.circular(8)),
                  child: Stack(
                    children: [
                      // First Dotted Border
                      DottedBorder(
                        borderType: BorderType.RRect,
                        color: Theme.of(context).colorScheme.inversePrimary,
                        dashPattern: const [16, 4],
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
                                      snapshot.data!.docs[index]
                                    );
                                    return Slidable(
                                      startActionPane: ActionPane(
                                        motion: Padding(
                                          padding: EdgeInsets.all(16.0),
                                          child: StretchMotion(),
                                        ), 
                                        children: [
                                          // Edit button
                                          SlidableAction(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(8),
                                              bottomLeft: Radius.circular(8),
                                            ),
                                            onPressed: null,
                                            backgroundColor: Colors.blue,
                                            icon: Icons.edit,
                                          ),
                                          // Delete button
                                          SlidableAction(
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(8),
                                              bottomRight: Radius.circular(8),
                                            ),
                                            onPressed: (context) {
                                              Costum.deleteCostum(costum.id);
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
                        onTap: () {
                          navigateToAddCostumPage();
                        },
                        child: FloatingActionButton(
                          onPressed: null,
                          backgroundColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)
                          ),
                          elevation: 0,
                          child: const Icon(Icons.add),
                        ),
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
