import 'package:flutter/material.dart';
class AnimeButton extends StatefulWidget {
  @override
  _AnimeButtonState createState() => _AnimeButtonState();
}

class _AnimeButtonState extends State<AnimeButton> {
  @override
  Widget build(BuildContext context) {
    bool _visible;
    return FloatingActionButton(
      onPressed: () {
        // Call setState. This tells Flutter to rebuild the
        // UI with the changes.
        setState(() {
          _visible = !_visible;
        });
      },
      tooltip: 'Toggle Opacity',
      child: Icon(Icons.flip),
    );
  }
}
