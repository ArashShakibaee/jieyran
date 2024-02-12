import 'dart:ui';

import 'package:jieyran/component/custom_icon.dart';
import 'package:jieyran/utils/app_color.dart';
import 'package:jieyran/utils/app_string.dart';
import 'package:flutter/material.dart';

class CustomAlert extends StatefulWidget {
  final VoidCallback onTapExit;
  final VoidCallback onTapTryAgain;
  final String title;
  final String content;
  const CustomAlert({
    super.key,
    required this.onTapExit,
    required this.onTapTryAgain,
    required this.title,
    required this.content,
  });

  @override
  State<CustomAlert> createState() => _CustomAlertState();
  static void show({
    required BuildContext context,
    bool isDismissible = false,
    required Function() onTapExit,
    required VoidCallback onTapTryAgain,
    required String title,
    required String content,
  }) {
    showDialog(
      barrierDismissible: isDismissible,
      context: context,
      builder: (context) => CustomAlert(
        onTapTryAgain: onTapTryAgain,
        onTapExit: onTapExit,
        content: content,
        title: title,
      ),
    );
  }

  static void showAlertDialog(
    BuildContext context, // Pass the context here
    String title,
    String content,
    VoidCallback onTapTryAgain,
    VoidCallback onTapExit,
    bool dismissible,
  ) {
    showDialog(
      barrierDismissible: dismissible,
      context: context,
      builder: (context) => CustomAlert(
        title: title,
        content: content,
        onTapTryAgain: onTapTryAgain,
        onTapExit: onTapExit,
      ),
    );
  }
}

class _CustomAlertState extends State<CustomAlert>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            color: AppColor.primaryColor.withOpacity(0.3),
          ),
        ),
        Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(100),
                    bottomLeft: Radius.circular(20),
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
                side: BorderSide(color: AppColor.primaryColor, width: 3)),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                ),
                const CustomIcon(iconPath: "gif/warning.gif")
              ],
            ),
            content: Text(widget.content),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(
                          color: AppColor.primaryColor.withOpacity(0.3),
                          width: 2)),
                  backgroundColor: AppColor.primaryColor.withOpacity(0.1),
                  textStyle: const TextStyle(color: Colors.black),
                ),
                child: Text(AppString.try_again,
                    style: const TextStyle(fontSize: 15)),
                onPressed: () => widget.onTapTryAgain(),
              ),
              TextButton(
                  style: TextButton.styleFrom(
                      foregroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(
                              color: Colors.red.withOpacity(0.3), width: 2)),
                      backgroundColor: Colors.red.withOpacity(0.1),
                      textStyle: const TextStyle(color: Colors.black)),
                  child: Text(
                    AppString.exitTheApp,
                    style: const TextStyle(fontSize: 15, color: Colors.red),
                  ),
                  onPressed: () => widget.onTapExit()),
            ],
          ),
        ),
      ],
    );
  }
}
