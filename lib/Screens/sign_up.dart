import 'package:flutter/material.dart';
import 'package:flutter_chat_app/Screens/chatroomscreen.dart';
import 'package:flutter_chat_app/Services/auth.dart';
import 'package:flutter_chat_app/Services/database.dart';
import 'package:flutter_chat_app/widgets/theme.dart';
import 'package:flutter_chat_app/widgets/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Signup extends StatefulWidget {
  final Function toggleView;
  Signup(this.toggleView);
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  AuthService authService = AuthService();
  DatabaseMethods _databaseMethods = DatabaseMethods();
  TextEditingController emailEditingController = new TextEditingController();
  TextEditingController passwordEditingController = new TextEditingController();
  TextEditingController usernameEditingController = new TextEditingController();

  singUp() async {

    if(formKey.currentState.validate()){
      await authService.signUpWithEmailAndPassword(
          emailEditingController.text,
          passwordEditingController.text).then((val) {
           // print("fdfdfsdfd ${val}");
            if(val == null){
              Fluttertoast.showToast(
                  msg: "The email address is already in use by another account",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0
              );
            }
            else{
              setState(() {
                isLoading = true;
              });
              Map<String , String> userInfoMap= {
                'name' : usernameEditingController.text,
                'email' : emailEditingController.text
              };
              _databaseMethods.addUserInfo(userInfoMap);
              Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) => ChatRoom()
              ));
            }

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: isLoading ?Container(
        child: Center(child: CircularProgressIndicator()),
      ) :SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(10, 150, 10, 10),
          child: Column(
            children: [
              Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      validator: (val){
                        return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val) ?
                        null : "Enter correct email";
                      },
                      style: simpleTextStyle(),
                      decoration: textFieldInputDecoration("Email"),
                      controller: emailEditingController,
                    ),
                    TextFormField(

                      validator: (val){
                        return val.isEmpty || val.length < 3 ? "Enter Username 3+ characters" : null;
                      },
                      style: simpleTextStyle(),
                      decoration: textFieldInputDecoration("User Name"),
                      controller: usernameEditingController,
                    ),
                    TextFormField(
                      obscureText: true,
                      validator:  (val){
                        return val.length < 6 ? "Enter Password 6+ characters" : null;
                      },
                      style: simpleTextStyle(),
                      decoration: textFieldInputDecoration("password"),
                      controller: passwordEditingController,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 26,
              ),

              GestureDetector(
                onTap: () {
                  singUp();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xff007EF4),
                          const Color(0xff2A75BC)
                        ],
                      )),
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    "Sign Up",
                    style: biggerTextStyle(),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white),
                width: MediaQuery.of(context).size.width,
                child: Text(
                  "Sign Up with Google",
                  style:
                  TextStyle(fontSize: 17, color: CustomTheme.textColor),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have account? ",
                    style: simpleTextStyle(),
                  ),
                  GestureDetector(
                    onTap: (){
                      widget.toggleView();
                    },
                    child: Text(
                      "Sign In now",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          decoration: TextDecoration.underline),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 50,
              )
            ],
          ),
        ),
      ),
    );
  }
}
