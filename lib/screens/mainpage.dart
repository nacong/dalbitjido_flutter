import 'package:flutter/material.dart';
import 'package:dalbitjido_flutter/screens/mappage.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dalbitjido_flutter/screens/registerpage.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final _auth = FirebaseAuth.instance;
  int _selectedIndex = 0;
  List<Widget> _widgetOptions = [
    Text('home'),
    Placeholder(),
    Placeholder(),
  ];

  int i=0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      if (i%2 == 0) {
        audioPlayer.open(Audio('assets/sound/test.mp3'));
        i++;
      } else {
        audioPlayer.stop();
        i++;
      }
    } else if (index == 1) {
      _logOut();
    }
  }

  void _logOut() async {
    await _auth.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => RegisterPage()));
  }

  AssetsAudioPlayer audioPlayer =
      AssetsAudioPlayer(); // this will create a instance object of a class

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xff6200ea),
        title: Text(
          '달빛지도',
          style: TextStyle(
              fontSize: 25, color: Colors.white, fontFamily: 'CafeSurround'),
        ),
        elevation: 0.0,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black.withOpacity(.60),
        selectedFontSize: 14,
        unselectedFontSize: 14,
        items: [
          BottomNavigationBarItem(
            label: 'Siren',
            icon: Text('🚨'),
          ),
          BottomNavigationBarItem(
            label: 'Logout',
            icon: Icon(Icons.logout),
          ),
        ],
        showSelectedLabels: false, //(1)
        showUnselectedLabels: false,
        onTap: _onItemTapped,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.fromLTRB(50.0, 15.0, 0, 0),
          children: <Widget>[
            SizedBox(height: 80),
            Text(
              '안녕하세요.',
              style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 30,
              ),
            ),
            SizedBox(height: 1),
            Text(
              '윤도빈님',
              style: TextStyle(
                  color: Colors.blue, fontFamily: 'CafeSurround', fontSize: 27),
            ),
            SizedBox(height: 80),
            Text(
              '내정보',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w100),
            ),
            SizedBox(height: 25),
            Text('즐겨찾기',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w100)),
            SizedBox(height: 25),
            Text('동행',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w100)),
            SizedBox(height: 25),
            new GestureDetector(
              onTap: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => MapPage(),
                  ),);
              },
              child: new Text("지도보기", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w100)),
              ),
            SizedBox(height: 25),
            Text('설정',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w100)),
            SizedBox(height: 250),
            Text(
              ' 세부정보',
              style: TextStyle(wordSpacing: 150),
            )
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(30.0, 40.0, 0, 0),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '안전한 길 안내 시작',
              style: TextStyle(fontSize: 25, fontFamily: 'CafeSurround'),
            ),
            IconButton(
              icon: Icon(Icons.arrow_right),
              iconSize: 50.0,
              onPressed: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => MapPage(),
                  ),
                );
              },
            ),
          ],
        )),
      ),
    );
  }
}
