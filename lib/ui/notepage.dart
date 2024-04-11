import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'addNotePage.dart';

class notepage extends StatefulWidget {
  const notepage({Key? key});

  @override
  State<notepage> createState() => _notepageState();
}

class _notepageState extends State<notepage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        children: [
          SpeedDialChild(
            child: Icon(Icons.short_text_outlined),
            label: "Text",
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => addNotePage()));
            },
          ),
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
