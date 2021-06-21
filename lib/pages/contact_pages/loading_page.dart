import 'package:contacts/firebaseContacts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:contacts/sqflite.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lottie/lottie.dart';
import 'package:connectivity/connectivity.dart';

class LoadingPage extends StatefulWidget {
  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  Sqflite sqflite = Sqflite();

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  bool hasConnectedToFirebase = false;
  bool hasContacts = false;
  bool hasErrorConnectingToFirebase = false;

  void getFirebaseContacts() async {
    FirebaseContacts firebaseContacts = FirebaseContacts();
    await firebaseContacts.getContacts();
    var contacts = firebaseContacts.contacts;

    Future.delayed(Duration.zero, () {
      Navigator.pushReplacementNamed(context, "/contacts", arguments: {
        "sqflite": sqflite,
        "contacts": contacts,
        "hasFirebase": hasConnectedToFirebase,
      });
    });
  }

  void getSqfliteContacts() async {
    await sqflite.getContacts();
    hasContacts = true;
    var contacts = sqflite.contacts;
    Future.delayed(Duration.zero, () {
      Navigator.pushReplacementNamed(context, "/contacts", arguments: {
        "sqflite": sqflite,
        "contacts": contacts,
        "hasFirebase": hasConnectedToFirebase,
      });
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      if(index == 1) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => LoadingPage(),
            transitionDuration: Duration(seconds: 0),
          ),
        );
      } else {
        Navigator.pushReplacementNamed(context, "/phoneDialer");
      }
    });
  }

  BottomNavigationBar bottomNavigationBar() {
    return BottomNavigationBar(
      backgroundColor: new Color(0xff252549),

      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(
            Icons.dialpad,
            size: 30,
          ),
          label: '',
          backgroundColor: Colors.red,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.contacts),
          label: '',
          backgroundColor: Colors.green,
        ),
      ],
      currentIndex: 1,
      selectedItemColor: Colors.white,
      unselectedItemColor: Color(0xff8686bd),
      onTap: _onItemTapped,
    );
  }

  void isConnected() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
      // Connected to firebase successfully
      hasConnectedToFirebase = true;
      print("Connected to firebase");

      // Check if user is logged in or not
      var user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        // not logged in
        Future.delayed(Duration.zero, () {
          Navigator.pushReplacementNamed(context, "/login");
        });
      } else {
        // Logged in
        getFirebaseContacts();
      }
    } else {
      print("User is not connected");
      hasConnectedToFirebase = false;
      getSqfliteContacts();
    }
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
            isConnected();
          } else {
            // Failed connecting to firebase
            // get sqflite contacts
            print("Failed connecting to firebase");
            getSqfliteContacts();
          }
          // isConnected();
        }

          // Otherwise, show something whilst waiting for initialization to complete
          return MaterialApp(
            home: Scaffold(
              backgroundColor: Color(0xff252549),
                  body: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(child: Lottie.asset('assets/loading_animation.json', width: 100, height: 100)),
                    ],
              ),

              bottomNavigationBar: bottomNavigationBar(),
            ),

          );
      },
    );
  }
}
