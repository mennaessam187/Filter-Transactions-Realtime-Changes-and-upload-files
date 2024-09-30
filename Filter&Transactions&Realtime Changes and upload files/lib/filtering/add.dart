import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:secondproject_firebase/component/materialbutton.dart';
import 'package:secondproject_firebase/screens/homescreen.dart';

import 'package:path/path.dart';

class addData extends StatefulWidget {
  const addData({super.key});

  @override
  State<addData> createState() => _addDataState();
}

class _addDataState extends State<addData> {
  File? fileimage;
  String? url;

  Future<void> permission1() async {
    await [Permission.camera, Permission.storage].request();
  }

  Future<void> getImage() async {
    final ImagePicker picker = ImagePicker();

    final XFile? photo = await picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      fileimage = File(photo.path);
      var imagename = basename(fileimage!.path);
      final storageRef = FirebaseStorage.instance.ref(imagename);
      await storageRef.putFile(fileimage!);
      url = await storageRef.getDownloadURL();
      setState(() {});
    }
  }

  GlobalKey<FormState> key3 = GlobalKey<FormState>();
  List<Map<String, TextEditingController>> userControllers = [
    {
      'name': TextEditingController(),
      'age': TextEditingController(),
      'phone': TextEditingController(),
      'money': TextEditingController(),
    }
  ];

  // Function to add new user input fields
  void addNewUser() {
    setState(() {
      //add map in list
      userControllers.add({
        'name': TextEditingController(),
        'age': TextEditingController(),
        'phone': TextEditingController(),
        'money': TextEditingController(),
      });
    });
  }

  // Function to add all user data to Firestore
  Future<void> addData(context) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    for (var controllers in userControllers) {
      // Add each user's data to the batch
      batch.set(users.doc(), {
        'name': controllers['name']!.text,
        'age': controllers['age']!.text,
        'phone': controllers['phone']!.text,
        'money': controllers['money']!.text,
        'image': url ?? "none",
      });
    }
    await batch.commit().then((_) {
      Navigator.of(context).pushReplacementNamed("homepage");
    }).catchError((error) {
      // Handle error if needed
    });
    // Commit the batch write
    // await batch.commit().then((_) {
    // print("All users added successfully");
    // Navigate to the home page after adding data
    // Navigator.of(context).pushReplacementNamed("homepage");
    //}).catchError((error) {
    //  print("Failed to add users: $error");
    //});
  }

  @override
  void initState() {
    permission1();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Data")),
      body: Form(
        key: key3,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            ...userControllers.map((controllers) {
              return Column(
                children: [
                  TextFormField(
                    controller: controllers['name'],
                    decoration: const InputDecoration(
                      hintText: "Name",
                    ),
                  ),
                  TextFormField(
                    controller: controllers['age'],
                    decoration: const InputDecoration(
                      hintText: "Age",
                    ),
                  ),
                  TextFormField(
                    controller: controllers['phone'],
                    decoration: const InputDecoration(
                      hintText: "Phone",
                    ),
                  ),
                  TextFormField(
                    controller: controllers['money'],
                    decoration: const InputDecoration(
                      hintText: "Money",
                    ),
                  ),
                  const SizedBox(height: 20), // Add spacing between form fields
                ],
              );
            }).toList(),
            // Button to add more form fields
            IconButton(onPressed: addNewUser, icon: const Icon(Icons.add)),
            materialbuttonimage(() async {
              await getImage();
            }, "up load text", url == null ? false : true),
            // Button to submit all users' data
            materialbutton(() {
              if (key3.currentState!.validate()) {
                addData(context);
              }
            }, "Add All Users"),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Dispose all controllers when the widget is destroyed
    for (var controllers in userControllers) {
      controllers.forEach((key, controller) => controller.dispose());
    }
    super.dispose();
  }
}
