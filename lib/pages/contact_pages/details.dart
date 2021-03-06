import 'package:contacts/contact.dart';
import 'package:contacts/firebaseContacts.dart';
import 'package:contacts/sqflite.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class ContactDetails extends StatefulWidget {
  @override
  _ContactDetailsState createState() => _ContactDetailsState();
}

class _ContactDetailsState extends State<ContactDetails> {
  FirebaseContacts ?firebaseContacts;
  List<String> items = [
    "Edit",
    "Delete",
  ];
  String? selectedUser;
  Map contact = {};
  Color starIconColor = Colors.white;
  String firstLetter = "";
  bool updateContact = false;
  bool isConnectedToFirebase = false;
  bool isSearched = false;
  late Sqflite sqflite;

  void _callNumber() async{
    FlutterPhoneDirectCaller.callNumber(contact["mobile"].toString());
  }

  void popScreen() {
    String workNumber;
    if(contact["work"] == "") {
      print("Work is empty");
      workNumber = "87";
    } else {
      print("Work is not empty");
      workNumber = contact["work"].toString();
    }
    // String workNumber = contact["work"] == "" ? "87" : contact["work"];
    print(contact["avatarImage"]);
    var newContact = Contact(
          contact["uId"],
          contact["id"],
          contact["name"],
          contact["companyName"],
          contact["email"],
          contact["mobile"],
          workNumber,
          contact["avatarImage"],
          contact["isFavourite"],
          contact["backgroundColor"],
        );
    if(isConnectedToFirebase) {
      if(firebaseContacts != null) {
        firebaseContacts!.updateContact(newContact);
      }
    }
    sqflite.updateContact(newContact);

    print("Set background Color ${contact["backgroundColor"]}");

    if(!isSearched) {
      Navigator.pushNamed(context, "/", arguments: {
      "hasUpdate": true,
      });
      // Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false, arguments: {
      //   "hasUpdate": true,
      // });
    } else {
      Navigator.pop(context);
    }

  }

  Widget contactListTileButtons() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () {
            // _callNumber(contacts[i].mobile.toString());
            _callNumber();
          },
          child: CircleAvatar(
            backgroundImage: AssetImage("assets/transparent-circle.png"),
            backgroundColor: Color(0xff3d3d63),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Icon(
                Icons.phone,
                color: Colors.white,
                size: 20,
              ),
            ),
            radius: 27,
          ),
        ),

        TextButton(
          onPressed: () async {
            List<String> numbers = [contact["mobile"].toString()];
            String _result = await sendSMS(message: "", recipients: numbers)
                .catchError((onError) {
              print(onError);
            });
          },
          child: CircleAvatar(
            backgroundImage: AssetImage("assets/transparent-circle.png"),
            backgroundColor: Color(0xff3d3d63),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Icon(
                Icons.messenger,
                color: Colors.white,
                size: 20,
              ),
            ),
            radius: 27,
          ),
        ),
      ],
    );
  }

  Future editDetails() async {
    // Go to edits page
    dynamic editedContact =
        await Navigator.pushNamed(context, "/details/edit", arguments: {
          "name": contact["name"],
          "mobile": contact["mobile"],
          "work": contact["work"],
          "email": contact["email"],
          "companyName": contact["companyName"],
          "avatarImage": contact["avatarImage"],
          "isConnectedToFirebase": contact["isConnectedToFirebase"],
        });

    // If the user edited the contact data
    if (editedContact is Map) {
      setState(() {
        contact = {
          "uId": contact["uId"],
          "id": contact["id"],
          "name": editedContact["name"],
          "mobile": editedContact["mobile"],
          "work": editedContact["work"],
          "email": editedContact["email"],
          "companyName": editedContact["companyName"],
          "avatarImage": editedContact["avatarImage"],
          "isFavourite": contact["isFavourite"],
          "hasRemoved": contact["hasRemoved"],
        };

        var mobileNumber = int.parse(editedContact["mobile"]);
        var workNumber = editedContact["work"] == "" ? 89 : int.parse(
            editedContact["work"]);

        sqflite.updateContact(
            Contact(
                "",
                contact["id"],
                editedContact["name"],
                editedContact["companyName"],
                editedContact["email"],
                mobileNumber,
                workNumber,
                editedContact["avatarImage"],
                contact["isFavourite"],
            )
        );
      });
    }
  }

  Padding topBarDropdown() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: DropdownButton<String>(
        underline: SizedBox(),
        icon: Icon(
          Icons.more_vert,
          color: Colors.white,
        ),
        value: selectedUser,
        onChanged: (value) {
          // print("selectedUser = $value");
          if (value == "Delete") {
            deleteContact();
          } else {
            editDetails();
          }
          // selectedUser = value;
        },
        items: items.map((item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Row(
              children: <Widget>[
                Text(
                  item,
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  AppBar contactsAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      bottomOpacity: 0.0,
      elevation: 0.0,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 35, top: 20),
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    contact["isFavourite"] = !contact["isFavourite"];
                  });
                },
                icon: Icon(
                  Icons.star,
                  color: starIconColor,
                  size: 30,
                ),
              ),
              topBarDropdown(),
            ],
          ),
        ),
      ],
      bottom: PreferredSize(
          child: Container(
            color: Colors.grey[800],
            height: 0.5,
          ),
          preferredSize: Size.fromHeight(0.2)),
    );
  }

  Stack topImages() {
    return Stack(
      // crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Visibility(
          visible: contact["avatarImage"].path == "",

          child: Padding(
            padding: EdgeInsets.only(left: 150, top: 50),
            child: CircleAvatar(
              radius: 36,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                backgroundImage: AssetImage("assets/transparent-circle.png"),
                backgroundColor: contact["backgroundColor"],
                child: Text(
                  contact["name"][0].toUpperCase(),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                radius: 33,
              ),
            ),
          ),
        ),
        Visibility(
          visible: contact["avatarImage"].path != "",

          child: Padding(
            padding: EdgeInsets.only(left: 150, top: 50),
            child: CircleAvatar(
              radius: 36,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                backgroundImage: FileImage(contact["avatarImage"]),
                radius: 33,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Delete contact
  void deleteContact() async {
    if(isConnectedToFirebase) {
      await firebaseContacts?.deleteContact(contact["uId"]);
    }
    sqflite.deleteContact(contact["id"]);

    Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false);
  }

  Row detailsData(icon, dataName, text) {
    return Row(
      children: [
        Icon(
          icon,
          color: Color(0xffb8a9eb0),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 0, 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Text(
                  dataName,
                  style: TextStyle(
                    color: Color(0xffb8a9eb0),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                text.toString(),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    contact = contact.isNotEmpty
        ? contact
        : ModalRoute.of(context)?.settings.arguments as Map;
    sqflite = contact["sqflite"] == null ? sqflite : contact["sqflite"];

    starIconColor =
        contact["isFavourite"] == true ? Colors.yellow : Colors.white;
    firstLetter = contact["name"][0].toUpperCase();
    isConnectedToFirebase = contact["isConnectedToFirebase"] == null ? isConnectedToFirebase : contact["isConnectedToFirebase"];

    if(isConnectedToFirebase) {
      firebaseContacts = FirebaseContacts();
    }

    isSearched = contact["isSearched"] != null;

    return Scaffold(
      resizeToAvoidBottomInset: false,

      appBar: contactsAppBar(),
      extendBodyBehindAppBar: true,
      backgroundColor: Color(0xff232338),

      body: Container(
        // height: 580,
        margin: EdgeInsets.only(top: 20),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          elevation: 1,
          margin: EdgeInsets.fromLTRB(20, 0, 20, 0),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              topImages(),

              // Name
              Center(
                heightFactor: 2,
                child: Text(
                  contact["name"],
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                ),
              ),

              Center(
                heightFactor: 0,
                child: Text(
                  contact["companyName"],
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xffb8a9eb0),
                  ),
                ),
              ),

              // Data details
              Padding(
                padding: EdgeInsets.only(left: 40, top: 40),
                child: Column(
                  children: [
                    detailsData(
                        Icons.phone_android, "MOBILE", contact["mobile"]),
                    SizedBox(height: 15,),
                    detailsData(Icons.phone, "WORK",
                        contact["work"] == 89 ? "" : contact["work"]),
                    SizedBox(height: 15,),
                    detailsData(Icons.email, "WORK", contact["email"]),
                  ],
                ),
              ),

            SizedBox(height: 25,),
            contactListTileButtons(),
            ],
          ),
        ),
      ),

      // Return back to main screen and pass the data
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          popScreen();
        },
        child: Icon(Icons.close, color: Colors.white,),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
