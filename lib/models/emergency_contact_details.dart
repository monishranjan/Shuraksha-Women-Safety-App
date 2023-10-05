class EmergencyContact {
  String? name;
  String? contact;

  EmergencyContact({required this.name, required this.contact});

  // Data from server
  factory EmergencyContact.fromMap(map) {
    return EmergencyContact(
        name: map['name'],
        contact: map['contact']
    );
  }

  // Sending data to server
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'contact': contact,
    };
  }
}