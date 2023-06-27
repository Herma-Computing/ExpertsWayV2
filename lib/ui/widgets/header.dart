import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'box.dart';

class Header extends StatelessWidget {
  final String title;

  const Header({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [
            const Box(
              icon: FontAwesomeIcons.arrowLeft,
              size: 20,
            ),
            const SizedBox(width: 15),
            Text(
              title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            )
          ]),
          const Box(
            icon: FontAwesomeIcons.magnifyingGlass,
            size: 20,
          )
        ],
      ),
    );
  }
}
