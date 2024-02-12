import 'package:jieyran/component/custom_icon.dart';
import 'package:jieyran/utils/app_color.dart';
import 'package:jieyran/utils/app_string.dart';
import 'package:flutter/material.dart';

class CustomToast extends StatefulWidget {
  const CustomToast({super.key});

  @override
  State<CustomToast> createState() => _CustomToastState();
}

class _CustomToastState extends State<CustomToast> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
              color: AppColor.primaryColor,
              offset: Offset(0, 2),
              blurRadius: 8,
              spreadRadius: 4)
        ],
        borderRadius: BorderRadius.circular(15.0),
        shape: BoxShape.rectangle,
        color: AppColor.secondaryColor,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CustomIcon(
            iconPath: 'gif/cross.gif',
          ),
          const SizedBox(
            width: 12.0,
          ),
          Text(
            AppString.doubleClickToExit,
            style: const TextStyle(color: Colors.black, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
