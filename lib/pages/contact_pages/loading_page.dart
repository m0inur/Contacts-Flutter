import 'package:contacts/firebaseContacts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:contacts/sqflite.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lottie/lottie.dart';

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
    // await sqflite.getContacts();
    // hasContacts = true;
    FirebaseContacts firebaseContacts = FirebaseContacts();
    // firebaseContacts.deleteContact();
    await firebaseContacts.getContacts();
    var contacts = firebaseContacts.contacts;
    print("Got Contacts");

    Future.delayed(Duration.zero, () {
      // Navigator.pushReplacementNamed(context, "/phoneDialer");
      Navigator.pushReplacementNamed(context, "/contacts", arguments: {
        "sqflite": sqflite,
        "contacts": contacts,
      });
    });
  }

  Future firebaseUser() async {
    return FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
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
            // Check if user is logged in or not
            var user = FirebaseAuth.instance.currentUser;
            if(user == null) {
              // not logged in
              Future.delayed(Duration.zero, () {
                Navigator.pushReplacementNamed(context, "/login");
              });
            } else {
              // Logged in
              getContacts();
            }
          }
          // isConnected();
        }

          // Otherwise, show something whilst waiting for initialization to complete
          return MaterialApp(
            home: Scaffold(
              backgroundColor: Color(0xff252549),
              body: ListView(
                children: [
                  // Loading animation
                  Center(
                    heightFactor: 6,
                      child: Lottie.asset('assets/loading_animation.json', width: 100, height: 100)
                  ),
                ],
              ),
            ),
          );
      },
    );
  }
}
