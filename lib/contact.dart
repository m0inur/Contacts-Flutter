class Contact {
  late String name;
  late String simLocation;
  late int number;

  Contact(name, number, simLocation) {
    this.name = name;
    this.number = number;
    this.simLocation = simLocation;
    // print("Contact($name, $number, $simLocation)");
  }

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'number': number,
      'simLocation': simLocation,
    };
  }
}