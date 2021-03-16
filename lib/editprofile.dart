import 'dart:math';
import 'user.dart';
import 'methods.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:supercharged/supercharged.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:simple_animations/simple_animations.dart';

class EditProfile extends StatefulWidget {
  final int
      page; //1 = feedback, 2 = change password, 3 = new password, 4 = delete account, 5 = confirmation on delete account
  final User user;
  EditProfile(this.page, this.user);
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  Methods methods = new Methods();
  int _page = 0;

  //used by 2 & 3
  bool _verifyPassword = true;
  String _passwordMessage = "";

  bool _verifyRetypePassword = true;
  String _retypePasswordMessage = "";

  bool _passwordHidden = true;
  FocusNode _passwordFocus = new FocusNode();
  TextEditingController _passwordController = new TextEditingController();

  bool _passwordHidden1 = true;
  FocusNode _retypePasswordFocus = new FocusNode();
  TextEditingController _retypePasswordController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _page = widget.page;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Container(
        color: Colors.black,
        child: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Stack(
            children: [
              Positioned.fill(
                child: AnimatedBackground(_page),
              ),
              onBottom(AnimatedWave(
                page: _page,
                height: 270,
                speed: 1.0,
              )),
              onBottom(AnimatedWave(
                page: _page,
                height: 180,
                speed: 0.9,
                offset: pi,
              )),
              onBottom(AnimatedWave(
                page: _page,
                height: 330,
                speed: 1.2,
                offset: pi / 2,
              )),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 20.0,
                    left: 10.0,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          FlutterIcons.md_arrow_round_back_ion,
                          color: Colors.white,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 10.0,
                          top: 7.0,
                        ),
                        child: methods.textOnly(
                            _page == 1
                                ? "Send Us Your Feedback!"
                                : _page == 2
                                    ? "Change Password?"
                                    : _page == 3
                                        ? "New Password"
                                        : "Delete Account?",
                            "Leoscar",
                            22.0,
                            Colors.white,
                            FontWeight.bold,
                            FontStyle.normal,
                            TextAlign.center),
                      ),
                    ],
                  ),
                ),
              ),
              _page == 1
                  ? _feedbackBuild()
                  : _page == 2
                      ? _changePasswordBuild()
                      : _page == 3
                          ? _newPasswordBuild()
                          : _page == 4
                              ? _changePasswordBuild()
                              : _deleteAccountBuild(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _feedbackBuild() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
            top: 80.0,
            left: 20.0,
            bottom: 20.0,
            right: 20.0,
          ),
          child: Material(
            elevation: 10.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(8.0),
              ),
            ),
            color: Colors.white,
            child: TextField(
              style: TextStyle(
                fontFamily: "Leoscar",
                fontSize: 18.0,
                letterSpacing: 1.0,
              ),
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.text,
              maxLines: 10,
              cursorColor: Colors.black,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(20.0),
                focusedBorder: const OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.black,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                ),
              ),
            ),
          ),
        ),
        RaisedButton(
          onPressed: () {
            Navigator.of(context).pop();
            Future.delayed(Duration(milliseconds: 300), () {
              methods.snackbarMessage(
                context,
                Duration(seconds: 1),
                Color(0XFFB563E0),
                methods.textOnly("Feedback submitted", "Leoscar", 18.0,
                    Colors.white, null, null, TextAlign.center),
              );
            });
          },
          elevation: 10.0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(80.0),
            side: BorderSide(
              color: Colors.black54,
            ),
          ),
          padding: const EdgeInsets.all(0.0),
          child: methods.textOnly("Submit", "Leoscar", 18.0, Colors.black,
              FontWeight.normal, FontStyle.normal, TextAlign.center),
        ),
      ],
    );
  }

  Widget _changePasswordBuild() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 80.0,
            left: 20.0,
            bottom: 20.0,
            right: 20.0,
          ),
          child: Material(
            elevation: 10.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(8.0),
              ),
            ),
            color: Colors.white,
            child: Theme(
              data: ThemeData(
                primaryColor: Colors.black,
              ),
              child: TextField(
                style: TextStyle(
                  fontFamily: "Leoscar",
                  fontSize: 18.0,
                  letterSpacing: 1.0,
                ),
                controller: _passwordController,
                obscureText: _passwordHidden,
                focusNode: _passwordFocus,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.text,
                cursorColor: Color(0XFF9866B3),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(20.0),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.black,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(8.0),
                    ),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _passwordHidden ? LineIcons.eyeSlash : LineIcons.eye,
                    ),
                    onPressed: () async {
                      if (!_passwordFocus.hasPrimaryFocus) {
                        _passwordFocus.unfocus();
                        _passwordFocus.canRequestFocus = false;
                      }
                      setState(() {
                        _passwordHidden = !_passwordHidden;
                      });
                    },
                  ),
                  hintText: "Current Password",
                  hintStyle: TextStyle(
                    fontFamily: "Leoscar",
                    fontSize: 14.0,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
            ),
          ),
        ),
        RaisedButton(
          onPressed: () {
            _passwordFocus.unfocus();
            setState(() {
              if (_page == 2) {
                if (_passwordController.text == widget.user.getPassword()) {
                  _passwordHidden = true;
                  _passwordController.clear();
                  _page = 3;
                } else {
                  Future.delayed(Duration(milliseconds: 300), () {
                    methods.snackbarMessage(
                      context,
                      Duration(seconds: 1),
                      Colors.red[400],
                      methods.textOnly(
                          "Incorrect password...please try again",
                          "Leoscar",
                          18.0,
                          Colors.white,
                          null,
                          null,
                          TextAlign.center),
                    );
                  });
                }
              } else {
                if (_passwordController.text == widget.user.getPassword()) {
                  _passwordHidden = true;
                  _passwordController.clear();
                  _page = 5;
                } else {
                  Future.delayed(Duration(milliseconds: 300), () {
                    methods.snackbarMessage(
                      context,
                      Duration(seconds: 1),
                      Colors.red[400],
                      methods.textOnly(
                          "Incorrect password...please try again",
                          "Leoscar",
                          18.0,
                          Colors.white,
                          null,
                          null,
                          TextAlign.center),
                    );
                  });
                }
              }
            });
          },
          elevation: 10.0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(80.0),
            side: BorderSide(
              color: Colors.black54,
            ),
          ),
          padding: const EdgeInsets.all(0.0),
          child: methods.textOnly("Submit", "Leoscar", 18.0, Colors.black,
              FontWeight.normal, FontStyle.normal, TextAlign.center),
        ),
      ],
    );
  }

  Widget _newPasswordBuild() {
    return Theme(
      data: ThemeData(
        primaryColor: Colors.black,
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Colors.black,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 80.0,
                bottom: 5.0,
              ),
              child: Material(
                elevation: 10.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                ),
                color: Colors.white,
                child: TextField(
                  onChanged: (String value) {
                    _passwordMessage = "Password must be at least ";
                    setState(() {
                      _verifyPassword = false;
                      if (value.length < 6) {
                        _passwordMessage += "6 characters";
                      } else if (!value.contains(new RegExp(r"(?=.*?[A-Z])"))) {
                        _passwordMessage += "1 uppercase letter";
                      } else if (!value.contains(new RegExp(r"(?=.*?[a-z])"))) {
                        _passwordMessage += " 1 lowercase letter";
                      } else if (!value.contains(new RegExp(r"(?=.*?[0-9])"))) {
                        _passwordMessage += "1 number";
                      } else if (!value
                          .contains(new RegExp(r"(?=.*?[#?!@$%^&*-])"))) {
                        _passwordMessage += "1 special character";
                      } else {
                        _verifyPassword = true;
                      }
                    });
                  },
                  onSubmitted: (String value) {
                    FocusScope.of(context).requestFocus(_retypePasswordFocus);
                  },
                  style: TextStyle(
                    fontFamily: "Leoscar",
                    fontSize: 18.0,
                    letterSpacing: 1.0,
                  ),
                  controller: _passwordController,
                  obscureText: _passwordHidden,
                  focusNode: _passwordFocus,
                  keyboardType: TextInputType.text,
                  cursorColor: Color(0XFF9866B3),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(20.0),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.black,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(8.0),
                      ),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _passwordHidden ? LineIcons.eyeSlash : LineIcons.eye,
                      ),
                      onPressed: () async {
                        if (!_passwordFocus.hasPrimaryFocus) {
                          _passwordFocus.unfocus();
                          _passwordFocus.canRequestFocus = false;
                        }
                        setState(() {
                          _passwordHidden = !_passwordHidden;
                        });
                      },
                    ),
                    hintText: "New Password",
                    hintStyle: TextStyle(
                      fontFamily: "Leoscar",
                      fontSize: 14.0,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              ),
            ),
            _showErrorMessage(!_verifyPassword, _passwordMessage),
            Padding(
              padding: const EdgeInsets.only(
                top: 10.0,
                bottom: 5.0,
              ),
              child: Material(
                elevation: 10.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                ),
                color: Colors.white,
                child: TextField(
                  onChanged: (String value) {
                    setState(() {
                      _verifyRetypePassword = false;
                      if (value == _passwordController.text) {
                        _verifyRetypePassword = true;
                      } else {
                        _retypePasswordMessage = "Password not match";
                      }
                    });
                  },
                  textInputAction: TextInputAction.done,
                  style: TextStyle(
                    fontFamily: "Leoscar",
                    fontSize: 18.0,
                    letterSpacing: 1.0,
                  ),
                  obscureText: _passwordHidden1,
                  controller: _retypePasswordController,
                  focusNode: _retypePasswordFocus,
                  decoration: InputDecoration(
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: Colors.red[400],
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: Colors.red[400],
                      ),
                    ),
                    errorStyle: TextStyle(
                      fontFamily: "Leoscar",
                      letterSpacing: 1.0,
                      color: Colors.red[400],
                    ),
                    contentPadding: EdgeInsets.all(20.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.black,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(8.0),
                      ),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _passwordHidden1 ? LineIcons.eyeSlash : LineIcons.eye,
                      ),
                      onPressed: () async {
                        if (!_retypePasswordFocus.hasPrimaryFocus) {
                          _retypePasswordFocus.unfocus();
                          _retypePasswordFocus.canRequestFocus = false;
                        }
                        setState(() {
                          _passwordHidden1 = !_passwordHidden1;
                        });
                      },
                    ),
                    hintText: "Re-type New Password",
                    hintStyle: TextStyle(
                      fontFamily: "Leoscar",
                      fontSize: 14.0,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              ),
            ),
            _showErrorMessage(!_verifyRetypePassword, _retypePasswordMessage),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 15.0,
                ),
                child: RaisedButton(
                  onPressed: () {
                    _passwordFocus.unfocus();
                    _retypePasswordFocus.unfocus();
                    if (_passwordController.text ==
                            _retypePasswordController.text &&
                        _passwordController.text.isNotEmpty &&
                        _retypePasswordController.text.isNotEmpty &&
                        _verifyPassword &&
                        _verifyRetypePassword) {
                      _passwordFocus.unfocus();
                      _retypePasswordFocus.unfocus();
                      widget.user.setPassword(_retypePasswordController.text);
                      Navigator.of(context).pop();
                      Future.delayed(Duration(milliseconds: 300), () {
                        methods.snackbarMessage(
                          context,
                          Duration(seconds: 1),
                          Color(0XFFB563E0),
                          methods.textOnly(
                              "Password changed successfully",
                              "Leoscar",
                              18.0,
                              Colors.white,
                              null,
                              null,
                              TextAlign.center),
                        );
                      });
                    } else {
                      Future.delayed(Duration(milliseconds: 300), () {
                        methods.snackbarMessage(
                          context,
                          Duration(seconds: 1),
                          Colors.red[400],
                          methods.textOnly(
                              "Please amend the error(s)",
                              "Leoscar",
                              18.0,
                              Colors.white,
                              null,
                              null,
                              TextAlign.center),
                        );
                      });
                    }
                  },
                  elevation: 10.0,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(80.0),
                    side: BorderSide(
                      color: Colors.black54,
                    ),
                  ),
                  padding: const EdgeInsets.all(0.0),
                  child: methods.textOnly(
                      "Submit",
                      "Leoscar",
                      18.0,
                      Colors.black,
                      FontWeight.normal,
                      FontStyle.normal,
                      TextAlign.center),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _deleteAccountBuild() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 80.0,
          ),
          child: Container(
            height: 50.0,
            decoration: BoxDecoration(
              color: Colors.red[400],
              border: Border(
                top: BorderSide(
                  color: Colors.black,
                  width: 1.5,
                ),
                bottom: BorderSide(
                  color: Colors.black,
                  width: 1.5,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 4.0,
                    right: 10.0,
                  ),
                  child: Icon(
                    FlutterIcons.warning_ant,
                    color: Colors.white,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 3.0,
                  ),
                  child: methods.textOnly(
                      "This is EXTREMELY IMPORTANT!",
                      "Leoscar",
                      20.0,
                      Colors.white,
                      FontWeight.normal,
                      FontStyle.normal,
                      TextAlign.center),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 20.0,
            horizontal: 10.0,
          ),
          child: Text(
            "Are you sure you want to delete this account? If you delete your account, you will permanently lose your profile, food and exercise records. This action cannot be undone!",
            style: TextStyle(
              fontFamily: "Leoscar",
              fontSize: 20.0,
              height: 1.2,
              letterSpacing: 1.0,
              color: Colors.white,
            ),
            textAlign: TextAlign.justify,
          ),
        ),
        Container(
          height: 50.0,
          decoration: BoxDecoration(
            color: Colors.red[400],
            border: Border(
              top: BorderSide(
                color: Colors.black,
                width: 1.5,
              ),
              bottom: BorderSide(
                color: Colors.black,
                width: 1.5,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 4.0,
                  right: 10.0,
                ),
                child: Icon(
                  FlutterIcons.warning_ant,
                  color: Colors.white,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 3.0,
                ),
                child: methods.textOnly(
                    "This is EXTREMELY IMPORTANT!",
                    "Leoscar",
                    20.0,
                    Colors.white,
                    FontWeight.normal,
                    FontStyle.normal,
                    TextAlign.center),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 20.0,
          ),
          child: RaisedButton(
            onPressed: () {
              widget.user.setEmail("");
              widget.user.setPassword("");
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              Future.delayed(Duration(milliseconds: 300), () {
                methods.snackbarMessage(
                  context,
                  Duration(seconds: 1),
                  Color(0XFFB563E0),
                  methods.textOnly("Account deleted", "Leoscar", 18.0,
                      Colors.white, null, null, TextAlign.center),
                );
              });
            },
            elevation: 10.0,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(80.0),
              side: BorderSide(
                color: Colors.black54,
              ),
            ),
            padding: const EdgeInsets.all(0.0),
            child: methods.textOnly("Delete", "Leoscar", 18.0, Colors.black,
                FontWeight.normal, FontStyle.normal, TextAlign.center),
          ),
        ),
      ],
    );
  }

  Widget _showErrorMessage(bool visible, String message) {
    return Visibility(
      visible: visible,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CustomPaint(
            painter: TrianglePainter(
              paintingStyle: PaintingStyle.fill,
            ),
            child: Icon(
              FlutterIcons.warning_ent,
              color: Colors.red,
              size: 16.0,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: methods.textOnly(message, "Leoscar", 13.0, Colors.white,
                FontWeight.normal, FontStyle.normal, TextAlign.start),
          ),
          CustomPaint(
            painter: TrianglePainter(),
            child: Icon(
              FlutterIcons.warning_ent,
              color: Colors.red,
              size: 16.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget onBottom(Widget child) => Positioned.fill(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: child,
        ),
      );
}

class AnimatedWave extends StatelessWidget {
  final int page;
  final double height;
  final double speed;
  final double offset;

  AnimatedWave({this.page, this.height, this.speed, this.offset = 0.0});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        height: height,
        width: constraints.biggest.width,
        child: LoopAnimation<double>(
            duration: (5000 / speed).round().milliseconds,
            tween: 0.0.tweenTo(2 * pi),
            builder: (context, child, value) {
              return CustomPaint(
                foregroundPainter: CurvePainter(page, value + offset),
              );
            }),
      );
    });
  }
}

class CurvePainter extends CustomPainter {
  final int page;
  final double value;

  CurvePainter(this.page, this.value);

  @override
  void paint(Canvas canvas, Size size) {
    Paint white;
    if (page != 5 && page != 4) {
      white = Paint()..color = Colors.white.withAlpha(60);
    } else {
      white = Paint()..color = Colors.black.withAlpha(100);
    }
    final path = Path();

    final y1 = sin(value);
    final y2 = sin(value + pi / 2);
    final y3 = sin(value + pi);

    final startPointY = size.height * (0.5 + 0.4 * y1);
    final controlPointY = size.height * (0.5 + 0.4 * y2);
    final endPointY = size.height * (0.5 + 0.4 * y3);

    path.moveTo(size.width * 0, startPointY);
    path.quadraticBezierTo(
        size.width * 0.5, controlPointY, size.width, endPointY);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, white);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

enum _BgProps { color1, color2 }

class AnimatedBackground extends StatelessWidget {
  final int page;
  AnimatedBackground(this.page);

  @override
  Widget build(BuildContext context) {
    // var tween;
    Color _color1;
    Color _color2;
    Color _color3;
    Color _color4;
    if (page != 5 && page != 4) {
      _color1 = Color(0XFFFC00FF).withOpacity(0.5);
      _color2 = Color(0XFFFC00FF).withOpacity(0.8);
      _color3 = Color(0XFF00DBDE).withOpacity(0.5);
      _color4 = Color(0XFF00DBDE).withOpacity(0.8);
    } else if (page == 4) {
      _color1 = Colors.red.withOpacity(0.8);
      _color2 = Colors.red.withOpacity(1);
      _color3 = Colors.black.withOpacity(0.8);
      _color4 = Colors.black;
    } else {
      _color1 = Colors.redAccent[700].withOpacity(0.7);
      _color2 = Colors.redAccent[700].withOpacity(0.9);
      _color3 = Colors.black.withOpacity(0.7);
      _color4 = Colors.black.withOpacity(0.9);
    }

    final tween = MultiTween<_BgProps>()
      ..add(_BgProps.color1, _color1.tweenTo(_color2))
      ..add(_BgProps.color2, _color3.tweenTo(_color4));

    return MirrorAnimation<MultiTweenValues<_BgProps>>(
      tween: tween,
      duration: 3.seconds,
      builder: (context, child, value) {
        return Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                value.get(_BgProps.color1),
                value.get(_BgProps.color2)
              ])),
        );
      },
    );
  }
}

class TrianglePainter extends CustomPainter {
  final Color strokeColor;
  final PaintingStyle paintingStyle;
  final double strokeWidth;

  TrianglePainter(
      {this.strokeColor = Colors.white,
      this.strokeWidth = 3,
      this.paintingStyle = PaintingStyle.fill});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = strokeColor
      ..strokeWidth = strokeWidth
      ..style = paintingStyle;

    canvas.drawPath(getTrianglePath(size.width, size.height), paint);
  }

  Path getTrianglePath(double x, double y) {
    return Path()
      ..moveTo(0, y)
      ..lineTo(x / 2, 2)
      ..lineTo(x, y)
      ..lineTo(0, y);
  }

  @override
  bool shouldRepaint(TrianglePainter oldDelegate) {
    return oldDelegate.strokeColor != strokeColor ||
        oldDelegate.paintingStyle != paintingStyle ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
