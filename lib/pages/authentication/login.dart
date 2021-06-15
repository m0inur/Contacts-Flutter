import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  double maxWidth = 30;
  final picker = ImagePicker();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailController.dispose();
    passwordController.dispose();
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
      actions: [
        TextButton(
          onPressed: () {
            print("Sign up");
            Navigator.pushReplacementNamed(context, "/signup");
          },
          child: Text(
            "Sign Up",
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget inputField(
      text, textStyle, myController, nameAndDividerGap, type, obscureText) {
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
            obscureText: obscureText,
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

            validator: (value) {
              print(value);
              if(type == TextInputType.emailAddress) {
                // Validate email
                print("validate email");
              }
            },
          ),
        ),
      ]),
    );
  }

  Future emailLogin(email, password) async {
    try {
      UserCredential user = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: email, password: password);

      return user;
    } catch (e) {
      print("Error: ");
      print(e);
      return "Could not login successfully";
    }

    return null;
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

  Future loginEmail() async {
    var email = emailController.text;
    var password = passwordController.text;

    String mail = "@gmail.com";

    // print("${email.length} <= ${mail.length}");
    if(email.length > mail.length) {
      String subString = email.substring(email.length - mail.length, email.length);
      print(subString == mail);
      if(subString != mail) {
        return "The E-mail is not valid";
      }
    } else {
      return "The E-mail is not valid";
    }

    // Login
    var result = await emailLogin(email, password);
    return result;
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = TextStyle(
      color: Colors.white70,
      fontSize: 18,
    );

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: appBar(),
        body: Container(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                SizedBox(height: 30),
                ListView(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    children: <Widget>[
                      Center(
                        child: Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 30,
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 50,
                      ),

                      // E-mail field
                      inputField("E-Mail", textStyle, emailController, 50.0,
                          TextInputType.emailAddress, false),
                      SizedBox(
                        height: 20,
                      ),

                      // Password field
                      inputField("Password", textStyle, passwordController, 20.0,
                          TextInputType.visiblePassword, true),
                      SizedBox(
                        height: 50,
                      ),

                      TextButton(
                        onPressed: () async {
                          if(emailController.text == "" || passwordController.text == "") return;
                          var result = await loginEmail();

                          if(result is String) {
                            showTopSnackBar(
                              context,
                              CustomSnackBar.error(
                                message: result,
                              ),
                              displayDuration: Duration(seconds: 1),
                            );
                          } else {
                            showTopSnackBar(
                              context,
                              CustomSnackBar.info(
                                message:
                                "You have logged in successfully",
                              ),
                              displayDuration: Duration(seconds: 1),
                            );

                            Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false);
                          }
                        },
                        child: CircleAvatar(
                          backgroundImage: AssetImage(
                            "assets/transparent-circle.png",
                          ),
                          child: Icon(
                              Icons.arrow_right_alt_sharp,
                            size: 30,
                            color: Colors.white,
                          ),
                          backgroundColor: Colors.deepPurpleAccent,
                          radius: 30,
                        ),
                      )
                    ]
                ),
                SizedBox(
                  height: 75,
                )
              ],
            ),
          ),
        )
    );
  }
}
