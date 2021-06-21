import 'package:contacts/contact.dart';
import 'package:contacts/firebaseContacts.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:io';

class Edit extends StatefulWidget {
  @override
  _EditState createState() => _EditState();
}

class _EditState extends State<Edit> {
  Map contact = new Map();
  double maxWidth = 30;
  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  final workController = TextEditingController();
  final emailController = TextEditingController();
  final companyNameController = TextEditingController();
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
        "Edit Contact",
        style: TextStyle(
          fontSize: 20,
            color: Colors.white
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

        SizedBox(width: 10,)
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
          color: Colors.white,
        ),
      ),
    );
  }

  void saveData() {
    // Save the data
    Navigator.pop(context, {
      "name": nameController.text,
      "mobile": mobileController.text,
      "work": workController.text,
      "email": emailController.text,
      "companyName": companyNameController.text,
      "avatarImage": contact["avatarImage"]
    });
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        contact["avatarImage"] = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    contact = ModalRoute.of(context)?.settings.arguments as Map;
    TextStyle textStyle = TextStyle(fontSize: 18);

    nameController.text = contact["name"];
    mobileController.text = contact["mobile"].toString();
    String work = contact["work"].toString();
    work == "89" ? workController.text = "" : workController.text = work;
    emailController.text = contact["email"];
    companyNameController.text = contact["companyName"];

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
                ],
              ),
              SizedBox(height: 50,),

              IconButton(
                onPressed: () {
                  print("Select image");
                  getImage();
                },

                icon: contact["avatarImage"].path != ""
                    ? Image.file(contact["avatarImage"])
                    : Image.asset('assets/newImage.png', color: Colors.white,),

                iconSize: 100,

              ),
            ],
          ),
        ));
  }
}
