import 'package:contacts/pages/contacts.dart';
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
  bool hasContacts = false;
  bool hasErrorConnectingToFirebase = false;
  bool hasConnectedToFirebase = false;

  void getContacts() async {
    await sqflite.getContacts();
    hasContacts = true;
    print("Got Contacts");
    isConnected();
  }

  void isConnected() {
    if(hasErrorConnectingToFirebase || hasConnectedToFirebase) {
      if(hasContacts) {
        Future.delayed(Duration.zero, () {
          Navigator.pushReplacementNamed(context, "/contacts", arguments: {
            "sqflite": sqflite,
            "contacts": sqflite.contacts,
          });
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    getContacts();
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        if(snapshot.hasError) {
          print("Error connecting to firebase, error = ${snapshot.error}");
          hasErrorConnectingToFirebase = true;
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          if(!hasErrorConnectingToFirebase) {
            print("Connected to firebase");
            hasConnectedToFirebase = true;
          }
          isConnected();
        }

          // Otherwise, show something whilst waiting for initialization to complete
          return MaterialApp(
            home: Scaffold(
              body: ListView(
                children: [
                  // Loading animation
                  // SizedBox(height: 40),
                  // Lottie.asset('assets/loading_animation.json'),
                ],
              ),
            ),
          );
      },
    );
  }
}
