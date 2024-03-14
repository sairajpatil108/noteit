import 'package:flutter/material.dart';
import 'package:noteit/ui/loginPage.dart';

class taskpage extends StatefulWidget {
  const taskpage({super.key});

  @override
  State<taskpage> createState() => _taskpageState();
}

class _taskpageState extends State<taskpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 255, 201, 201),
              borderRadius: BorderRadius.circular(20),
            ),
            child: profilePhoto(),
          ),
          profileName()
          // Card(
          //     color: Color.fromARGB(255, 255, 201, 201),
          //     child: ListTile(leading: Checkbox_custom(), title: TextField())),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        child: Icon(Icons.task),
        onPressed: () {
          _showBottomSheet(context);
        },
      ),
    );
  }
}

class Checkbox_custom extends StatefulWidget {
  const Checkbox_custom({super.key});

  @override
  State<Checkbox_custom> createState() => _Checkbox_customState();
}

class _Checkbox_customState extends State<Checkbox_custom> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains) == false) {
        return Color.fromARGB(255, 52, 255, 157);
      } else
        return const Color.fromARGB(255, 255, 149, 142);
    }

    return Checkbox(
      shape: CircleBorder(),
      checkColor: Color.fromARGB(255, 255, 201, 201),
      fillColor: MaterialStateProperty.resolveWith(getColor),
      value: isChecked,
      onChanged: (bool? value) {
        setState(() {
          isChecked = value!;
        });
      },
    );
  }
}

void _showBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: new BorderRadius.only(
          topLeft: const Radius.circular(25.0),
          topRight: const Radius.circular(25.0),
        ),
      ),
      child: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                child: Icon(
                  Icons.add_task_rounded,
                  size: 50,
                  color: Color.fromARGB(255, 52, 255, 157),
                ),
                height: 60,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(50, 8, 50, 8),
              child: TextFormField(
                decoration: InputDecoration(hintText: "Task"),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(50, 8, 50, 8),
              child: TextFormField(
                decoration: InputDecoration(hintText: "Discription"),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.15,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the bottom sheet
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    ),
  );
}
