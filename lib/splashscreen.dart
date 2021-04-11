import 'tabs.dart';
import 'user.dart';
import 'dart:async';
import 'methods.dart';
import 'loginscreen.dart';
import 'fadeanimation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  User user;
  bool _darkMode;
  int _loggedIn =
      0; // 0 = navigate to login as unregistered user, 1 = navigate to login with email, 2 = navigate to tabs

  @override
  void initState() {
    super.initState();
    _loadPrefUserDetails();
    _loadPrefDarkMode();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      title: "Life Maintenance Application",
      // debugShowCheckedModeBanner: false,
      theme: _darkMode == true
          ? ThemeData(
              brightness: Brightness.dark,
              floatingActionButtonTheme: FloatingActionButtonThemeData(
                foregroundColor: Colors.transparent,
              ),
            )
          : ThemeData.light(),
      home: Scaffold(
        body: SplashScreen(
          loggedIn: _loggedIn,
          user: user,
          callback1: () async {
            if (this.mounted) {
              await _loadPrefDarkMode();
            }
          },
        ),
      ),
    );
  }

  Future<void> _loadPrefUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _email = (prefs.getString('email') ?? '');
    String _password = (prefs.getString('pass') ?? '');
    if (_email.isNotEmpty && _password.isNotEmpty) {
      await http.post(
          Uri.parse(
              "https://lifemaintenanceapplication.000webhostapp.com/php/login.php"),
          body: {
            "email": _email,
            "password": _password,
          }).then((res) async {
        List userDetails = res.body.split("&");
        if (userDetails[0] == "success admin") {
          setState(() {
            user = new User(
              userDetails[1],
              userDetails[2],
              userDetails[3],
              userDetails[4],
              userDetails[5],
              userDetails[6],
              userDetails[7],
              _darkMode,
            );
            _loggedIn = 2;
          });
        } else if (userDetails[0] == "success") {
          setState(() {
            user = new User(
              userDetails[1],
              userDetails[2],
              userDetails[3],
              userDetails[4],
              userDetails[5],
              userDetails[6],
              userDetails[7],
              _darkMode,
            );
            _loggedIn = 2;
          });
        }
      }).catchError((err) {
        print(err);
      });
    } else if (_email.isNotEmpty) {
      setState(() {
        _loggedIn = 1;
      });
    }
  }

  Future<void> _loadPrefDarkMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool darkMode = (prefs.getBool('darkmode')) ?? false;
    print("darkmodeMyApp: $darkMode");
    setState(() {
      _darkMode = darkMode;
    });
  }
}

class SplashScreen extends StatefulWidget {
  final int loggedIn;
  final User user;
  final VoidCallback callback1;
  const SplashScreen({Key key, this.loggedIn, this.user, this.callback1})
      : super(key: key);
  @override
  _SplashScreenState createState() {
    return _SplashScreenState(
      callback2: () {
        callback1();
      },
    );
  }
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  VoidCallback callback2;
  _SplashScreenState({this.callback2});
  AnimationController controller;
  Animation<double> animation;
  Methods methods = new Methods();
  bool run = false;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 3000), vsync: this);
    animation = Tween(begin: 0.0, end: 1.0).animate(controller)
      ..addListener(() async {
        setState(() {
          run = true;
        });
        if (animation.value > 0.99) {
          if (widget.loggedIn == 0) {
            await Navigator.push(
              context,
              PageTransition(
                child: LoginScreen(
                  userLogout: 1,
                  callback1: () {
                    if (this.mounted) {
                      print("##########backtosplash#######1");
                      callback2();
                    }
                  },
                ),
                type: PageTransitionType.fade,
              ),
            );
          } else if (widget.loggedIn == 1) {
            await Navigator.push(
              context,
              PageTransition(
                child: LoginScreen(
                  userLogout: 2,
                  callback1: () {
                    if (this.mounted) {
                      print("##########backtosplash#######2");
                      callback2();
                    }
                  },
                ),
                type: PageTransitionType.fade,
              ),
            );
          } else {
            methods.snackbarMessage(
              context,
              Duration(
                seconds: 1,
              ),
              Color(0XFFB563E0),
              true,
              methods.textOnly(
                  "Login successful...Welcome ${widget.user.getName()}",
                  "Leoscar",
                  18.0,
                  Colors.white,
                  null,
                  null,
                  TextAlign.center),
            );
            await Navigator.push(
              context,
              PageTransition(
                child: Tabs(
                  user: widget.user,
                  callback1: () {
                    if (this.mounted) {
                      print("##########backtosplash#######3");
                      callback2();
                    }
                  },
                ),
                type: PageTransitionType.fade,
              ),
            );
          }
        }
      });
    controller.repeat();
  }

  @override
  void dispose() {
    controller.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          FutureBuilder(
              future: Future.delayed(Duration(milliseconds: 500)),
              builder: (context, builder) {
                return Hero(
                  tag: "background",
                  child: Image.asset(
                    "assets/images/splashbg.png",
                    fit: BoxFit.cover,
                  ),
                );
              }),
          FadeAnimation(
            1.5,
            true,
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    tag: "logo",
                    child: Image.asset(
                      "assets/images/logo.gif",
                      scale: 2.5,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      "Life Maintenance Application",
                      style: TextStyle(
                        fontSize: 40.0,
                        fontFamily: "Athena",
                        letterSpacing: 1.5,
                        foreground: Paint()
                          ..shader = LinearGradient(
                            colors: <Color>[
                              Color(0XFF001F52),
                              Color(0XFF015F9F),
                              Color(0XFF00D1D0),
                              Color(0XFF00CC49),
                              Color(0XFFFA9308),
                              Color(0XFFEE1F27),
                            ],
                          ).createShader(
                            Rect.fromLTWH(20.0, 0.0, 300.0, 0.0),
                          ),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedPositioned(
            left: run ? MediaQuery.of(context).size.width : -100,
            bottom: 20,
            duration: Duration(milliseconds: 3600),
            child: Image.asset(
              "assets/images/running.gif",
              scale: 5,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 10.0,
              child: LinearProgressIndicator(
                value: animation.value,
                backgroundColor: Colors.transparent,
                valueColor: AlwaysStoppedAnimation<Color>(Color(0XFFAB77C7)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
