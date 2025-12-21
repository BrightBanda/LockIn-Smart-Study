import 'package:flutter/material.dart';

class Mybutton extends StatelessWidget {
  final void Function()? onPressed;
  final Widget child;
  const Mybutton({super.key, required this.onPressed, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 75,
      decoration: BoxDecoration(
        color: const Color.fromARGB(177, 255, 229, 127),
        borderRadius: BorderRadius.circular(8),
      ),
      child: MaterialButton(onPressed: onPressed, child: child),
    );
  }
}
