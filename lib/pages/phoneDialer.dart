import 'package:flutter/material.dart';

class PhoneDialer extends StatefulWidget {
  @override
  _PhoneDialerState createState() => _PhoneDialerState();
}

class _PhoneDialerState extends State<PhoneDialer> {
  final numberController = TextEditingController(text: "");

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    numberController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    Widget circleAvatar(text, fontSize) {
      return TextButton(
        onPressed: () {
          setState(() {
            numberController.text += text;
          });
        },

        child: Column(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage("assets/transparent-circle.png"),
              backgroundColor: Colors.blueGrey[300],
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  text,
                  style: TextStyle(color: Colors.white, fontSize: fontSize),
                ),
              ),
              radius: 30,
            ),
            SizedBox(
              width: 80,
            ),
          ],
        ),
      );
    }

    Widget dialPad() {
      return Column(
        children: [
          Padding(
            padding: EdgeInsets.all(15),
            child: Text(
              numberController.text,
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              circleAvatar("0", 23.0),
              circleAvatar("1", 23.0),
              circleAvatar("2", 23.0),
            ],
          ),

          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              circleAvatar("3", 23.0),
              circleAvatar("4", 23.0),
              circleAvatar("5", 23.0),
            ],
          ),

          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              circleAvatar("6", 23.0),
              circleAvatar("7", 23.0),
              circleAvatar("8", 23.0),
            ],
          ),

          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              circleAvatar("9", 23.0),

              TextButton(
                onPressed: () {
                  print("Call");
                },
                child: Column(
                  children: [
                    CircleAvatar(
                      backgroundImage:
                          AssetImage("assets/transparent-circle.png"),
                      backgroundColor: Colors.green[400],
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Icon(
                          Icons.phone,
                          color: Colors.white,
                        ),
                      ),
                      radius: 30,
                    ),
                    SizedBox(
                      width: 80,
                    ),
                  ],
                ),
              ),

              TextButton(
                onPressed: () {
                  setState(() {
                    var text = numberController.text;
                    var subString = text.substring(0, text.length - 1);

                    numberController.text = subString;
                  });
                },

                child: Column(
                  children: [
                    CircleAvatar(
                      backgroundImage:
                      AssetImage("assets/transparent-circle.png"),
                      backgroundColor: Colors.blueGrey[300],
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                      ),
                      radius: 30,
                    ),
                    SizedBox(
                      width: 80,
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(
            height: 15,
          ),
        ],
      );
    }

    void _onItemTapped(int index) {
      setState(() {
        if(index == 1) {
          Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false);
        } else {
          Navigator.pushReplacementNamed(context, "/phoneDialer");
        }
        print("$index got tapped");
      });
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 60,
            ),
            dialPad()
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: new Color(0xff252549),

        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.dialpad,
              size: 30,
            ),
            label: '',
            backgroundColor: Colors.red,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contacts),
            label: '',
            backgroundColor: Colors.green,
          ),
        ],
        currentIndex: 0,
        selectedItemColor: Colors.white,
        unselectedItemColor: Color(0xff8686bd),
        onTap: _onItemTapped,
      ),
    );
  }
}