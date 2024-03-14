import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'addNotePage.dart';

class notepage extends StatefulWidget {
  const notepage({super.key});

  @override
  State<notepage> createState() => _notepageState();
}

class _notepageState extends State<notepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Card(
            color: Color.fromARGB(255, 255, 201, 201),
            child: const ListTile(title: TextField()),
          ),
        ],
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        children: [
          SpeedDialChild(
              child: Icon(Icons.short_text_outlined),
              label: "Text",
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => addNotePage()));
              }),
          SpeedDialChild(
            child: Icon(Icons.image),
            label: "Image",
          ),
          SpeedDialChild(
            child: Icon(Icons.camera_alt),
            label: "Take photo",
          ),
        ],
      ),
    );
  }
}
