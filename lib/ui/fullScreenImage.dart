import 'package:flutter/material.dart';

class FullScreenImagePage extends StatelessWidget {
  final String imageUrl;
  final VoidCallback onDelete;

  const FullScreenImagePage({
    Key? key,
    required this.imageUrl,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          Center(
            child: Image.network(imageUrl),
          ),
          Positioned(
            bottom: 16.0,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: onDelete,
                  child: Text('Delete'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}