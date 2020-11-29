import 'dart:io';
import 'dart:math';

import 'package:MyCreativity/pages/drawer.dart';
import 'package:MyCreativity/pages/homePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
User currUser = _auth.currentUser;

class UserDetails extends StatefulWidget {
  @override
  _UserDetailsState createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  final CollectionReference users =
      FirebaseFirestore.instance.collection("users");
  final CollectionReference profile =
      FirebaseFirestore.instance.collection("profile");
  final StorageReference storageReference = FirebaseStorage().ref();
  //add profile image to database
  Future<void> uploadImageToFirebase(File file) async {
    try {
      AsyncSnapshot<DocumentSnapshot> user = users.doc(currUser.uid).snapshots()
          as AsyncSnapshot<DocumentSnapshot>;
      String name = await user.data.get('name');
      String email = await user.data.get('email');
      String initial = await user.data.get('initial');
      // Make random image name.
      int randomNumber = Random().nextInt(100000);
      String fileLocation = 'profile/image$randomNumber.jpg';
      // Upload image to firebase.
      StorageReference storageRef = storageReference.child(fileLocation);
      StorageUploadTask uploadTask = storageRef.putFile(file);
      await uploadTask.onComplete;
      var fileString = await storageRef.getDownloadURL();
      // Upload image to firestore.
      await profile.doc(currUser.uid).set({
        'name': name,
        'email': email,
        'initial': initial,
        'url': fileString,
      });
    } catch (e) {
      print(e);
    }
  }

  // Future<void> getDetails() async {
  //   AsyncSnapshot<DocumentSnapshot> user = users.doc(currUser.uid).snapshots()
  //       as AsyncSnapshot<DocumentSnapshot>;
  //   String name = await user.data.get('name');
  //   String email = await user.data.get('email');
  //   String initial = await user.data.get('initial');
  //   return Column(
  //     children: <Widget>[
  //       ClipOval(),
  //       Text("Name:   $name"),
  //       Text("Email address:    $email"),
  //       Center(
  //         child: FlatButton(onPressed: (){}, child: Text("Save")),
  //       ),
  //     ],
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: FlatButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
          child: Text(
            "MyCreativity",
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ),
        centerTitle: true,
        actions: <Widget>[
          CircleAvatar(
            backgroundColor: Colors.pink,
            child: Text(
              "JD",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      drawer: signedInDrawer(),
      body: Container(
        child: Center(
          child: Container(),
        ),
      ),
    );
  }
}
