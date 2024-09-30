import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:secondproject_firebase/component/materialbutton.dart';

class addAllCategory extends StatefulWidget {
  const addAllCategory({super.key});

  @override
  State<addAllCategory> createState() => _addAllCategoryState();
}

class _addAllCategoryState extends State<addAllCategory> {
  GlobalKey<FormState> key6 = GlobalKey();
  List<Map<String, TextEditingController>> userControllers = [
    {
      'name': TextEditingController(),
      'age': TextEditingController(),
      'phone': TextEditingController(),
      'money': TextEditingController(),
    }
  ];
  void addUserController() {
    setState(() {
      userControllers.add({
        'name': TextEditingController(),
        'age': TextEditingController(),
        'phone': TextEditingController(),
        'money': TextEditingController(),
      });
    });
  }

  Future<void> addData() async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    WriteBatch batch = FirebaseFirestore.instance.batch();
    for (var controller in userControllers) {
      batch.set(users.doc(), {
        'name': controller['name']!.text,
        'age': controller['age']!.text,
        'phone': controller['phone']!.text,
        'money': controller['money']!.text,
      });
      await batch.commit().then((_) {
        Navigator.of(context).pushReplacementNamed("homepage");
      }).catchError((error) {
        // Handle error if needed
      });
    }
  }

  @override
  void dispose() {
    // Dispose all controllers when the widget is destroyed
    for (var controllers in userControllers) {
      controllers.forEach((key, controller) => controller.dispose());
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: key6,
        child: ListView(
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
            IconButton(
                onPressed: () {
                  addUserController();
                },
                icon: Icon(Icons.add)),
            IconButton(onPressed: () {}, icon: Icon(Icons.remove)),
            materialbutton(() {
              addData();
            }, "Add All")
          ],
        ),
      ),
    );
  }
}
