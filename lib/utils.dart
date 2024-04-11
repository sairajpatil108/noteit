import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:gallery_picker/gallery_picker.dart';

Future<void> signInUserAnon() async {
  try {
    final Credential = await FirebaseAuth.instance.signInAnonymously();
  } catch (e) {
    print(e);
  }
}

Future<File?> getImageFromGalary(BuildContext context) async {
  try {
    List<MediaFile>? singleMedia =
        await GalleryPicker.pickMedia(context: context, singleMedia: true);
    return singleMedia?.first.getFile();
  } catch (e) {
    print(e);
  }
}

Future<bool> uploadFileForUser(File file) async {
  try {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final storageRef = FirebaseStorage.instance.ref();
    final fileName = file.path.split('/').last;
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final uploadRef = storageRef.child("$userId/uploads/$timestamp-$fileName");
    await uploadRef.putFile(file);
    return true;
  } catch (e) {
    print(e);
    return false;
  }
}




// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:noteit/utils.dart';

// class imagepage extends StatefulWidget {
//   const imagepage({Key? key}) : super(key: key);

//   @override
//   State<imagepage> createState() => _TaskPageState();
// }

// class _TaskPageState extends State<imagepage> {
//   final TextEditingController _textEditingController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       floatingActionButton: _UploadMediaButton(context),
//       body: _BuildUI(),
//     );
//   }

//   Widget _UploadMediaButton(BuildContext context) {
//     return FloatingActionButton(
//         child: const Icon(Icons.add_a_photo),
//         onPressed: () async {
//           File? selecterImage = await getImageFromGalary(context);
//           if (selecterImage != null) {
//             bool success = await uploadFileForUser(selecterImage);
//             await uploadFileForUser(selecterImage);
//             print("Upload success: $success");
//           }
//         });
//   }

//   Widget _BuildUI() {
//     return Container();
//   }
// }
