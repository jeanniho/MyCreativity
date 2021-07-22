import 'package:MyCreativity/database/database.dart';
import 'package:MyCreativity/pages/commentPage.dart';
import 'package:MyCreativity/pages/drawer.dart';
import 'package:MyCreativity/pages/homePage.dart';
import 'package:MyCreativity/pages/uploadPost.dart';
import 'package:chewie/chewie.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
User user = _auth.currentUser;

class DetailPage extends StatefulWidget {
  final post;
  final postWidget;
  final type;
  DetailPage({this.post, this.postWidget, this.type});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  VideoPlayerController videoPlayerController;
  ChewieController chewieController;
  @override
  void initState() {
    videoPlayerController =
        VideoPlayerController.network('${widget.post.data()["url"]}');
    super.initState();
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      aspectRatio: 3 / 2,
      autoPlay: true,
      looping: true,
      showControls: true,
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Text('An error occured'),
        );
      },
      materialProgressColors: ChewieProgressColors(
        playedColor: Colors.red,
        handleColor: Colors.blue,
        backgroundColor: Colors.grey,
        bufferedColor: Colors.lightGreen,
      ),
      placeholder: Container(
        color: Colors.grey,
      ),
      autoInitialize: true,
    );
    videoPlayerController.addListener(() {
      if (videoPlayerController.value.position ==
          videoPlayerController.value.duration) {
        videoPlayerController.seekTo(Duration(seconds: 0));
        print('video Ended');
      }
    });
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
              colors: [Colors.blue[100], Colors.pink[600]]
              ),
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
            widget.postWidget ??
                Chewie(
                  controller: chewieController,
                ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FlatButton(
                  color: Colors.pink[100],
                  onPressed: () {
                    DatabaseService(uid: user.uid)
                        .delete(widget.post, widget.type, user);
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
