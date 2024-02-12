import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class AppWebView extends StatelessWidget {
  final String initialUrl;
  final void Function(InAppWebViewController)? onWebViewCreated;
  final Function(bool)? onLoadingChanged;
  final PullToRefreshController? pullToRefreshController;
  void Function(InAppWebViewController, Uri?, int, String)? onLoadError;

  AppWebView({
    Key? key,
    required this.initialUrl,
    this.onLoadError,
    this.onWebViewCreated,
    this.onLoadingChanged,
    this.pullToRefreshController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InAppWebView(
      onLoadError: onLoadError,
      initialUrlRequest: URLRequest(url: Uri.parse(initialUrl)),
      onWebViewCreated: onWebViewCreated,
      onLoadStart: (controller, url) {
        onLoadingChanged?.call(true);
      },
      onLoadStop: (controller, url) {
        onLoadingChanged?.call(false);
      },
      pullToRefreshController: pullToRefreshController,
    );
  }
}
