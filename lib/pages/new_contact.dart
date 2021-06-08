import 'package:flutter/material.dart';
import 'package:flutter/src/material/input_border.dart';

class NewContact extends StatefulWidget {
  @override
  _NewContactState createState() => _NewContactState();
}

class _NewContactState extends State<NewContact> {
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final nameController = TextEditingController();
  final phoneController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  AppBar newContactAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      leadingWidth: 100,
      centerTitle: true,
      leading: TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text(
          "Cancel",
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
      ),
      title: Text(
        "New Contact",
        style: TextStyle(
          fontSize: 20,
          color: Colors.black,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            saveData();
          },
          child: Text(
            "Done",
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
        ),
      ],
    );
  }

  void saveData() {
    // If data is empty
    if(nameController.text == "" && phoneController.text == "") {
      print("Dont push the data");
      Navigator.pop(context);
    } else {
      print("Push the data");
      // Save the data
      Navigator.pop(context, {
        "name": nameController.text,
        "phone": phoneController.text,
      });

      // print("Save name ${nameController.text} and number ${phoneController.text}");
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: newContactAppBar(),
        body: Container(
          child: Column(
            children: <Widget>[
              SizedBox(height: 30),
              Center(
                  child: CircleAvatar(
                backgroundImage: AssetImage("assets/default-user.jpg"),
                radius: 50,
              )),

              // Name field
              IntrinsicHeight(
                child: Row(children: [
                  SizedBox(width: 20),

                  Text(
                    "Name",
                    style: TextStyle(fontSize: 18),
                  ),

                  SizedBox(width: 30),

                  VerticalDivider(
                    thickness: 1,
                    width: 5,
                    color: Colors.black,

                    indent: 10,
                    endIndent: 10,
                  ),

                  Expanded(
                    child: TextFormField(
                      controller: nameController,

                      decoration: new InputDecoration(
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding:
                        EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                      ),

                      keyboardType: TextInputType.name,
                    ),
                  )
                ]),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Divider(
                  height: 1,
                  color: Colors.black,
                ),
              ),

              IntrinsicHeight(
                child: Row(children: [
                  SizedBox(width: 21),

                  Text(
                    "Phone",
                    style: TextStyle(fontSize: 18),
                  ),

                  SizedBox(width: 25),

                  VerticalDivider(
                    thickness: 1,
                    width: 5,
                    color: Colors.black,

                    indent: 10,
                    endIndent: 10,
                  ),

                  Expanded(
                    child: TextFormField(
                      controller: phoneController,
                      decoration: new InputDecoration(
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding:
                        EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                      ),

                      keyboardType: TextInputType.number,
                    ),
                  )
                ]),
              ),
            ],
          ),
        ));
  }
}