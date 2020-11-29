import 'package:MyCreativity/pages/homePage.dart';
import 'package:MyCreativity/pages/signIn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    //return home or sign up depending on auth status
    if (user == null) {
      return SignIn();
    } else {
      return HomePage();
    }
  }
}