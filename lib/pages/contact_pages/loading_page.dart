import 'package:contacts/contact.dart';
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
  bool hasUpdate = false;
  List<Contact> sqfliteContacts = [];
  List<Contact> firebaseContacts = [];

  Future setFirebaseContacts() async {
    FirebaseContacts firebase = FirebaseContacts();
    await firebase.getContacts();
    firebaseContacts = firebase.contacts;
  }

  Future<String> setSqfliteContacts() async {
    await sqflite.getContacts();
    hasContacts = true;
    sqfliteContacts = sqflite.contacts;
    return "done";
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

      // Check if user is logged in or not
      var user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        // not logged in
        Future.delayed(Duration.zero, () {
          Navigator.pushReplacementNamed(context, "/login");
        });
      } else {
        // Logged in
        FirebaseContacts firebase = FirebaseContacts();
        await setFirebaseContacts();
        await setSqfliteContacts();
        // print("Firebase contacts: ");
        // print(firebaseContacts);

        // if(firebaseContacts.length != sqfliteContacts.length || hasUpdate) {
        //   print("Set contacts to both databases");
        //   await setSqfliteContacts();
        //   await firebase.setContacts(sqfliteContacts);
        // }
        changePage(firebaseContacts);
      }
    } else {
      hasConnectedToFirebase = false;

      // Get sqflite contacts
      await setSqfliteContacts();
      changePage(sqfliteContacts);
    }
  }

  void changePage(contacts) {
    Future.delayed(Duration.zero, () {
      Navigator.pushNamed(context, "/contacts", arguments: {
        "sqflite": sqflite,
        "contacts": contacts,
        "hasFirebase": hasConnectedToFirebase,
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var data = ModalRoute.of(context)?.settings.arguments;
    if(data != null) {
      data = data as Map;
      hasUpdate = data["hasUpdate"] != null;
    }

    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        if(snapshot.hasError) {
          hasErrorConnectingToFirebase = true;
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          if(!hasErrorConnectingToFirebase) {
            isConnected();
          } else {
            // Failed connecting to firebase
            // get sqflite contacts
            setSqfliteContacts();
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
