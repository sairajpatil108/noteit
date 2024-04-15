// ignore_for_file: library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CompleteNotePage extends StatefulWidget {
  final DocumentSnapshot note;

  const CompleteNotePage({Key? key, required this.note}) : super(key: key);

  @override
  _CompleteNotePageState createState() => _CompleteNotePageState();
}

class _CompleteNotePageState extends State<CompleteNotePage> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note['title']);
    _contentController = TextEditingController(text: widget.note['content']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Note',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                style: const TextStyle(fontSize: 20.0),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _contentController,
                decoration: const InputDecoration(
                  labelText: 'Content',
                  border: OutlineInputBorder(),
                ),
                maxLines: null, // Allows unlimited lines
                keyboardType: TextInputType.multiline,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveChanges,
        child: const Icon(Icons.save),
      ),
    );
  }

  void _saveChanges() {
    FirebaseFirestore.instance
        .collection('user_notes')
        .doc(widget.note.id)
        .update({
      'title': _titleController.text,
      'content': _contentController.text,
    }).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Changes saved')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save changes: $error')),
      );
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }
}
