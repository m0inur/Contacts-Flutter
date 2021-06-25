import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:lottie/lottie.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  double maxWidth = 30;
  final picker = ImagePicker();
  bool isShowingAstronaut = true;
  int counter = 0;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();
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

  // Sign up
  Future emailSignup(email, password) async {
    bool emailValid = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);

    if (!emailValid) {
      return "The E-mail is not valid";
    }
    try {
      UserCredential user = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
          email: email, password: password);

      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      }
    } catch (e) {
      print("Error: ");
      print(e);
    }

    return null;
  }

  void loginButtonPressed() async {
    var result = await emailSignup(emailController.text, passwordController.text);

    if(result is String) {
      showTopSnackBar(
        context,
        CustomSnackBar.error(
          message:
          result,
        ),
        displayDuration: Duration(seconds: 1),
      );
    } else {
      showTopSnackBar(
        context,
        CustomSnackBar.info(
          message:
          "You have signed up in successfully",
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ListView(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    children: <Widget>[

                      Visibility(
                          visible: isShowingAstronaut,
                          child: Lottie.asset('assets/astronut-signup.json', height: 270)
                      ),
                      SizedBox(height: 10,),
                      Visibility(
                        visible: !isShowingAstronaut,
                        child: SizedBox(
                          height: 20,
                        ),
                      ),
                      // SizedBox(height: 100,),

                      inputField("username", usernameController,
                          TextInputType.emailAddress, false),
                      SizedBox(
                        height: 6,
                      ),
                      inputField("email", emailController,
                          TextInputType.emailAddress, false),
                      SizedBox(
                        height: 6,
                      ),
                      // Password field
                      inputField("password", passwordController,
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
                            'REGISTER',
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
                            "Already have an account?",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, "/login");
                            },
                            child: Text(
                              " Login",
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xff7f82bb),
                              ),
                            ),
                          )
                        ],
                      ),
                    ]),
              ],
            ),
          ),
        ));
  }
}
