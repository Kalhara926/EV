class ChargingSession {
  final String stationName;
  final String connectorType;
  final double energyConsumedKWh;
  final double cost;
  final DateTime startTime;
  final DateTime endTime;
  final String paymentMethod; // e.g., 'Card Payment', 'PayPal', 'iPay'

  ChargingSession({
    required this.stationName,
    required this.connectorType,
    required this.energyConsumedKWh,
    required this.cost,
    required this.startTime,
    required this.endTime,
    required this.paymentMethod,
  });

  // Optional: A method to convert to/from JSON if you plan to persist data
  Map<String, dynamic> toJson() {
    return {
      'stationName': stationName,
      'connectorType': connectorType,
      'energyConsumedKWh': energyConsumedKWh,
      'cost': cost,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'paymentMethod': paymentMethod,
    };
  }

  factory ChargingSession.fromJson(Map<String, dynamic> json) {
    return ChargingSession(
      stationName: json['stationName'],
      connectorType: json['connectorType'],
      energyConsumedKWh: json['energyConsumedKWh'],
      cost: json['cost'],
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      paymentMethod: json['paymentMethod'],
    );
  }
}