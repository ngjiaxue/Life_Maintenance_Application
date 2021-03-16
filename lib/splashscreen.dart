import 'package:flutter/services.dart';

import 'loginscreen.dart';
import 'fadeanimation.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

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
  bool run = false;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 2500), vsync: this);
    animation = Tween(begin: 0.0, end: 1.0).animate(controller)
      ..addListener(() {
        setState(() {
          run = true;
          if (animation.value > 0.99) {
            Navigator.push(
              context,
              PageTransition(
                child: LoginScreen(1),
                type: PageTransitionType.fade,
              ),
            );
            // if (widget.loggedIn == 0) {
            //   Navigator.push(
            //     context,
            //     ScaleRoute(
            //       page: Tabs(
            //         user: widget.user,
            //       ),
            //     ),
            //   );
            // } else if (widget.loggedIn == 1) {
            //   Navigator.push(
            //     context,
            //     ScaleRoute(
            //       page: LoginScreen(1),
            //     ),
            //   );
            // } else if (widget.loggedIn == 2) {
            //   Navigator.push(
            //     context,
            //     ScaleRoute(
            //       page: AdminTabs(
            //         user: widget.user,
            //       ),
            //     ),
            //   );
            // } else {
            //   Navigator.push(
            //     context,
            //     ScaleRoute(
            //       page: Tabs(user: widget.user),
            //     ),
            //   );
            // }
          }
        });
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
          FadeAnimation(
            0.5,
            true,
            Hero(
              tag: "background",
              child: Image.asset(
                "assets/images/splashbg.jpg",
                fit: BoxFit.cover,
              ),
            ),
          ),
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
                      "assets/images/logo.png",
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
}
