import 'package:apps/pages/contacts.dart';
import 'package:apps/pages/details.dart';
import 'package:apps/pages/edit.dart';
import 'package:apps/pages/new_contact.dart';
import 'package:flutter/material.dart';

// TODO: Flesh out contacts page
// Add a search bar
//   write logic for search bar

// TODO: Flesh out edit page
// Change App bar when editing
// Disable search
// Add big dots left side of contact numbers
//    logic for big dots
// Add delete button for the selected items
//    Add delete functionality logic

// TODO: Flesh out details page
// Show details of number
//  Add delete functionality
// Add edit functionality


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "/new_contact",
      routes: {
        "/": (context) => Contacts(),
        "/edit": (context) => Edit(),
        "/details": (context) => Details(),
        "/new_contact": (context) => NewContact(),
      },
    );
  }
}