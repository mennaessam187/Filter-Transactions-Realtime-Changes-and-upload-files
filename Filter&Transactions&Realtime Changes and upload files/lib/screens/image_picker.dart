import 'dart:io';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ImagePickerScreen extends StatefulWidget {
  const ImagePickerScreen({Key? key}) : super(key: key);

  @override
  State<ImagePickerScreen> createState() => _ImagePickerScreenState();
}

File? file;
String? url;

class _ImagePickerScreenState extends State<ImagePickerScreen> {
  Future<void> permission() async {
    await [Permission.camera, Permission.storage].request();
  }

  Future<void> getImage() async {
    final ImagePicker picker = ImagePicker();

    final XFile? photo = await picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      file = File(photo.path);
      var imagename = basename(file!.path);
      final storageRef = FirebaseStorage.instance.ref(imagename);
      await storageRef.putFile(file!);
      url = await storageRef.getDownloadURL();
      setState(() {});
    }
  }

  /* Future<void> requestPermissions() async {
    await [Permission.camera, Permission.storage].request();
  }
*/
  /* Future<void> getImage() async {
    final ImagePicker picker = ImagePicker();
    // final XFile? photo = await picker.pickImage(source: ImageSource.camera);
    final XFile? imageCamera =
        await picker.pickImage(source: ImageSource.camera);
    if (imageCamera != null) {
      file = File(imageCamera.path);
      var imagename = basename(imageCamera.path);
      final StorageRef = FirebaseStorage.instance.ref().child(imagename);
      await StorageRef.putFile(file!);
      url = await StorageRef.getDownloadURL();

      setState(() {});
    }
  }
*/
  @override
  void initState() {
    super.initState();
    permission(); // Request permissions on init
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Image Picker"),
      ),
      body: Column(
        children: [
          MaterialButton(
            onPressed: getImage,
            child: const Text("Pick Photo"),
          ),
          if (url != null) Image.network(url!),
        ],
      ),
    );
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MaterialApp(home: ImagePickerScreen()));
}
