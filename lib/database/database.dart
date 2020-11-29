// import 'dart:html';
import 'dart:io';
import 'dart:math';
import 'package:MyCreativity/pages/musicPost.dart';
import 'package:MyCreativity/pages/myPost.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  //firestore collection reference
  final CollectionReference users =
      FirebaseFirestore.instance.collection("users");
  final CollectionReference images =
      FirebaseFirestore.instance.collection("images");
  final CollectionReference videos =
      FirebaseFirestore.instance.collection("videos");
  final CollectionReference music =
      FirebaseFirestore.instance.collection("music");
  //firebase storage reference
  final StorageReference storageReference = FirebaseStorage().ref();

  Future addUserDetails(String name, String surname, String email) async {
    return await users.doc(uid).set({
      "name": name + " " + surname,
      "email": email,
      "initial": (name[0] + surname[0]).toUpperCase(),
    });
  }

  //return current user initials
  Widget getInitial() {
    return StreamBuilder<DocumentSnapshot>(
      stream: users.doc(uid).snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            body: Text('An Error has occured'),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading...");
        }

        return Text(
          snapshot.data.get('initial'),
        );
      },
    );
  }

  //get user email
  Widget getEmail() {
    return StreamBuilder<DocumentSnapshot>(
      stream: users.doc(uid).snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            body: Text('An Error has occured'),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading...");
        }

        return Text(
          snapshot.data.get('email'),
        );
      },
    );
  }

  //get user name
  Widget getName() {
    return StreamBuilder<DocumentSnapshot>(
      stream: users.doc(uid).snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            body: Text('An Error has occured'),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading...");
        }

        return Text(
          snapshot.data.get('name'),
        );
      },
    );
  }

  //add image to database
  Future<void> uploadImageToFirebase(
      File file, String type, String caption) async {
    dynamic data;
    try {
      final DocumentReference document = users.doc(uid);
      await document.get().then<dynamic>((DocumentSnapshot snapshot) async {
        data = snapshot.data();
      });
      // Make random image name.
      int randomNumber = Random().nextInt(100000);
      if (type.toLowerCase() == "image") {
        String fileLocation = 'images/image$randomNumber.jpg';
        // Upload image to firebase.
        StorageReference storageRef = storageReference.child(fileLocation);
        StorageUploadTask uploadTask = storageRef.putFile(file);
        await uploadTask.onComplete;
        var fileString = await storageRef.getDownloadURL();
        // Upload image to firestore.
        await images.doc().set({
          'name': data["name"],
          'email': data["email"],
          'initial': data["initial"],
          'url': fileString,
          "caption": caption,
        });
        // _addPathToDatabase(imageLocation, type);
      }
      if (type.toLowerCase() == "video") {
        String fileLocation = 'videos/video$randomNumber.jpg';
        // Upload image to firebase.
        StorageReference storageRef = storageReference.child(fileLocation);
        StorageUploadTask uploadTask = storageRef.putFile(file);
        await uploadTask.onComplete;
        var fileString = await storageRef.getDownloadURL();
        await videos.doc().set({
          'name': data["name"],
          'email': data["email"],
          'initial': data["initial"],
          'url': fileString,
          "caption": caption,
        });
        // _addPathToDatabase(imageLocation,type);
      }
      if (type.toLowerCase() == "music") {
        String fileLocation = 'music/audio$randomNumber.jpg';
        StorageReference storageRef = storageReference.child(fileLocation);
        StorageUploadTask uploadTask = storageRef.putFile(file);
        await uploadTask.onComplete;
        var fileString = await storageRef.getDownloadURL();
        // Upload image to firestore.
        await music.doc().set({
          'name': data["name"],
          'email': data["email"],
          'initial': data["initial"],
          'url': fileString,
          "caption": caption,
        });
        // _addPathToDatabase(imageLocation,type);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  //return the images
  Widget getImages(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: images
          .snapshots(), //FirebaseFirestore.instance.collection('ArtPost').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        return Container(
          margin: EdgeInsets.only(top: 8),
          child: GridView.builder(
            physics: BouncingScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, crossAxisSpacing: 1 //space between posts
                ),
            itemCount: snapshot.data.docs.length,
            itemBuilder: (BuildContext context, int index) {
              DocumentSnapshot post = snapshot.data.docs[index];
              return MyPost(
                type: "image",
                post: post,
                postWidget: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.network(
                    post.data()["url"],
                    fit: BoxFit.fill,
                    height: 300,
                    width: 600,
                  ),
                ),
              );
            },
          ),
        ); //_buildList(context, snapshot.data.docs);
      },
    );
  } //return the images

  //return the videos
  Widget getVideos(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: videos
          .snapshots(), //FirebaseFirestore.instance.collection('ArtPost').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        return Container(
          margin: EdgeInsets.only(top: 8),
          child: GridView.builder(
            physics: BouncingScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, crossAxisSpacing: 1 //space between posts
                ),
            itemCount: snapshot.data.docs.length,
            itemBuilder: (BuildContext context, int index) {
              DocumentSnapshot post = snapshot.data.docs[index];
              // print(post.data()["url"]);
              return MyPost(
                post: post,
                type: "video",
              );
            },
          ),
        ); //_buildList(context, snapshot.data.docs);
      },
    );
  }

  Widget getMusic(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: music
          .snapshots(), //FirebaseFirestore.instance.collection('ArtPost').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        return Container(
          margin: EdgeInsets.only(top: 8),
          child: GridView.builder(
            physics: BouncingScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, crossAxisSpacing: 1 //space between posts
                ),
            itemCount: snapshot.data.docs.length,
            itemBuilder: (BuildContext context, int index) {
              DocumentSnapshot post = snapshot.data.docs[index];
              return MusicPost(
                post: post,
              );
            },
          ),
        ); //_buildList(context, snapshot.data.docs);
      },
    );
  }

  //add comments
  Future<void> addComments(String url, String comment) async {
    bool postId = false;
    await images.get().then((docs) => {
          docs.docs.forEach((doc) {
            var docId = doc.id;
            if (doc.data()["url"] == url) {
              final CollectionReference comments =
                  images.doc(docId).collection("comments");
              addComment(docId, comment, comments);
              postId = true;
            }
          })
        });
    if (!postId) {
      await videos.get().then((docs) => {
            docs.docs.forEach((doc) {
              var docId = doc.id;
              if (doc.data()["url"] == url) {
                final CollectionReference comments =
                    images.doc(docId).collection("comments");
                addComment(docId, comment, comments);
                postId = true;
              }
            })
          });
    }
    if (!postId) {
      await music.get().then((docs) => {
            docs.docs.forEach((doc) {
              var docId = doc.id;
              if (doc.data()["url"] == url) {
                final CollectionReference comments =
                    images.doc(docId).collection("comments");
                addComment(docId, comment, comments);
                postId = true;
              }
            })
          });
    }
  }

  //add comment
  Future<void> addComment(
      String docId, String comment, CollectionReference comments) async {
    try {
      var data;
      final DocumentReference document = users.doc(uid);
      await document.get().then<dynamic>((DocumentSnapshot snapshot) async {
        data = snapshot.data();
      });
      await comments.doc().set({
        'name': data["name"],
        'email': data["email"],
        'initial': data["initial"],
        "comment": comment,
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Widget comments(BuildContext context, String url) {
    return FutureBuilder<List<Card>>(
      future: downloadData(url), //get the data/comments
      builder: (BuildContext context, AsyncSnapshot<List<Card>> snapshot) {
        // AsyncSnapshot<Your object type>
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: Text('Please wait its loading...'));
        }
        if (snapshot.hasError)
          return Center(child: Text('Error: ${snapshot.error}'));
        if (snapshot.hasData) {
          return Expanded(
            child: ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, int index) {
                  return snapshot.data[index];
                }),
          );
        } else {
          return Center(
            child: new Text("Still not working"),
          );
        }
      },
    );
  }

  Future<List<Card>> downloadData(String url) async {
    Stream<QuerySnapshot> comment;
    List<Card> posts = [];
    comment = await images.where("url", isEqualTo: url).get().then((value) {
      var temp = value.docs.length > 0 ? value.docs[0].id : null;
      return images.doc(temp).collection("comments").snapshots();
    });
    comment.forEach((element) {
      element.docs.forEach((e) {
        posts.add(Card(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 5,
              ),
              Text(
                "${e.data()["name"]}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 8, bottom: 8),
                    child: CircleAvatar(
                      backgroundColor: Colors.deepPurpleAccent,
                      child: Text(
                        "${e.data()["initial"]}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text("${e.data()["comment"]}"),
                ],
              ),
            ],
          ),
        ));
      });
    });
    return Future.value(posts); // return your response
  }

  delete(dynamic post, String type, User user) async {
    try {
      if (type == "music") {
        await music
            .where("url", isEqualTo: post["url"])
            .get()
            .then<dynamic>((QuerySnapshot snapshot) async {
          var batch = FirebaseFirestore.instance.batch();
          batch.delete(snapshot.docs[0].reference);
          return batch.commit();
        });
      }
      if (type == "image") {
        await images
            .where("url", isEqualTo: post["url"])
            .get()
            .then<dynamic>((QuerySnapshot snapshot) async {
          var batch = FirebaseFirestore.instance.batch();
          batch.delete(snapshot.docs[0].reference);
          return batch.commit();
        });
      }
      if (type == "video") {
        await videos
            .where("url", isEqualTo: post["url"])
            .get()
            .then<dynamic>((QuerySnapshot snapshot) async {
          var batch = FirebaseFirestore.instance.batch();
          batch.delete(snapshot.docs[0].reference);
          return batch.commit();
        });
      }
    } catch (e) {
      print(e);
    }
  }
}
