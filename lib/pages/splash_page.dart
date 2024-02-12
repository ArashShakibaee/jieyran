import 'dart:io';
import 'package:flutter/services.dart';
import 'package:jieyran/component/custom_alert.dart';
import 'package:jieyran/pages/home_page.dart';
import 'package:jieyran/utils/app_color.dart';
import 'package:jieyran/utils/app_string.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:glowy_borders/glowy_borders.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = 'splash-page';

  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation animation;
  bool isAlertDialogShown = false;

  @override
  void initState() {
    super.initState();
    checkConnectionAndShowDialog();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    animation =
        ColorTween(begin: AppColor.secondaryColor, end: AppColor.secondaryColor)
            .animate(_controller);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(
          systemNavigationBarDividerColor: AppColor.secondaryColor,
          systemNavigationBarColor: AppColor.secondaryColor,
          statusBarColor: AppColor.secondaryColor,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarIconBrightness: Brightness.dark),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> checkConnectionAndShowDialog() async {
    final Connectivity checkConnection = Connectivity();
    final ConnectivityResult connectivityResult =
        await checkConnection.checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        isAlertDialogShown = true;
      });
      // ignore: use_build_context_synchronously
      CustomAlert.show(
        context: context,
        isDismissible: false,
        onTapTryAgain: () async {
          final newConnectivityResult =
              await checkConnection.checkConnectivity();
          if (newConnectivityResult != ConnectivityResult.none) {
            setState(() {
              isAlertDialogShown = false;
            });
            Navigator.of(context).pop();
            _controller.forward();
            _controller.addListener(() {
              setState(() {});
            });
            Future.delayed(const Duration(milliseconds: 3000), () {
              Navigator.pushReplacementNamed(context, HomePage.routeName);
            });
          }
        },
        onTapExit: () {
          exit(0);
        },
        title: AppString.titleOffline,
        content: AppString.contentOffline,
      );
    } else if (connectivityResult != ConnectivityResult.none) {
      setState(() {
        isAlertDialogShown = false;
      });

      Future.delayed(const Duration(milliseconds: 3000), () {
        Navigator.pushReplacementNamed(context, HomePage.routeName);
      });
      _controller.forward();
      _controller.addListener(() {
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.secondaryColor,
      body: Center(
        child: Stack(
          children: [
            Align(
                alignment: Alignment.center,
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                      image: const DecorationImage(
                        image: AssetImage("images/logo.png"),
                      ),
                      color: animation.value),
                )),
            Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 70),
                  child: AnimatedGradientBorder(
                    borderSize: 2,
                    glowSize: 10,
                    gradientColors: [
                      Colors.transparent,
                      AppColor.primaryColor,
                      Colors.red.shade300,
                      Colors.purple.shade50
                    ],
                    animationTime: 3,
                    animationProgress: 1,
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    child: SizedBox(
                      width: 250,
                      height: 50,
                      child: Container(
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            color: AppColor.primaryColor),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(AppString.welcome,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 16.0)),
                          ],
                        ),
                      ),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
