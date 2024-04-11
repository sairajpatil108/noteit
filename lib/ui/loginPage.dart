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
              Lottie.asset('assets/animation_lmdqbm1f.json', height: 200),
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
    return MyHomePage();
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
                  radius: 50, // Adjust the radius as needed
                  backgroundColor:
                      Colors.transparent, // Make the background transparent
                  child: ClipOval(
                    child: Image.network(
                      _user!.photoURL!,
                      width: 100, // Set the width and height of the image
                      height: 100,
                      fit: BoxFit
                          .cover, // Ensure the image covers the circular frame
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                profileName(),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _logout();
                    Navigator.pop(context); 
                  },
                  child: Text('Logout'),
                ),
              ],
            ),
          );
        },
      );
    },
    child: CircleAvatar(
      radius: 25, // Adjust the radius as needed
      backgroundColor: Colors.transparent, // Make the background transparent
      child: ClipOval(
        child: Image.network(
          _user!.photoURL!,
          width: 40, // Set the width and height of the image
          height: 40,
          fit: BoxFit.cover, // Ensure the image covers the circular frame
        ),
      ),
    ),
  );
}

void _logout() {
  FirebaseAuth.instance.signOut();
}

Widget profileName() {
  return Container(child: Text(_user!.email!, style: TextStyle(fontSize: 15)));
}

Future<bool> isUserLoggedIn() async {
  final _user = FirebaseAuth.instance.currentUser;
  return _user != null; // Return true if user is logged in, false otherwise
}
