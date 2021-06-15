import 'package:contacts/contact.dart';
import 'package:contacts/firebaseContacts.dart';
import 'package:contacts/sqflite.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:io';

class NewContact extends StatefulWidget {
  @override
  _NewContactState createState() => _NewContactState();
}

class _NewContactState extends State<NewContact> {
  final nameController = TextEditingController();
  final companyNameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  final workController = TextEditingController();
  FirebaseContacts firebaseContacts = FirebaseContacts();

  double maxWidth = 30;
  int id = 0;

  File _avatarImage = File("");
  late Sqflite sqflite;
  final picker = ImagePicker();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    mobileController.dispose();
    workController.dispose();
    emailController.dispose();
    companyNameController.dispose();
    super.dispose();
  }

  AppBar appBar() {
    return AppBar(
      elevation: 0.0,
      leadingWidth: 100,
      centerTitle: true,
      leading: TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text(
          "Cancel",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
      title: Text(
        "New Contact",
        style: TextStyle(
          fontSize: 20,
          color: Colors.white,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            saveData();
          },
          child: Text(
            "Done",
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget inputField(text, textStyle, myController, nameAndDividerGap, type) {
    return IntrinsicHeight(
      child: Row(children: [
        SizedBox(width: 20),

        Text(
          text,
          style: textStyle,
        ),
        // print(_textSize(text, TextStyle(fontSize: 18))),
        SizedBox(width: nameAndDividerGap),

        VerticalDivider(
          color: Colors.white,
          thickness: 1,
          width: 5,
          indent: 7,
          endIndent: 7,
        ),

        Expanded(
          child: TextFormField(
            style: TextStyle(
              color: Colors.white,
            ),
            controller: myController,

            decoration: new InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),

              contentPadding:
              EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
            ),
            keyboardType: type,
          ),
        ),

      ]),
    );
  }

  Widget customVerticalRow() {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Divider(
          height: 10,
          color: Colors.black,
        ),
      ),
    );
  }

  void saveData() async {
    // If data is empty
    if (nameController.text == "" && mobileController.text == "" ||
        mobileController.text == "") {
      Navigator.pop(context);
    } else {
      var result = {
        "name": nameController.text,
        "mobile": mobileController.text,
        "work": workController.text,
        "email": emailController.text,
        "companyName": companyNameController.text,
        "avatarImage": _avatarImage,
      };
      var mobileNumber = int.parse(mobileController.text);
      var workNumber =
          workController.text == "" ? 89 : int.parse(workController.text);
      var newContact = Contact(
          id,
          result["name"],
          result["companyName"],
          result["email"],
          mobileNumber,
          workNumber,
          _avatarImage.path,
          false);
      print(newContact.backgroundColor);
      id++;
      // Insert contact into firebase
      firebaseContacts.addContact(newContact);
      firebaseContacts.getContacts();

      // insert contact into sqflite
      sqflite.insertContact(newContact);
      Navigator.pushReplacementNamed(context, "/");
    }
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _avatarImage = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var data = ModalRoute.of(context)?.settings.arguments as Map;
    sqflite = data["sqflite"];

    TextStyle textStyle = TextStyle(
      color: Colors.white70,
      fontSize: 18,
    );

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: appBar(),
        body: Container(
          child: Column(
            children: <Widget>[
              SizedBox(height: 15),
              ListView(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: <Widget>[
                  // Name field
                  inputField("Name", textStyle, nameController, maxWidth,
                  TextInputType.name),
                  SizedBox(height: 15,),

                  // E-mail field
                  inputField("E-Mail", textStyle, emailController, 30.0,
                      TextInputType.emailAddress),
                  SizedBox(height: 15,),

                  // Company name field
                  inputField("Company Name", textStyle, companyNameController,
                      30.0, TextInputType.emailAddress),
                  SizedBox(height: 15,),

                  inputField("Mobile", textStyle, mobileController, 23.0,
                      TextInputType.number),
                  SizedBox(height: 15,),

                  inputField("Work", textStyle, workController, 37.0,
                      TextInputType.number),
                  SizedBox(height: 15,),
                ]
              ),

              SizedBox(height: 50,),

              IconButton(
                onPressed: () {
                  print("Select image");
                  getImage();
                },

                icon: _avatarImage.path != ""
                    ? Image.file(_avatarImage)
                    : Image.asset('assets/newImage.png', color: Colors.white,),

                iconSize: 100,

              ),
              SizedBox(height: 15),
            ],
          ),
        ));
  }
}
