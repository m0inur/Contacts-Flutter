import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:io';

class Contact {
  late String name;
  late String companyName;
  late String email;
  late File avatarImage = File("");

  late int mobile;
  late int work;

  late Color backgroundColor = Colors.primaries[Random().nextInt(Colors.primaries.length)];

  bool isFavourite = false;

  Contact(name, companyName, email, mobile, work, avatarImage) {
    this.name = name;
    this.companyName = companyName;
    this.email = email;
    this.mobile = mobile;
    if(work is int) this.work = work;
    if(avatarImage.path != "") {
      print("Set avatar image");
      this.avatarImage = avatarImage;
    }
    backgroundColor = Colors.primaries[Random().nextInt(Colors.primaries.length)];
  }

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'number': mobile,
      'avatarImage': avatarImage,
    };
  }
}