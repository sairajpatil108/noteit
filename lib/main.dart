import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:noteit/firebase_options.dart';
import 'package:noteit/ui/linkpage.dart';
import 'package:noteit/ui/loginPage.dart';
import 'package:noteit/ui/notepage.dart';
import 'package:noteit/ui/taskpage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme:
            const ColorScheme.dark(primary: Color.fromARGB(255, 255, 201, 201)),
        useMaterial3: true,
      ),
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

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
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
                child: profilePhoto(),
              ),
            ],
          ),
          bottom: const TabBar(tabs: [
            Text('Tasks'),
            Text('Notes'),
            Text('Links'),
          ]),
        ),
        body: const TabBarView(children: [taskpage(), notepage(), linkpage()]),
      ),
    );
  }
}
