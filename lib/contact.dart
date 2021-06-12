import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:io';

class Contact {
  late String name;
  late String companyName;
  late String email;
  late File avatarImage = File("");

  late int id;
  late int mobile;
  late int work;

  late Color backgroundColor;
  bool isFavourite = false;

  Contact(id, name, companyName, email, mobile, work, avatarImage, isFavourite) {
    this.id = id;
    this.name = name;
    this.companyName = companyName;
    this.email = email;
    this.mobile = mobile;

    if(work is int) this.work = work;

    if(avatarImage is String) {
      avatarImage = File(avatarImage);
    } else {
      if(avatarImage.path != "") {
        print("Set avatar image");
        this.avatarImage = avatarImage;
      }
    }

    if(isFavourite is int) {
      this.isFavourite = isFavourite == 0 ? false : true;
    } else {
      this.isFavourite = isFavourite;
    }

    backgroundColor = Colors.primaries[Random().nextInt(Colors.primaries.length)];
  }

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    // 'CREATE TABLE dogs(id INTEGER PRIMARY KEY, name TEXT, companyName TEXT, email TEXT, avatarImage TEXT, mobile INT, work INT, isFavourite INT)',
    return {
      'name': name,
      'companyName': companyName,
      'email': email,
      'avatarImage': avatarImage.path,
      'mobile': mobile,
      'work': work,
      'isFavourite': isFavourite == false ? 0 : 1,
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Contact{name: $name, company name: $companyName, e-mail: $email, avatarImage: ${avatarImage.path}, mobile: $mobile, work: $work, isFavourite: $isFavourite}';
  }
}