import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:noteit/firebase_options.dart';
import 'package:noteit/ui/imagepage.dart';
import 'package:noteit/ui/loginPage.dart';
import 'package:noteit/ui/notepage.dart';
import 'package:noteit/ui/taskpage.dart';
import 'package:noteit/ui/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyAv1Cs3oC-SYEVBkMePc9LyxdPKLvPt_mM",
            authDomain: "noteit-4d8ee.firebaseapp.com",
            projectId: "noteit-4d8ee",
            storageBucket: "noteit-4d8ee.appspot.com",
            messagingSenderId: "986529406150",
            appId: "1:986529406150:web:d237d34fecbbddc4e78bc7",
            measurementId: "G-M6QPPBTJ1Y"));
  } else {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  }

  FirebaseFirestore.instance.settings =
      const Settings(persistenceEnabled: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
      darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
      home: const loginPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var login = false;

  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    TaskPage(), // Second tab content
    Notepage(), // First tab content
    ImagePage(), // Third tab content
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(
                child: Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
              child: Text(
                'NoteIt',
              ),
            )),
            SizedBox(
                height: 40,
                width: 40,
                child: Lottie.asset('assets/animation_lmdqbm1f.json')),
            Expanded(child: SizedBox()),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
              child: profilePhoto(context),
            ),
          ],
        ),
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.note),
            label: 'Notes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.image),
            label: 'Images',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
