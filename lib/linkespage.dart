import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class linkespage extends StatefulWidget {
  const linkespage({super.key});

  @override
  State<linkespage> createState() => _linkespageState();
}

class _linkespageState extends State<linkespage> {
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