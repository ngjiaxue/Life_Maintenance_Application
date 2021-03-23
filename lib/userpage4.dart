import 'dart:ui';
import 'user.dart';
import 'methods.dart';
import 'loginscreen.dart';
import 'editprofile.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class UserPage4 extends StatefulWidget {
  final User user;
  const UserPage4({Key key, this.user}) : super(key: key);
  @override
  _UserPage4State createState() => _UserPage4State();
}

class _UserPage4State extends State<UserPage4>
    with AutomaticKeepAliveClientMixin {
  Methods methods = new Methods();
  double _screenWidth;
  double _height = 0.0;
  double _weight = 0.0;
  bool _isEditing = false;
  bool _confirmationMessage = false;
  // Flushbar flushbar;
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _dobController = new TextEditingController();
  TextEditingController _genderController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _phoneController = new TextEditingController();
  TextEditingController _heightController = new TextEditingController();
  TextEditingController _weightController = new TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    _screenWidth = MediaQuery.of(context).size.width;
    return Container(
      child: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            leading: SizedBox.shrink(),
            backgroundColor: Colors.transparent,
            expandedHeight: _screenWidth,
            flexibleSpace: Container(
              height: _screenWidth,
              width: _screenWidth,
              child: Stack(
                children: [
                  ClipPath(
                    clipper: ClippingClass(),
                    child: Image.asset(
                      // "assets/images/defaultprofilepic.png",
                      "assets/images/profile.jpg",
                      fit: BoxFit.cover,
                      height: _screenWidth,
                      width: _screenWidth,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 50,
                    ),
                    child: ClipPath(
                      clipper: ClippingClass(),
                      child: Container(
                        width: _screenWidth,
                        height: _screenWidth,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withOpacity(0),
                              Colors.white.withOpacity(0.1),
                              Colors.white.withOpacity(0.2),
                              Colors.white.withOpacity(0.3),
                              Colors.white.withOpacity(0.4),
                              Colors.white.withOpacity(0.5),
                              Colors.white.withOpacity(0.6),
                              Colors.white.withOpacity(0.7),
                              Colors.white.withOpacity(0.8),
                              Colors.white.withOpacity(0.9),
                              Colors.white.withOpacity(1),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          border: Border.all(
                            color: Colors.white.withOpacity(0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 30.0,
                      ),
                      child: ShaderMask(
                        shaderCallback: (Rect bounds) {
                          return LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: methods.color(),
                            tileMode: TileMode.clamp,
                          ).createShader(bounds);
                        },
                        child: Text(
                          "Profile",
                          style: TextStyle(
                            fontFamily: "Leoscar",
                            fontSize: 36.0,
                            color: Colors.white,
                            letterSpacing: 1.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        right: 74.0,
                      ),
                      child: Visibility(
                        visible: !_confirmationMessage,
                        child: FloatingActionButton(
                          onPressed: () {
                            if (!_isEditing) {
                              //TODO: camera function
                            } else {
                              setState(() {
                                _confirmationMessage = true;
                                FocusScope.of(context).unfocus();
                              });
                              _showSnackbar(
                                  Colors.red[400],
                                  () {
                                    ScaffoldMessenger.of(context)
                                        .hideCurrentSnackBar();
                                    setState(() {
                                      _confirmationMessage = false;
                                    });
                                  },
                                  "Discard the change(s)",
                                  () {
                                    setState(() {
                                      ScaffoldMessenger.of(context)
                                          .hideCurrentSnackBar();
                                      _nameController.clear();
                                      _dobController.clear();
                                      _genderController.clear();
                                      _emailController.clear();
                                      _phoneController.clear();
                                      _heightController.clear();
                                      _weightController.clear();
                                      _confirmationMessage = false;
                                      _isEditing = false;
                                    });
                                  });
                            }
                          },
                          heroTag: 3,
                          mini: true,
                          elevation: 10.0,
                          backgroundColor:
                              !_isEditing ? Colors.white : Colors.red,
                          child: !_isEditing
                              ? ShaderMask(
                                  shaderCallback: (Rect bounds) {
                                    return LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: methods.color(),
                                      tileMode: TileMode.clamp,
                                    ).createShader(bounds);
                                  },
                                  child: Icon(
                                    LineIcons.camera,
                                    color: Colors.white,
                                  ),
                                )
                              : Icon(
                                  FlutterIcons.cancel_mco,
                                  color: Colors.white,
                                ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                            side: BorderSide(color: Colors.black12),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        right: 24.0,
                      ),
                      child: Visibility(
                        visible: !_confirmationMessage,
                        child: FloatingActionButton(
                          onPressed: () {
                            if (!_isEditing) {
                              setState(() {
                                _isEditing = true;
                              });
                            } else {
                              setState(() {
                                _confirmationMessage = true;
                                FocusScope.of(context).unfocus();
                              });
                              _showSnackbar(
                                  Colors.green,
                                  () {
                                    ScaffoldMessenger.of(context)
                                        .hideCurrentSnackBar();
                                    setState(() {
                                      _confirmationMessage = false;
                                    });
                                  },
                                  "Apply the change(s)?",
                                  () {
                                    ScaffoldMessenger.of(context)
                                        .hideCurrentSnackBar();
                                    setState(() {
                                      if (_nameController.text.isNotEmpty) {
                                        widget.user
                                            .setName(_nameController.text);
                                      }
                                      if (_dobController.text.isNotEmpty) {
                                        widget.user.setDob(_dobController.text);
                                      }
                                      if (_genderController.text.isNotEmpty) {
                                        widget.user
                                            .setGender(_genderController.text);
                                      }
                                      if (_emailController.text.isNotEmpty) {
                                        widget.user
                                            .setEmail(_emailController.text);
                                      }
                                      if (_phoneController.text.isNotEmpty) {
                                        widget.user
                                            .setPhone(_phoneController.text);
                                      }
                                      if (_heightController.text.isNotEmpty) {
                                        widget.user
                                            .setHeight(_heightController.text);
                                      }
                                      if (_weightController.text.isNotEmpty) {
                                        widget.user
                                            .setWeight(_weightController.text);
                                      }
                                      _nameController.clear();
                                      _dobController.clear();
                                      _genderController.clear();
                                      _emailController.clear();
                                      _phoneController.clear();
                                      _heightController.clear();
                                      _weightController.clear();
                                      _confirmationMessage = false;
                                      _isEditing = false;
                                    });
                                  });
                            }
                          },
                          heroTag: 4,
                          mini: true,
                          elevation: 10.0,
                          backgroundColor:
                              !_isEditing ? Colors.white : Colors.green,
                          child: !_isEditing
                              ? ShaderMask(
                                  shaderCallback: (Rect bounds) {
                                    return LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: methods.color(),
                                      tileMode: TileMode.clamp,
                                    ).createShader(bounds);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 4.0,
                                    ),
                                    child: Icon(
                                      FlutterIcons.edit_faw,
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              : Icon(
                                  FlutterIcons.save_faw,
                                  color: Colors.white,
                                ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                            side: BorderSide(color: Colors.black12),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              <Widget>[
                _information("Name", widget.user.getName(), 0, _nameController),
                _information(
                    "Date of Birth", widget.user.getDob(), 1, _dobController),
                _information(
                    "Gender", widget.user.getGender(), 2, _genderController),
                _information(
                    "Email", widget.user.getEmail(), 3, _emailController),
                _information(
                    "Phone", widget.user.getPhone(), 4, _phoneController),
                _information("Height", widget.user.getHeight() + " cm", 5,
                    _heightController),
                _information("Weight", widget.user.getWeight() + " kg", 6,
                    _weightController),
                Visibility(
                  visible: !_isEditing,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 30.0,
                      ),
                      _information("Logout", "", 7, null),
                      _information("Feedback", "", 8, null),
                      SizedBox(
                        height: 30.0,
                      ),
                      _information("Change Password", "", 9, null),
                      _information("Delete Account", "", 10, null),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _information(String _leading, String _content, int _index,
      TextEditingController _textEditingController) {
    Color _color;
    Widget _icon;
    if (_index % 5 == 0) {
      _color = Color(0XFF015F9F);
    } else if (_index % 5 == 1) {
      _color = Color(0XFF00D1D0);
    } else if (_index % 5 == 2) {
      _color = Color(0XFF00CC49);
    } else if (_index % 5 == 3) {
      _color = Color(0XFFFA9308);
    } else {
      _color = Color(0XFFEE1F27);
    }
    if (_index == 0) {
      _icon = Icon(
        FlutterIcons.address_card_o_faw,
        color: _color,
      );
    } else if (_index == 1) {
      _icon = Icon(
        FlutterIcons.birthday_cake_faw,
        color: _color,
      );
    } else if (_index == 2) {
      _icon = Icon(
        FlutterIcons.transgender_faw,
        color: _color,
      );
    } else if (_index == 3) {
      _icon = Icon(
        FlutterIcons.email_outline_mco,
        color: _color,
        size: 26.0,
      );
    } else if (_index == 4) {
      _icon = Icon(
        FlutterIcons.mobile1_ant,
        color: _color,
      );
    } else if (_index == 5) {
      _icon = Icon(
        FlutterIcons.human_male_height_mco,
        color: _color,
      );
    } else if (_index == 6) {
      _icon = Icon(
        FlutterIcons.weight_kilogram_mco,
        color: _color,
      );
    } else if (_index == 7) {
      _icon = Icon(
        FlutterIcons.logout_sli,
        color: _color,
      );
    } else if (_index == 8) {
      _icon = Icon(
        FlutterIcons.comment_discussion_oct,
        color: _color,
      );
    } else if (_index == 9) {
      _icon = Icon(
        FlutterIcons.lock_sli,
        color: _color,
      );
    } else if (_index == 10) {
      _color = Colors.red[400];
      _icon = Icon(
        FlutterIcons.deleteuser_ant,
        color: Colors.white,
      );
    } else {
      _icon = SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(
        bottom: 5.0,
      ),
      child: Container(
        height: 60.0,
        child: Card(
          color: _index == 10 ? _color : null,
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8.0),
            ),
            side: BorderSide(
              width: 1.5,
              color: _index != 10 ? _color : Colors.black12,
            ),
          ),
          child: _index <= 6
              ? _personalContent(_index, _leading, _content, _color, _icon,
                  _textEditingController)
              : _otherContent(_index, _leading, _content, _color, _icon),
        ),
      ),
    );
  }

  Widget _personalContent(
      int _index,
      String _leading,
      String _content,
      Color _color,
      Widget _widget,
      TextEditingController _textEditingController) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: [
              _widget,
              Padding(
                padding: const EdgeInsets.only(
                  top: 4.0,
                  left: 10.0,
                ),
                child: methods.textOnly(
                    _leading,
                    "Leoscar",
                    18.0,
                    (_content == "0.0 kg" || _content == "0.0 cm")
                        ? Colors.red
                        : Colors.black,
                    FontWeight.normal,
                    FontStyle.normal,
                    TextAlign.start),
              ),
            ],
          ),
          !_isEditing
              ? Padding(
                  padding: const EdgeInsets.only(
                    top: 4.0,
                  ),
                  child: methods.textOnly(
                      _content,
                      "Leoscar",
                      18.0,
                      (_content == "0.0 kg" || _content == "0.0 cm")
                          ? Colors.red
                          : Colors.black,
                      FontWeight.normal,
                      FontStyle.normal,
                      TextAlign.start),
                )
              : Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 2.5,
                    ),
                    child: _editContent(
                        _index, _content, _color, _textEditingController),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _editContent(int _index, String _content, Color _color,
      TextEditingController _textEditingController) {
    return Stack(
      children: [
        TextFormField(
          onTap: () {
            if (_index == 1) {
              DatePicker.showDatePicker(
                context,
                minTime: DateTime(DateTime.now().year - 100, 1, 1),
                maxTime: DateTime.now(),
                onCancel: () {
                  setState(() {
                    if (_dobController.text == " ") {
                      _dobController.clear();
                    }
                    FocusScope.of(context).requestFocus(new FocusNode());
                  });
                },
                onConfirm: (date) {
                  setState(() {
                    _dobController.text = DateFormat("yyyy-MM-dd").format(date);
                  });
                },
                currentTime: DateTime.parse(widget.user.getDob()),
              );
            } else if (_index == 5) {
              _showDialog(_index);
            } else if (_index == 6) {
              _showDialog(_index);
            }
          },
          controller: _textEditingController,
          cursorColor: _color,
          readOnly: _index == 0 || _index == 3 || _index == 4 ? false : true,
          style: TextStyle(
            fontFamily: "Leoscar",
            fontSize: 18.0,
            letterSpacing: 1.0,
          ),
          textAlign: TextAlign.end,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: _content,
            hintStyle: TextStyle(
              fontFamily: "Leoscar",
              fontSize: 18.0,
              letterSpacing: 1.0,
              color: Colors.black38,
            ),
          ),
        ),
        (_index == 2)
            ? Container(
                height: 60.0,
                width: double.infinity,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    icon: SizedBox.shrink(),
                    items: ["Male", "Female"]
                        .map((label) => DropdownMenuItem(
                              child: Text(
                                label,
                                style: TextStyle(
                                  fontFamily: "Leoscar",
                                  fontSize: 17.0,
                                  letterSpacing: 1.0,
                                ),
                              ),
                              value: label,
                            ))
                        .toList(),
                    onChanged: (_gender) {
                      setState(() {
                        _genderController.text = _gender;
                      });
                    },
                  ),
                ),
              )
            : SizedBox.shrink(),
      ],
    );
  }

  Widget _otherContent(int _index, String _leading, String _content,
      Color _color, Widget _widget) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: _index != 10 ? _color.withOpacity(0.3) : Colors.red[200],
      onTap: () {
        if (_index == 7) {
          _showSnackbar(
              Color(0XFFB563E0),
              () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
              "Do you want to Logout?",
              () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                Navigator.push(
                  context,
                  PageTransition(
                    child: LoginScreen(2),
                    type: PageTransitionType.fade,
                  ),
                );
                // Future.delayed(Duration(milliseconds: 300), () {
                //   Navigator.of(context).pop();
                // });
              });
        } else if (_index == 8) {
          Navigator.push(
            context,
            PageTransition(
              child: EditProfile(1, widget.user),
              type: PageTransitionType.fade,
            ),
          );
        } else if (_index == 9) {
          Navigator.push(
            context,
            PageTransition(
              child: EditProfile(2, widget.user),
              type: PageTransitionType.fade,
            ),
          );
        } else if (_index == 10) {
          Navigator.push(
            context,
            PageTransition(
              child: EditProfile(4, widget.user),
              type: PageTransitionType.fade,
            ),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10.0,
        ),
        child: Row(
          children: <Widget>[
            _widget,
            Padding(
              padding: const EdgeInsets.only(
                top: 4.0,
                left: 10.0,
              ),
              child: methods.textOnly(
                  _leading,
                  "Leoscar",
                  18.0,
                  _index != 10 ? Colors.black : Colors.white,
                  FontWeight.normal,
                  FontStyle.normal,
                  TextAlign.start),
            ),
          ],
        ),
      ),
    );
  }

  Future<Null> _showSnackbar(Color color, Function() onTapCancel,
      String message, Function() onTapProceed) {
    return methods.snackbarMessage(
      context,
      Duration(days: 365),
      color,
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            child: Container(
              child: Icon(
                LineIcons.times,
                color: Colors.white,
              ),
            ),
            onTap: onTapCancel,
          ),
          methods.textOnly(message, "Leoscar", 18.0, Colors.white, null, null,
              TextAlign.center),
          GestureDetector(
            child: Container(
              child: Icon(
                LineIcons.check,
                color: Colors.white,
              ),
            ),
            onTap: onTapProceed,
          ),
        ],
      ),
    );
  }

  void _showDialog(int _index) {
    showDialog<double>(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              // return Column(
              //   children: <Widget>[
              //     SizedBox(height: 16),
              //     Text('Decimal', style: Theme.of(context).textTheme.headline6),
              //     DecimalNumberPicker(
              //       value: _currentDoubleValue,
              //       minValue: 0,
              //       maxValue: 10,
              //       decimalPlaces: 2,
              //       onChanged: (value) =>
              //           setState(() => _currentDoubleValue = value),
              //     ),
              //     SizedBox(height: 32),
              //   ],
              // );
              // return new DecimalNumberPicker(
              //   minValue: _index == 5 ? 50 : 30,
              //   maxValue: _index == 5 ? 200 : 300,
              //   // title: _index == 5
              //   //     ? methods.textOnly(
              //   //         "Pick a new height",
              //   //         "Leoscar",
              //   //         26.0,
              //   //         Color(0XFF7100AD),
              //   //         FontWeight.bold,
              //   //         FontStyle.normal,
              //   //         TextAlign.start)
              //   //     : methods.textOnly(
              //   //         "Pick a new weight",
              //   //         "Leoscar",
              //   //         26.0,
              //   //         Color(0XFF7100AD),
              //   //         FontWeight.bold,
              //   //         FontStyle.normal,
              //   //         TextAlign.start),
              //   // initialDoubleValue: _index == 5
              //   //     ? (_height != 0.0
              //   //         ? _height
              //   //         : widget.user.getHeight() == "0.0"
              //   //             ? 50.0
              //   //             : double.parse(widget.user.getHeight()))
              //   //     : (_weight != 0.0
              //   //         ? _weight
              //   //         : widget.user.getWeight() == "0.0"
              //   //             ? 30.0
              //   //             : double.parse(widget.user.getWeight())),
              //   textStyle: TextStyle(
              //     fontFamily: "Leoscar",
              //     fontSize: 20.0,
              //     letterSpacing: 1.0,
              //     color: Colors.grey,
              //   ),
              //   selectedTextStyle: TextStyle(
              //     fontFamily: "Leoscar",
              //     fontSize: 22.0,
              //     letterSpacing: 1.0,
              //     color: Color(0XFF7100AD),
              //   ),
              //   //     confirmWidget: InkWell(
              //   //       highlightColor: Colors.transparent,
              //   //       splashColor: Color(0XFFE7BAFF),
              //   //       child: Ink(
              //   //         height: 36.0,
              //   //         width: 70.0,
              //   //         decoration: BoxDecoration(
              //   //           color: Color(0XFF9866B3),
              //   //           borderRadius: new BorderRadius.circular(
              //   //             8.0,
              //   //           ),
              //   //         ),
              //   //         child: Center(
              //   //           child: methods.textOnly("Ok", "Leoscar", 18.0, Colors.white,
              //   //               FontWeight.bold, null, null),
              //   //         ),
              //   //       ),
              //   //     ),
              //   //     cancelWidget: MaterialButton(
              //   //       highlightColor: Colors.transparent,
              //   //       splashColor: Color(0XFFE7BAFF),
              //   //       shape: RoundedRectangleBorder(
              //   //         borderRadius: BorderRadius.circular(8.0),
              //   //       ),
              //   //       onPressed: () {
              //   //         Navigator.of(context).pop();
              //   //       },
              //   //       child: methods.textOnly("Cancel", "Leoscar", 18.0,
              //   //           Color(0XFF9866B3), FontWeight.bold, null, null),
              //   //     ),
              // );
            })
        .then((value) {
      setState(() {
        if (_index == 5 && value != null) {
          _height = value;
          _heightController.text = value.toString();
        } else if (_index == 6 && value != null) {
          _weight = value;
          _weightController.text = value.toString();
        }
      });
    });
  }

  @override
  bool get wantKeepAlive => true;
}

class ClippingClass extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height - 60);
    path.quadraticBezierTo(
        size.width / 4, size.height, size.width / 2, size.height);
    path.quadraticBezierTo(size.width - (size.width / 4), size.height,
        size.width, size.height - 60);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
