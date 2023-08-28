import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class notepage extends StatefulWidget {
  const notepage({super.key});

  @override
  State<notepage> createState() => _notepageState();
}

class _notepageState extends State<notepage> {
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