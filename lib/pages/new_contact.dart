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
  final mobileController = TextEditingController();
  final workController = TextEditingController();
  final emailController = TextEditingController();
  final companyNameController = TextEditingController();
  double maxWidth = 30;
  File _avatarImage = File("");
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

  AppBar newContactAppBar() {
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
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
      ),
      title: Text(
        "New Contact",
        style: TextStyle(
          fontSize: 20,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            saveData();
          },
          child: Text(
            "Done",
            style: TextStyle(fontSize: 20, color: Colors.black),
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
            style: TextStyle(fontSize: 18),
          ),
          // print(_textSize(text, TextStyle(fontSize: 18))),
          SizedBox(width: nameAndDividerGap),

          VerticalDivider(
            thickness: 1,
            width: 5,
            indent: 7,
            endIndent: 7,
          ),

          Expanded(
            // height: SizeConfig().heightSize(context, 10.0),
            // width: SizeConfig().widthSize(context, 1.5),
            child: TextFormField(
              controller: myController,
              decoration: new InputDecoration(
                contentPadding:
                EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
              ),

              keyboardType: type,
            ),
          )
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

  void saveData() {
    // If data is empty
    if(nameController.text == "" && mobileController.text == "" || mobileController.text == "") {
      Navigator.pop(context);
    } else {
      // Save the data
      Navigator.pop(context, {
        "name": nameController.text,
        "mobile": mobileController.text,
        "work": workController.text,
        "email": emailController.text,
        "companyName": companyNameController.text,
        "avatarImage": _avatarImage,
      });

      // print("Name: ${nameController.text} Mobile: ${mobileController.text}");
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
    TextStyle textStyle = TextStyle(
      fontSize: 18,
    );

    return Scaffold(
        resizeToAvoidBottomInset: false,

        appBar: newContactAppBar(),
        body: Container(
          child: Column(
            children: <Widget>[
              SizedBox(height: 15),
              IconButton(
                onPressed: () {
                  print("Select image");
                  getImage();
                },
                icon: _avatarImage.path != "" ? Image.file(_avatarImage) : Image.asset('assets/newImage.png'),
                iconSize: 85,
              ),

              ListView(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: <Widget> [
                  // Name field
                  inputField("Name", textStyle, nameController, maxWidth, TextInputType.name),

                  // E-mail field
                  inputField("E-Mail", textStyle, emailController, 30.0, TextInputType.emailAddress),

                  // Company name field
                  inputField("Company Name", textStyle, companyNameController, 30.0, TextInputType.emailAddress),

                  inputField("Mobile", textStyle, mobileController, 23.0, TextInputType.number),

                  inputField("Work", textStyle, workController, 37.0, TextInputType.number),
                ],
              ),
              SizedBox(height: 15),
            ],
          ),
        )
    );
  }
}