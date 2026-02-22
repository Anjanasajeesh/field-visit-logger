class Visit {
  int? id;
  String farmerName;
  String village;
  String cropType;
  String notes;
  String imagePath;
  double latitude;
  double longitude;
  String dateTime;
  bool isSynced;

  Visit({
    this.id,
    required this.farmerName,
    required this.village,
    required this.cropType,
    required this.notes,
    required this.imagePath,
    required this.latitude,
    required this.longitude,
    required this.dateTime,
    required this.isSynced,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'farmerName': farmerName,
      'village': village,
      'cropType': cropType,
      'notes': notes,
      'imagePath': imagePath,
      'latitude': latitude,
      'longitude': longitude,
      'dateTime': dateTime,
      'isSynced': isSynced ? 1 : 0,
    };
  }

  factory Visit.fromMap(Map<String, dynamic> map) {
    return Visit(
      id: map['id'],
      farmerName: map['farmerName'],
      village: map['village'],
      cropType: map['cropType'],
      notes: map['notes'],
      imagePath: map['imagePath'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      dateTime: map['dateTime'],
      isSynced: map['isSynced'] == 1,
    );
  }
}
