import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({Key? key}) : super(key: key);

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _buildTasksList(),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          _showAddTaskDialog(context);
        },
      ),
    );
  }

  Widget _buildTasksList() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      // If user is not logged in, return an empty container
      return Container();
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('tasks')
          .where('userId', isEqualTo: currentUser.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('Error'),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final List<DocumentSnapshot> documents = snapshot.data!.docs;

        if (documents.isEmpty) {
          return Center(
            child: Lottie.asset("assets/tasks.json"),
          );
        }

        return ListView.builder(
          itemCount: documents.length,
          itemBuilder: (context, index) {
            final task = documents[index];
            return Dismissible(
              key: Key(task.id),
              background: Container(
                color: const Color.fromARGB(255, 246, 137, 129),
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: const Icon(
                  Icons.delete,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) {
                _deleteTask(task.id);
              },
              child: InkWell(
                onTap: () {
                  Fluttertoast.showToast(
                    msg: 'swipe left to delete task',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.SNACKBAR,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                },
                child: Card(
                  child: ListTile(
                    title: Text(task['title'],
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    subtitle: Text(
                      DateFormat('EEE, M/d/y')
                          .format(task['timestamp'].toDate()),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _deleteTask(String taskId) async {
    try {
      await FirebaseFirestore.instance.collection('tasks').doc(taskId).delete();
    } catch (e) {
      print("Error deleting task: $e");
      // Handle error if needed
    }
  }

  void _showAddTaskDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Task'),
          content: TextField(
            controller: _textEditingController,
            decoration: const InputDecoration(hintText: 'Enter task title'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                _saveTask();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _saveTask() {
    final String title = _textEditingController.text.trim();
    if (title.isNotEmpty) {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        FirebaseFirestore.instance.collection('tasks').add({
          'userId': currentUser.uid,
          'title': title,
          'timestamp': Timestamp.now(),
        }).then((_) {
          _textEditingController.clear();
        }).catchError((error) {
          print("Error adding task: $error");
        });
      }
    }
  }
}
