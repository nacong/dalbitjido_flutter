import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:location/location.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => new _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  late PullToRefreshController pullToRefreshController;
  String url = "";
  double progress = 0;
  final urlController = TextEditingController();

  @override
  void initState() {
    super.initState();

    getLatLong();

    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: Colors.blue,
      ),
      onRefresh: () async {
        if (Platform.isAndroid) {
          webViewController?.reload();
        } else if (Platform.isIOS) {
          webViewController?.loadUrl(
              urlRequest: URLRequest(url: await webViewController?.getUrl()));
        }
      },
    );
  }

  Location location = new Location();

  bool _serviceEnabled = true;
  PermissionStatus? _permissionGranted;
  LocationData? _locationData;

  dynamic lat;
  dynamic lon;
  String _url = "";

  Future<LocationData> getLatLong() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        // return _locationData;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        // return _locationData;
      }
    }
    
    return _locationData = await location.getLocation();
  }

  @override
  void dispose() {
    super.dispose();
  }

  String MY_URL = 'https://dalbitjidoflask.run.goorm.io/arr/';

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getLatLong(),
      builder: (BuildContext context, AsyncSnapshot<LocationData> snap) {
        if (!snap.hasData || snap.data!.longitude == null)
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        String _url =
            "${MY_URL}${snap.data!.latitude.toString()}/${snap.data!.longitude.toString()}";
        print(_url);
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Color(0xff6200ea),
            title: Text(
              '달빛지도',
              style: TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                  fontFamily: 'CafeSurround'),
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
                  label: 'asdf', icon: Icon(Icons.add_alert)),
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
                      color: Colors.blue,
                      fontFamily: 'CafeSurround',
                      fontSize: 27),
                ),
                SizedBox(height: 80),
                Text(
                  '내정보',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w100),
                ),
                SizedBox(height: 25),
                Text('즐겨찾기',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w100)),
                SizedBox(height: 25),
                Text('동행',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w100)),
                SizedBox(height: 25),
                Text('지도보기',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w100)),
                SizedBox(height: 25),
                Text('설정',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w100)),
                SizedBox(height: 250),
                Text(
                  ' 세부정보',
                  style: TextStyle(wordSpacing: 150),
                )
              ],
            ),
          ),
          body: SafeArea(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Stack(
                    children: [
                      InAppWebView(
                        key: webViewKey,
                        initialUrlRequest: URLRequest(url: Uri.parse(_url)),
                        initialOptions: options,
                        pullToRefreshController: pullToRefreshController,
                        onWebViewCreated: (controller) {
                          webViewController = controller;
                        },
                        onLoadStart: (controller, url) {
                          setState(() {
                            this.url = url.toString();
                            urlController.text = this.url;
                          });
                        },
                        androidOnPermissionRequest:
                            (controller, origin, resources) async {
                          return PermissionRequestResponse(
                              resources: resources,
                              action: PermissionRequestResponseAction.GRANT);
                        },
                        shouldOverrideUrlLoading:
                            (controller, navigationAction) async {
                          var uri = navigationAction.request.url!;

                          if (![
                            "http",
                            "https",
                            "file",
                            "chrome",
                            "data",
                            "javascript",
                            "about"
                          ].contains(uri.scheme)) {
                            if (await canLaunch(url)) {
                              // Launch the App
                              await launch(
                                url,
                              );
                              // and cancel the request
                              return NavigationActionPolicy.CANCEL;
                            }
                          }

                          return NavigationActionPolicy.ALLOW;
                        },
                        onLoadStop: (controller, url) async {
                          pullToRefreshController.endRefreshing();
                          setState(() {
                            this.url = url.toString();
                            urlController.text = this.url;
                          });
                        },
                        onLoadError: (controller, url, code, message) {
                          pullToRefreshController.endRefreshing();
                        },
                        onProgressChanged: (controller, progress) {
                          if (progress == 100) {
                            pullToRefreshController.endRefreshing();
                          }
                          setState(() {
                            this.progress = progress / 100;
                            urlController.text = this.url;
                          });
                        },
                        onUpdateVisitedHistory:
                            (controller, url, androidIsReload) {
                          setState(() {
                            this.url = url.toString();
                            urlController.text = this.url;
                          });
                        },
                        onConsoleMessage: (controller, consoleMessage) {
                          print(consoleMessage);
                        },
                      ),
                      progress < 1.0
                          ? LinearProgressIndicator(value: progress)
                          : Container(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
