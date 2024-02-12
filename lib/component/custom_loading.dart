import 'dart:ui';

import 'package:jieyran/utils/app_color.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class CustomLoading extends StatelessWidget {
  const CustomLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Add the glassy screen effect
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            color: AppColor.primaryColor.withOpacity(0.1),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const PreferredSize(
              preferredSize:
                  Size.fromHeight(1.5), // Adjust the height as needed
              child: LinearProgressIndicator(
                color: AppColor.primaryColor, // Customize the color as needed
                backgroundColor: AppColor
                    .secondaryColor, // Customize the background color as needed
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LoadingAnimationWidget.discreteCircle(
                  color: AppColor.primaryColor,
                  secondRingColor: AppColor.secondaryColor,
                  thirdRingColor: Colors.white,
                  size: 40,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
