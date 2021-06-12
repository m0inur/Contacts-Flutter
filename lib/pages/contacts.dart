import 'dart:math';
import 'package:flutter/material.dart';
import 'package:contacts/contact.dart';

class Contacts extends StatefulWidget {
  @override
  _ContactsState createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  Color randomColor() =>
      Color((Random().nextDouble() * 0xFFFFFF).toInt() << 0).withOpacity(1.0);

  List<Contact> contacts = [];

  void contactOnTap(i) async {
    dynamic newContact = await Navigator.pushNamed(
        context, "/details", arguments: {
      "name": contacts[i].name,
      "mobile": contacts[i].mobile,
      "work": contacts[i].work,
      "email": contacts[i].email,
      "avatarImage": contacts[i].avatarImage,
      "backgroundColor": contacts[i].backgroundColor,
      "companyName": contacts[i].companyName,
      "isFavorite": contacts[i].isFavourite,
      "hasRemoved": false,
    });

    setState(() {
      // if the new contact was removed
      if (newContact["hasRemoved"] == true) {
        // remove
        contacts.remove(contacts[i]);
      } else {
        contacts[i].name = newContact["name"];
        contacts[i].mobile =
        newContact["mobile"] is int ? newContact["mobile"] : int.parse(
            newContact["mobile"]);
        if(newContact["work"] is int) {
          contacts[i].work = newContact["work"];
        } else {
          if(newContact["work"] != "") {
            contacts[i].work = int.parse(newContact["work"]);
          }
        }
        contacts[i].avatarImage = newContact["avatarImage"];
        contacts[i].email = newContact["email"];
        contacts[i].companyName = newContact["companyName"];
        contacts[i].isFavourite = newContact["isFavorite"];
      }
    });
  }

  void saveContact () async {
    dynamic result = await Navigator.pushNamed(context, "/new_contact");
    if (result != null) {
      setState(() {
        var mobileNumber = int.parse(result["mobile"]);
        var workNumber = result["work"] == "" ? 89 : int.parse(
            result["work"]);
        Contact newContact = Contact(
            result["id"], result["name"], result["companyName"], result["email"],
            mobileNumber, workNumber, result["avatarImage"], false);

        contacts.add(newContact);
      });
    }
  }

  AppBar contactsAppBar() {
    return AppBar(
      // backgroundColor: Colors.white,
      title: Container(
        child: Row(
          children: <Widget>[
            SizedBox(
              width: 170,
            ),
            Text(
              "All",
              // style: TextStyle(color: Colors.black),
            ),
            Icon(Icons.keyboard_arrow_down),
          ],
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: new Icon(
            Icons.search,
            size: 30,
          ),
        ),
        IconButton(
          onPressed: () => saveContact(),
          icon: new Icon(
            Icons.add,
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
    var letter = "";
    if (i == 0 ||
        contacts[i].name[0].toUpperCase() !=
            contacts[i - 1].name[0].toUpperCase()) {
      letter = contacts[i].name[0].toUpperCase();
    }
    return ListTile(
      onTap: () => contactOnTap(i),
      title: Container(
        child: Card(
          elevation: 0,
          color: Colors.transparent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Visibility(
                visible: letter != "",
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                  child: Text(
                    letter,
                    style: TextStyle(
                        color: Colors.blueGrey[300],
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),

              Row(
                children: <Widget>[
                  contacts[i].isFavourite == true ? Icon(
                    Icons.star, color: Colors.yellow,) : SizedBox(width: 24),
                  SizedBox(width: 10),

                  Visibility(
                    // IF there is no avatar image
                    visible: contacts[i].avatarImage.path == "",
                    // Set a random background color
                    child: CircleAvatar(
                      backgroundImage: AssetImage(
                          "assets/transparent-circle.png"),
                      backgroundColor: contacts[i].backgroundColor,
                      child: Text(contacts[i].name[0].toUpperCase()),
                      radius: 25,
                    ),
                  ),

                  Visibility(
                    // IF there is no avatar image
                    visible: contacts[i].avatarImage.path != "",
                    // Set a random background color
                    // child: Image.file(contacts[i].avatarImage),
                    child: CircleAvatar(
                      backgroundImage: FileImage(contacts[i].avatarImage),
                      radius: 25,
                    ),
                  ),

                  SizedBox(width: 25),

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
                            fontWeight: FontWeight.bold),
                      ),
                    ],
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
    var data = ModalRoute.of(context)?.settings.arguments as Map;
    contacts = data["contacts"] == null ? contacts : data["contacts"];
    contacts
        .sort((a, b) => a.name.toUpperCase().compareTo(b.name.toUpperCase()));

    return Scaffold(
      // backgroundColor: Colors.black,
        appBar: contactsAppBar(),
        body: Column(
          children: <Widget>[
            Expanded(child: contactsList()),
          ],
        )
    );
  }
}
