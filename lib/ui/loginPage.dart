 
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:noteit/main.dart';
import 'package:sign_in_button/sign_in_button.dart';

class loginPage extends StatefulWidget {
  const loginPage({super.key});

  @override
  State<loginPage> createState() => _loginPageState();
}

User? _user;

class _loginPageState extends State<loginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen((event) {
      setState(() {
        _user = event;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _user != null ? _userInfo() : _googleSignInButton(),
    );
  }

  Widget _googleSignInButton() {
    return Center(
      child: SizedBox(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset('assets/diary.json', height: 200),
          const SizedBox(
            height: 40,
          ),
          SignInButton(
            Buttons.google,
            text: 'Sign in with Google',
            onPressed: () {
              _handleGoogleSignin();
            },
          ),
        ],
      )),
    );
  }

  Widget _userInfo() {
    return const MyHomePage();
  }

  void _handleGoogleSignin() {
    try {
      GoogleAuthProvider _googleAuthProvider = GoogleAuthProvider();
      _auth.signInWithProvider(_googleAuthProvider);
    } catch (error) {
      print(error);
    }
  }
}

Widget profilePhoto(BuildContext context) {
  return GestureDetector(
    onTap: () {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 50,  
                  backgroundColor:
                      Colors.transparent,  
                  child: ClipOval(
                    child: Image.network(
                      _user!.photoURL!,
                      width: 100,  
                      height: 100,
                      fit: BoxFit
                          .cover,  
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                profileName(),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _logout();
                    Navigator.pop(context);
                  },
                  child: const Text('Logout'),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text("developed by sairajpatil108",
                    style: TextStyle(
                      fontSize: 10,
                    )),
              ],
            ),
          );
        },
      );
    },
    child: CircleAvatar(
      radius: 25, 
      backgroundColor: Colors.transparent,  
      child: ClipOval(
        child: Image.network(
          _user!.photoURL!,
          width: 40,  
          height: 40,
          fit: BoxFit.cover,  
        ),
      ),
    ),
  );
}

void _logout() {
  FirebaseAuth.instance.signOut();
}

Widget profileName() {
  return Container(
      child: Text(_user!.email!, style: const TextStyle(fontSize: 15)));
}

Future<bool> isUserLoggedIn() async {
  final _user = FirebaseAuth.instance.currentUser;
  return _user != null;  
}
