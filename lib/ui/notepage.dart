

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:noteit/ui/addNote.dart';
import 'package:noteit/ui/completenoteView.dart';

class Notepage extends StatefulWidget {
  const Notepage({Key? key}) : super(key: key);

  @override
  State<Notepage> createState() => _NotepageState();
}

class _NotepageState extends State<Notepage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _addNote() async {
   
    User? user = _auth.currentUser;
    if (user == null) {
 
      print('User not signed in');
      return;
    }

 
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddNotePage()),
    );
  }

  Future<void> _deleteNote(String noteId) async {
    try {
      await FirebaseFirestore.instance
          .collection('user_notes')
          .doc(noteId)
          .delete();
    } catch (e) {
      print("Error deleting note: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildNotesList(),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNote,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildNotesList() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
   
      return Container();
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('user_notes')
            .where('userId', isEqualTo: currentUser.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final List<QueryDocumentSnapshot> documents = snapshot.data!.docs;

          if (documents.isEmpty) {
            return Center(
              child: Lottie.asset(
                'assets/animation_lmdqbm1f.json',
                height: 200,
                width: 200,
                fit: BoxFit.cover,
              ),
            );
          }
          return Stack(
            children: [
              GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: documents.length,
                itemBuilder: (context, index) {
                  var note = documents[index];
                  return Draggable(
                    feedback: const Card(
                      color: Color.fromARGB(255, 253, 121, 112),
                      elevation: 6,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 8),
                            Text(
                              "Drag your finger\n on bin to delete",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(height: 15),
                          ],
                        ),
                      ),
                    ),
                    childWhenDragging: Container(),
                    data: note.id,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CompleteNotePage(note: note),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                note['title'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 8),
                              LimitedBox(
                                maxHeight:
                                    100,  
                                child: Text(
                                  note['content'],
                                  maxLines: 5,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 80.0, right: 0),
                  child: DragTarget<String>(
                    onAccept: (noteId) => _deleteNote(noteId),
                    builder: (context, candidateData, rejectedData) {
                      return InkWell(
                        onTap: () {
                          Fluttertoast.showToast(
                            msg: 'Drag note here to delete it',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.SNACKBAR,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.black,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                        },
                        child: Card(
                          shape: CircleBorder(),
                          color: Color.fromARGB(255, 249, 108, 98),
                          child: Lottie.asset("assets/deleteAnimation.json",
                              height: 70, width: 70),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
