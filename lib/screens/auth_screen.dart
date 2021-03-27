import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../widgets/auth/auth_form.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLoading = false;
  void _submitAuthForm(String email, String password, String userName,
      bool isLogin, BuildContext ctx) async {
    UserCredential _authResult;
    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin)
        _authResult = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      else {
        _authResult =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        try {
          await FirebaseFirestore.instance
              .collection("users")
              .doc(_authResult.user.uid)
              .set({
            "userName": userName,
            "email": email,
            "password": password,
          });
        } catch (e) {}
      }
    } on FirebaseAuthException catch (e) {
      String authError = "Error occured";
      if (e.code == 'weak-password') {
        authError = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        authError = 'The account already exists for that email.';
      } else if (e.code == 'user-not-found') {
        authError = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        authError = 'Wrong password provided for that user.';
      }
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(authError),
          backgroundColor: Theme.of(ctx).errorColor,
        ),
      );
    } catch (e) {
      print(e);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(
        _submitAuthForm,
        _isLoading,
      ),
    );
  }
}
