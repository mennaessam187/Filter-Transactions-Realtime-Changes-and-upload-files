//import 'dart:js_interop_unsafe';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:secondproject_firebase/filtering/add.dart';
import 'package:secondproject_firebase/filtering/filter.dart';

class homepage extends StatefulWidget {
  const homepage({super.key});

  @override
  State<homepage> createState() => _homepageState();
}

// CollectionReference users = FirebaseFirestore.instance.collection('users');

class _homepageState extends State<homepage> {
  List<Map<String, dynamic>> data = [];
  final Stream<QuerySnapshot> usersStream =
      FirebaseFirestore.instance.collection('users').snapshots();
  /* getData() async {
    QuerySnapshot data1 =
        await FirebaseFirestore.instance.collection('users').get();
    setState(() {});
    data = data1.docs.map((doc) {
      Map<String, dynamic> docData = doc.data() as Map<String, dynamic>;
      docData['id'] = doc.id;
      return docData;
    }).toList();
  }
*/
  @override
  /* void initState() {
    getData();

    super.initState();
  }
*/
  static deleteFile(String urlFile) async {
    try {
      final ref = FirebaseStorage.instance.refFromURL(urlFile);
      await ref.delete();
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("homePage"),
        actions: [
          IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context)
                    .pushNamedAndRemoveUntil("Login", (route) => false);
              },
              icon: Icon(Icons.output_rounded))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => addData()));
        },
        child: Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: usersStream,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            print("Error");
            return Text("Something went wrong!");
          }

          // Handle loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            print("loading....");
            return CircularProgressIndicator(); // Return a loading spinner
          }

          // Handle no data or empty collection
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            print("data not valid");
            return Text("No data available"); // Return message for no data
          }
          return ListView.builder(
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  String id = snapshot.data!.docs[index].id;
                  DocumentReference documentReference =
                      FirebaseFirestore.instance.collection('users').doc(id);

                  FirebaseFirestore.instance
                      .runTransaction((transaction) async {
                        DocumentSnapshot snapshot =
                            await transaction.get(documentReference);

                        if (snapshot.exists) {
                          var snapData = snapshot.data();
                          if (snapData is Map<String, dynamic>) {
                            var currentMoney = snapshot['money'].toString();
                            var newMoney = int.parse(currentMoney) + 100;
                            transaction
                                .update(documentReference, {'money': newMoney});
                          }
                        }

                        // Perform an update on the document
                      })
                      .then(
                          (value) => print("Follower count updated to $value"))
                      .catchError((error) =>
                          print("Failed to update user followers: $error"));
                },
                child: Card(
                  child: ListTile(
                      title: Text(
                        "${snapshot.data!.docs[index]['name']}",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        children: [
                          Text("age:${snapshot.data!.docs[index]['age']}"),
                          Container(
                            width: 50,
                            height: 50,
                            child: Image.network(
                                snapshot.data!.docs[index]['image']),
                          ),
                          IconButton(
                            onPressed: () async {
                              String id = snapshot.data!.docs[index]
                                  .id; // Firestore document ID
                              String imageUrl = snapshot.data!.docs[index]
                                  ['image']; // Image URL from Firestore

                              try {
                                // Step 1: Delete image from Firebase Storage
                                if (imageUrl != "none") {
                                  deleteFile(imageUrl);
                                }

                                // Step 2: Delete document from Firestore
                                await FirebaseFirestore.instance
                                    .collection("users")
                                    .doc(id)
                                    .delete(); // Delete the Firestore document

                                print("Document deleted successfully.");
                              } catch (e) {
                                print("Error deleting document or image: $e");
                              }
                            },
                            icon: Icon(Icons.delete),
                          ),
                        ],
                      ),
                      trailing: Text(
                        " ${snapshot.data!.docs[index]['money']}",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                ),
              );
            },
            itemCount: snapshot.data!.docs.length,
          );
        },
      ),
    );
  }
}
/*
 ListView.builder(
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () async {
            
              ///instead of transaction
              /// DocumentReference docsnap=FirebaseFirestore.instance.collection("users").doc(id);
              /// docsnap.update({"money":int.parse(data[index]['money'])+100});
            },
            child: Card(
              child: ListTile(
                title: Text(
                  "${data[index]['name']}",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text("age: ${data[index]['age']}"),
                trailing: Text(
                  " ${data[index]['money']}",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        },
        itemCount: data.length,
      ),
*/
/*
  String id = data[index]['id'];
              DocumentReference documentSnapshot =
                  await FirebaseFirestore.instance.collection('users').doc(id);
              FirebaseFirestore.instance.runTransaction((transaction) async {
                DocumentSnapshot snapshot =
                    await transaction.get(documentSnapshot);
                if (snapshot.exists) {
                  var snapData = snapshot.data();
                  if (snapData is Map<String, dynamic>) {
                    int currentMoney = int.parse(snapData['money'].toString());
                    int updatedMoney = currentMoney + 100;
                    //   String money =
                    //     (int.parse(snapData['money']) + 100).toString();
                    transaction.update(
                        documentSnapshot, {'money': updatedMoney.toString()});
                  }
                }
              }).then((value) {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil("homepage", (route) => false);
              });
*/