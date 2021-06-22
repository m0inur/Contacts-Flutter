import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:io';

class Contact {
  List<Color> avatarColors = [
    Colors.deepOrange,
    Colors.blue,
    Colors.orangeAccent,
    Colors.teal,
    Colors.deepPurple,
    Colors.cyan,
    Colors.deepOrangeAccent,
    Colors.indigoAccent,
    Colors.pinkAccent,
    Colors.deepPurpleAccent,
  ];

  late String uId = "";
  late String name;
  late String companyName;
  late String email;
  late File avatarImage = File("");

  late int id;
  late int mobile;
  late int work;

  late Color backgroundColor;
  bool isFavourite = false;

  Contact(uId, id, name, companyName, email, mobile, work, avatarImage, isFavourite, [color]) {
    if(uId != null) if (uId != "") this.uId = uId;
    this.id = id;
    this.name = name;
    this.companyName = companyName;
    this.email = email;
    this.mobile = mobile is String ? int.parse(mobile) : mobile;
    this.work = work is int ? work : int.parse(work);

    if(avatarImage is String) {
      this.avatarImage = File(avatarImage);
    } else if(avatarImage is File) {
      this.avatarImage = avatarImage;
    }

    if(isFavourite is int) {
      this.isFavourite = isFavourite == 0 ? false : true;
    } else {
      this.isFavourite = isFavourite;
    }

    // if(color != null) {
    //   print(color);
    //   backgroundColor = new Color(int.parse(color.substring("MaterialColor(primary value: Color(".length, color.length - 2)));
    //   return;
    // }

    // if(backgroundColor.toString() != "") return;
    final random = new Random();
    var i = random.nextInt(avatarColors.length);
    backgroundColor = avatarColors[i];
  }

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    // 'CREATE TABLE contacts(id INTEGER PRIMARY KEY, name TEXT, companyName TEXT, email TEXT, avatarImage TEXT, backgroundColor TEXT, mobile INT, work INT, isFavourite INT)',
    return {
      'name': name,
      'companyName': companyName,
      'email': email,
      'avatarImage': avatarImage.path,
      'backgroundColor': backgroundColor.toString(),
      'mobile': mobile,
      'work': work,
      'isFavourite': isFavourite == false ? 0 : 1,
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Contact{uId: $uId id: $id name: $name, company name: $companyName, e-mail: $email, avatarImage: ${avatarImage.path}, mobile: $mobile, work: $work, isFavourite: $isFavourite}';
  }
}