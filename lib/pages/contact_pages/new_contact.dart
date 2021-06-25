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
  FirebaseContacts ?firebaseContacts;
  bool isConnectedToFirebase = false;

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
          "$text",
          style: textStyle,
        ),
        // print(_textSize(text, TextStyle(fontSize: 18))),
        SizedBox(width: nameAndDividerGap - 15),
        Text(
          ":",
          style: TextStyle(
            fontSize: 21
          ),
        ),
        SizedBox(width: 10),
        // VerticalDivider(
        //   color: Colors.white,
        //   thickness: 1,
        //   width: 5,
        //   indent: 7,
        //   endIndent: 7,
        // ),

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
  // Widget inputField(
  //     text, myController, type) {
  //   return IntrinsicHeight(
  //     child: Padding(
  //       padding: const EdgeInsets.only(left: 40, right: 40),
  //       child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Text(text.toUpperCase(), style: TextStyle(
  //               fontWeight: FontWeight.bold,
  //               letterSpacing: 1.3,
  //               color: Color(0xff7f82bb),
  //             ),),
  //             SizedBox(height: 10,),
  //             Expanded(
  //               child: TextFormField(
  //                 style: TextStyle(color: Colors.white,),
  //                 controller: myController,
  //                 keyboardType: type,
  //
  //                 decoration: new InputDecoration(
  //                   fillColor: Color(0xff1f1f34),
  //                   filled: true,
  //
  //                   enabledBorder: new OutlineInputBorder(
  //                     borderRadius: new BorderRadius.circular(10),
  //                     borderSide: new BorderSide(
  //                         color: Colors.transparent
  //                     ),
  //                   ),
  //
  //                   focusedBorder: new OutlineInputBorder(
  //                     borderRadius: new BorderRadius.circular(10),
  //                     borderSide: new BorderSide(
  //                         color: Colors.transparent
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ]),
  //     ),
  //   );
  // }

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
          "",
          id,
          result["name"],
          result["companyName"],
          result["email"],
          mobileNumber,
          workNumber,
          _avatarImage.path,
          false);

      if(isConnectedToFirebase) {
        // Insert contact into databases
        firebaseContacts!.addContact(newContact);
      }
      
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
    id = data["contactsLen"] + 1;
    isConnectedToFirebase = data["isConnectedToFirebase"];

    if(isConnectedToFirebase) {
      firebaseContacts = FirebaseContacts();
    }
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
                  inputField("Organization", textStyle, companyNameController,
                      30.0, TextInputType.emailAddress),
                  SizedBox(height: 15,),

                  inputField("Mobile", textStyle, mobileController, 23.0,
                      TextInputType.number),
                  SizedBox(height: 15,),

                  inputField("Work", textStyle, workController, 37.0,
                      TextInputType.number),
                  SizedBox(height: 15,),


                  // // Name field
                  // inputField("Name", nameController,
                  //     TextInputType.name),
                  // SizedBox(height: 15,),
                  //
                  // // E-mail field
                  // inputField("E-Mail", emailController,
                  //     TextInputType.emailAddress),
                  // SizedBox(height: 15,),
                  //
                  // // Company name field
                  // inputField("Organization", companyNameController, TextInputType.emailAddress),
                  // SizedBox(height: 15,),
                  //
                  // inputField("Mobile", mobileController, TextInputType.number),
                  // SizedBox(height: 15,),
                  //
                  // inputField("Work", workController, TextInputType.number),
                  // SizedBox(height: 15,),
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
