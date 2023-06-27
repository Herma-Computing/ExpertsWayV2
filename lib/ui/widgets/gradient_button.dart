import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../theme/theme.dart';

// ignore: must_be_immutable
class GradientBtn extends StatelessWidget {
  final VoidCallback? onPressed;
  final String btnName;
  String iconUrl;
  bool isPcked;
  final bool defaultBtn;
  double borderRadius;
  double height;
  double? width;

  GradientBtn({
    Key? key,
    required this.onPressed,
    required this.btnName,
    this.iconUrl = 'https://cdn-icons-png.flaticon.com/512/6062/6062646.png',
    this.isPcked = true,
    required this.defaultBtn,
    this.borderRadius = 10,
    this.height = 35,
    this.width = 135,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return InkWell(
      borderRadius: BorderRadius.circular(borderRadius),
      onTap: onPressed,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: themeProvider.currentTheme == ThemeData.light() ? Colors.grey.shade300 : Colors.transparent,
                spreadRadius: 1,
                blurRadius: 6,
                offset: const Offset(2, 8))
          ],
          color: isPcked
              ? themeProvider.currentTheme == ThemeData.light()
                  ? Colors.white
                  : const Color.fromARGB(26, 255, 255, 255)
              : defaultBtn
                  ? null
                  : themeProvider.currentTheme == ThemeData.light()
                      ? Colors.blue
                      : Colors.blue,
          gradient: defaultBtn ? const LinearGradient(colors: [Color(0xff2686FF), Color(0xff26B0FF)]) : null,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!defaultBtn)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: CachedNetworkImage(
                  imageUrl: iconUrl,
                  height: 20,
                  width: 20,
                ),
              ),
            Padding(
                padding: const EdgeInsets.only(right: 0),
                child: Text(
                  btnName,
                  style: TextStyle(
                      fontSize: defaultBtn ? 15 : null,
                      fontWeight: FontWeight.w400,
                      color: !isPcked
                          ? themeProvider.currentTheme == ThemeData.light()
                              ? Colors.white
                              : Colors.grey[900]
                          : themeProvider.currentTheme == ThemeData.light()
                              ? Colors.grey[900]
                              : Colors.white),
                )),
          ],
        ),
      ),
    );
  }
}
