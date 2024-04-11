import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CompleteNotePage extends StatelessWidget {
  final DocumentSnapshot note;

  const CompleteNotePage({Key? key, required this.note}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text( note['title'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            note['content'],
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
        ),
      ),
    );
  }
}
