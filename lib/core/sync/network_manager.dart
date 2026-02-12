import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'sync_models.dart';

class NetworkManager {
  static NetworkManager? _instance;
  static NetworkManager get instance => _instance ??= NetworkManager._();
  NetworkManager._();

  final Connectivity _connectivity = Connectivity();

  Future<NetworkQuality> assessNetworkQuality() async {
    final result = await _connectivity.checkConnectivity();
    ConnectionType type;

    if (result == ConnectivityResult.wifi) {
      type = ConnectionType.wifi;
    } else if (result == ConnectivityResult.mobile) {
      type = ConnectionType.mobile;
    } else if (result == ConnectivityResult.none) {
      type = ConnectionType.none;
    } else {
      type = ConnectionType.unknown;
    }

    // Simplified bandwidth estimation
    int bandwidth = 0;
    if (type == ConnectionType.wifi) {
      bandwidth = 15000000; // 15 Mbps est
    } else if (type == ConnectionType.mobile) {
      bandwidth = 5000000; // 5 Mbps est
    }

    return NetworkQuality(connectionType: type, bandwidth: bandwidth);
  }
}
