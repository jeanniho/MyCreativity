import 'package:MyCreativity/database/database.dart';
import 'package:MyCreativity/pages/commentPage.dart';
import 'package:MyCreativity/pages/drawer.dart';
import 'package:MyCreativity/pages/homePage.dart';
import 'package:MyCreativity/pages/uploadPost.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:toast/toast.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
User user = _auth.currentUser;

class MusicDetailPage extends StatefulWidget {
  final post;
  MusicDetailPage({this.post});

  @override
  _MusicDetailPageState createState() => _MusicDetailPageState();
}

class _MusicDetailPageState extends State<MusicDetailPage> {
  bool playable = false;
  bool isPlaying = false;
  AudioPlayer _audioPlayer = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
          FlatButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UploadPost()),
                );
              },
              icon: Icon(
                Icons.file_upload,
                color: Colors.white,
              ),
              label: Text(
                "Upload",
                style: TextStyle(
                  color: Colors.white,
                ),
              )),
        ],
      ),
      drawer: signedInDrawer(),
      body: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.blue[100], Colors.pink[600]]),
        ),
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
            Container(
              width: size.width * .7,
              height: size.height * .6,
              child: Stack(children: <Widget>[
                Image.asset(
                  'assets/img.jpg',
                  fit: BoxFit.fill,
                  width: size.width * .7,
                  height: size.height * .6,
                ),
                Positioned(
                    bottom: 10,
                    left: 32,
                    child: Container(
                      height: 50,
                      width: 200,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          GestureDetector(
                            child: Icon(
                              isPlaying ? Icons.pause : Icons.play_arrow,
                              color: Colors.white,
                            ),
                            onTap: () async {
                              if (isPlaying) {
                                _audioPlayer.pause();
                                setState(() {
                                  isPlaying = false;
                                });
                              } else {
                                int status = await _audioPlayer
                                    .play(widget.post.data()["url"]);
                                if (status == 1) {
                                  setState(() {
                                    isPlaying = true;
                                  });
                                }
                              }
                            },
                          ),
                          GestureDetector(
                            child: Icon(
                              Icons.stop,
                              color: Colors.white,
                            ),
                            onTap: () {
                              if (isPlaying) {
                                _audioPlayer.stop();
                                setState(() {
                                  isPlaying = false;
                                });
                              } else {
                                Toast.show(
                                  "No audio playing",
                                  context,
                                  duration: Toast.LENGTH_SHORT,
                                  gravity: Toast.BOTTOM,
                                  textColor: Colors.grey[400],
                                  backgroundColor: Colors.grey[100],
                                  backgroundRadius: 6.0,
                                );
                              }
                            },
                          )
                        ],
                      ),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(25),
                      ),
                    )),
              ]),
            ),
            Text(
              "${widget.post.data()["caption"]}",
              style: TextStyle(
                color: Colors.deepPurpleAccent,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FlatButton(
                  color: Colors.pink[100],
                  onPressed: () {
                    DatabaseService(uid: user.uid)
                        .delete(widget.post, "music", user);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  },
                  child: Text("Delete"),
                ),
                SizedBox(
                  width: 8,
                ),
                FlatButton(
                  color: Colors.blue[100],
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CommentPage(
                                  post: widget.post,
                                )));
                  },
                  child: Text("Comments"),
                ),
                SizedBox(
                  width: 8,
                ),
                FlatButton(
                  color: Colors.deepPurpleAccent,
                  onPressed: () async {
                    final status = await Permission.storage.request();
                    if (status.isGranted) {
                      final externalDir = await getExternalStorageDirectory();
                      await FlutterDownloader.enqueue(
                        url: '${widget.post.data()["url"]}',
                        savedDir: externalDir.path,
                        fileName: 'post',
                        showNotification: true,
                        openFileFromNotification: true,
                      );
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: Text("Post successfully downloaded"),
                            );
                          });
                    } else {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: Text("permission denied"),
                            );
                          });
                      print('permission denied');
                    }
                  },
                  child: Text("Download",
                      style: TextStyle(
                        color: Colors.white,
                      )),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
