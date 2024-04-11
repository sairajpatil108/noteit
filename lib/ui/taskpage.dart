import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
      appBar: AppBar(
        title: const Text('Tasks'),
      ),
      body: _buildTasksList(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          _showAddTaskDialog(context);
        },
      ),
    );
  }

  Widget _buildTasksList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('tasks').snapshots(),
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
          return const Center(
            child: Text('No tasks found.'),
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
              direction: DismissDirection.vertical,
              onDismissed: (direction) {
                _deleteTask(task.id);
              },
              child: Card(
                child: ListTile(
                  title: Text(task['title']),
                  subtitle: Text(DateFormat('yyyy-MM-dd').format(task['timestamp'].toDate())),
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
      FirebaseFirestore.instance.collection('tasks').add({
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
