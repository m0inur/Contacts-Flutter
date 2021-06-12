import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:contacts/sqflite.dart';
import 'package:firebase_core/firebase_core.dart';

class LoadingPage extends StatefulWidget {
  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  Sqflite sqflite = Sqflite();
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  bool hasFirebaseConnectionError = false;
  bool isFirebaseConnectionDone = false;

  void getContacts() async {
    await sqflite.getContacts();

    Navigator.pushReplacementNamed(context, "/contacts", arguments: {
      "sqflite": sqflite,
      "contacts": sqflite.contacts,
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting) {
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

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done || snapshot.hasError) {
          print("Connected or errored while connecting to firebase");
          getContacts();
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return LoadingPage();
      },
    );
  }
}
