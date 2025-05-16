import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_quest/model/user.dart';
import 'package:fit_quest/services/database.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  FitUser? userToFitUser(User? user) {
    return user != null ? FitUser(uid: user.uid) : null;
  }

  Stream<FitUser?> get user {
    return _auth.authStateChanges().map((User? user) => userToFitUser(user));
  }

  Future signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      return userToFitUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future register(
    String email,
    String password,
    String name,
    int age,
    double weight,
    double height,
  ) async {
    UserCredential result = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    User? user = result.user;
    UserData userData = UserData(
      uid: user!.uid,
      name: name,
      age: age,
      weight: weight,
      height: height,
    );
    await DatabaseService(uid: user.uid).setUserData(userData);
    return userToFitUser(user);
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
