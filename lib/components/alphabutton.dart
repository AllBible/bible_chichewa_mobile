import 'package:flutter/material.dart';

class AlphaButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final double padding = 20;
  const AlphaButton({super.key, required this.onPressed, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.brown,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.fromLTRB(0, padding, 0, padding),
          side: const BorderSide(width: 2, color: Colors.brown),
        ),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }
}
