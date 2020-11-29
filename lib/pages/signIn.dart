import 'package:MyCreativity/database/authenticate.dart';
import 'package:MyCreativity/pages/drawer.dart';
import 'package:MyCreativity/pages/homePage.dart';
import 'package:MyCreativity/pages/sharedVariables.dart';
import 'package:MyCreativity/pages/signUp.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  String errorMessage = "";
  final Authenticate _auth = Authenticate();
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.deepPurpleAccent,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        elevation: 0.0,
        title: Text("MyCreativity"),
        centerTitle: true,
        actions: <Widget>[
          CircleAvatar(
            child: Icon(
              Icons.all_inclusive
            ),
          ),
        ],
      ),
      drawer: signedOutDrawer(),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
        child: ListView(
          children: <Widget>[
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: textInputDecoration.copyWith(labelText: "Email address"),
                    validator: (val) {
                      if (val.isEmpty || !val.contains("@")) {
                        return "Please provide a valid email address";
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  TextFormField(
                    controller: _password,
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    decoration: textInputDecoration.copyWith(labelText: "Password"),
                    validator: (val) {
                      if (val.isEmpty) {
                        return "Please provide a valid email address";
                      }
                      if (val.length < 6) {
                        return "Password must be at least 6 characters long";
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  FlatButton(
                    color: Colors.white,
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        dynamic user =
                            await _auth.signInWithEmailAndPassword(
                                _email.text,
                                _password.text);
                        if (user == null) {
                          setState(() {
                            errorMessage = "Unable to sign in";
                          });
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => HomePage())
                          );
                        }
                      }
                    },
                    child: Text(
                      "Sign in",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  //SizedBox(height: 5.0,),
                  Center(
                    child: Text(
                      errorMessage,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Don't have an account?",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      FlatButton(
                        onPressed: () {
                          Navigator.push(
                            context, 
                            MaterialPageRoute(builder: (context)=>SignUp()),
                          );
                        },
                        child: Text(
                          "Sign up",
                          style: TextStyle(
                            color: Colors.yellow,
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }
}
