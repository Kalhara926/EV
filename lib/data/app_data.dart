// lib/data/app_data.dart

import 'package:latlong2/latlong.dart';

// --- Mock EV Station Data ---
class EvStation {
  final String id;
  final String name;
  final String address;
  final LatLng location;
  final int availableChargers;
  final int totalChargers;
  final double rating;
  final String imageUrl; // Added for more realism
  final List<String> chargerTypes; // e.g., ['Type 2', 'CCS Combo 2']
  final List<String> amenities; // e.g., ['Restaurant', 'Washroom', 'WiFi']
  final String operatingHours;
  final String? contactNumber; // Optional contact number

  EvStation({
    required this.id,
    required this.name,
    required this.address,
    required this.location,
    required this.availableChargers,
    required this.totalChargers,
    required this.rating,
    this.imageUrl = 'https://via.placeholder.com/150', // Default placeholder
    this.chargerTypes = const [],
    this.amenities = const [],
    this.operatingHours = '24/7',
    this.contactNumber,
  });
}

// Dummy EV Stations in Sri Lanka
final List<EvStation> mockEvStations = [
  EvStation(
    id: 'station_001',
    name: 'Colombo City Center Charger',
    address: '137 Sir James Peiris Mawatha, Colombo 02',
    location: const LatLng(6.9218, 79.8562), // Colombo City Center
    availableChargers: 3,
    totalChargers: 5,
    rating: 4.5,
    imageUrl: 'https://cdn.evcharge.lk/images/stations/colombo-city-centre.jpg',
    chargerTypes: ['Type 2', 'CCS Combo 2'],
    amenities: ['Mall', 'Food Court', 'Restrooms'],
    operatingHours: '10 AM - 10 PM',
    contactNumber: '+94 112 345678',
  ),
  EvStation(
    id: 'station_002',
    name: 'Arcade Independence Square',
    address: 'Independence Avenue, Colombo 07',
    location: const LatLng(6.9038, 79.8637), // Arcade Independence Square
    availableChargers: 1,
    totalChargers: 2,
    rating: 4.0,
    imageUrl:
        'https://cdn.evcharge.lk/images/stations/arcade-independence-square.jpg',
    chargerTypes: ['Type 2', 'CHAdeMO'],
    amenities: ['Shops', 'Restaurants', 'Open Area'],
    operatingHours: '8 AM - 11 PM',
    contactNumber: '+94 112 678901',
  ),
  EvStation(
    id: 'station_003',
    name: 'Galle Face Green Station',
    address: 'Galle Face Green, Colombo 01',
    location: const LatLng(6.9248, 79.8517), // Near Galle Face Hotel
    availableChargers: 2,
    totalChargers: 3,
    rating: 4.2,
    imageUrl: 'https://cdn.evcharge.lk/images/stations/galle-face-green.jpg',
    chargerTypes: ['CCS Combo 2'],
    amenities: ['Beach Access', 'Food Stalls'],
    operatingHours: '24/7',
    contactNumber: '+94 771 234567',
  ),
  EvStation(
    id: 'station_004',
    name: 'Kandy City Centre Charger',
    address: '5 Dalada Veediya, Kandy',
    location: const LatLng(7.2914, 80.6367), // Kandy City Centre
    availableChargers: 4,
    totalChargers: 4,
    rating: 4.8,
    imageUrl: 'https://cdn.evcharge.lk/images/stations/kandy-city-centre.jpg',
    chargerTypes: ['Type 2', 'CCS Combo 2', 'CHAdeMO'],
    amenities: ['Shopping Mall', 'Cinema', 'Restrooms'],
    operatingHours: '9:30 AM - 9:30 PM',
    contactNumber: '+94 812 234567',
  ),
  EvStation(
    id: 'station_005',
    name: 'Southern Expressway - Kottawa Exit',
    address: 'Kottawa Interchange, Kottawa',
    location: const LatLng(6.8409, 79.9575), // Kottawa Interchange
    availableChargers: 0, // No chargers available
    totalChargers: 1,
    rating: 3.5,
    imageUrl: 'https://cdn.evcharge.lk/images/stations/kottawa-expressway.jpg',
    chargerTypes: ['CCS Combo 2'],
    amenities: ['Rest Stop', 'Cafe'],
    operatingHours: '24/7',
    contactNumber: '+94 712 987654',
  ),
  EvStation(
    id: 'station_006',
    name: 'Negombo Beach Road',
    address: 'Lewis Pl, Negombo',
    location: const LatLng(7.2140, 79.8390),
    availableChargers: 2,
    totalChargers: 2,
    rating: 4.1,
    imageUrl: 'https://cdn.evcharge.lk/images/stations/negombo-beach.jpg',
    chargerTypes: ['Type 2'],
    amenities: ['Hotels', 'Restaurants', 'Beach'],
    operatingHours: '6 AM - 10 PM',
    contactNumber: '+94 773 456789',
  ),
  EvStation(
    id: 'station_007',
    name: 'Matara Town Center',
    address: 'Matara-Kataragama Rd, Matara',
    location: const LatLng(5.9525, 80.5517),
    availableChargers: 1,
    totalChargers: 2,
    rating: 3.9,
    imageUrl: 'https://cdn.evcharge.lk/images/stations/matara-town.jpg',
    chargerTypes: ['CCS Combo 2', 'CHAdeMO'],
    amenities: ['Shops', 'Local Eateries'],
    operatingHours: '7 AM - 9 PM',
    contactNumber: '+94 711 223344',
  ),
  EvStation(
    id: 'station_008',
    name: 'Jaffna City Hub',
    address: 'K.K.S. Road, Jaffna',
    location: const LatLng(9.6647, 80.0210),
    availableChargers: 3,
    totalChargers: 3,
    rating: 4.6,
    imageUrl: 'https://cdn.evcharge.lk/images/stations/jaffna-hub.jpg',
    chargerTypes: ['Type 2', 'CCS Combo 2'],
    amenities: ['Market', 'Banks'],
    operatingHours: '8 AM - 8 PM',
    contactNumber: '+94 765 432109',
  ),
];

// --- Mock User Vehicle Data ---
class Vehicle {
  String id;
  String make;
  String model;
  String year;
  String licensePlate;
  String batteryCapacityKWh; // e.g., "60 kWh"
  String chargingPortType; // e.g., "Type 2", "CCS Combo 2", "CHAdeMO"
  String? imageUrl; // Optional: Image for the vehicle

  Vehicle({
    required this.id,
    required this.make,
    required this.model,
    required this.year,
    required this.licensePlate,
    required this.batteryCapacityKWh,
    required this.chargingPortType,
    this.imageUrl,
  });

  // Add a copyWith method for easier updates (from previous code)
  Vehicle copyWith({
    String? id,
    String? make,
    String? model,
    String? year,
    String? licensePlate,
    String? batteryCapacityKWh,
    String? chargingPortType,
    String? imageUrl,
  }) {
    return Vehicle(
      id: id ?? this.id,
      make: make ?? this.make,
      model: model ?? this.model,
      year: year ?? this.year,
      licensePlate: licensePlate ?? this.licensePlate,
      batteryCapacityKWh: batteryCapacityKWh ?? this.batteryCapacityKWh,
      chargingPortType: chargingPortType ?? this.chargingPortType,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  // Convert to JSON (useful if we later implement local storage like shared_preferences)
  Map<String, dynamic> toJson() => {
        'id': id,
        'make': make,
        'model': model,
        'year': year,
        'licensePlate': licensePlate,
        'batteryCapacityKWh': batteryCapacityKWh,
        'chargingPortType': chargingPortType,
        'imageUrl': imageUrl,
      };

  // Create from JSON
  factory Vehicle.fromJson(Map<String, dynamic> json) => Vehicle(
        id: json['id'],
        make: json['make'],
        model: json['model'],
        year: json['year'],
        licensePlate: json['licensePlate'],
        batteryCapacityKWh: json['batteryCapacityKWh'],
        chargingPortType: json['chargingPortType'],
        imageUrl: json['imageUrl'],
      );
}

// Using a list that can be modified by the MyVehicleScreen
List<Vehicle> mockUserVehicles = [
  Vehicle(
    id: 'vehicle_001',
    make: 'Tesla',
    model: 'Model 3',
    year: '2022',
    licensePlate: 'CAB-1234',
    batteryCapacityKWh: '75 kWh',
    chargingPortType: 'Type 2',
    imageUrl:
        'https://cache.bmw.co.th/image/upload/t_amp_landing_img/bmwgroup/image/upload/v1684305917/BMW-i-models-overview-TH-HP-stage-desktop.jpg',
  ),
  Vehicle(
    id: 'vehicle_002',
    make: 'Nissan',
    model: 'Leaf',
    year: '2018',
    licensePlate: 'SPA-5678',
    batteryCapacityKWh: '40 kWh',
    chargingPortType: 'CHAdeMO',
    imageUrl:
        'https://hips.hearstapps.com/hmg-prod/images/2018-nissan-leaf-102-1533220455.jpg?crop=0.6666666666666666xw:1xh;center,top&resize=1200:*',
  ),
  Vehicle(
    id: 'vehicle_003',
    make: 'Porsche',
    model: 'Taycan',
    year: '2023',
    licensePlate: 'ABC-0001',
    batteryCapacityKWh: '93.4 kWh',
    chargingPortType: 'CCS Combo 2',
    imageUrl:
        'https://cdn.motor1.com/images/mgl/kG7k8/s1/2022-porsche-taycan-gts.webp',
  ),
  Vehicle(
    id: 'vehicle_004',
    make: 'Hyundai',
    model: 'Kona Electric',
    year: '2021',
    licensePlate: 'KONA-EV',
    batteryCapacityKWh: '64 kWh',
    chargingPortType: 'CCS Combo 2',
    imageUrl:
        'https://www.hyundai.com/content/dam/hyundai/ww/en/images/eco/kona-electric/hyundai-kona-electric-highlights-driving-performance-desktop.jpg',
  ),
];

// --- Mock Charging History Data ---
class ChargingSession {
  final String id;
  final String vehicleId; // Added: Link to the vehicle
  final String stationName;
  final String chargerId;
  final String chargerTypeUsed; // Added: Type of charger used
  final DateTime startTime;
  final DateTime endTime;
  final double durationMinutes;
  final double energyConsumedKWh;
  final double cost; // Changed from pointsUsed to cost for simplicity
  final int vehicleBatteryPercentageStart; // Added
  final int vehicleBatteryPercentageEnd; // Added

  ChargingSession({
    required this.id,
    required this.vehicleId,
    required this.stationName,
    required this.chargerId,
    required this.chargerTypeUsed,
    required this.startTime,
    required this.endTime,
    required this.durationMinutes,
    required this.energyConsumedKWh,
    required this.cost,
    required this.vehicleBatteryPercentageStart,
    required this.vehicleBatteryPercentageEnd,
  });
}

// Dummy Charging Sessions
List<ChargingSession> mockChargingHistory = [
  ChargingSession(
    id: 'ch_001',
    vehicleId: 'vehicle_001', // Tesla Model 3
    stationName: 'Colombo City Center Charger',
    chargerId: 'CCC-001',
    chargerTypeUsed: 'Type 2',
    startTime: DateTime(2025, 5, 20, 10, 0),
    endTime: DateTime(2025, 5, 20, 10, 50),
    durationMinutes: 50,
    energyConsumedKWh: 15.0,
    cost: 1500.0,
    vehicleBatteryPercentageStart: 30,
    vehicleBatteryPercentageEnd: 55,
  ),
  ChargingSession(
    id: 'ch_002',
    vehicleId: 'vehicle_002', // Nissan Leaf
    stationName: 'Arcade Independence Square',
    chargerId: 'AIS-001',
    chargerTypeUsed: 'CHAdeMO',
    startTime: DateTime(2025, 5, 15, 14, 15),
    endTime: DateTime(2025, 5, 15, 14, 45),
    durationMinutes: 30,
    energyConsumedKWh: 8.0,
    cost: 800.0,
    vehicleBatteryPercentageStart: 20,
    vehicleBatteryPercentageEnd: 48,
  ),
  ChargingSession(
    id: 'ch_003',
    vehicleId: 'vehicle_001', // Tesla Model 3
    stationName: 'Kandy City Centre Charger',
    chargerId: 'KCC-004',
    chargerTypeUsed: 'CCS Combo 2',
    startTime: DateTime(2025, 5, 10, 9, 0),
    endTime: DateTime(2025, 5, 10, 9, 50),
    durationMinutes: 50,
    energyConsumedKWh: 20.0,
    cost: 2000.0,
    vehicleBatteryPercentageStart: 40,
    vehicleBatteryPercentageEnd: 70,
  ),
  ChargingSession(
    id: 'ch_004',
    vehicleId: 'vehicle_003', // Porsche Taycan
    stationName: 'Southern Expressway - Kottawa Exit',
    chargerId: 'SEX-001',
    chargerTypeUsed: 'CCS Combo 2',
    startTime: DateTime(2025, 5, 5, 18, 0),
    endTime: DateTime(2025, 5, 5, 18, 45),
    durationMinutes: 45,
    energyConsumedKWh: 30.0, // High energy for Taycan
    cost: 3000.0,
    vehicleBatteryPercentageStart: 15,
    vehicleBatteryPercentageEnd: 50,
  ),
  ChargingSession(
    id: 'ch_005',
    vehicleId: 'vehicle_004', // Hyundai Kona Electric
    stationName: 'Negombo Beach Road',
    chargerId: 'NBR-001',
    chargerTypeUsed: 'Type 2',
    startTime: DateTime(2025, 5, 25, 11, 0),
    endTime: DateTime(2025, 5, 25, 12, 0),
    durationMinutes: 60,
    energyConsumedKWh: 10.0,
    cost: 1000.0,
    vehicleBatteryPercentageStart: 25,
    vehicleBatteryPercentageEnd: 45,
  ),
];
