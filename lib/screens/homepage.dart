import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:dalbitjido_flutter/screens/registerpage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '달빛지도',
              style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold, fontFamily: 'CafeSurround', color: Color(0xff6200EA)),
            ),
            Container(
              margin: EdgeInsets.all(50.0),
            ),
            TextButton(
              onPressed:  () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => RegisterPage(),
                  ),
                );
              }, child: Text('회원가입'))
          ],
        ),
      ),
    );
  }
}