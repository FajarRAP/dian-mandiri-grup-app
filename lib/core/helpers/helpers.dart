import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:intl/intl.dart';

import '../common/constants.dart';
import '../exceptions/refresh_token.dart';

final dateFormat = DateFormat('y-MM-dd', 'id_ID');
final dateTimeFormat = DateFormat('dd-MM-y HH:mm:ss', 'id_ID');
final dMyFormat = DateFormat('dd-MM-y', 'id_ID');
final timeFormat = DateFormat('HH:mm:ss', 'id_ID');

String evaluateStage(String stage) {
  switch (stage) {
    case scanStage:
      return 'Scan';
    case pickUpStage:
      return 'Ambil Barang';
    case checkStage:
      return 'Checker';
    case packStage:
      return 'Packing';
    case sendStage:
      return 'Kirim';
    case returnStage:
      return 'Retur';
    case cancelStage:
      return 'Cancel';
    default:
      return 'Tidak Diketahui';
  }
}

Future<bool> isInternetConnected() async {
  final connectivity = await Connectivity().checkConnectivity();
  return !connectivity.contains(ConnectivityResult.none);
}

bool isRefreshed<T>(T state, String? refreshToken) {
  return state is RefreshToken && refreshToken != null;
}