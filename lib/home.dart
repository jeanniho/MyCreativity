// import 'dart:io';

// import 'package:audio_picker/audio_picker.dart';
// import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Butterfly Video'),
      ),
      body: Container(
        margin: EdgeInsets.all(8),
        child: Column(
          children: <Widget>[
            FlatButton(
              onPressed: () async {
                // FilePickerResult result = await FilePicker.platform.pickFiles();

                // if(result != null) {
                //   File file = File(result.files.single.path);
                //   print(file);
                // } else {
                  // User canceled the picker
                // }
                // var pickedFile = await AudioPicker.pickAudio();
                // print(pickedFile);
              },
              child: Text('pick audio'),
            ),
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
