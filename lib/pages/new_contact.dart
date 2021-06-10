import 'package:flutter/material.dart';
import 'package:flutter/src/material/input_border.dart';

class NewContact extends StatefulWidget {
  @override
  _NewContactState createState() => _NewContactState();
}

class _NewContactState extends State<NewContact> {
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  // final nameController = TextEditingController(text: "John");
  // final mobileController = TextEditingController(text: "01921831293");
  // final workController = TextEditingController(text: "");
  // final emailController = TextEditingController(text: "john@gmail.com");

  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  final workController = TextEditingController();
  final emailController = TextEditingController();
  final companyNameController = TextEditingController();
  double maxWidth = 30;

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
                // border: InputBorder.none,
                // enabledBorder: InputBorder.none,
                // disabledBorder: InputBorder.none,
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
      });

      // print("Name: ${nameController.text} Mobile: ${mobileController.text}");
    }
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
              Center(
                  child: CircleAvatar(
                    backgroundImage: AssetImage("assets/default-user.jpg"),
                    radius: 50,
                  )
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

class SizeConfig{

  double heightSize(BuildContext context, double value){
    value /= 100;
    return MediaQuery.of(context).size.height * value;
  }

  double widthSize(BuildContext context, double value){
    value /=100;
    return MediaQuery.of(context).size.width * value;
  }
}