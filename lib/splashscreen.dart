import 'dart:async';

import 'tabs.dart';
import 'user.dart';
import 'methods.dart';
import 'loginscreen.dart';
import 'fadeanimation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    return MaterialApp(
      title: "Life Maintenance Application",
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SplashScreen(),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;
  Methods methods = new Methods();
  User user;
  int _loggedIn =
      0; // 0 = navigate to login as unregistered user, 1 = navigate to login with email, 2 = navigate to tabs
  bool run = false;

  @override
  void initState() {
    super.initState();
    _loadPref();
    controller = AnimationController(
        duration: const Duration(milliseconds: 2500), vsync: this);
    animation = Tween(begin: 0.0, end: 1.0).animate(controller)
      ..addListener(() {
        setState(() {
          run = true;
        });
        if (animation.value > 0.99) {
          if (_loggedIn == 0) {
            Navigator.push(
              context,
              PageTransition(
                child: LoginScreen(1),
                type: PageTransitionType.fade,
              ),
            );
          } else if (_loggedIn == 1) {
            Navigator.push(
              context,
              PageTransition(
                child: LoginScreen(2),
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
              methods.textOnly("Login successful...Welcome ${user.getName()}",
                  "Leoscar", 18.0, Colors.white, null, null, TextAlign.center),
            );
            Navigator.push(
              context,
              PageTransition(
                child: Tabs(
                  user: user,
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
      color: Colors.white,
      child: Stack(
        children: [
          FutureBuilder(
              future: Future.delayed(Duration(milliseconds: 500)),
              builder: (context, builder) {
                return Hero(
                  tag: "background",
                  child: Image.asset(
                    "assets/images/splashbg.jpg",
                    fit: BoxFit.cover,
                  ),
                );
              }),
          // FadeAnimation(
          //   0.5,
          //   true,
          //   Hero(
          //     tag: "background",
          //     child: Image.asset(
          //       "assets/images/splashbg.jpg",
          //       fit: BoxFit.cover,
          //     ),
          //   ),
          // ),
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
                      // "assets/images/logo.png",
                      "assets/images/logo.gif",
                      scale: 3,
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
            left: run ? MediaQuery.of(context).size.width - 30 : -85,
            bottom: 20,
            duration: Duration(milliseconds: 2850),
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

  Future<void> _loadPref() async {
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
          }).then((res) {
        List userDetails = res.body.split("&");

        if (userDetails[0] == "success admin") {
          user = new User(
            userDetails[1],
            userDetails[2],
            userDetails[3],
            userDetails[4],
            userDetails[5],
            userDetails[6],
            userDetails[7],
          );
          setState(() {
            _loggedIn = 2;
          });
        } else if (userDetails[0] == "success") {
          user = new User(
            userDetails[1],
            userDetails[2],
            userDetails[3],
            userDetails[4],
            userDetails[5],
            userDetails[6],
            userDetails[7],
          );
          setState(() {
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
}
