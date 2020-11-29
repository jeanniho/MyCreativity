import 'package:MyCreativity/database/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Authenticate {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //track auth state change
  Stream<User> get user {
    return _auth.authStateChanges();
  }

  //sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      final UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      final User user = result.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //register with email and password
  Future signUpWithEmailAndPassword(String name, String surname,
      String email, String password) async {
    try {
      final UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      final User user = result.user;
      await DatabaseService(uid: user.uid).addUserDetails(name, surname, user.email);
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //log out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}