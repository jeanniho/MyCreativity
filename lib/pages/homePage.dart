import 'package:MyCreativity/pages/drawer.dart';
import 'package:MyCreativity/pages/tableLayout.dart';
import 'package:MyCreativity/pages/uploadPost.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
      body: TableLayout(),
    );
  }
}
