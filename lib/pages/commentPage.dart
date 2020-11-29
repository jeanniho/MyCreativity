import 'package:MyCreativity/database/database.dart';
import 'package:MyCreativity/pages/drawer.dart';
import 'package:MyCreativity/pages/homePage.dart';
import 'package:MyCreativity/pages/sharedVariables.dart';
import 'package:MyCreativity/pages/uploadPost.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
User user = _auth.currentUser;

class CommentPage extends StatefulWidget {
  final post;
  CommentPage({this.post});

  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  DatabaseService comments = DatabaseService(uid: user.uid);
  final _formKey = GlobalKey<FormState>();
  final _comment = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
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
          FlatButton.icon(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => UploadPost()),);
            },
            icon: Icon(Icons.file_upload,color: Colors.white,),
            label: Text("Upload",
              style: TextStyle(
                color: Colors.white,
              ),
            )
          ),
        ],
      ),
      drawer: signedInDrawer(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.teal[200], Colors.orange[300]]),
        ),
        padding: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            Column(
              children: <Widget>[
                Text("${widget.post.data()["name"]}"),
                Text("${widget.post.data()["email"]}"),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.network(
                widget.post.data()["url"],
                fit: BoxFit.fill,
                height: 200,
                width: 400,
              ),
            ),
            SizedBox(
              height: 8,
            ),
            comments.comments(context, widget.post.data()["url"]),
            
            SizedBox(
              height: 8,
            ),
            Expanded(
              child: Form(
                key: _formKey,
                child: Row(
                  children: <Widget>[
                    CircleAvatar(
                      backgroundColor: Colors.pink,
                      child: Text(
                        "JD",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: TextFormField(
                        decoration: textInputDecoration.copyWith(
                            labelText: "Leave a comment"),
                        controller: _comment,
                        keyboardType: TextInputType.text,
                        validator: (val) {
                          if (val.isEmpty) {
                            return "You can't submit an empty string";
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    FlatButton(
                      color: Colors.red,
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          print(_comment.text);
                          DatabaseService(uid: user.uid).addComments(
                              widget.post.data()["url"], _comment.text);
                          _comment.clear();
                          //add this comment onto the other comments for this artwork
                        }
                      },
                      child: Text(
                        "post",
                      ),
                      // shape: BorderRadius.circular(radius),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _comment.dispose();
    super.dispose();
  }
}
