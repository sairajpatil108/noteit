import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:noteit/ui/flashpage.dart';

class linkpage extends StatefulWidget {
  const linkpage({super.key});

  @override
  State<linkpage> createState() => _linkpageState();
}

class _linkpageState extends State<linkpage> {
  @override
  Widget build(BuildContext context) {
    return Container(child: Lottie.asset('assets/animation_lmdqbm1f.json'));
  }
}
