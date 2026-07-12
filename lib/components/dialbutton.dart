import 'package:flutter/material.dart';

class DialButton extends StatelessWidget {
  final VoidCallback onPressed;
  final int number;
  final double padding;
  const DialButton(
      {Key? key,
      required this.onPressed,
      required this.number,
      required this.padding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            // fixedSize: const Size(50, 50),
            padding: EdgeInsets.fromLTRB(0, padding, 0, padding),
            side: const BorderSide(width: 2, color: Colors.brown)),
        child: Text(
          number.toString(),
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.brown,
          ),
        ),
      ),
    );
  }
}
