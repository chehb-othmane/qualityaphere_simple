import 'package:flutter/material.dart';

class AppIcon extends StatelessWidget {
  final double size;
  final double borderRadius;
  final Color backgroundColor;

  const AppIcon({
    super.key,
    this.size = 48,
    this.borderRadius = 12,
    this.backgroundColor = const Color(0xFF135BEC),
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        height: size,
        width: size,
        color: backgroundColor,
        alignment: Alignment.center,
        child: Image.asset(
          'assets/icons/icon.png',
          width: size * 0.6,
          height: size * 0.6,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
