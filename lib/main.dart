// ignore_for_file: library_private_types_in_public_api

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:noteit/linkespage.dart';
import 'package:noteit/notepage.dart';
import 'package:noteit/taskpage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late TabController controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(vsync: this, length: 5);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          toolbarHeight: 35,
          backgroundColor: Colors.black,
          title: const Center(
              child: Text(
            'Snippits',
          )),
          bottom: const TabBar(tabs: [
            Text('Tasks'),
            Text('Note'),
            Text('Links'),
          ]),
          actions: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 30, 5),
              child: Icon(CupertinoIcons.search),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.black,
            hoverColor: Colors.white.withOpacity(0.4),
            child: const Icon(
              Icons.add_circle_sharp,
              size: 50,
            ),
            onPressed: () {}),
        body: TabBarView(children: [
          taskpage(),
          //
          //
          //
          notepage(),
          //
          //
          //
          linkespage()
        ]),
      ),
    );
  }
}
