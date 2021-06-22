import 'package:contacts/pages/phoneDialer.dart';
import 'package:contacts/sqflite.dart';
import 'package:flutter/material.dart';
import 'package:contacts/contact.dart';

class Contacts extends StatefulWidget {
  @override
  _ContactsState createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  List<Contact> contacts = [];
  Sqflite? sqflite;
  AppBar ?appBar;

  bool isConnectedToFirebase = false;
  bool isSearching = false;

  void contactOnTap(i) {
    // print("${contacts[i]}");
    Navigator.pushNamed(context, "/details", arguments: {
      "uId": contacts[i].uId,
      "id": contacts[i].id,
      "name": contacts[i].name,
      "mobile": contacts[i].mobile,
      "work": contacts[i].work,
      "email": contacts[i].email,
      "avatarImage": contacts[i].avatarImage,
      "backgroundColor": contacts[i].backgroundColor,
      "companyName": contacts[i].companyName,
      "isFavourite": contacts[i].isFavourite,
      "hasRemoved": false,
      "sqflite": sqflite,
      "isConnectedToFirebase": isConnectedToFirebase,
    });
  }

  void saveContact() async {
    await Navigator.pushNamed(context, "/new_contact", arguments: {
      "sqflite": sqflite,
      "contactsLen": contacts.length,
      "isConnectedToFirebase": isConnectedToFirebase
    });
  }

  AppBar contactsAppBar() {
    return AppBar(
      // backgroundColor: Colors.white,
      automaticallyImplyLeading: false,

      title: Container(
        child: Row(
          children: <Widget>[
            SizedBox(
              width: 170,
            ),
            Text(
              "All",
              style: TextStyle(color: Colors.white),
            ),
            Icon(
              Icons.keyboard_arrow_down,
              color: Colors.white,
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, "/search", arguments: {
              "sqflite": sqflite,
              "isConnectedToFirebase": isConnectedToFirebase,
            });
          },
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

  Widget contactListTile(i) {
    var letter = "";
    if (i == 0 ||
        contacts[i].name[0].toUpperCase() !=
            contacts[i - 1].name[0].toUpperCase()) {
      letter = contacts[i].name[0].toUpperCase();
    }
    return TextButton(
      onPressed: () {
        contactOnTap(i);
      },
      child: Card(
        elevation: 0,
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Name letter category
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Visibility(
                  visible: letter != "",
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: Text(
                      letter,
                      style: TextStyle(
                          color: Colors.blueGrey[300],
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),

            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                contacts[i].isFavourite == true ? Icon(
                  Icons.star,
                  color: Colors.yellow,
                ) : SizedBox(width: 24,),

                SizedBox(width: 10,),

                // Show avatar
                Visibility(
                  // IF there is no avatar image
                  visible: contacts[i].avatarImage.path == "",
                  // Set a random background color
                  child: CircleAvatar(
                    backgroundImage:
                        AssetImage("assets/transparent-circle.png"),
                    backgroundColor: contacts[i].backgroundColor,
                    child: Text(
                      contacts[i].name[0].toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      if (index == 0) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => PhoneDialer(),
            transitionDuration: Duration(seconds: 0),
          ),
        );
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

  @override
  Widget build(BuildContext context) {
    var data = ModalRoute.of(context)?.settings.arguments as Map;
    if (data["contacts"] == null) {
      Navigator.pushReplacementNamed(context, "/");
    }
    sqflite = data["sqflite"];
    contacts = data["contacts"];
    isConnectedToFirebase = data["hasFirebase"];

    contacts
        .sort((a, b) => a.name.toUpperCase().compareTo(b.name.toUpperCase()));
    if(isSearching) {
      // appBar = searchBarAppbar();
    } else {
      appBar = contactsAppBar();
    }
    return Scaffold(
      // backgroundColor: Colors.black,
      appBar: appBar,
      body: Column(
        children: <Widget>[
          Expanded(child: contactsList()),
          // contactsList(),
        ],
      ),

      bottomNavigationBar: bottomNavigationBar(),
    );
  }
}
