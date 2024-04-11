import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:noteit/ui/fullScreenImage.dart';

class ImagePage extends StatefulWidget {
  const ImagePage({Key? key}) : super(key: key);

  @override
  State<ImagePage> createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {
  final ImagePicker _picker = ImagePicker();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<String> imageUrls = [];

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<void> _loadImages() async {
    User? user = _auth.currentUser;
    if (user != null) {
      String userId = user.uid;
      ListResult result = await FirebaseStorage.instance
          .ref()
          .child('images/$userId')
          .listAll();

      List<String> urls = [];
      await Future.forEach(result.items, (Reference ref) async {
        String downloadURL = await ref.getDownloadURL();
        urls.add(downloadURL);
      });

      setState(() {
        imageUrls = urls;
      });
    }
  }

Future<void> _uploadImage() async {
  final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
  if (pickedFile != null) {
    File imageFile = File(pickedFile.path);
    String userId = _auth.currentUser?.uid ?? 'unknown';
    String fileName =
        '${userId}_${DateTime.now().millisecondsSinceEpoch}.jpg';

    Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('images/$userId/$fileName');

    UploadTask uploadTask = firebaseStorageRef.putFile(imageFile);

    await uploadTask.whenComplete(() => setState(() {
      _loadImages();
      Fluttertoast.showToast(msg: 'Image uploaded successfully!');
    }));
  } else {
    print('No image selected.');
  }
}
  void _deleteImage(String imageUrl) async {
    await FirebaseStorage.instance.refFromURL(imageUrl).delete();
    _loadImages();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Gallery'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _uploadImage,
        child: const Icon(Icons.add_a_photo),
      ),
      body: imageUrls.isEmpty
          ? Center(child: CircularProgressIndicator())
          : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: imageUrls.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FullScreenImagePage(
                          imageUrl: imageUrls[index],
                          onDelete: () => _deleteImage(imageUrls[index]),
                        ),
                      ),
                    );
                  },
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                            10), // Adjust the value as needed
                        child: Image.network(
                          imageUrls[index],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
