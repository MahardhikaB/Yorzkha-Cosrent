import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yorzkha_cos/components/card.dart';
import 'package:yorzkha_cos/logic/costum.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // logout function
  void logout() async {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    // Take collection from firestore
    final costumCollection = FirebaseFirestore.instance.collection('Costum');

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
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
                    child: DottedBorder(
                      borderType: BorderType.RRect,
                      color: Theme.of(context).colorScheme.inversePrimary,
                      dashPattern: const [16, 4],
                      radius: const Radius.circular(8),
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
                                final costum = Costum.fromSnapshot(snapshot.data!.docs[index]);
                                return MyCard(costum: costum);
                              },
                            );
                          }
                        },
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