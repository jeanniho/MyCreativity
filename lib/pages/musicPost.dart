import 'package:MyCreativity/pages/musicDetail.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class MusicPost extends StatefulWidget {
  final post;

  MusicPost({this.post});

  @override
  _MusicPostState createState() => _MusicPostState();
}

class _MusicPostState extends State<MusicPost> {
  bool playable = false;
  bool isPlaying = false;
  AudioPlayer _audioPlayer = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _audioPlayer.stop();
        setState(() {
          isPlaying = false;
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MusicDetailPage(
              post: widget.post,
            ),
          ),
        );
      },
      child: Card(
        child: Stack(
          children: [
            Container(
              height: 210,
              width: 210,
              child: Image.asset(
                'assets/img.jpg',
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              bottom: 55,
              left: 5,
              child: Container(
                height: 25,
                width: 100,
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
              ),
            ),
            Positioned(
              bottom: 0,
              child: Opacity(
                opacity: .65,
                child: Container(
                    height: 50,
                    width: 210,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(4),
                          bottomRight: Radius.circular(4)),
                      color: Colors.black,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5, top: 5),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.post.data()["name"],
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                            SizedBox(height: 5),
                            Text(widget.post.data()["email"],
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          ]),
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
