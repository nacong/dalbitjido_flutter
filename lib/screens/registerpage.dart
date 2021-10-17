import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:dalbitjido_flutter/screens/mainpage.dart';
import 'package:dalbitjido_flutter/screens/registerpage_phone.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Builder(
        builder: (context) {
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    '달빛지도',
                    style: TextStyle(
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'CafeSurround',
                      color: Color(0xff6200EA),
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    padding: EdgeInsets.all(40.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('1. 휴대전화 인증 (FakeCall)을 위함입니다.'),
                        ButtonTheme(
                          height: 50.0,
                          child: TextButton(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Icon(Icons.phone_android),
                                  Text(
                                    'Login with phone',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 15.0),
                                  ),
                                  Opacity(
                                    opacity: 0.0,
                                    child:
                                        Icon(Icons.phone_android),
                                  ),
                                ],
                              ),
                              onPressed: () => {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => RegisterPhonePage()))
                                  }),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(4.0),
                            ),
                          ),
                        ),
                        Text('2. 소셜 인증'),
                        ButtonTheme(
                          height: 50.0,
                          child: TextButton(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Image.asset('assets/image/glogo.png'),
                                  Text(
                                    'Login with Google',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 15.0),
                                  ),
                                  Opacity(
                                    opacity: 0.0,
                                    child:
                                        Image.asset('assets/image/glogo.png'),
                                  ),
                                ],
                              ),
                              onPressed: () {
                            signInWithGoogle();
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => MainPage()));
                                  }),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(4.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

Future<UserCredential> signInWithGoogle() async {
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  final GoogleSignInAuthentication googleAuth =
      await googleUser!.authentication;
  final OAuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );
  return await FirebaseAuth.instance.signInWithCredential(credential);
}
