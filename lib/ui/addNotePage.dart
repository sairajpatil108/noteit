import 'package:flutter/material.dart';

class addNotePage extends StatefulWidget {
  const addNotePage({super.key});

  @override
  State<addNotePage> createState() => _addNotePageState();
}

class _addNotePageState extends State<addNotePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.75,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 255, 201, 201),
            ),
          )
        ],
      ),
    );
  }
}
