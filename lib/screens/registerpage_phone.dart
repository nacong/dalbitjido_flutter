import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:dalbitjido_flutter/screens/mainpage.dart';

class RegisterPhonePage extends StatefulWidget {
  @override
  _RegisterPhonePageState createState() => _RegisterPhonePageState();
}

enum MobileVerificationState {
  SHOW_MOBILE_FORM_STATE,
  SHOW_OTP_FORM_STATE,
}

class _RegisterPhonePageState extends State<RegisterPhonePage> {
  MobileVerificationState currentState =
      MobileVerificationState.SHOW_MOBILE_FORM_STATE;

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final otpController = TextEditingController();
  final phoneController = TextEditingController();

  FirebaseAuth _auth = FirebaseAuth.instance;

  late String verificationId;

  bool showLoading = false;

  void SignInWithPhoneAuthCredential(PhoneAuthCredential phoneAuthCredential) async{

    setState(() {
      showLoading = true;
    });

    try{
      final authCredential = await _auth.signInWithCredential(phoneAuthCredential);
      
      setState(() {
        showLoading = false;
      });

      if(authCredential.user != null) {
        Navigator.push(context, MaterialPageRoute(builder: (context)=> MainPage()));
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        showLoading = false;
      });
      // _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(e.message),));
    }
}

  getOtpFormWidget(context) {
    return Column(
      children: [
        Spacer(),
        TextField(
          controller: otpController,
          decoration: InputDecoration(
            hintText: "Enter OTP",
          ),
        ),
        SizedBox(height: 16),
        TextButton(
            onPressed: () {
              PhoneAuthCredential phoneAuthCredential =
                  PhoneAuthProvider.credential(
                      verificationId: verificationId,
                      smsCode: otpController.text);

              SignInWithPhoneAuthCredential(phoneAuthCredential);
            },
            child: Text("VERIFY"),
            style: TextButton.styleFrom(
              primary: Colors.blue,
            )),
        Spacer(),
      ],
    );
  }

  getMobileFormWidget(context) {
    return Column(children: [
      Text(
        '달빛지도',
        style: TextStyle(
            fontSize: 40.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'CafeSurround',
            color: Color(0xff6200EA)),
      ),
      Spacer(),
      TextField(
        controller: phoneController,
        decoration: InputDecoration(
          hintText: "Phone Number",
        ),
      ),
      SizedBox(height: 16),
      TextButton(
        onPressed: () async {

          setState(() {
            showLoading = true;
          });

          await _auth.verifyPhoneNumber(
              phoneNumber: "+82"+phoneController.text.substring(1).trim(),
              verificationCompleted: (phoneAuthCredential) async {
                setState(() {
                  showLoading = false;
                });
                // SignInWithPhoneAuthCredential(phoneAuthCredential);
              },
              verificationFailed: (verificationFailed) async {
                setState(() {
                  showLoading = false;
                });
                // _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(verificationFailed.message),));
              },
              codeSent: (verificationId, resendingToken) async {
                setState(() {
                  showLoading = false;
                  currentState = MobileVerificationState.SHOW_OTP_FORM_STATE;
                  this.verificationId = verificationId;
                });
              },
              codeAutoRetrievalTimeout: (verificationId) async {});
        },
        child: Text('login'),
      ),
      Spacer(),
    ]);
  }

  

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: Container(
          child: showLoading ? Center(child: CircularProgressIndicator(),) : currentState == MobileVerificationState.SHOW_MOBILE_FORM_STATE
              ? getMobileFormWidget(context)
              : getOtpFormWidget(context),
          padding: const EdgeInsets.all(16),
        ));
  }
}