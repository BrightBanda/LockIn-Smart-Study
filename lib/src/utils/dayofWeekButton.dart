import 'package:flutter/material.dart';

class Dayofweekbutton extends StatelessWidget {
  final String day;
  const Dayofweekbutton({super.key, required this.day});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey),
        ),
        width: 65,
        child: MaterialButton(onPressed: () {}, child: Text(day)),
      ),
    );
  }
}
