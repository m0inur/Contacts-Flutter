import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:contacts/sqflite.dart';

class LoadingPage extends StatefulWidget {
  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  Sqflite sqflite = Sqflite();

  void getContacts() async {
    var contacts = await sqflite.getContacts();
    Navigator.pushReplacementNamed(context, "/contacts", arguments: {
      "contacts": contacts,
    });
  }

  @override
  Widget build(BuildContext context) {
    print("Loading Page");
    getContacts();
    return MaterialApp(
      home: Scaffold(
        body: ListView(
          children: [
            // Loading animation
            SizedBox(height: 40),
            Lottie.asset('assets/loading_animation.json', frameRate: FrameRate(140)),
          ],
        ),
      ),
    );
  }
}
