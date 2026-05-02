import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();

  // Vérifie si l'appareil est connecté à internet
  Future<bool> isConnected() async {
    final result = await _connectivity.checkConnectivity();
    return result.first != ConnectivityResult.none;
  }

  // Écoute les changements de connexion en temps réel
  Stream<bool> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged.map(
      (result) => result.first != ConnectivityResult.none,
    );
  }
}