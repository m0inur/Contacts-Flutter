import 'package:flutter/material.dart';
import 'package:flutter/src/material/input_border.dart';

class NewContact extends StatefulWidget {
  @override
  _NewContactState createState() => _NewContactState();
}

class _NewContactState extends State<NewContact> {
  AppBar newContactAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      leadingWidth: 100,
      centerTitle: true,
      leading: TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text(
          "Cancel",
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
      ),
      title: Text(
        "New Contact",
        style: TextStyle(
          fontSize: 20,
          color: Colors.black,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            "Done",
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget inputField (text) {
      return             IntrinsicHeight(
        child: Row(children: [
          SizedBox(width: 20),

          Text(
            "$text",
            style: TextStyle(fontSize: 18),
          ),

          SizedBox(width: 30),

          VerticalDivider(
            thickness: 1,
            width: 10,
            color: Colors.black,

            indent: 10,
            endIndent: 10,
          ),

          SizedBox(width: 30),

          Expanded(
            child: TextFormField(
              initialValue: '$text',

              decoration: new InputDecoration(
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  contentPadding:
                  EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
              ),
            ),
          )
        ]),
      );
    }
    return Scaffold(
        appBar: newContactAppBar(),
        body: Container(
          child: Column(
            children: <Widget>[
              SizedBox(height: 30),
              Center(
                  child: CircleAvatar(
                backgroundImage: AssetImage("assets/default-user.jpg"),
                radius: 50,
              )),

              inputField("Name"),
              inputField("Phone"),

            ],
          ),
        ));
  }
}
