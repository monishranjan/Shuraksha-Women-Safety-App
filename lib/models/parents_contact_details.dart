class ParentsContact {
  String? name;
  String? contact;

  ParentsContact({required this.name, required this.contact});

  // Data from server
  factory ParentsContact.fromMap(map) {
    return ParentsContact(
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