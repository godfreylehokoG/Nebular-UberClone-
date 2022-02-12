import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:rider_app/AllScreens/registrationScreen.dart';
import 'package:rider_app/Allwidgets/progressDialog.dart';
import 'package:snap/snap.dart';

import '../main.dart';
import 'mainscreen.dart';

class loginScreen extends StatelessWidget {

  static const String idScreen = "logins";
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: 45.0,), //Login Screen logo
              Image(
                image: AssetImage("images/logo.png"),
                width: 390.0,
                height: 350.0,
                alignment: Alignment.center,
              ),
              SizedBox(height: 1.0,), //login Screen text
              Text(
                "Login as a Rider",
                style: TextStyle(fontSize: 24.0, fontFamily: "Brand Bold"),
                textAlign: TextAlign.center,
              ),

              Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [

                    SizedBox(height: 1.0,), //Email field
                    TextField(
                      controller: emailTextEditingController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: TextStyle(
                          fontSize: 14.0,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.0  ,
                        ),
                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),

                    SizedBox(height: 1.0,), //password field
                    TextField(
                      controller: passwordTextEditingController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Password",
                        labelStyle: TextStyle(
                          fontSize: 14.0,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.0  ,
                        ),
                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),

                    SizedBox(height: 20.0,), //Login Button
                    ElevatedButton(
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                      ),

                      onPressed: () {
                        if (!emailTextEditingController.text.contains("@")) {
                          displayToastMessage("Invalid Email.", context);
                        }
                        else if (passwordTextEditingController.text.isEmpty) {
                          displayToastMessage("Please enter password", context);
                        }
                        else {
                          loginAndAuthenticateUser(context);
                        }
                      },
                      child: const Text("Login"),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: ()
                {
                  Navigator.pushNamedAndRemoveUntil(context, RegistrationScreen.idScreen, (route) => false);
                },
                  child: Text(
                    "Not a member yet? Join here"
                  ),
              )
            ],
          ),
        ),
      ),

    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void loginAndAuthenticateUser(BuildContext context) async {

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return ProgressDialog(message: "Signing-in Please wait...",);
        }
    );

    final User firebaseUser = (await _firebaseAuth
        .signInWithEmailAndPassword(
        email: emailTextEditingController.text,
        password: passwordTextEditingController.text
    ).catchError((errMsg) {
      Navigator.pop(context);
      displayToastMessage("Error: " + errMsg.toString(), context);
    })).user;

    if(firebaseUser != null)
    { //user created successful
      userRef.child(firebaseUser.uid).once().then((value) => (DataSnapshot snap){
        if(snap.value != null)
        {
          Navigator.pushNamedAndRemoveUntil(context, MainScreen.idScreen, (route) => false);
          displayToastMessage("You are logged in", context);
        }
        else {
          //return error
          Navigator.pop(context);
          _firebaseAuth.signOut();
          displayToastMessage("Account does not exist. Please create account", context);
        }
      });

    }
    else {
      //return error
      Navigator.pop(context);
      _firebaseAuth.signOut();
      displayToastMessage("Error, not signed in.", context);
    }
  }
}
