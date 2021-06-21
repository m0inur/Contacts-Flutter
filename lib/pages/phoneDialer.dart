import 'package:contacts/pages/contact_pages/loading_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class PhoneDialer extends StatefulWidget {
  @override
  _PhoneDialerState createState() => _PhoneDialerState();
}

class _PhoneDialerState extends State<PhoneDialer> {
  final numberController = TextEditingController(text: "");
  double circleAvatarYGap = 5;
  double buttonLeftGap = 340;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    numberController.dispose();
    super.dispose();
  }

  void _callNumber() async {
    FlutterPhoneDirectCaller.callNumber(numberController.text);
  }

  Widget circleAvatar(text, fontSize) {
    return TextButton(
      onPressed: () {
        if (numberController.text.length > 15) return;
        setState(() {
          print(fontSize);
          numberController.text += text;
        });
      },
      child: Column(
        children: [
          CircleAvatar(
            backgroundImage: AssetImage("assets/transparent-circle.png"),
            backgroundColor: Color(0xff3d3d63),
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
            width: 20,
          ),
        ],
      ),
    );
  }

  Widget build(BuildContext context) {
    Widget dialPad() {
      return Column(
        children: [
          Stack(
            fit: StackFit.loose,
            children: [

              Padding(
                padding: EdgeInsets.fromLTRB(90, 15, 15, 15),
                child: Text(
                  numberController.text,
                  style: TextStyle(
                    fontSize: 25,
                  ),
                ),
              ),

              Positioned(
                left: buttonLeftGap,
                child: TextButton(
                  onPressed: () {
                    print("Cut");
                    var text = numberController.text;
                    if(text == "") return;
                    setState(() {
                      var subString = text.substring(0, text.length - 1);

                      numberController.text = subString;
                    });
                  },
                  child: Icon(
                    Icons.backspace_outlined,
                    color: Colors.white,
                  ),
                ),
              ),

              Divider(
                color: Colors.transparent,
              ),
            ],

            clipBehavior: Clip.none,
          ),

          Divider(
            color: Colors.white,
            indent: 70,
            endIndent: 70,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              circleAvatar("1", 23.0),
              circleAvatar("2", 23.0),
              circleAvatar("3", 23.0),
            ],
          ),
          SizedBox(
            height: circleAvatarYGap,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              circleAvatar("4", 23.0),
              circleAvatar("5", 23.0),
              circleAvatar("6", 23.0),
            ],
          ),
          SizedBox(
            height: circleAvatarYGap,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              circleAvatar("7", 23.0),
              circleAvatar("8", 23.0),
              circleAvatar("9", 23.0),
            ],
          ),
          SizedBox(
            height: circleAvatarYGap,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              circleAvatar("*", 40.0),
              circleAvatar("0", 23.0),
              circleAvatar("#", 23.0),
            ],
          ),
          SizedBox(
            height: circleAvatarYGap,
          ),

          TextButton(
            onPressed: () {
              _callNumber();
            },
            child: Column(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage("assets/transparent-circle.png"),
                  backgroundColor: Colors.green,
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
        ],
      );
    }

    void _onItemTapped(int index) {
      setState(() {
        if (index == 1) {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation1, animation2) => LoadingPage(),
              transitionDuration: Duration(seconds: 0),
            ),
          );
        } else {
          Navigator.pushReplacementNamed(context, "/phoneDialer");
        }
        print("$index got tapped");
      });
    }

    BottomNavigationBar bottomNavigationBar() {
      return BottomNavigationBar(
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
      );
    }

    return Scaffold(
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              dialPad(),
              SizedBox(height: 20),
            ],
          ),
        ),
        bottomNavigationBar: bottomNavigationBar());
  }
}
