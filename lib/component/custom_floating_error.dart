import 'package:jieyran/utils/app_color.dart';
import 'package:jieyran/utils/app_string.dart';
import 'package:flutter/material.dart';

class CustomFloatingError extends StatelessWidget {
  final VoidCallback onCloseButton;
  const CustomFloatingError({required this.onCloseButton, super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.07,
        decoration: BoxDecoration(
          color: AppColor.primaryColor,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                style: IconButton.styleFrom(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: const BorderSide(
                            color: AppColor.secondaryColor, width: 2))),
                onPressed: () => onCloseButton(),
                icon: const Icon(Icons.close, color: AppColor.secondaryColor),
              ),
              Text(
                AppString.vpnConnection,
                style: const TextStyle(
                    color: AppColor.secondaryColor, fontSize: 13),
              ),
              const Icon(
                Icons.error_outline_outlined,
                color: AppColor.secondaryColor,
                size: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
