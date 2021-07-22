import 'package:MyCreativity/pages/detailPage.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class MyPost extends StatefulWidget {
  final post;
  final postWidget;
  final type;

  MyPost({this.post, this.postWidget, this.type});

  @override
  _MyPostState createState() => _MyPostState();
}

class _MyPostState extends State<MyPost> {
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    if (widget.type == "video") {
      _controller = VideoPlayerController.network(
        widget.post.data()["url"],
      );
      // Initialize the controller and store the Future for later use.
      _initializeVideoPlayerFuture = _controller.initialize();

      // Use the controller to loop the video.
      _controller.setLooping(true);

      super.initState();
    }
  }

  @override
  void dispose() {
    if (widget.type == "video") {
      _controller.dispose();
      super.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DetailPage(
                  post: widget.post,
                  postWidget: widget.postWidget,
                  type: widget.type)),
        );
      },
      child: Card(
        child: Stack(
          children: [
            widget.postWidget ??
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Container(
                    height: 300,
                    width: 600,
                    child: FutureBuilder(
                      future: _initializeVideoPlayerFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return AspectRatio(
                            aspectRatio: _controller.value.aspectRatio,
                            child: VideoPlayer(_controller),
                          );
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      },
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
