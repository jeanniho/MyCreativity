import 'dart:io';

import 'package:MyCreativity/pages/drawer.dart';
import 'package:MyCreativity/pages/homePage.dart';
import 'package:MyCreativity/pages/sharedVariables.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:MyCreativity/database/database.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
User user = _auth.currentUser;
Widget initial = DatabaseService(uid: user.uid).getInitial();

class UploadPost extends StatefulWidget {
  @override
  _UploadPostState createState() => _UploadPostState();
}

class _UploadPostState extends State<UploadPost> {
  final _formKey = GlobalKey<FormState>();
  final _caption = TextEditingController();

  String _category = "Image";
  String caption = "";
  ImagePicker _imagePicker = ImagePicker();
  dynamic _selectedFile;
  final List<String> categories = ["Image", "Video", "Music"];

  Widget selectedPost() {
    if (_category.toLowerCase() == "image") {
      return ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Image(
          image: AssetImage("assets/test1.jpg"),
          fit: BoxFit.fill,
          height: 300,
          width: 600,
        ),
      );
    }
    if (_category.toLowerCase() == "video") {
      return ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Image(
          image: AssetImage("assets/test1.jpg"),
          fit: BoxFit.fill,
          height: 300,
          width: 600,
        ),
      );
    } else {
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.lightGreen[400], Colors.deepPurpleAccent[400]]),
        ),
        height: MediaQuery.of(context).size.height / 2,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Upload an artwork",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 8,
              ),
              FlatButton.icon(
                color: Colors.blue,
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: ((builder) => bottomSheet()),
                  );
                },
                icon: Icon(
                  Icons.add_to_photos,
                  color: Colors.white,
                ),
                label: Text(
                  "Select file",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget bottomSheet() {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: <Widget>[
          Text(
            "Select file",
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton.icon(
                onPressed: () {
                  if (_category.toLowerCase() == "image") {
                    getImage("image", "camera");
                  }
                  if (_category.toLowerCase() == "video") {
                    getImage("video", "camera");
                  }
                  if (_category.toLowerCase() == "music") {
                    getImage("music", "dnm");
                  }
                },
                icon: Icon(
                  Icons.camera,
                ),
                label: Text(
                  "Camera",
                ),
              ),
              FlatButton.icon(
                onPressed: () {
                  if (_category.toLowerCase() == "image") {
                    getImage("image", "gallery");
                  }
                  if (_category.toLowerCase() == "videos") {
                    getImage("video", "gallery");
                  } else {
                    getImage("music", "dnm");
                  }
                },
                icon: Icon(
                  Icons.folder,
                  color: Colors.grey,
                ),
                label: Text(
                  "Files",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void getImage(String categori, String option) async {
    var pickedFile;
    if (categori.toLowerCase() == "image") {
      if (option.toLowerCase() == "camera") {
        pickedFile = await _imagePicker.getImage(source: ImageSource.camera);
      } else {
        pickedFile = await _imagePicker.getImage(source: ImageSource.gallery);
      }
    }
    if (categori.toLowerCase() == "video") {
      if (option.toLowerCase() == "camera") {
        pickedFile = await _imagePicker.getVideo(source: ImageSource.camera);
      } else {
        try {
          File _result = await FilePicker.getFile(
              type: FileType.video, allowedExtensions: ['mp4']);
          if (_result != null) {
            pickedFile = _result;
          } else {
            print("File not selected");
          }
        } catch (e) {
          print(e);
        }
      }
    }
    if (categori.toLowerCase() == "music") {
      // pickedFile = await AudioPicker.pickAudio();
      try {
        File _result = await FilePicker.getFile(type: FileType.audio);
        if (_result != null) {
          pickedFile = _result;
        } else {
          print("File not selected");
        }
      } catch (e) {
        print(e);
      }
    }
    setState(() {
      _selectedFile = pickedFile;
    });
    Navigator.of(context).pop();
  }

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
            child: initial,
          ),
        ],
      ),
      drawer: signedInDrawer(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.pink[400], Colors.lightGreen[400]]),
        ),
        padding: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            Container(
              //margin: EdgeInsets.all(8),
              child: DropdownButtonFormField(
                value: _category,
                decoration: textInputDecoration,
                items: categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(
                      "$category",
                    ),
                    // onTap: () {
                    //   print(_category);
                    //   //add function here to collect posts from a selected category
                    // },
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() {
                    _category = val;
                    //add function here to collect posts from a selected category
                  });
                },
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.lightGreen[400],
                      Colors.deepPurpleAccent[400]
                    ]),
              ),
              height: MediaQuery.of(context).size.height / 2,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Upload an artwork",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    FlatButton.icon(
                      color: Colors.blue,
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: ((builder) => bottomSheet()),
                        );
                      },
                      icon: Icon(
                        Icons.add_to_photos,
                        color: Colors.white,
                      ),
                      label: Text(
                        "Select file",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // selectedPost(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: FlatButton(
                    color: Colors.lightGreen[400],
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: ((builder) => Container(
                              height: 100,
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20),
                              child: Column(
                                children: <Widget>[
                                  Form(
                                    key: _formKey,
                                    child: Expanded(
                                      child: TextFormField(
                                        decoration:
                                            textInputDecoration.copyWith(
                                                labelText: "Add a caption"),
                                        controller: _caption,
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
                                  ),
                                  Center(
                                    child: FlatButton(
                                      color: Colors.blue,
                                      onPressed: () {
                                        if (_formKey.currentState.validate()) {
                                          setState(() {
                                            caption = _caption.text;
                                          });
                                          Navigator.of(context).pop();
                                        }
                                      },
                                      child: Text(
                                        "Done",
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                      );
                    },
                    child: Text("Edit",
                        style: TextStyle(
                          color: Colors.white,
                        )),
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                FlatButton(
                  color: Colors.pink[400],
                  onPressed: () {
                    setState(() {
                      _selectedFile = null;
                      caption = "";
                    });
                  },
                  child: Text("Delete"),
                ),
                SizedBox(
                  width: 8,
                ),
                FlatButton(
                  color: Colors.deepPurpleAccent,
                  onPressed: () async {
                    if (_selectedFile != null) {
                      await DatabaseService(uid: user.uid)
                          .uploadImageToFirebase(
                              File(_selectedFile.path), _category, caption);
                      setState(() {
                        caption = "";
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                      );
                    } else {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: Text("Please select a post"),
                            );
                          });
                    }
                  },
                  child: Text("Post"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _caption.dispose();
    super.dispose();
  }
}
