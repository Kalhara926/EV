import '../models/charging_session.dart';

class ChargingHistoryManager {
  static final ChargingHistoryManager _instance = ChargingHistoryManager._internal();

  factory ChargingHistoryManager() {
    return _instance;
  }

  ChargingHistoryManager._internal();

  final List<ChargingSession> _sessions = [];

  List<ChargingSession> get sessions => _sessions.toList(); // Return a copy to prevent external modification

  void addSession(ChargingSession session) {
    _sessions.add(session);
    // In a real app, you'd save this to local storage (shared_preferences, database) here
    print('Charging session added to history: ${session.stationName}');
  }
}