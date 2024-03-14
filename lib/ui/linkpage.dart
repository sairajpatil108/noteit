import 'package:flutter/material.dart';
import 'package:noteit/ui/flashpage.dart';

class linkpage extends StatefulWidget {
  const linkpage({super.key});

  @override
  State<linkpage> createState() => _linkpageState();
}

class _linkpageState extends State<linkpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          const Card(
            color: Color.fromARGB(255, 255, 201, 201),
            child: ListTile(title: TextField()),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showBottomSheet_1(context);
        },
        child: const Icon(Icons.add_link),
      ),
    );
  }
}

void _showBottomSheet_1(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: new BoxDecoration(
        color: const Color.fromARGB(255, 255, 201, 201),
        borderRadius: new BorderRadius.only(
          topLeft: const Radius.circular(25.0),
          topRight: const Radius.circular(25.0),
        ),
      ),
      child: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(50, 8, 50, 8),
              child: TextFormField(
                decoration: const InputDecoration(hintText: "Link"),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(50, 8, 50, 8),
              child: TextFormField(
                decoration: const InputDecoration(hintText: "Discription"),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const flashpage()));
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    ),
  );
}
