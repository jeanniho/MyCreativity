import 'package:MyCreativity/database/authenticate.dart';
// import 'package:MyCreativity/home.dart';
import 'package:MyCreativity/pages/wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FlutterDownloader.initialize(
      debug: false // optional: set false to disable printing logs to console
      );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final TargetPlatform _platform = TargetPlatform.android;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: Authenticate().user,
      child: MaterialApp(
        theme: ThemeData.light().copyWith(
          platform: _platform ?? Theme.of(context).platform,
        ),
        home: Wrapper(),
      ),
    );
  }
}
