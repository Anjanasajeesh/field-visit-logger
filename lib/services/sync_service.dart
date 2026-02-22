import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:field_visit_logger/db/visit_db.dart';
import 'package:field_visit_logger/models/visit_model.dart';

class SyncService {
  static final SyncService instance = SyncService._internal();
  SyncService._internal();

  final Connectivity _connectivity = Connectivity();

  void startAutoSync() {
    _connectivity.onConnectivityChanged.listen((result) {
      if (result != ConnectivityResult.none) {
        _syncPendingVisits();
      }
    });
  }

  Future<void> _syncPendingVisits() async {
    final visits = await VisitDatabase.instance.getVisits();

    for (Visit visit in visits) {
      if (!visit.isSynced) {
        bool success = await _sendToServer(visit);

        if (success && visit.id != null) {
          await VisitDatabase.instance.markSynced(visit.id!);
        }
      }
    }
  }

  Future<bool> _sendToServer(Visit visit) async {
    await Future.delayed(const Duration(seconds: 2));

    return true;
  }
}
