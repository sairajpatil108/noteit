import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';
import 'package:noteit/models/todo.dart';
import 'package:noteit/services/database_service.dart';

class imagepage extends StatefulWidget {
  const imagepage({Key? key}) : super(key: key);

  @override
  State<imagepage> createState() => _TaskPageState();
}

class _TaskPageState extends State<imagepage> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {}));
  }
}