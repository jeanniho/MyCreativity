import 'package:MyCreativity/database/authenticate.dart';
import 'package:MyCreativity/database/database.dart';
import 'package:MyCreativity/pages/homePage.dart';
import 'package:MyCreativity/pages/signIn.dart';
import 'package:MyCreativity/pages/signUp.dart';
import 'package:MyCreativity/pages/uploadPost.dart';
import 'package:MyCreativity/pages/userDetails.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final Authenticate authenticate = Authenticate();
final FirebaseAuth _auth = FirebaseAuth.instance;
User user = _auth.currentUser;
Widget initial = DatabaseService(uid: user.uid).getInitial();
Widget email = DatabaseService(uid: user.uid).getEmail();
Widget name = DatabaseService(uid: user.uid).getName();

class signedInDrawer extends StatefulWidget {
  signedInDrawer({Key key}) : super(key: key);

  @override
  _signedInDrawerState createState() => _signedInDrawerState();
}

class _signedInDrawerState extends State<signedInDrawer> {

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      child: ListView(children: [
        UserAccountsDrawerHeader(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft, end: Alignment.bottomRight,
                //stops: [0.1,0.4]
                colors: [Colors.pink[400], Colors.lightGreen[400]]),
          ),
          accountEmail: email,
          accountName: name,
          currentAccountPicture: GestureDetector(
            child: CircleAvatar(
              backgroundColor: Colors.lightGreen[400],
              child: Icon(Icons.person),
            ),
          ),
        ),
        InkWell(
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            },
            child:
                ListTile(leading: Icon(Icons.image), title: Text('Pictures'))),
        InkWell(
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
          child: ListTile(
              leading: Icon(Icons.local_movies), title: Text('Videos')),
        ),
        InkWell(
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
          child:
              ListTile(leading: Icon(Icons.music_video), title: Text('Music')),
        ),
        InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UploadPost()),
              );
            },
            child: ListTile(
              leading: Icon(Icons.file_upload),
              title: Text('Upload artwork'),
            )),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UserDetails()),
            );
          },
          child: ListTile(
            leading: Icon(Icons.person_outline),
            title: Text('My account'),
          ),
        ),
        Divider(
          thickness: 2,
          endIndent: 8,
          indent: 8,
          color: Colors.lightGreen[400],
        ),
        InkWell(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomePage()));
          },
          child: ListTile(leading: Icon(Icons.help), title: Text('About')),
        ),
        InkWell(
          onTap: () {
            Scaffold.of(context).showSnackBar(
              SnackBar(content: Text("You can see your settings here!")),
            );
          },
          child: ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
          ),
        ),
        InkWell(
          onTap: () async {
            await authenticate.signOut();
          },
          child: ListTile(
              leading: Icon(Icons.power_settings_new), title: Text("Logout")),
        ),
      ]),
    );
  }
}

class signedOutDrawer extends StatefulWidget {
  signedOutDrawer({Key key}) : super(key: key);

  @override
  _signedOutDrawerState createState() => _signedOutDrawerState();
}

class _signedOutDrawerState extends State<signedOutDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      child: ListView(children: [
        UserAccountsDrawerHeader(
          accountEmail: Text("Anonymous"),
          accountName: Text("Anonymous"),
          currentAccountPicture:
              GestureDetector(child: CircleAvatar(child: Icon(Icons.person))),
        ),
        InkWell(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomePage()));
          },
          child: ListTile(leading: Icon(Icons.help), title: Text('About')),
        ),
        InkWell(
          onTap: () {
            Scaffold.of(context).showSnackBar(
              SnackBar(content: Text("You Must Be Signed In To Use!")),
            ); //Navigator.pushNamed(context, '/');
          },
          child: ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignUp()),
            );
          },
          child: ListTile(
            leading: Icon(Icons.person_add),
            title: Text("Sign up"),
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignIn()),
            );
          },
          child: ListTile(
            leading: Icon(Icons.lock_open),
            title: Text("Sign in"),
          ),
        ),
      ]),
    );
  }
}
