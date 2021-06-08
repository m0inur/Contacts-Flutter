import 'package:flutter/material.dart';

class Details extends StatelessWidget {
  Map data = {};
  String firstLetter = "";

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context)?.settings.arguments as Map;
    firstLetter = data["name"][0].toUpperCase();
    print(data);

    AppBar contactsAppBar() {
      return AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),

        backgroundColor: Colors.black,
        title: Text(
          "Details",
          style: TextStyle(
              fontSize: 20,
          ),
        ),
        actions: [
          TextButton(
              onPressed: () {},
              child: Text(
                "Edit",
                style: TextStyle(
                  fontSize: 23,
                  color: Colors.white,
                ),
              )
          ),

          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.ios_share,
              size: 30,
            ),
          ),
        ],
        bottom: PreferredSize(
            child: Container(
              color: Colors.grey[800],
              height: 0.5,
            ),
            preferredSize: Size.fromHeight(0.2)
        ),
      );
    }

    Widget headerSection() {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0, 70, 0, 0),
        child: Column(
          children: <Widget> [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,

              children: <Widget> [
                CircleAvatar(
                  backgroundImage: AssetImage("assets/grey-square.png"),
                  radius: 55,
                  child: Text(
                      "$firstLetter",
                    style: TextStyle(
                      fontSize: 45,
                      color: Colors.grey[400]
                    ),
                  ),
                ),
              ],
            ),
            Text(
              data["name"],
              style: TextStyle(
                color: Colors.white,
                fontSize: 20
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: contactsAppBar(),
      body: headerSection(),
    );
  }
}

