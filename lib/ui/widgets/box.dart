import 'package:flutter/material.dart';
import 'package:expertsway/utils/color.dart';

class Box extends StatelessWidget {
  final IconData icon;
  final double size;
  const Box({Key? key, required this.icon, required this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
                blurRadius: 10,
                offset: Offset(1, 1),
                color: Color.fromARGB(54, 104, 104, 104))
          ]),
      child: Icon(
        icon,
        size: size,
        color: maincolor,
      ),
    );
  }
}
