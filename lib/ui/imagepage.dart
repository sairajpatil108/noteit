 

import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
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
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  @override
  void dispose() {
    super.dispose();
    
  }

  Future<void> _loadImages() async {
    setState(() {
      _isLoading = true;
    });

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

       
      if (mounted) {
        setState(() {
          imageUrls = urls;
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _uploadImage() async {
    setState(() {
      _isLoading = true;
    });

    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      String userId = _auth.currentUser?.uid ?? 'unknown';
      String fileName =
          '${userId}_${DateTime.now().millisecondsSinceEpoch}.jpg';

      Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child('images/$userId/$fileName');

      UploadTask uploadTask = firebaseStorageRef.putFile(imageFile);

      await uploadTask.whenComplete(() {
        setState(() {
          _isLoading = false;
          _loadImages();  
          Fluttertoast.showToast(msg: 'Image uploaded successfully!');
        });
      });
    } else {
      print('No image selected.');
      setState(() {
        _isLoading = false; 
      });
    }
  }

  void _deleteImage(String imageUrl) async {
    await FirebaseStorage.instance.refFromURL(imageUrl).delete();
    
    if (mounted) {
      setState(() {
        _loadImages();
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _uploadImage,
        child: const Icon(Icons.add_a_photo_rounded),
      ),
      body: _isLoading
          ? Center(
              child: Lottie.asset('assets/loadingAnimation.json',
                  height: 120, width: 120),
            )
          : imageUrls.isEmpty
              ? const Center(
                  child: Text('No images found.'),
                )
              : GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                                10),  
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
