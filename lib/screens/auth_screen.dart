import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widgets/auth/auth_form.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;

// ignore: non_constant_identifier_names
  void _SubmitAuthForm(String email, String password, String username,
      bool isLogin, BuildContext ctx) async {
    try {
      // ignore: prefer_typing_uninitialized_variables, unused_local_variable
      var rslt;
      if (isLogin) {
        rslt = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        rslt = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        debugPrint(rslt.user.uid);

        await FirebaseFirestore.instance
            .collection('users')
            .doc(rslt.user.uid.toString())
            .set({
          'username': username,
          'email': email,
        });
      }
    } on PlatformException catch (exp) {
      var message = 'An error occured, please check your credencials';
      if (exp.message != null) {
        message = exp.message!;
      }
      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).errorColor,
      ));
    } catch (err) {
      debugPrint(err.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: AuthForm(
        submitFn: _SubmitAuthForm,
      ),
    );
  }
}
