import 'package:flutter/material.dart';
import 'package:dalbitjido_flutter/screens/mappage.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
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
          BottomNavigationBarItem(label: 'asdf', icon: Icon(Icons.add_alert)),
          BottomNavigationBarItem(
            label: 'Music',
            icon: Icon(Icons.music_note),
          ),
          BottomNavigationBarItem(
            label: 'Places',
            icon: Icon(Icons.local_activity),
          ),
        ],
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
            Text('지도보기',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w100)),
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
          child: IconButton(
            icon: Icon(Icons.arrow_right),
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => MapPage(),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
