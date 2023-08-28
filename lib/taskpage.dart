import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class taskpage extends StatefulWidget {
  const taskpage({super.key});

  @override
  State<taskpage> createState() => _taskpageState();
}

class _taskpageState extends State<taskpage> {
  @override
  Widget build(BuildContext context) {
    return ListView(
            children: [
              Card(
                color: Colors.white.withOpacity(0.5),
                child: const ListTile(title: TextField()),
              ),
            ],
          );
  }
}