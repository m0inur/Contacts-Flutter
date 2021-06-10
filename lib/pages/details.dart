import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ContactDetails extends StatefulWidget {
  @override
  _ContactDetailsState createState() => _ContactDetailsState();
}

class _ContactDetailsState extends State<ContactDetails> {
  List<String> items = [
    "Edit",
    "Delete",
  ];
  String? selectedUser;
  Map contact = {};
  Color starIconColor = Colors.white;
  String firstLetter = "";

  void popScreen() {
    Navigator.pop(context, {
      "name": contact["name"],
      "mobile": contact["mobile"],
      "work": contact["work"],
      "email": contact["email"],
      "companyName": contact["companyName"],
      "isFavorite": contact["isFavorite"],
      "hasRemoved": contact["hasRemoved"],
    });
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
          child: Row(children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    contact["isFavorite"] = !contact["isFavorite"];
                  });
                },
                icon: Icon(
                  Icons.star,
                  color: starIconColor,
                  size: 30,
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: DropdownButton<String>(
                  underline: SizedBox(),
                  icon: Icon(
                    Icons.more_vert,
                    color: Colors.white,
                  ),

                  value: selectedUser,
                  onChanged: (value) {
                    setState(() {
                      print("selectedUser = $value");
                      if(value == "Delete") {
                        contact["hasRemoved"] = true;
                        popScreen();
                      }
                      selectedUser = value;
                    });
                  },
                  items: items.map((item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Row(
                        children: <Widget>[
                          Text(
                            item,
                            style:  TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
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
        ClipRRect(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10)),
          child: Image.asset(
            "assets/banner.png",
            fit: BoxFit.fill,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 150, top: 135),
          child: SizedBox(
            child: CircleAvatar(
              radius: 36,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                backgroundImage: AssetImage("assets/transparent-circle.png"),
                backgroundColor: contact["backgroundColor"],
                child: Text(
                  contact["name"][0].toUpperCase(),
                  style: TextStyle(fontSize: 20),
                ),
                radius: 33,
              ),
            ),
          ),
        ),
      ],
    );
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
    contact = ModalRoute.of(context)?.settings.arguments as Map;
    starIconColor = contact["isFavorite"] == true ? Colors.yellow : Colors.white;
    firstLetter = contact["name"][0].toUpperCase();

    return Scaffold(
      appBar: contactsAppBar(),
      extendBodyBehindAppBar: true,
      backgroundColor: Color(0xffbeff4f7),

      body: Container(
        margin: EdgeInsets.only(top: 20),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 1,
          margin: EdgeInsets.fromLTRB(20, 20, 20, 120),
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
                padding: EdgeInsets.all(35),
                child: Column(
                  children: [
                    detailsData(
                        Icons.phone_android, "MOBILE", contact["mobile"]),
                    detailsData(Icons.phone, "WORK", contact["work"] == 89 ? "" : contact["work"]),
                    detailsData(Icons.email, "WORK", contact["email"]),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      // Return back to main screen and pass the data
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          popScreen();
        },
        child: Icon(Icons.close),
        backgroundColor: Colors.grey[100],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
