import 'user.dart';
import 'methods.dart';
import 'dart:convert';
import 'userpage1.dart';
import 'userpage2.dart';
import 'userpage3.dart';
import 'userpage4.dart';
import 'fadeanimation.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_icons/flutter_icons.dart';
// import 'package:overlay_support/overlay_support.dart';

class Tabs extends StatefulWidget {
  final User user;
  const Tabs({Key key, this.user}) : super(key: key);
  @override
  _TabsState createState() => _TabsState();
}

class _TabsState extends State<Tabs> with TickerProviderStateMixin {
  Methods methods = new Methods();
  User user;
  List<bool> _tabSelected = [true, false, false, false];
  // List _foodList = [];
  // List _exerciseList = [];
  // List _userFoodList = [];
  // List _userExerciseList = [];
  bool _fadeIn = false;
  bool _onDrag = true;
  double _screenHeight;
  int _currentTab = 0;
  int _badgeQuantity = 0;
  int _userPage1CallBack = 0;

  @override
  void initState() {
    super.initState();
    _loadList("food");
    _loadList("exercise");
    _loadUserList("food");
    _loadUserList("exercise");
    _getBadgeCount(0);
    Future.delayed(Duration(milliseconds: 1300), () {
      setState(() {
        _fadeIn = true;
      });
    });
  }

  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  Widget _buildPageView() {
    return PageView(
      onPageChanged: (index) {
        _getBadgeCount(0);
        _loadList("food");
        _loadList("exercise");
        _loadUserList("food");
        _loadUserList("exercise");
        setState(() {
          if (_onDrag) {
            if (index == 0) {
              _tabSelected[0] = true;
              _tabSelected[1] = false;
              _tabSelected[2] = false;
              _tabSelected[3] = false;
            } else if (index == 1) {
              _tabSelected[0] = false;
              _tabSelected[1] = true;
              _tabSelected[2] = false;
              _tabSelected[3] = false;
            } else if (index == 2) {
              _tabSelected[0] = false;
              _tabSelected[1] = false;
              _tabSelected[2] = true;
              _tabSelected[3] = false;
            } else {
              _tabSelected[0] = false;
              _tabSelected[1] = false;
              _tabSelected[2] = false;
              _tabSelected[3] = true;
            }
          } else {
            if (_currentTab == 0) {
              _tabSelected[0] = true;
              _tabSelected[1] = false;
              _tabSelected[2] = false;
              _tabSelected[3] = false;
            } else if (_currentTab == 1) {
              _tabSelected[0] = false;
              _tabSelected[1] = true;
              _tabSelected[2] = false;
              _tabSelected[3] = false;
            } else if (_currentTab == 2) {
              _tabSelected[0] = false;
              _tabSelected[1] = false;
              _tabSelected[2] = true;
              _tabSelected[3] = false;
            } else {
              _tabSelected[0] = false;
              _tabSelected[1] = false;
              _tabSelected[2] = false;
              _tabSelected[3] = true;
            }
            Future.delayed(Duration(milliseconds: 100), () {
              _onDrag = true;
            });
          }
        });
      },
      controller: pageController,
      children: <Widget>[
        UserPage1(
          callback1: () {
            if (this.mounted) {
              setState(() {});
            }
          },
          func1: (integer) {
            setState(() {
              _getBadgeCount(integer);
            });
          },
          user: widget.user,
          // userFoodList: _userFoodList,
          // userExerciseList: _userExerciseList,
        ),
        UserPage2(
          user: widget.user,
          // foodList: _foodList,
          // userFoodList: _userFoodList,
        ),
        UserPage3(
          callback1: () {
            if (this.mounted) {
              setState(() {});
            }
          },
          func1: (integer) {
            pageController.animateToPage(integer,
                duration: Duration(milliseconds: 500), curve: Curves.ease);
            setState(() {
              _tabSelected[0] = false;
              _tabSelected[1] = false;
              _tabSelected[2] = false;
              _tabSelected[3] = true;
            });
          },
          user: widget.user,
          // exerciseList: _exerciseList,
          // userExerciseList: _userExerciseList,
        ),
        UserPage4(
          user: widget.user,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    _screenHeight = MediaQuery.of(context).size.height;
    return _fadeIn
        ? Scaffold(
            resizeToAvoidBottomInset: false,
            body: WillPopScope(
              onWillPop: () {
                return methods.backPressed(context, FocusScope.of(context));
              },
              child: Stack(
                children: [
                  Scaffold(
                    body: Container(
                      height: _screenHeight - 65.0,
                      child: _buildPageView(),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: FadeAnimation(
                      0.5,
                      false,
                      Container(
                        height: 100.0,
                        color: Colors.transparent,
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                height: 65,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      offset: Offset(0, -1),
                                      blurRadius: 5,
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    _unactiveIcon(FlutterIcons.home_ant, 0,
                                        _tabSelected[0]),
                                    _unactiveIcon(
                                        FlutterIcons.food_apple_outline_mco,
                                        1,
                                        _tabSelected[1]),
                                    _unactiveIcon(FlutterIcons.running_faw5s, 2,
                                        _tabSelected[2]),
                                    _unactiveIcon(
                                        FlutterIcons.shield_account_outline_mco,
                                        3,
                                        _tabSelected[3]),
                                  ],
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.topCenter,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  _activeIcon(FlutterIcons.home_ant, "Home",
                                      _tabSelected[0]),
                                  _activeIcon(
                                      FlutterIcons.food_apple_outline_mco,
                                      "Food",
                                      _tabSelected[1]),
                                  _activeIcon(FlutterIcons.running_faw5s,
                                      "Exercise", _tabSelected[2]),
                                  _activeIcon(
                                      FlutterIcons.shield_account_outline_mco,
                                      "Profile",
                                      _tabSelected[3]),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        : Scaffold();
  }

  Future<void> _loadList(String option) async {
    await http.post(
        Uri.parse(
            "https://lifemaintenanceapplication.000webhostapp.com/php/loadlist.php"),
        body: {
          "option": option,
        }).then((res) {
      if (res.body != "no data") {
        var _extractData = json.decode(res.body);
        setState(() {
          if (option == "food") {
            // _foodList = _extractData;
            widget.user.setFoodList(_extractData);
          } else {
            // _exerciseList = _extractData;
            widget.user.setExerciseList(_extractData);
          }
        });
      } else {
        methods.snackbarMessage(
          context,
          Duration(
            seconds: 1,
          ),
          Colors.red[400],
          true,
          methods.textOnly("Please connect to the internet", "Leoscar", 18.0,
              Colors.white, null, null, TextAlign.center),
        );
      }
    });
  }

  Future<void> _loadUserList(String option) async {
    await http.post(
        Uri.parse(
            "https://lifemaintenanceapplication.000webhostapp.com/php/loaduserlist.php"),
        body: {
          "email": widget.user.getEmail(),
          "option": option,
        }).then((res) {
      if (res.body != "no data" && res.body != "connected but no data") {
        var _extractData = json.decode(res.body);
        setState(() {
          if (option == "food") {
            // _userFoodList = _extractData;
            widget.user.setUserFoodList(_extractData);
          } else {
            // _userExerciseList = _extractData;
            widget.user.setUserExerciseList(_extractData);
          }
        });
      } else if (res.body == "connected but no data") {
      } else {
        methods.snackbarMessage(
          context,
          Duration(
            seconds: 1,
          ),
          Colors.red[400],
          true,
          methods.textOnly("Please connect to the internet", "Leoscar", 18.0,
              Colors.white, null, null, TextAlign.center),
        );
      }
    });
  }

  Widget _unactiveIcon(IconData iconData, int index, bool visible) {
    return GestureDetector(
      onTap: () {
        _getBadgeCount(0);
        setState(() {
          _currentTab = index;
          _onDrag = false;
        });
        pageController.animateToPage(index,
            duration: Duration(milliseconds: 500), curve: Curves.ease);
      },
      child: Container(
        width: 70.0,
        color: Colors.transparent,
        child: Visibility(
          visible: !visible,
          child: Badge(
            animationType: BadgeAnimationType.scale,
            position: BadgePosition.topEnd(top: -7, end: 12),
            showBadge: (index == 3 && _badgeQuantity > 0) ? true : false,
            badgeContent: methods.textOnly(
                _badgeQuantity.toString(),
                "Leoscar",
                10.0,
                Colors.white,
                FontWeight.normal,
                FontStyle.normal,
                TextAlign.center),
            child: methods.shaderMask(
              Icon(
                iconData,
                color: Colors.white,
              ),
              false,
            ),
          ),
        ),
      ),
    );
  }

  Widget _activeIcon(IconData iconData, String label, bool visible) {
    return Container(
      width: 70.0,
      color: Colors.transparent,
      child: Visibility(
        visible: visible,
        child: FadeAnimation(
          0.01,
          false,
          Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: ClipRect(
                  clipper: HalfClipper(),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 5.0,
                    ),
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  width: 70.0,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 5.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          height: 60.0,
                          width: 60.0,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: methods.color(),
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(80),
                            ),
                          ),
                          child: Icon(
                            iconData,
                            color: Colors.white,
                          ),
                        ),
                        methods.shaderMask(
                          methods.textOnly(
                              label,
                              "Leoscar",
                              15.0,
                              Colors.white,
                              FontWeight.normal,
                              FontStyle.normal,
                              TextAlign.start),
                          false,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _getBadgeCount(int _i) {
    //_i = 0 => tabs, _i = 1 => userpage1-height, _i = 2 => userpage1-weight
    setState(() {
      if (_i == 1 || _i == 2) {
        if (_i == 1 && _userPage1CallBack != _i) {
          _userPage1CallBack = _i;
          _badgeQuantity--;
        } else if (_i == 2 && _userPage1CallBack != _i) {
          _userPage1CallBack = _i;
          _badgeQuantity--;
        }
      } else {
        if (widget.user.getHeight() == "0.0" ||
            widget.user.getWeight() == "0.0") {
          if (widget.user.getHeight() == "0.0" &&
              widget.user.getWeight() == "0.0") {
            _badgeQuantity = 2;
          } else {
            _badgeQuantity = 1;
          }
        } else {
          _badgeQuantity = 0;
        }
      }
    });
  }
}

class HalfClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) => Rect.fromLTWH(0, 0, size.width, size.height / 2);

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) => true;
}
