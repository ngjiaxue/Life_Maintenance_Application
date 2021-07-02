import 'dart:math';
import 'user.dart';
import 'dart:convert';
import 'methods.dart';
import 'loginscreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:line_icons/line_icons.dart';
import 'package:supercharged/supercharged.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:page_transition/page_transition.dart';
import 'package:simple_animations/simple_animations.dart';

class EditProfile extends StatefulWidget {
  final int
      page; //1 = feedback, 2 = change email, 3 = new email, 4 = change password, 5 = new password, 6 = delete account, 7 = confirmation on delete account
  final User user;
  EditProfile(this.page, this.user);
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  Methods methods = new Methods();
  double _screenHeight;
  int _page = 0;
  int _index =
      1; // for _feedbackBuild 1 = new feedback, 2 = feedback history, 3 = all feedback(only admin)
  AssetImage _gif;
  bool _menuPressed = false;
  bool _menuInstantPressed = false;
  bool _pageChanging = false;
  List _allFeedbackList = [];
  List _onlyUserFeedbackList = [];
  String _feedbackHeader = "Send Us Your Feedback!";

  Map<int, Color> _swatch = {
    50: Color.fromRGBO(0, 0, 0, .1),
    100: Color.fromRGBO(0, 0, 0, .2),
    200: Color.fromRGBO(0, 0, 0, .3),
    300: Color.fromRGBO(0, 0, 0, .4),
    400: Color.fromRGBO(0, 0, 0, .5),
    500: Color.fromRGBO(0, 0, 0, .6),
    600: Color.fromRGBO(0, 0, 0, .7),
    700: Color.fromRGBO(0, 0, 0, .8),
    800: Color.fromRGBO(0, 0, 0, .9),
    900: Color.fromRGBO(0, 0, 0, 1),
  };

  bool _verifyPassword = true;
  String _passwordMessage = "";

  bool _verifyRetypePassword = true;
  String _retypePasswordMessage = "";

  bool _verifyEmail = true;
  String _emailMessage = "";

  FocusNode _feedbackFocus = new FocusNode();
  TextEditingController _feedbackController = new TextEditingController();

  FocusNode _emailFocus = new FocusNode();
  TextEditingController _emailController = new TextEditingController();

  bool _passwordHidden = true;
  FocusNode _passwordFocus = new FocusNode();
  TextEditingController _passwordController = new TextEditingController();

  bool _passwordHidden1 = true;
  FocusNode _retypePasswordFocus = new FocusNode();
  TextEditingController _retypePasswordController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadFeedbackList();
    _page = widget.page;
  }

  @override
  Widget build(BuildContext context) {
    _gif = AssetImage("assets/images/logowithtext.gif");
    _screenHeight = MediaQuery.of(context).size.height;
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
                child: AnimatedBackground(_page, widget.user.getDarkMode()),
              ),
              onBottom(
                AnimatedWave(
                  page: _page,
                  height: 270,
                  speed: 1.0,
                  isDarkMode: widget.user.getDarkMode(),
                ),
              ),
              onBottom(
                AnimatedWave(
                  page: _page,
                  height: 180,
                  speed: 0.9,
                  offset: pi,
                  isDarkMode: widget.user.getDarkMode(),
                ),
              ),
              onBottom(
                AnimatedWave(
                  page: _page,
                  height: 330,
                  speed: 1.2,
                  offset: pi / 2,
                  isDarkMode: widget.user.getDarkMode(),
                ),
              ),
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
                          color: widget.user.getDarkMode()
                              ? Colors.white70
                              : Colors.white,
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
                                ? _feedbackHeader
                                : _page == 2
                                    ? "Change Email?"
                                    : _page == 3
                                        ? "New Email"
                                        : _page == 4
                                            ? "Change Password?"
                                            : _page == 5
                                                ? "New Password"
                                                : "Delete Account?",
                            "Leoscar",
                            22.0,
                            widget.user.getDarkMode()
                                ? Colors.white70
                                : Colors.white,
                            FontWeight.bold,
                            FontStyle.normal,
                            TextAlign.center),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                child: _page == 1
                    ? _feedbackBuild()
                    : _page == 2 || _page == 4 || _page == 6
                        ? _verifyPasswordBuild()
                        : _page == 3
                            ? _newEmailBuild()
                            : _page == 5
                                ? _newPasswordBuild()
                                : _deleteAccountBuild(),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _page == 1
          ? Padding(
              padding: const EdgeInsets.only(
                right: 8.0,
                bottom: 8.0,
              ),
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 204.0),
                    child: widget.user.getIsAdmin()
                        ? methods.fab(
                            1,
                            0,
                            "All feedback(s)",
                            _pageChanging
                                ? () {}
                                : () {
                                    setState(() {
                                      _feedbackHeader = "All feedback(s)";
                                      _pageChanging = true;
                                      _menuInstantPressed = false;
                                      _index = 3;
                                    });
                                    Future.delayed(
                                        const Duration(milliseconds: 1300), () {
                                      setState(() {
                                        _menuPressed = false;
                                      });
                                    });
                                  },
                            FlutterIcons.user_sli,
                            FlutterIcons.comment_discussion_oct,
                            _index == 3,
                            _menuPressed,
                            _menuInstantPressed,
                            widget.user.getDarkMode())
                        : SizedBox.shrink(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 142.0),
                    child: methods.fab(
                        2,
                        0,
                        "Feedback(s) History",
                        _pageChanging
                            ? () {}
                            : () {
                                setState(() {
                                  _feedbackHeader = "Feedback(s) History";
                                  _pageChanging = true;
                                  _menuInstantPressed = false;
                                  _index = 2;
                                });
                                Future.delayed(
                                    const Duration(milliseconds: 1300), () {
                                  setState(() {
                                    _menuPressed = false;
                                  });
                                });
                              },
                        FlutterIcons.comment_discussion_oct,
                        FlutterIcons.history_mdi,
                        _index == 2,
                        _menuPressed,
                        _menuInstantPressed,
                        widget.user.getDarkMode()),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 80.0),
                    child: methods.fab(
                        3,
                        0,
                        "New Feedback",
                        _pageChanging
                            ? () {}
                            : () {
                                setState(() {
                                  _feedbackHeader = "Send Us Your Feedback!";
                                  _pageChanging = true;
                                  _menuInstantPressed = false;
                                  _index = 1;
                                });
                                Future.delayed(
                                    const Duration(milliseconds: 1300), () {
                                  setState(() {
                                    _menuPressed = false;
                                  });
                                });
                              },
                        FlutterIcons.comment_discussion_oct,
                        FlutterIcons.comment_discussion_oct,
                        _index == 1,
                        _menuPressed,
                        _menuInstantPressed,
                        widget.user.getDarkMode()),
                  ),
                  methods.fab(4, 0, "", () {
                    setState(() {
                      _menuPressed = true;
                      _menuInstantPressed = false;
                    });
                    Future.delayed(const Duration(milliseconds: 1300), () {
                      setState(() {
                        _menuPressed = false;
                      });
                    });
                  }, Icons.close, Icons.close, false, _menuPressed,
                      _menuInstantPressed, widget.user.getDarkMode()),
                  methods.fab(
                      5,
                      0,
                      "",
                      _menuPressed
                          ? () {}
                          : () {
                              setState(() {
                                _menuPressed = true;
                                _menuInstantPressed = true;
                                _pageChanging = false;
                              });
                            },
                      Icons.menu,
                      Icons.menu,
                      false,
                      _menuPressed,
                      _menuInstantPressed,
                      widget.user.getDarkMode()),
                ],
              ),
            )
          : SizedBox.shrink(),
    );
  }

  Widget _feedbackBuild() {
    return AnimatedOpacity(
      opacity: !_menuInstantPressed ? 1.0 : 0.0,
      duration: Duration(milliseconds: 1000),
      child: _index == 1
          ? Column(
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
                    color: widget.user.getDarkMode()
                        ? Colors.white70
                        : Colors.white,
                    child: Theme(
                      data: ThemeData(
                        primarySwatch: MaterialColor(0XFF000000, _swatch),
                      ),
                      child: TextField(
                        enabled: !_menuInstantPressed,
                        style: TextStyle(
                          fontFamily: "Leoscar",
                          fontSize: 18.0,
                          letterSpacing: 1.0,
                        ),
                        controller: _feedbackController,
                        focusNode: _feedbackFocus,
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
                ),
                ElevatedButton(
                  onPressed: () async {
                    _feedbackFocus.unfocus();
                    if (_feedbackController.text.isNotEmpty) {
                      _loading();
                      await http.post(
                          Uri.parse(
                              "https://lifemaintenanceapplication.000webhostapp.com/php/addfeedback.php"),
                          body: {
                            "email": widget.user.getEmail(),
                            "feedback": _feedbackController.text,
                          }).then((res) async {
                        if (res.body == "success") {
                          await _loadFeedbackList();
                          methods.snackbarMessage(
                            context,
                            Duration(seconds: 1),
                            Color(0XFFB563E0),
                            true,
                            methods.textOnly(
                                "Feedback submitted",
                                "Leoscar",
                                18.0,
                                Colors.white,
                                null,
                                null,
                                TextAlign.center),
                          );
                          setState(() {
                            _feedbackController.clear();
                          });
                        } else {
                          methods.snackbarMessage(
                            context,
                            Duration(
                              milliseconds: 1500,
                            ),
                            Colors.red[400],
                            true,
                            methods.textOnly(
                                "Submit failed...Please try again",
                                "Leoscar",
                                18.0,
                                Colors.white,
                                null,
                                null,
                                TextAlign.center),
                          );
                        }
                      }).whenComplete(() => Navigator.pop(context));
                    } else if (_menuInstantPressed) {
                      return;
                    } else {
                      methods.snackbarMessage(
                        context,
                        Duration(
                          milliseconds: 1500,
                        ),
                        Colors.red[400],
                        true,
                        methods.textOnly("Feedback can't be blank", "Leoscar",
                            18.0, Colors.white, null, null, TextAlign.center),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: widget.user.getDarkMode()
                        ? Colors.white70
                        : Colors.white,
                    onPrimary: widget.user.getDarkMode()
                        ? Colors.grey[700]
                        : Colors.grey[350],
                    elevation: 20.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0),
                      side: BorderSide(
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  child: methods.textOnly(
                      "Submit",
                      "Leoscar",
                      18.0,
                      Colors.black,
                      FontWeight.normal,
                      FontStyle.normal,
                      TextAlign.center),
                ),
              ],
            )
          : (_index == 2 && _onlyUserFeedbackList.length == 0) ||
                  (_index == 3 && _allFeedbackList.length == 0)
              ? Center(
                  child: methods.noRecordFound(7, 20),
                )
              : Padding(
                  padding: const EdgeInsets.only(
                    top: 80.0,
                    left: 20.0,
                    right: 20.0,
                  ),
                  child: Container(
                    child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: _index == 2
                            ? _onlyUserFeedbackList.length
                            : _allFeedbackList.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(
                              bottom: 10.0,
                            ),
                            child: Container(
                              height: _index == 2
                                  ? _screenHeight / 7.5
                                  : _screenHeight / 6.5,
                              child: Card(
                                elevation: 10.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8.0),
                                  ),
                                  side: BorderSide(
                                    width: 3,
                                    color: index % 5 == 0
                                        ? Color(0XFF015F9F)
                                        : index % 5 == 1
                                            ? Color(0XFF00D1D0)
                                            : index % 5 == 2
                                                ? Color(0XFF00CC49)
                                                : index % 5 == 3
                                                    ? Color(0XFFFA9308)
                                                    : Color(0XFFEE1F27),
                                  ),
                                ),
                                child: InkWell(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8.0),
                                  ),
                                  splashColor: index % 5 == 0
                                      ? Color(0XFF015F9F)
                                      : index % 5 == 1
                                          ? Color(0XFF00D1D0)
                                          : index % 5 == 2
                                              ? Color(0XFF00CC49)
                                              : index % 5 == 3
                                                  ? Color(0XFFFA9308)
                                                  : Color(0XFFEE1F27),
                                  onTap: () {
                                    showModalBottomSheet(
                                        context: context,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10.0),
                                            topRight: Radius.circular(10.0),
                                          ),
                                        ),
                                        builder: (BuildContext context) {
                                          return SingleChildScrollView(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                _index == 3
                                                    ? Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                          left: 6.0,
                                                          top: 6.0,
                                                        ),
                                                        child: methods.textOnly(
                                                            ("Author: ${_allFeedbackList[index]["email"]}"),
                                                            "Leoscar",
                                                            12.0,
                                                            widget.user
                                                                    .getDarkMode()
                                                                ? Colors.white70
                                                                : Colors.black,
                                                            FontWeight.normal,
                                                            FontStyle.normal,
                                                            TextAlign.start),
                                                      )
                                                    : SizedBox.shrink(),
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Text(
                                                    "\"${_index == 2 ? _onlyUserFeedbackList[index]["feedback"] : _allFeedbackList[index]["feedback"]}\"",
                                                    textAlign:
                                                        TextAlign.justify,
                                                    style: TextStyle(
                                                      fontFamily: "Leoscar",
                                                      fontSize: 18.0,
                                                      letterSpacing: 1.0,
                                                      color: widget.user
                                                              .getDarkMode()
                                                          ? Colors.white70
                                                          : Colors.black,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    right: 6.0,
                                                    bottom: 6.0,
                                                  ),
                                                  child: Align(
                                                    alignment:
                                                        Alignment.bottomRight,
                                                    child: methods.textOnly(
                                                        ("Date created: ${_index == 2 ? _onlyUserFeedbackList[index]["date"] : _allFeedbackList[index]["date"]}"),
                                                        "Leoscar",
                                                        12.0,
                                                        widget.user
                                                                .getDarkMode()
                                                            ? Colors.white70
                                                            : Colors.black,
                                                        FontWeight.normal,
                                                        FontStyle.normal,
                                                        TextAlign.end),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        });
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _index == 3
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                left: 6.0,
                                                top: 6.0,
                                              ),
                                              child: methods.textOnly(
                                                  ("Author: ${_allFeedbackList[index]["email"]}"),
                                                  "Leoscar",
                                                  12.0,
                                                  widget.user.getDarkMode()
                                                      ? Colors.white70
                                                      : Colors.black,
                                                  FontWeight.normal,
                                                  FontStyle.normal,
                                                  TextAlign.start),
                                            )
                                          : SizedBox.shrink(),
                                      _index == 3
                                          ? Spacer()
                                          : SizedBox.shrink(),
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(
                                          "\"${_index == 2 ? _onlyUserFeedbackList[index]["feedback"] : _allFeedbackList[index]["feedback"]}\"",
                                          maxLines: 3,
                                          overflow: TextOverflow.fade,
                                          textAlign: TextAlign.justify,
                                          style: TextStyle(
                                            fontFamily: "Leoscar",
                                            fontSize: 18.0,
                                            letterSpacing: 1.0,
                                            color: widget.user.getDarkMode()
                                                ? Colors.white70
                                                : Colors.black,
                                          ),
                                        ),
                                      ),
                                      Spacer(),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          right: 6.0,
                                          bottom: 6.0,
                                        ),
                                        child: Align(
                                          alignment: Alignment.bottomRight,
                                          child: methods.textOnly(
                                              ("Date created: ${_index == 2 ? _onlyUserFeedbackList[index]["date"] : _allFeedbackList[index]["date"]}"),
                                              "Leoscar",
                                              12.0,
                                              widget.user.getDarkMode()
                                                  ? Colors.white70
                                                  : Colors.black,
                                              FontWeight.normal,
                                              FontStyle.normal,
                                              TextAlign.end),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                ),
    );
  }

  Widget _verifyPasswordBuild() {
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
            color: widget.user.getDarkMode() ? Colors.white70 : Colors.white,
            child: Theme(
              data: ThemeData(
                primarySwatch: MaterialColor(0XFF000000, _swatch),
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
        ElevatedButton(
          onPressed: () async {
            _passwordFocus.unfocus();
            if (_passwordController.text.isNotEmpty) {
              _loading();
              await http.post(
                  Uri.parse(
                      "https://lifemaintenanceapplication.000webhostapp.com/php/inappverifypassword.php"),
                  body: {
                    "email": widget.user.getEmail(),
                    "password": _passwordController.text,
                  }).then((res) {
                if (res.body == "success") {
                  setState(() {
                    _passwordController.clear();
                    _page++;
                  });
                } else {
                  methods.snackbarMessage(
                    context,
                    Duration(
                      milliseconds: 1500,
                    ),
                    Colors.red[400],
                    true,
                    methods.textOnly(
                        "Wrong password...Please try again",
                        "Leoscar",
                        18.0,
                        Colors.white,
                        null,
                        null,
                        TextAlign.center),
                  );
                }
              }).whenComplete(() => Navigator.pop(context));
            } else {
              methods.snackbarMessage(
                context,
                Duration(
                  milliseconds: 1500,
                ),
                Colors.red[400],
                true,
                methods.textOnly("Password can't be blank", "Leoscar", 18.0,
                    Colors.white, null, null, TextAlign.center),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            primary: widget.user.getDarkMode() ? Colors.white70 : Colors.white,
            onPrimary:
                widget.user.getDarkMode() ? Colors.grey[700] : Colors.grey[350],
            elevation: 20.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50.0),
              side: BorderSide(
                color: Colors.black54,
              ),
            ),
          ),
          child: methods.textOnly("Submit", "Leoscar", 18.0, Colors.black,
              FontWeight.normal, FontStyle.normal, TextAlign.center),
        ),
      ],
    );
  }

  Widget _newEmailBuild() {
    return Theme(
      data: ThemeData(
        primarySwatch: MaterialColor(0XFF000000, _swatch),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 80.0,
            ),
            child: _warningBar("WARNING!"),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 20.0,
              horizontal: 10.0,
            ),
            child: Text(
              "Once you had changed your email successfully, you need to verify your new email again before you are able to use your new email to login.",
              style: TextStyle(
                fontFamily: "Leoscar",
                fontSize: 20.0,
                height: 1.2,
                letterSpacing: 1.0,
                color:
                    widget.user.getDarkMode() ? Colors.white70 : Colors.white,
              ),
              textAlign: TextAlign.justify,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 10.0,
              left: 20.0,
              bottom: 5.0,
              right: 20.0,
            ),
            child: Material(
              elevation: 10.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(8.0),
                ),
              ),
              color: widget.user.getDarkMode() ? Colors.white70 : Colors.white,
              child: TextField(
                style: TextStyle(
                  fontFamily: "Leoscar",
                  fontSize: 18.0,
                  letterSpacing: 1.0,
                ),
                onChanged: (String value) {
                  _emailMessage = "Please insert a valid email format";
                  Pattern pattern =
                      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[com]{3,}))$';
                  RegExp regex = new RegExp(pattern);
                  setState(() {
                    if (!regex.hasMatch(value)) {
                      _verifyEmail = false;
                    } else {
                      _verifyEmail = true;
                    }
                  });
                },
                controller: _emailController,
                focusNode: _emailFocus,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.emailAddress,
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
                  hintText: "New Email",
                  hintStyle: TextStyle(
                    fontFamily: "Leoscar",
                    fontSize: 14.0,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ),
          ),
          _showErrorMessage(!_verifyEmail, _emailMessage),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 15.0,
              ),
              child: ElevatedButton(
                onPressed: () async {
                  _emailFocus.unfocus();
                  if (_emailController.text.isNotEmpty) {
                    if (_verifyEmail == false) {
                      Future.delayed(Duration(milliseconds: 300), () {
                        methods.snackbarMessage(
                          context,
                          Duration(seconds: 1),
                          Colors.red[400],
                          true,
                          methods.textOnly(
                              "Please insert a valid email format",
                              "Leoscar",
                              18.0,
                              Colors.white,
                              null,
                              null,
                              TextAlign.center),
                        );
                      });
                    } else {
                      _loading();
                      await http.post(
                          Uri.parse(
                              "https://lifemaintenanceapplication.000webhostapp.com/php/editprofile.php"),
                          body: {
                            "email": widget.user.getEmail(),
                            "newEmail": _emailController.text,
                          }).then((res) {
                        if (res.body == "success") {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            PageTransition(
                              child: LoginScreen(userLogout: 3),
                              type: PageTransitionType.fade,
                            ),
                          );
                          Future.delayed(Duration(milliseconds: 1000), () {
                            methods.snackbarMessage(
                              context,
                              Duration(seconds: 3),
                              Color(0XFFB563E0),
                              true,
                              methods.textOnly(
                                  "Email changed successfully, please check your NEW email to verify your account",
                                  "Leoscar",
                                  18.0,
                                  Colors.white,
                                  null,
                                  null,
                                  TextAlign.center),
                            );
                          });
                        } else {
                          Navigator.pop(context);
                          Future.delayed(Duration(milliseconds: 300), () {
                            methods.snackbarMessage(
                              context,
                              Duration(seconds: 1),
                              Colors.red[400],
                              true,
                              methods.textOnly(
                                  "Email can't be changed...Please try again",
                                  "Leoscar",
                                  18.0,
                                  Colors.white,
                                  null,
                                  null,
                                  TextAlign.center),
                            );
                          });
                        }
                      });
                    }
                  } else {
                    methods.snackbarMessage(
                      context,
                      Duration(
                        milliseconds: 1500,
                      ),
                      Colors.red[400],
                      true,
                      methods.textOnly("Email can't be blank", "Leoscar", 18.0,
                          Colors.white, null, null, TextAlign.center),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary:
                      widget.user.getDarkMode() ? Colors.white70 : Colors.white,
                  onPrimary: widget.user.getDarkMode()
                      ? Colors.grey[700]
                      : Colors.grey[350],
                  elevation: 20.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                    side: BorderSide(
                      color: Colors.black54,
                    ),
                  ),
                ),
                child: methods.textOnly("Submit", "Leoscar", 18.0, Colors.black,
                    FontWeight.normal, FontStyle.normal, TextAlign.center),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _newPasswordBuild() {
    return Theme(
      data: ThemeData(
        primarySwatch: MaterialColor(0XFF000000, _swatch),
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
                color:
                    widget.user.getDarkMode() ? Colors.white70 : Colors.white,
                child: TextField(
                  onChanged: (String value) {
                    _passwordMessage = "Password must be at least ";
                    _retypePasswordMessage = "Password not match";
                    setState(() {
                      _verifyPassword = false;
                      _verifyRetypePassword = false;
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
                      } else if (_passwordController.text ==
                          _retypePasswordController.text) {
                        _verifyPassword = true;
                        _verifyRetypePassword = true;
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
                color:
                    widget.user.getDarkMode() ? Colors.white70 : Colors.white,
                child: TextField(
                  onChanged: (String value) {
                    setState(() {
                      _verifyRetypePassword = false;
                      if (value == _passwordController.text) {
                        _verifyRetypePassword = true;
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
                child: ElevatedButton(
                  onPressed: () async {
                    _passwordFocus.unfocus();
                    _retypePasswordFocus.unfocus();
                    if (_passwordController.text.isNotEmpty &&
                        _retypePasswordController.text.isNotEmpty) {
                      _loading();
                      await http.post(
                          Uri.parse(
                              "https://lifemaintenanceapplication.000webhostapp.com/php/editprofile.php"),
                          body: {
                            "email": widget.user.getEmail(),
                            "newPassword": _passwordController.text,
                          }).then((res) {
                        if (res.body == "success") {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            PageTransition(
                              child: LoginScreen(userLogout: 2),
                              type: PageTransitionType.fade,
                            ),
                          );
                          Future.delayed(Duration(milliseconds: 1000), () {
                            methods.snackbarMessage(
                              context,
                              Duration(seconds: 2),
                              Color(0XFFB563E0),
                              true,
                              methods.textOnly(
                                  "Please insert your NEW password to login",
                                  "Leoscar",
                                  18.0,
                                  Colors.white,
                                  null,
                                  null,
                                  TextAlign.center),
                            );
                          });
                        } else {
                          Navigator.pop(context);
                          Future.delayed(Duration(milliseconds: 300), () {
                            methods.snackbarMessage(
                              context,
                              Duration(seconds: 1),
                              Colors.red[400],
                              true,
                              methods.textOnly(
                                  "Password can't be changed...Please try again",
                                  "Leoscar",
                                  18.0,
                                  Colors.white,
                                  null,
                                  null,
                                  TextAlign.center),
                            );
                          });
                        }
                      });
                    } else if (!_verifyPassword) {
                      methods.snackbarMessage(
                        context,
                        Duration(
                          milliseconds: 1500,
                        ),
                        Colors.red[400],
                        true,
                        methods.textOnly(_passwordMessage, "Leoscar", 18.0,
                            Colors.white, null, null, TextAlign.center),
                      );
                    } else if (!_verifyRetypePassword) {
                      methods.snackbarMessage(
                        context,
                        Duration(
                          milliseconds: 1500,
                        ),
                        Colors.red[400],
                        true,
                        methods.textOnly(_retypePasswordMessage, "Leoscar",
                            18.0, Colors.white, null, null, TextAlign.center),
                      );
                    } else {
                      methods.snackbarMessage(
                        context,
                        Duration(
                          milliseconds: 1500,
                        ),
                        Colors.red[400],
                        true,
                        methods.textOnly("Password can't be blank", "Leoscar",
                            18.0, Colors.white, null, null, TextAlign.center),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: widget.user.getDarkMode()
                        ? Colors.white70
                        : Colors.white,
                    onPrimary: widget.user.getDarkMode()
                        ? Colors.grey[700]
                        : Colors.grey[350],
                    elevation: 20.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0),
                      side: BorderSide(
                        color: Colors.black54,
                      ),
                    ),
                  ),
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
          child: _warningBar("This is EXTREMELY IMPORTANT!"),
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
              color: widget.user.getDarkMode() ? Colors.white70 : Colors.white,
            ),
            textAlign: TextAlign.justify,
          ),
        ),
        _warningBar("This is EXTREMELY IMPORTANT!"),
        Padding(
          padding: const EdgeInsets.only(
            top: 20.0,
          ),
          child: ElevatedButton(
            onPressed: () async {
              _loading();
              await http.post(
                  Uri.parse(
                      "https://lifemaintenanceapplication.000webhostapp.com/php/deleteaccount.php"),
                  body: {
                    "email": widget.user.getEmail(),
                  }).then((res) {
                if (res.body == "success") {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    PageTransition(
                      child: LoginScreen(userLogout: 3),
                      type: PageTransitionType.fade,
                    ),
                  );
                  Future.delayed(Duration(milliseconds: 1000), () {
                    methods.snackbarMessage(
                      context,
                      Duration(seconds: 2),
                      Color(0XFFB563E0),
                      true,
                      methods.textOnly(
                          "Account deleted...You are no longer available to login with the deleted email",
                          "Leoscar",
                          18.0,
                          Colors.white,
                          null,
                          null,
                          TextAlign.center),
                    );
                  });
                } else {
                  Navigator.pop(context);
                  methods.snackbarMessage(
                    context,
                    Duration(
                      milliseconds: 1500,
                    ),
                    Colors.red[400],
                    true,
                    methods.textOnly(
                        "Account can't be deleted...Please try again",
                        "Leoscar",
                        18.0,
                        Colors.white,
                        null,
                        null,
                        TextAlign.center),
                  );
                }
              });
            },
            style: ElevatedButton.styleFrom(
              primary:
                  widget.user.getDarkMode() ? Colors.white70 : Colors.white,
              onPrimary: widget.user.getDarkMode()
                  ? Colors.grey[700]
                  : Colors.grey[350],
              elevation: 20.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),
                side: BorderSide(
                  color: Colors.black54,
                ),
              ),
            ),
            child: methods.textOnly("Delete", "Leoscar", 18.0, Colors.black,
                FontWeight.normal, FontStyle.normal, TextAlign.center),
          ),
        ),
      ],
    );
  }

  Widget _warningBar(String text) {
    return Container(
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
              color: widget.user.getDarkMode() ? Colors.white70 : Colors.white,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 3.0,
            ),
            child: methods.textOnly(
                text,
                "Leoscar",
                20.0,
                widget.user.getDarkMode() ? Colors.white70 : Colors.white,
                FontWeight.normal,
                FontStyle.normal,
                TextAlign.center),
          ),
        ],
      ),
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
            child: methods.textOnly(
                message,
                "Leoscar",
                13.0,
                widget.user.getDarkMode() ? Colors.white70 : Colors.white,
                FontWeight.normal,
                FontStyle.normal,
                TextAlign.start),
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

  void _loading() {
    showModalBottomSheet(
        context: context,
        enableDrag: false,
        isDismissible: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
          ),
        ),
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, newSetState) {
            return Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: _gif,
                  scale: 3,
                ),
              ),
            );
          });
        });
  }

  Future<void> _loadFeedbackList() async {
    await http
        .post(Uri.parse(
            "https://lifemaintenanceapplication.000webhostapp.com/php/loadfeedbacklist.php"))
        .then((res) async {
      if (res.body != "no data") {
        var _extractData = json.decode(res.body);
        setState(() {
          _allFeedbackList = _extractData;
          for (int _i = 0; _i < _extractData.length; _i++) {
            if (_allFeedbackList[_i]["email"] == widget.user.getEmail()) {
              _onlyUserFeedbackList.add(_extractData[_i]);
            }
          }
        });
      }
    });
  }
}

class AnimatedWave extends StatelessWidget {
  final int page;
  final double height;
  final double speed;
  final double offset;
  final bool isDarkMode;

  AnimatedWave(
      {this.page, this.height, this.speed, this.offset = 0.0, this.isDarkMode});

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
                foregroundPainter:
                    CurvePainter(page, value + offset, isDarkMode),
              );
            }),
      );
    });
  }
}

class CurvePainter extends CustomPainter {
  final int page;
  final double value;
  final bool isDarkMode;

  CurvePainter(this.page, this.value, this.isDarkMode);

  @override
  void paint(Canvas canvas, Size size) {
    Paint white;
    if (page != 6 && page != 7) {
      if (isDarkMode) {
        white = Paint()..color = Colors.grey.withAlpha(60);
      } else {
        white = Paint()..color = Colors.white.withAlpha(60);
      }
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
  final bool isDarkMode;
  AnimatedBackground(this.page, this.isDarkMode);

  @override
  Widget build(BuildContext context) {
    Color _color1;
    Color _color2;
    Color _color3;
    Color _color4;
    if (page != 6 && page != 7) {
      _color1 = isDarkMode
          ? Color(0XFFFC00FF).withOpacity(0.4)
          : Color(0XFFFC00FF).withOpacity(0.5);
      _color2 = isDarkMode
          ? Color(0XFFFC00FF).withOpacity(0.6)
          : Color(0XFFFC00FF).withOpacity(0.8);
      _color3 = isDarkMode
          ? Color(0XFF00DBDE).withOpacity(0.4)
          : Color(0XFF00DBDE).withOpacity(0.5);
      _color4 = isDarkMode
          ? Color(0XFF00DBDE).withOpacity(0.6)
          : Color(0XFF00DBDE).withOpacity(0.8);
    } else if (page == 6) {
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
