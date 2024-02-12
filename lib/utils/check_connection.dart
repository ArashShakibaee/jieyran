import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class CheckConnection {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  Future<void> initConnectivity(
      Function(ConnectivityResult) updateCallback) async {
    ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on Exception catch (_) {
      print("Error checking connectivity");
      return;
    }

    updateCallback(result);
  }

  void startListening(Function(ConnectivityResult) updateCallback) {
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(updateCallback);
  }

  void stopListening() {
    _connectivitySubscription.cancel();
  }

  Future<void> dispose() async {
    _connectivitySubscription.cancel();
  }
}
