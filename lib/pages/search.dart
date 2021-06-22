import 'package:contacts/contact.dart';
import 'package:contacts/sqflite.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final searchBarController = TextEditingController();
  List<Contact> contacts = [];
  Sqflite ?sqflite;

  bool isConnectedToFirebase = false;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    searchBarController.dispose();
    super.dispose();
  }

  PreferredSize appBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(60.0),
      child: AppBar(
        actions: [],
        title: IntrinsicHeight(
            child: TextFormField(
              controller: searchBarController,
              style: new TextStyle(fontWeight: FontWeight.normal, color: Colors.white),
              decoration: InputDecoration(
                hintText: 'John',
                hintStyle: TextStyle(
                  color: Colors.white,
                ),

                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(32.0)
                ),

                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                    borderRadius: BorderRadius.circular(32.0)
                ),

                suffixIcon: IconButton(
                    onPressed: () {
                      searchContacts();
                    },
                    icon: Icon(Icons.search, color: Colors.white,),
                ),

                contentPadding: new EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
              ),
            ),
        ),
      ),
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
              children: [
                Visibility(
                  visible: letter != "",
                  child: SizedBox(height: 20,),
                ),
              ],
            ),

            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                contacts[i].isFavourite == true ?
                Icon(
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

  ListView contactsList() {
    return ListView.builder(
      itemCount: contacts.length,
      itemBuilder: (context, i) {
        return contactListTile(i);
      },
    );
  }

  void contactOnTap(i) {
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
      "isSearched": true,
    });
  }

  void searchContacts() async {
    var name = searchBarController.text;
    await sqflite!.getContactsWith(name);

    setState(() {
      contacts = sqflite!.searchedContacts;
    });
  }

  @override
  Widget build(BuildContext context) {
    var data = ModalRoute.of(context)?.settings.arguments as Map;
    sqflite = data["sqflite"];
    isConnectedToFirebase = data["isConnectedToFirebase"];

    return Scaffold(
      appBar: appBar(),
      body: Column(
        children: <Widget>[
          Expanded(child: contactsList()),
          // contactsList(),
        ],
      ),

      // Return back to main screen and pass the data
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false);
        },
        child: Icon(Icons.close, color: Colors.white,),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}