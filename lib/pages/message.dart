import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';

class Message extends StatefulWidget {
  @override
  _MessageState createState() => _MessageState();
}

class _MessageState extends State<Message> {
  final numberController = TextEditingController();
  String number = "";

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    numberController.dispose();
    super.dispose();
  }

  void _sendSMS(String message, String number) async {
    List<String> numbers = [number];

    String _result = await sendSMS(message: message, recipients: numbers)
        .catchError((onError) {
      print(onError);
    });
    print(_result);
  }

  @override
  Widget build(BuildContext context) {
    var data = ModalRoute.of(context)?.settings.arguments as Map;
    number = data["number"];

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),

        title: Text(
          "Message",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
              margin: const EdgeInsets.all(15.0),
              padding: const EdgeInsets.all(3.0),

              child: IntrinsicHeight(
                child: Row(children: [
                  Expanded(
                    child: TextFormField(
                      controller: numberController,
                      style: TextStyle(color: Colors.white),

                      decoration: new InputDecoration(
                        labelText: "Message",
                        labelStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),

                        border: new OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(10.0),
                          ),
                        ),

                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(
                            color: Colors.white,
                            width: 2.0,
                          ),
                        ),

                        contentPadding:
                        EdgeInsets.only(left: 15, bottom: 11, top: 20, right: 15),
                      ),

                      maxLines: 5,
                      keyboardType: TextInputType.text,
                    ),
                  ),

                  IconButton(
                      onPressed: () {
                        _sendSMS(numberController.text, number);
                      },
                      icon: Icon(Icons.subdirectory_arrow_right),
                      color: Colors.white,
                      iconSize: 25,
                  ),
                ]),
              )
          )
        ],
      )
    );
  }
}
