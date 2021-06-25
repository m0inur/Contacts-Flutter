import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:lottie/lottie.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  double maxWidth = 30;
  final picker = ImagePicker();
  bool isShowingAstronaut = true;
  int counter = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  AppBar appBar() {
    return AppBar(
      elevation: 5.0,
      leadingWidth: 100,
      centerTitle: true,
      leading: TextButton(
        onPressed: () {
          Navigator.pushReplacementNamed(context, "/");
        },
        child: Text(
          "Cancel",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
      title: Text(
        "Login",
        style: TextStyle(
            fontSize: 23,
            letterSpacing: 1.5,
            // fontWeight: FontWeight.bold,
            color: Colors.white),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, "/signup");
          },
          child: Text(
            "Sign Up",
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget inputField(text, myController, type, obscureText) {
    return IntrinsicHeight(
      child: Padding(
        padding: const EdgeInsets.only(left: 50, right: 50),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            text.toUpperCase(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              letterSpacing: 1.3,
              color: Color(0xff7f82bb),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Expanded(
            child: FocusScope(
              child: Focus(
                onFocusChange: (focus) {
                  setState(() {
                    isShowingAstronaut = !focus;
                  });
                },
                child: TextFormField(
                  obscureText: obscureText,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  controller: myController,
                  keyboardType: type,
                  decoration: new InputDecoration(
                    fillColor: Color(0xff1f1f34),
                    filled: true,
                    enabledBorder: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(10),
                      borderSide: new BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(10),
                      borderSide: new BorderSide(color: Colors.transparent),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Future emailLogin(email, password) async {
    try {
      UserCredential user = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

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

    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);

    // print("${email.length} <= ${mail.length}");
    if (!emailValid) {
      return "The E-mail is not valid";
    }

    // Login
    var result = await emailLogin(email, password);
    return result;
  }

  void loginButtonPressed() async {
    if (emailController.text == "" || passwordController.text == "") return;
    var result = await loginEmail();

    if (result is String) {
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
        CustomSnackBar.success(
          message: "You have logged in successfully",
        ),
        displayDuration: Duration(seconds: 1),
      );

      Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          bottomOpacity: 0.0,
          elevation: 0.0,
          toolbarHeight: 0,
        ),
        backgroundColor: Color(0xff282849),
        body: Container(
          child: Form(
            key: _formKey,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                ListView(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    children: <Widget>[
                      Visibility(
                          visible: isShowingAstronaut,
                          child: Lottie.asset('assets/astronaut.json',
                              height: 370)),
                      Visibility(
                        visible: !isShowingAstronaut,
                        child: SizedBox(
                          height: 70,
                        ),
                      ),

                      // E-mail field
                      inputField("EMail", emailController,
                          TextInputType.emailAddress, false),
                      SizedBox(
                        height: 6,
                      ),
                      // Password field
                      inputField("Password", passwordController,
                          TextInputType.visiblePassword, true),
                      SizedBox(
                        height: 20,
                      ),

                      Padding(
                        padding: EdgeInsets.only(left: 110, right: 110),
                        child: ElevatedButton(
                          onPressed: () {
                            loginButtonPressed();
                        },
                          child: Text(
                            'LOGIN',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              letterSpacing: 1.5,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green,
                            fixedSize: Size(20, 45),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(25), // <-- Radius
                            ),
                            elevation: 10,
                          ),
                        ),
                      ),

                      // SizedBox(height: 15,),
                      // Center(child: Text("Don't have an account?")),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account?",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, "/signup");
                            },
                            child: Text(
                              " Sign Up",
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xff7f82bb),
                              ),
                            ),
                          )
                        ],
                      )
                    ]),
              ],
            ),
          ),
        ));
  }
}
