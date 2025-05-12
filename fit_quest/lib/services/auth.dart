import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_quest/model/user.dart';
import 'package:fit_quest/services/database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  FitUser? _userFromFirebaseUser(User? user) {
    return user != null ? FitUser(uid: user.uid) : null;
  }

  Stream<FitUser?> get user {
    return _auth.authStateChanges().map(
      (User? user) => _userFromFirebaseUser(user),
    );
  }

  Future signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future register(String email, String password, String name, int age, double weight, double height) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      await DatabaseService(
        uid: user!.uid,
      ).updateUserData(name, age, weight, height);
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
