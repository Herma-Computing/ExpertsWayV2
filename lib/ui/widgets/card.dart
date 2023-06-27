import 'package:expertsway/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:expertsway/theme/config.dart' as config;
import 'package:provider/provider.dart';

class CardWidget extends StatelessWidget {
  final bool gradient;
  final bool button;
  final Color? color;
  final double? width;
  final double? height;
  final Widget child;
  final int? duration;
  final Border? border;
  final BorderRadius? borderRadius;
  final Function()? func;
  const CardWidget({
    super.key,
    required this.gradient,
    required this.button,
    this.color,
    this.width,
    this.height,
    required this.child,
    this.duration,
    this.func,
    this.border,
    this.borderRadius, // an optional field for setting the border-radius
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            blurRadius: 25,
            offset: Offset(0, 10),
            color: Color(0x1A636363),
          ),
        ],
      ),
      child: ClipPath(
        clipper: ShapeBorderClipper(
          shape: RoundedRectangleBorder(
            // if borderRadius is not passed to the constructor, we use a default value of 10
            borderRadius: borderRadius ?? BorderRadius.circular(10),
          ),
        ),
        child: AnimatedContainer(
          duration: Duration(milliseconds: duration ?? 500),
          width: width,
          height: height,
          decoration: BoxDecoration(
            border: border ??
                Border.all(
                  color: Provider.of<ThemeProvider>(context).currentTheme == ThemeData.light() ? Colors.white : Colors.transparent,
                  width: 0,
                ),
            // borderRadius: BorderRadius.circular(10),
            color: color ?? config.Colors().mainColor(1),
            gradient: gradient
                ? config.Colors().waves
                : LinearGradient(colors: [color ?? config.Colors().mainColor(1), color ?? config.Colors().mainColor(1)]),
          ),
          child: button
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: MaterialButton(
                    padding: EdgeInsets.zero,
                    elevation: 0,
                    onPressed: func,
                    child: child,
                  ),
                )
              : child,
        ),
      ),
    );
  }
}
