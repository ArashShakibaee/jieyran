import 'package:flutter/material.dart';

class CustomIcon extends StatelessWidget {
  final String iconPath;
  final double? height;
  const CustomIcon({required this.iconPath, this.height, super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      iconPath,
      height: height ?? 30,
    );
  }
}
