class Contact {
  late String name;
  late String companyName;
  late String avatarImage;
  late int number;
  bool isFavourite = false;

  Contact(name, companyName, number, avatarImage) {
    this.name = name;
    this.companyName = companyName;
    this.number = number;
    this.avatarImage = avatarImage;
    // print("Contact($name, $number, $avatarImage)");
  }

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'number': number,
      'avatarImage': avatarImage,
    };
  }
}