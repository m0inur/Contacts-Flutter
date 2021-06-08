import 'package:apps/contact.dart';
import 'package:flutter/material.dart';

class Contacts extends StatefulWidget {
  @override
  _ContactsState createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  List<Contact> contacts = [
    Contact("erbi Maam", 01854624557, "sim1.png"),
    Contact("Abu Dauod", 01836891273, "sim2.png"),
    Contact("drbi Maam", 01854624557, "sim1.png"),
    Contact("arbi Maam", 01854624557, "sim1.png"),
    Contact("Crbi Maam", 01854624557, "sim1.png"),
    Contact("Brbi Maam", 01854624557, "sim1.png"),
  ];

  AppBar contactsAppBar() {
    return AppBar(
      backgroundColor: Colors.black,
      title: Text(
        "Contacts",
        style: TextStyle(fontSize: 30),
      ),
      actions: [
        TextButton(
            onPressed: () {},
            child: Text(
              "Edit",
              style: TextStyle(
                fontSize: 23,
                color: Colors.white,
              ),
            )),
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.add,
            size: 40,
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.settings_outlined,
            size: 30,
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
          "simLocation": contacts[i].simLocation,
        });
      },

      title: Text(
        contacts[i].name,
        style: TextStyle(
            color: Colors.white,
            fontSize: 19,
            fontWeight: FontWeight.w400
        ),
      ),

      trailing: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Image.asset(
              "assets/${contacts[i].simLocation}",
              height: 25,
              width: 25,
              fit: BoxFit.fitWidth,
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    contacts.sort((a, b) => a.name.toUpperCase().compareTo(b.name.toUpperCase()));
    contacts.forEach((element) {print(element.name); });

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: contactsAppBar(),
      body: contactsList(),
    );
  }
}
