import 'package:MyCreativity/pages/myPost.dart';
import 'package:MyCreativity/pages/posts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:MyCreativity/database/database.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
User user = _auth.currentUser;

class TableLayout extends StatefulWidget {
  @override
  _TableLayoutState createState() => _TableLayoutState();
}

class _TableLayoutState extends State<TableLayout> {
  Widget displayMusic() {
    //create a call to database, get post as a list
    return Container(
      margin: EdgeInsets.only(top: 8),
      child: GridView.builder(
        physics: BouncingScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, crossAxisSpacing: 1 //space between posts
            ),
        itemCount: posts.length,
        itemBuilder: (BuildContext context, int index) {
          Post post = posts[index];
          return MyPost(
            post: post,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: TabBar(
            tabs: <Widget>[
              Tab(
                child: Text("Images"),
              ),
              Tab(
                child: Text("Videos"),
              ),
              Tab(
                child: Text("Music"),
              ),
            ],
            indicatorColor: Colors.white,
          ),
          actions: <Widget>[],
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.lightGreen[500], Colors.pink[400]]),
          ),
          child: TabBarView(children: <Widget>[
            Container(
              child: DatabaseService(uid: user.uid).getImages(context),
            ),
            Container(
              child: DatabaseService(uid: user.uid).getVideos(context),
            ),
            Container(child: DatabaseService(uid: user.uid).getMusic(context)),
          ]),
        ),
      ),
    );
  }
}
