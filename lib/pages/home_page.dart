import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:jieyran/component/app_web_view.dart';
import 'package:jieyran/component/custom_alert.dart';
import 'package:jieyran/component/custom_icon.dart';
import 'package:jieyran/component/custom_loading.dart';
import 'package:jieyran/component/custom_toast.dart';
import 'package:jieyran/utils/app_color.dart';
import 'package:jieyran/utils/app_string.dart';
import 'package:jieyran/utils/check_connection.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:toastification/toastification.dart';

class HomePage extends StatefulWidget {
  static const String routeName = 'home-page';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PullToRefreshController? pullToRefreshController;
  bool isLoading = true;
  int currentIndex = 0;
  final List<String> initialUrls = [
    "https://jieyran.ir/",
    "https://jieyran.ir/shop/",
    "https://jieyran.ir/%d8%b3%d8%a8%d8%af-%d8%ae%d8%b1%db%8c%d8%af/",
    "https://jieyran.ir/%d9%88%d8%a8%d9%84%d8%a7%da%af/",
    "https://jieyran.ir/my-account/",
  ];
  final List<CustomIcon> icons = [
    const CustomIcon(
      iconPath: "gif/home.gif",
    ),
    const CustomIcon(
      iconPath: "gif/shopping-bag.gif",
    ),
    const CustomIcon(
      iconPath: "gif/shopping.gif",
    ),
    const CustomIcon(
      iconPath: "gif/article.gif",
    ),
    const CustomIcon(
      iconPath: "gif/account.gif",
    ),
  ];
  InAppWebViewController? _webViewController;
  DateTime? currentBackPressTime;
  final CheckConnection checkConnection = CheckConnection();
  bool isAlertDialogShown = false;
  bool isVpnNotificationShown = false;
  GlobalKey<CurvedNavigationBarState> bottomNavigationKey = GlobalKey();
  late FToast fToast;

  @override
  void initState() {
    super.initState();
    pullToRefreshController = PullToRefreshController(
      options:
          PullToRefreshOptions(enabled: true, color: AppColor.primaryColor),
      onRefresh: _handleRefresh,
    );
    checkConnection.initConnectivity(_updateConnectionStatus);
    checkConnection.startListening(_updateConnectionStatus);
    fToast = FToast();
    fToast.init(context);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(
          systemNavigationBarDividerColor: Colors.white,
          systemNavigationBarColor: Colors.white,
          statusBarColor: AppColor.secondaryColor,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarIconBrightness: Brightness.dark),
    );
  }

  @override
  void dispose() {
    checkConnection.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    AppWebView(
                      initialUrl: initialUrls[currentIndex],
                      onWebViewCreated:
                          (InAppWebViewController webViewController) {
                        _webViewController = webViewController;
                      },
                      onLoadingChanged: (isLoading) {
                        setState(() {
                          this.isLoading = isLoading;
                        });
                      },
                      pullToRefreshController: pullToRefreshController,
                      onLoadError: (controller, url, code, message) {
                        setState(() {
                          isLoading = false;
                          CustomAlert.show(
                            context: context,
                            isDismissible: true,
                            onTapTryAgain: () {
                              _handleRefresh();
                              Navigator.of(context)
                                  .pop(); // Close the dialog if needed
                            },
                            onTapExit: () {
                              // Close the dialog if needed
                              exit(0);
                            },
                            title: AppString.titleOffline,
                            content: AppString.contentOffline,
                          );
                        });
                      },
                    ),
                    if (isLoading == true) const CustomLoading()
                  ],
                ),
              )
            ],
          ),
          bottomNavigationBar: Directionality(
            textDirection: TextDirection.rtl,
            child: CurvedNavigationBar(
              key: bottomNavigationKey,
              index: currentIndex,
              height: 60.0,
              items: icons,
              color: Colors.white,
              buttonBackgroundColor: Colors.white,
              backgroundColor: AppColor.secondaryColor,
              animationCurve: Curves.easeInBack,
              animationDuration: const Duration(milliseconds: 1000),
              onTap: (index) {
                setState(() {
                  currentIndex = index;
                });
                _handleNavigationBarTap(index);
              },
              letIndexChange: (index) => true,
            ),
          ),
        ),
      ),
    );
  }

  void _handleNavigationBarTap(int index) {
    // Update the currentIndex to reflect the new page index
    setState(() {
      currentIndex = index;
    });

    // Load the URL associated with the selected page
    _webViewController?.loadUrl(
      urlRequest: URLRequest(
        url: Uri.parse(
          initialUrls[currentIndex],
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    DateTime now = DateTime.now();
    if (await _webViewController!.canGoBack()) {
      _webViewController!.goBack(); // Navigate back in WebView history
      return false; // Prevent app exit
    } else if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      fToast.showToast(
          child: const CustomToast(),
          gravity: ToastGravity.BOTTOM,
          toastDuration: const Duration(seconds: 2),
          positionedToastBuilder: (context, child) {
            return Positioned(
              bottom: 10.0,
              right: 16,
              left: 16,
              child: child,
            );
          });
      return false;
    } else {
      return true;
    }
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    if (result == ConnectivityResult.none && isAlertDialogShown) {
      isAlertDialogShown = true;
      CustomAlert.show(
          context: context,
          isDismissible: false,
          onTapTryAgain: () {
            _handleRefresh();
            Navigator.of(context).pop();
          },
          onTapExit: () {
            exit(0);
          },
          title: AppString.titleOffline,
          content: AppString.contentOffline);
    } else if (result == ConnectivityResult.vpn && !isVpnNotificationShown) {
      setState(() {
        isVpnNotificationShown = true;
      });
      toastification.showWarning(
        icon: const CustomIcon(iconPath: "gif/error.gif"),
        context: context,
        closeOnClick: true,
        showCloseButton: false,
        autoCloseDuration: const Duration(seconds: 10),
        animationBuilder: ((context, animation, child) {
          return ScaleTransition(scale: animation, child: child);
        }),
        title: AppString.vpnConnection,
        backgroundColor: Colors.white,
        foregroundColor: AppColor.secondaryColor,
        elevation: 4,
      );
    }
  }

  Future<void> _handleRefresh() async {
    if (isAlertDialogShown) {
      return; // Prevent refreshing while an alert is shown
    }
    checkConnection.initConnectivity(_updateConnectionStatus);
    if (_webViewController != null) {
      await _webViewController!.reload();
      pullToRefreshController!.endRefreshing(); // Complete the refresh action
    }
  }
}
