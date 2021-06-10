import 'package:contacts/pages/details.dart';
import 'package:contacts/pages/edit.dart';
import 'package:flutter/material.dart';
import 'package:contacts/pages/contacts.dart';
import 'package:contacts/pages/new_contact.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        accentColor: Colors.white,
        primaryColor: Colors.white,
        brightness: Brightness.light,
      ),

      initialRoute: "/",
      routes: {
        "/": (context) => Contacts(),
        "/edit": (context) => Edit(),
        "/details": (context) => ContactDetails(),
        "/new_contact": (context) => NewContact(),
      },
    );
  }
}