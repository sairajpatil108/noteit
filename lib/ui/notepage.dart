import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
    // Ensure user is signed in
    User? user = _auth.currentUser;
    if (user == null) {
      // Handle if user is not signed in
      print('User not signed in');
      return;
    }

    // Navigate to the add note page
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddNotePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
      ),
      body: _buildNotesList(),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNote,
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildNotesList() {
    return Stack(
      children: [
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('notes')
              .orderBy('timestamp', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text('No notes found.'),
              );
            }

            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var note = snapshot.data!.docs[index];
                return LongPressDraggable(
                  data: note,
                  child: GestureDetector(
                    onTap: () {
                      // Navigate to the complete notes page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CompleteNotePage(note: note)),
                      );
                    },
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  note['title'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8.0),
                            Expanded(
                              child: Text(
                                note['content'],
                                maxLines: 5, // Adjust max lines as needed
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  feedback: Material(
                    child: Container(
                      width: 200,
                      height: 100,
                      color: Colors.transparent,
                      child: Center(
                        child: Text(
                          note['title'],
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                  childWhenDragging: SizedBox.shrink(),
                  onDragStarted: () {
                    // Implement any behavior when dragging starts
                  },
                  onDragCompleted: () {
                    // Implement any behavior when dragging is completed
                  },
                  onDraggableCanceled: (velocity, offset) {
                    // Implement any behavior when dragging is canceled
                  },
                );
              },
            );
          },
        ),
        Positioned(
          bottom: 90.0, // Adjust position as needed
          left: 270,
          right: 0,
          child: DragTarget<DocumentSnapshot>(
            onWillAccept: (data) => true,
            onAccept: (data) {
              _deleteNote(data.id);
            },
            builder: (context, candidateData, rejectedData) {
              return Center(
                child: Card(
                  color: Color.fromARGB(255, 245, 143, 135),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Icon(Icons.delete),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

Future<void> _deleteNote(String noteId) async {
  try {
    await FirebaseFirestore.instance.collection('notes').doc(noteId).delete();
  } catch (e) {
    print("Error deleting note: $e");
    // Handle error if needed
  }
}
