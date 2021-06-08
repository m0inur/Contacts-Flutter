import 'package:apps/contact.dart';
import 'package:flutter/material.dart';

class Contacts extends StatefulWidget {
  @override
  _ContactsState createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  List<Contact> contacts = [
    Contact("Erbi Maam", "Staford University", 01854624557, "sim1.png"),
    Contact("Abu Dauod", "Hooli Inc", 01836891273, "sim2.png"),
    Contact("Drbi Maam", "UC Berkeley", 01854624557, "sim1.png"),
    Contact("Erbi Maam", "Husky Energy", 01854624557, "sim1.png"),
    Contact("Crbi Maam", "Pied Piper", 01854624557, "sim1.png"),
    Contact("Brbi Maam", "Hooli Inc.", 01854624557, "sim1.png"),
  ];

  AppBar contactsAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      title: Container(
        child: Row(
          children: <Widget>[
            SizedBox(
              width: 170,
            ),
            Text(
              "All",
              style: TextStyle(color: Colors.black),
            ),
            Icon(Icons.keyboard_arrow_down, color: Colors.black),
          ],
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: new Icon(
            Icons.search,
            color: Colors.black,
            size: 30,
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: new Icon(
            Icons.add,
            color: Colors.black,
            size: 40,
          ),
        ),
      ],
    );
  }

  ListView contactsList() {
    return ListView.builder(
      itemCount: contacts.length,
      itemBuilder: (context, i) {
        return contactListTile(i);
      },
    );
  }

  ListTile contactListTile(i) {
    return ListTile(
      onTap: () {
        Navigator.pushNamed(context, "/details", arguments: {
          "name": contacts[i].name,
          "number": contacts[i].number,
          "simLocation": contacts[i].avatarImage,
        });
      },
      title: Container(
        child: Card(
          elevation: 0,
          color: Colors.transparent,

          child: Row(
            children: <Widget>[
              CircleAvatar(
                backgroundImage: AssetImage("assets/grey-square.png"),
                child: Text("A"),
                radius: 25,
              ),

              SizedBox(width: 25,),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      "${contacts[i].name}",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  Text(
                    "${contacts[i].companyName}",
                    style: TextStyle(
                      color: Colors.blueGrey[200],
                      fontSize: 17,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    contacts
        .sort((a, b) => a.name.toUpperCase().compareTo(b.name.toUpperCase()));
    return Scaffold(
      // backgroundColor: Colors.black,
      appBar: contactsAppBar(),
      body: contactsList(),
    );
  }
}
