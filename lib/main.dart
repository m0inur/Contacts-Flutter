import 'package:contacts/pages/loading_page.dart';
import 'package:flutter/material.dart';
import 'package:contacts/pages/details.dart';
import 'package:contacts/pages/edit.dart';
import 'package:contacts/pages/contacts.dart';
import 'package:contacts/pages/new_contact.dart';

void main() async {
  runApp(MyApp());
  WidgetsFlutterBinding.ensureInitialized();
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
          // backgroundColor: Color(0xffb),

        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xff2f2f53),
          elevation: 0.0,

          actionsIconTheme: IconThemeData(
            color: Colors.white,
          )
        ),

        scaffoldBackgroundColor: Color(0xff232339),

        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Color(0xff3d3d63),
        ),

        textTheme: TextTheme(
          bodyText1: TextStyle(),
          bodyText2: TextStyle(),
        ).apply(
          bodyColor: Colors.white,
          displayColor: Colors.blue,
        ),

        cardTheme: CardTheme(
          color: Color(0xff232339),
        )
      ),

      initialRoute: "/",

      routes: {
        "/": (context) => LoadingPage(),
        "/contacts": (context) => Contacts(),
        "/edit": (context) => Edit(),
        "/details": (context) => ContactDetails(),
        "/new_contact": (context) => NewContact(),
        "/details/edit": (context) => Edit(),
      },
    );
  }
}
