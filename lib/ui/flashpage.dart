import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class flashpage extends StatefulWidget {
  const flashpage({super.key});

  @override
  State<flashpage> createState() => _flashpageState();
}

class _flashpageState extends State<flashpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Container(
        child: Lottie.asset('assets/animation_lmdqbm1f.json'),
      )),
    );
  }
}
